import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'screens/main_weather_screen.dart';
import 'screens/daily_weather_screen.dart';
import 'screens/weekly_weather_screen.dart';
import 'screens/advice_screen.dart';
import 'screens/archive_weather_screen.dart';

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
    PointerDeviceKind.unknown,
  };
}

void main() {
  runApp(WeatherMateApp());
}

class WeatherMateApp extends StatefulWidget {
  @override
  State<WeatherMateApp> createState() => _WeatherMateAppState();
}

class _WeatherMateAppState extends State<WeatherMateApp> {
  bool isDarkMode = true;
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: AppScrollBehavior(),
      title: 'Weather Mate',
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: PageView(
        controller: _controller,
        children: [
          MainWeatherScreen(
            isDarkMode: isDarkMode,
            onToggleTheme: () {
              setState(() => isDarkMode = !isDarkMode);
            },
          ),
          DailyWeatherScreen(
            isDarkMode: isDarkMode,
          ),
          WeeklyWeatherScreen(
            isDarkMode: isDarkMode,
          ),
          AdviceScreen(
            isDarkMode: isDarkMode,
          ),
          ArchiveWeatherScreen(
            isDarkMode: isDarkMode,
          ),

        ],
      ),
    );
  }
}
