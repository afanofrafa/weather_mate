import 'package:weather_icons/weather_icons.dart';
import 'package:flutter/material.dart';

IconData getWeatherIcon(String description) {
  print('getIcon weatherDesc: $description');
  switch (description.toLowerCase()) {
    case 'ясно':
      return WeatherIcons.day_sunny;
    case 'переменная облачность':
      return WeatherIcons.day_cloudy;
    case 'туман':
      return WeatherIcons.fog;
    case 'дождь':
      return WeatherIcons.rain;
    case 'снег':
      return WeatherIcons.snow;
    case 'ливень':
      return WeatherIcons.rain;
    case 'гроза':
      return WeatherIcons.thunderstorm;
    default:
      return WeatherIcons.na;
  }
}
Color getHueShiftedColor(Color baseColor, {double shift = 10}) {
  final hsl = HSLColor.fromColor(baseColor);
  final shiftedHue = (hsl.hue + shift) % 360;
  return hsl.withHue(shiftedHue).toColor();
}