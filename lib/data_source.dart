import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:weather/models/forecast.dart';

import 'models/time_series.dart';

abstract class DataSource {
  Future<WeeklyForecastDto> getWeeklyForecast();
  Future<WeatherChartData> getChartData();
}

class FakeDataSource extends DataSource {
  @override
  Future<WeeklyForecastDto> getWeeklyForecast() async {
    final json = await rootBundle.loadString("assets/daily_weather.json");
    return WeeklyForecastDto.fromJson(jsonDecode(json));
  }

  @override
  Future<WeatherChartData> getChartData() async {
    final json = await rootBundle.loadString("assets/chart_data.json");
    return WeatherChartData.fromJson(jsonDecode(json));
  }

}


class RealDataSource extends DataSource {
  @override
  Future<WeeklyForecastDto> getWeeklyForecast() async {
    final location = await Location.instance.getLocation();
    final apiUrl = Uri.https("api.open-meteo.com", '/v1/forecast', {
      'latitude': '${location.latitude}',
      'longitude': '${location.longitude}',
      'daily': ['weather_code', 'temperature_2m_max', 'temperature_2m_min'],
      'wind_speed_unit': 'ms',
      'timezone': 'Europe/Berlin',
    });
    final response = await http.get(Uri.parse(apiUrl.toString()));
    return WeeklyForecastDto.fromJson(jsonDecode(response.body));
  }

  @override
  Future<WeatherChartData> getChartData() async {
    const apiUrl = "https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&daily=rain_sum&timezone=Europe%2FBerlin";
    final response = await http.get(Uri.parse(apiUrl));
    return WeatherChartData.fromJson(jsonDecode(response.body));
  }

}