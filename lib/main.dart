import 'package:flutter/material.dart';
import 'screens/main_weather_screen.dart';

void main() {
  runApp(WeatherMateApp());
}

class WeatherMateApp extends StatefulWidget {
  @override
  State<WeatherMateApp> createState() => _WeatherMateAppState();
}

class _WeatherMateAppState extends State<WeatherMateApp> {
  bool isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Mate',
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: MainWeatherScreen(
        isDarkMode: isDarkMode,
        onToggleTheme: () {
          setState(() {
            isDarkMode = !isDarkMode;
          });
        },
      ),
    );
  }
}
