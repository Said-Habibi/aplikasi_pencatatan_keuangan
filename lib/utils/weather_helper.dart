import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherData {
  final double tempC;
  final String condition;
  final String iconUrl;
  final double precipMM;
  final String? areaName;

  WeatherData({
    required this.tempC,
    required this.condition,
    required this.iconUrl,
    required this.precipMM,
    this.areaName,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final current = json['current_condition'][0];
    String? area;
    try {
      area = json['nearest_area'][0]['areaName'][0]['value'];
    } catch (_) {}

    return WeatherData(
      tempC: double.tryParse(current['temp_C'].toString()) ?? 0,
      condition: current['weatherDesc'][0]['value'],
      iconUrl: current['weatherIconUrl'][0]['value'],
      precipMM: double.tryParse(current['precipMM'].toString()) ?? 0,
      areaName: area,
    );
  }

  IconData get iconData {
    final desc = condition.toLowerCase();
    if (desc.contains('sunny') || desc.contains('clear')) return Icons.wb_sunny_rounded;
    if (desc.contains('partly cloudy')) return Icons.wb_cloudy_rounded;
    if (desc.contains('cloudy') || desc.contains('overcast')) return Icons.cloud_rounded;
    if (desc.contains('mist') || desc.contains('fog') || desc.contains('haze')) return Icons.cloud_queue_rounded;
    if (desc.contains('patchy rain') || desc.contains('light rain') || desc.contains('rain')) return Icons.umbrella_rounded;
    if (desc.contains('thunder') || desc.contains('storm')) return Icons.thunderstorm_rounded;
    if (desc.contains('snow')) return Icons.ac_unit_rounded;
    return Icons.wb_cloudy_rounded;
  }
}

class WeatherHelper {
  static Future<WeatherData?> fetchWeather(String location) async {
    try {
      final response = await http.get(Uri.parse('https://wttr.in/$location?format=j1'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherData.fromJson(data);
      }
    } catch (e) {
      debugPrint('Error fetching weather: $e');
    }
    return null;
  }
}
