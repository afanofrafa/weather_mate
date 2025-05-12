import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../widgets/city_search_widget.dart';

class MainWeatherScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final String initialCity;
  final double latitude;
  final double longitude;

  const MainWeatherScreen({
    Key? key,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.initialCity,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  @override
  State<MainWeatherScreen> createState() => _MainWeatherScreenState();
}

class _MainWeatherScreenState extends State<MainWeatherScreen> {
  late String _selectedDate;
  late String _selectedCity;
  late double _latitude;
  late double _longitude;

  String _weatherDesc = '';
  double _temperature = 0.0;
  double _precipitation = 0.0;

  @override
  void initState() {
    super.initState();
    _selectedCity = widget.initialCity;
    _latitude = widget.latitude;
    _longitude = widget.longitude;
    _initDate();
    _fetchWeather();
  }

  void _initDate() {
    final now = DateTime.now();
    const weekdays = [
      'понедельник', 'вторник', 'среда', 'четверг',
      'пятница', 'суббота', 'воскресенье'
    ];
    const months = [
      'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
      'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'
    ];

    final weekday = weekdays[now.weekday - 1];
    final day = now.day;
    final month = months[now.month - 1];

    _selectedDate = 'Сегодня, $weekday, $day $month';
  }

  Future<void> _fetchWeather() async {
    print('[LOG] MainWeatherScreen: Получение погоды для $_selectedCity ($_latitude, $_longitude)');

    final weatherUrl = Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=$_latitude&longitude=$_longitude&current_weather=true&daily=precipitation_sum&timezone=auto',
    );

    try {
      final weatherRes = await http.get(weatherUrl);
      if (weatherRes.statusCode == 200) {
        final weatherData = json.decode(weatherRes.body);
        final current = weatherData['current_weather'];
        final daily = weatherData['daily'];

        setState(() {
          _temperature = current['temperature']?.toDouble() ?? 0.0;
          _weatherDesc = _mapWeatherCodeToDescription(current['weathercode']);
          _precipitation = daily['precipitation_sum'][0]?.toDouble() ?? 0.0;
        });

        print('[LOG] Погода обновлена: $_temperature°C, $_weatherDesc, $_precipitation мм');
      } else {
        print('[ERROR] Ошибка погоды: ${weatherRes.statusCode}');
      }
    } catch (e) {
      print('[ERROR] Ошибка получения погоды: $e');
    }
  }

  Future<void> _getCoordinatesForCity(String city) async {
    print('[LOG] Получение координат для города: $city');

    final url = Uri.parse(
      'https://geocoding-api.open-meteo.com/v1/search?name=$city&count=1&language=ru&format=json',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          final result = data['results'][0];
          setState(() {
            _latitude = result['latitude'];
            _longitude = result['longitude'];
            _selectedCity = '${result['name']}, ${result['country_code']}';
          });
          print('[LOG] Координаты получены: $_latitude, $_longitude ($_selectedCity)');
          await _fetchWeather();
        } else {
          print('[ERROR] Координаты не найдены для города $city');
        }
      } else {
        print('[ERROR] Ошибка координат: ${response.statusCode}');
      }
    } catch (e) {
      print('[ERROR] Ошибка получения координат: $e');
    }
  }

  String _mapWeatherCodeToDescription(int code) {
    if (code == 0) return 'Ясно';
    if ([1, 2, 3].contains(code)) return 'Переменная облачность';
    if ([45, 48].contains(code)) return 'Туман';
    if ([51, 53, 55, 61, 63, 65].contains(code)) return 'Дождь';
    if ([66, 67, 71, 73, 75, 77].contains(code)) return 'Снег';
    if ([80, 81, 82].contains(code)) return 'Ливень';
    if ([95, 96, 99].contains(code)) return 'Гроза';
    return 'Неизвестно';
  }

  void _openCitySearch() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CitySearchWidget(
            onCitySelected: (displayName, cityOnly) async {
              Navigator.pop(context);
              setState(() {
                _selectedCity = displayName; // Показать полный формат
              });
              await _getCoordinatesForCity(cityOnly); // Искать по названию города
            },
          ),

        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final backgroundImage = widget.isDarkMode
        ? 'assets/images/darkTheme.png'
        : 'assets/images/lightTheme.png';

    final textColor = widget.isDarkMode ? Colors.white : Colors.black87;
    final subTextColor = widget.isDarkMode ? Colors.white70 : Colors.black54;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _openCitySearch,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.onToggleTheme,
        child: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Icon(Icons.location_on, color: subTextColor, size: 20),
                const SizedBox(height: 4),
                Text(
                  _selectedCity.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _selectedDate,
                  style: TextStyle(color: subTextColor, fontSize: 14),
                ),
              ],
            ),
            Icon(Icons.wb_sunny, size: 100, color: textColor),
            Text(
              '${_temperature.toStringAsFixed(0)}°С',
              style: TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Text(
              _weatherDesc,
              style: TextStyle(
                fontSize: 22,
                color: textColor,
              ),
            ),
            Text(
              '${_precipitation.toStringAsFixed(1)} мм осадков',
              style: TextStyle(
                fontSize: 14,
                color: subTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
