import 'package:flutter/material.dart';
import 'package:weather/models/forecast.dart';

class WeeklyForecastList extends StatelessWidget {
  final WeeklyForecastDto weeklyForecast;

  const WeeklyForecastList({super.key, required this.weeklyForecast});

  @override
  Widget build(BuildContext context) {
    final DateTime currentDate = DateTime.now();
    final TextTheme textTheme = Theme.of(context).textTheme;
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final daily = weeklyForecast.daily!;
          final date = DateTime.parse(daily.time![index]);
          final weatherCode = WeatherCode.fromInt(daily.weatherCode![index]);
          final tempMax = daily.temperature2MMax![index];
          final tempMin = daily.temperature2MMin![index];
          return Card(
            child: Row(
              children: <Widget>[
                SizedBox(
                  height: 150.0,
                  width: 150.0,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      DecoratedBox(
                        position: DecorationPosition.foreground,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: <Color>[
                              Colors.grey[800]!,
                              Colors.transparent
                            ],
                          ),
                        ),
                        child: Image.asset(
                          weatherCode.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Center(
                        child: Text(
                          '${date.day} / ${date.month}',
                          style: textTheme.displayMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          weekdayAsString(date),
                          style: textTheme.titleLarge,
                        ),
                        const SizedBox(height: 10.0),
                        Text(weatherCode.description,
                            style: textTheme.titleSmall),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    '${tempMax} | ${tempMin} °C',
                    style: textTheme.titleSmall,
                  ),
                ),
              ],
            ),
          );
        },
        childCount: 7,
      ),
    );
  }

  String weekdayAsString(DateTime time) {
    return switch (time.weekday) {
      DateTime.monday => 'Monday',
      DateTime.tuesday => 'Tuesday',
      DateTime.wednesday => 'Wednesday',
      DateTime.thursday => 'Thursday',
      DateTime.friday => 'Friday',
      DateTime.saturday => 'Saturday',
      DateTime.sunday => 'Sunday',
      _ => ''
    };
  }
}
