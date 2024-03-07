import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/data_source.dart';
import 'package:weather/models.dart';
import 'package:weather/weather_sliver_app_bar.dart';
import 'package:weather/weekly_forecast_list.dart';

class WeeklyForecastScreen extends StatefulWidget {
  const WeeklyForecastScreen({super.key});

  @override
  State<WeeklyForecastScreen> createState() => _WeeklyForecastScreenState();
}

class _WeeklyForecastScreenState extends State<WeeklyForecastScreen> {
  final controller = StreamController<WeeklyForecastDto>();

  @override
  void initState() {
    super.initState();
    loadForecast();
  }

  Future<void> loadForecast() async {
    final future = context.read<DataSource>().getWeeklyForecast();
    controller.addStream(future.asStream());
    await future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: controller.stream,
        builder: (context, snapshot) {
          return CustomScrollView(
            slivers: <Widget>[
              WeatherSliverAppBar(onRefresh: loadForecast),
              if (snapshot.hasData)
                WeeklyForecastList(weeklyForecast: snapshot.data!)
              else if (snapshot.hasError)
                buildError(snapshot, context)
              else
                buildSpinner()
            ],
          );
        },
      ),
    );
  }

  Widget buildError(Object? error, BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          error.toString(),
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }

  Widget buildSpinner() {
    return const SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
