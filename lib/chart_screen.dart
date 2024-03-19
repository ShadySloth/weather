import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;

import 'data_source.dart';
import 'models/time_series.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final axisColor = charts.MaterialPalette.gray.shadeDefault;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/'),
        child: const Text('Home'),
      ),
      body: Column(
        children: [
          Container(
            height: 600,
            child: FutureBuilder<WeatherChartData>(
              future: context.read<DataSource>().getChartData(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final variables = snapshot.data!.daily!;
                return charts.TimeSeriesChart(
                  [
                    for (final variable in variables)
                      charts.Series<TimeSeriesDatum, DateTime>(
                        id: '${variable.name} ${variable.unit}',
                        colorFn: (_, __) =>
                            charts.MaterialPalette.blue.shadeDefault,
                        domainFn: (datum, _) => datum.domain,
                        measureFn: (datum, _) => datum.measure,
                        data: variable.values,
                        labelAccessorFn: (datum, _) {
                          if (datum.measure == 0) {
                            return '';
                          } else {
                            return datum.measure.toString();
                          }
                        },
                      ),
                  ],
                  animate: true,
                  defaultRenderer: charts.BarRendererConfig<DateTime>(
                    barRendererDecorator: charts.BarLabelDecorator(
                      labelPosition: charts.BarLabelPosition.inside,
                      labelAnchor: charts.BarLabelAnchor.end,
                    ),
                  ),
                  defaultInteractions: false,
                  dateTimeFactory: const charts.LocalDateTimeFactory(),
                  domainAxis: charts.DateTimeAxisSpec(
                    tickProviderSpec:
                        const charts.DayTickProviderSpec(increments: [1]),
                    renderSpec: charts.SmallTickRendererSpec(
                      labelStyle: charts.TextStyleSpec(color: axisColor),
                      lineStyle: charts.LineStyleSpec(color: axisColor),
                    ),
                  ),
                  primaryMeasureAxis: charts.NumericAxisSpec(
                    renderSpec: charts.GridlineRendererSpec(
                      // Tick and Label styling here.
                      labelStyle: charts.TextStyleSpec(color: axisColor),
                      // Change the line colors to match text color.
                      lineStyle: charts.LineStyleSpec(color: axisColor),
                    ),
                  ),
                  behaviors: [charts.ChartTitle("Rain sum")],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
