import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:weather/models.dart';

abstract class DataSource {
  Future<WeeklyForecastDto> getWeeklyForecast();
}

class FakeDataSource extends DataSource {
  @override
  Future<WeeklyForecastDto> getWeeklyForecast() async {
    final json = await rootBundle.loadString("assets/daily_weather.json");
    return WeeklyForecastDto.fromJson(jsonDecode(json));
  }
}


class RealDataSource extends DataSource {
  @override
  Future<WeeklyForecastDto> getWeeklyForecast() async {
    const url = "https://api.open-meteo.com/v1/forecast?latitude=55.4933&longitude=8.5307&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=Europe%2FBerlin";
    final response = await http.get(Uri.parse(url));
    final map = json.decode(response.body);
    return WeeklyForecastDto.fromJson(map);
  }
}