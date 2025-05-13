import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'models/location_model.dart';
import 'models/main_weather_model.dart';
import 'models/daily_weather_model.dart';
import 'models/week_weather_model.dart';

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
  runApp(
    MultiProvider(  // Используем MultiProvider, чтобы предоставить несколько провайдеров
      providers: [
        ChangeNotifierProvider(create: (_) => WeekWeatherModel()),
        ChangeNotifierProvider(create: (_) => DailyWeatherModel()),
        ChangeNotifierProvider(create: (_) => LocationModel('', '', 0.0, 0.0)),  // Ваш LocationModel
        ChangeNotifierProvider(create: (_) => MainWeatherModel()),  // Новый провайдер для WeatherModel
      ],
      child: WeatherMateApp(),
    ),
  );
}

class WeatherMateApp extends StatefulWidget {
  @override
  State<WeatherMateApp> createState() => _WeatherMateAppState();
}

class _WeatherMateAppState extends State<WeatherMateApp> {
  bool isDarkMode = true;
  final PageController _controller = PageController();

  @override
  void initState() {
    super.initState();
    _initLocationAndCity();
  }

  Future<void> _initLocationAndCity() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      final location = await _fetchCityFromGeoDB(position.latitude, position.longitude);

      if (location != null && mounted) {
        final locationModel = Provider.of<LocationModel>(
            context, listen: false);

        locationModel.updateLocation(
          location['city'] ?? 'Unknown City', // Default value if null
          location['countryCode'] ?? 'Unknown', // Default value if null
          position.latitude,
          position.longitude,
        );
      }
    } catch (e) {
      print('[ERROR] Геолокация: $e');
    }
  }

  Future<Map<String, String>?> _fetchCityFromGeoDB(double lat, double lon) async {
    final formattedLat = lat >= 0 ? '+${lat.toStringAsFixed(4)}' : lat.toStringAsFixed(4);
    final formattedLon = lon >= 0 ? '+${lon.toStringAsFixed(4)}' : lon.toStringAsFixed(4);
    final isoLocation = '$formattedLat$formattedLon';

    final url = Uri.parse(
        'https://wft-geo-db.p.rapidapi.com/v1/geo/locations/$isoLocation/nearbyCities?limit=1');

    final response = await http.get(url, headers: {
      'X-RapidAPI-Key': '993922b5f3mshc1d0a910a76c84bp1ad143jsne70a7f222492',
      'X-RapidAPI-Host': 'wft-geo-db.p.rapidapi.com',
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final cities = data['data'] as List;
      if (cities.isNotEmpty) {
        final city = cities.first;
        return {
          'city': city['city'],
          'countryCode': city['countryCode'],
        };
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final locationModel = Provider.of<LocationModel>(context);

    return MaterialApp(
      scrollBehavior: AppScrollBehavior(),
      title: 'Weather Mate',
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: (locationModel.city.isEmpty)
          ? const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      )
          : PageView(
        controller: _controller,
        children: [
          MainWeatherScreen(
            isDarkMode: isDarkMode,
            onToggleTheme: () {
              setState(() => isDarkMode = !isDarkMode);
            },
          ),
          // Передаем locationModel в DailyWeatherScreen
          DailyWeatherScreen(isDarkMode: isDarkMode),
          WeeklyWeatherScreen(isDarkMode: isDarkMode),
          AdviceScreen(isDarkMode: isDarkMode, weatherType: 'rainy'),
          ArchiveWeatherScreen(isDarkMode: isDarkMode),
        ],
      ),
    );
  }
}
