import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

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

  String? _detectedCity;
  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    super.initState();
    _initLocationAndCity();
  }

  Future<void> _initLocationAndCity() async {
    print('[LOG] Инициализация геолокации и определения города...');
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      print('[LOG] Служба геолокации включена: $serviceEnabled');
      if (!serviceEnabled) {
        print('[ERROR] Геолокация отключена.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      print('[LOG] Статус разрешения: $permission');

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        print('[LOG] Новый статус разрешения после запроса: $permission');

        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          print('[ERROR] Пользователь не предоставил разрешение. Прерываем.');
          return;
        }
      }


      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print('[LOG] Координаты: lat=${position.latitude}, lon=${position.longitude}');

      final city = await _fetchCityFromGeoDB(position.latitude, position.longitude);

      if (city != null) {
        print('[LOG] Город определён: $city');
        if (mounted) {
          setState(() {
            _latitude = position.latitude;
            _longitude = position.longitude;
            _detectedCity = city;
          });
        }
      } else {
        print('[ERROR] Город не удалось определить.');
      }
    } catch (e, stack) {
      print('[EXCEPTION] Ошибка при получении местоположения: $e');
      print(stack);
    }
  }

  Future<String?> _fetchCityFromGeoDB(double lat, double lon) async {
    // Форматируем координаты в ISO 6709: ±DD.DDDD±DDD.DDDD
    final formattedLat = lat >= 0 ? '+${lat.toStringAsFixed(4)}' : lat.toStringAsFixed(4);
    final formattedLon = lon >= 0 ? '+${lon.toStringAsFixed(4)}' : lon.toStringAsFixed(4);
    final isoLocation = '$formattedLat$formattedLon';

    final url = Uri.parse(
        'https://wft-geo-db.p.rapidapi.com/v1/geo/locations/$isoLocation/nearbyCities?limit=1'
    );

    print('[LOG] Запрос в GeoDB: $url');

    final response = await http.get(url, headers: {
      'X-RapidAPI-Key': '993922b5f3mshc1d0a910a76c84bp1ad143jsne70a7f222492',
      'X-RapidAPI-Host': 'wft-geo-db.p.rapidapi.com',
    });

    print('[LOG] Ответ от GeoDB: ${response.statusCode}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final cities = data['data'] as List;
      if (cities.isNotEmpty) {
        final city = cities.first;
        return '${city['city']}, ${city['countryCode']}';
      }
    } else {
      print('[ERROR] Ошибка GeoDB: ${response.statusCode}, тело: ${response.body}');
    }

    return null;
  }


  @override
  Widget build(BuildContext context) {
    print('[LOG] Состояние build: city=$_detectedCity, lat=$_latitude, lon=$_longitude');

    return MaterialApp(
      scrollBehavior: AppScrollBehavior(),
      title: 'Weather Mate',
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: (_detectedCity == null || _latitude == null || _longitude == null)
          ? const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      )
          : PageView(
        controller: _controller,
        children: [
          MainWeatherScreen(
            isDarkMode: isDarkMode,
            initialCity: _detectedCity!,
            latitude: _latitude!,
            longitude: _longitude!,
            onToggleTheme: () {
              setState(() => isDarkMode = !isDarkMode);
            },
          ),
          DailyWeatherScreen(isDarkMode: isDarkMode),
          WeeklyWeatherScreen(isDarkMode: isDarkMode),
          AdviceScreen(isDarkMode: isDarkMode, weatherType: 'rainy'),
          ArchiveWeatherScreen(isDarkMode: isDarkMode),
        ],
      ),
    );
  }
}
