import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/main_weather_model.dart';
import '../models/week_weather_model.dart';
import '../models/daily_weather_model.dart';
import '../models/location_model.dart';
import 'package:provider/provider.dart';
import '../widgets/city_search_widget.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class ArchiveWeatherScreen extends StatefulWidget {
  final bool isDarkMode;
  final PageController controller; // ← добавляем это

  const ArchiveWeatherScreen({
    Key? key,
    required this.isDarkMode,
    required this.controller, // ← и это
  }) : super(key: key);

  @override
  _ArchiveWeatherScreenState createState() => _ArchiveWeatherScreenState();
}

class _ArchiveWeatherScreenState extends State<ArchiveWeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  DateTime? _selectedDate;
  Map<String, dynamic>? _weatherData;
  String _selectedCity = "";

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isDarkMode ? Colors.white : Colors.black87;
    final bgImage = widget.isDarkMode
        ? 'assets/images/darkTheme.png'
        : 'assets/images/lightTheme.png';

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(bgImage, fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(widget.isDarkMode ? 0.3 : 0.15),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Ваша информация сверху
                Text(
                  'Архив погоды',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                CitySearchWidget(
                  onCitySelected: (displayName, cityOnly) async {
                    setState(() {
                      _selectedCity = displayName;
                    });
                  },
                ),
                const SizedBox(height: 12),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 40),
                  ),
                  onPressed: _pickDate,
                  child: Text(_selectedDate == null
                      ? 'Выбрать дату'
                      : DateFormat('dd.MM.yyyy').format(_selectedDate!)),
                ),
                const SizedBox(height: 12),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 40),
                  ),
                  onPressed: _fetchWeather,
                  child: const Text('Показать погоду'),
                ),
                const SizedBox(height: 20),

                // Expanded обертывает часть, которая может изменять размер
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (_weatherData != null)
                          Card(
                            color: widget.isDarkMode
                                ? Colors.white10
                                : Colors.white.withOpacity(0.8),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Город: ${_weatherData!['city']}',
                                    style: TextStyle(color: textColor),
                                  ),
                                  Text(
                                    'Дата: ${_weatherData!['date']}',
                                    style: TextStyle(color: textColor),
                                  ),
                                  Text(
                                    'Температура: ${_weatherData!['temp']}°C',
                                    style: TextStyle(color: textColor),
                                  ),
                                  Text(
                                    'Описание: ${_weatherData!['description']}',
                                    style: TextStyle(color: textColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime.now().subtract(Duration(days: 1511)), // или любую другую минимальную дату
      lastDate: now.add(const Duration(days: 14)), // до 14 дней вперёд
      builder: (context, child) {
        return Theme(
          data: widget.isDarkMode ? ThemeData.dark() : ThemeData.light(),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _getCoordinatesForCity(String city) async {
    final url = Uri.parse(
      'https://geocoding-api.open-meteo.com/v1/search?name=$city&count=1&language=ru&format=json',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          final result = data['results'][0];
          final displayName = result['name'];
          final countryCode = result['country_code'];
          final lat = result['latitude'];
          final lon = result['longitude'];

          Provider.of<LocationModel>(context, listen: false)
              .updateLocation(displayName, countryCode, lat, lon);

          Provider.of<MainWeatherModel>(context, listen: false).reset();
          const weekdays = ['понедельник', 'вторник', 'среда', 'четверг', 'пятница', 'суббота', 'воскресенье'];
          const months = ['января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'];
          String str = '${weekdays[_selectedDate!.weekday - 1]}, ${_selectedDate!.day} ${months[_selectedDate!.month - 1]} ${_selectedDate!.year}';
          Provider.of<MainWeatherModel>(context, listen: false).updateSelectedDate(str, _selectedDate!);
          Provider.of<MainWeatherModel>(context, listen: false).updateArchiveScreenCall(true);
          Provider.of<DailyWeatherModel>(context, listen: false).reset();

          Provider.of<WeekWeatherModel>(context, listen: false).reset();

          //await _fetchWeather();
        }
      }
    } catch (e) {
      print('[ERROR] Ошибка получения координат: $e');
    }
  }
  Future<void> _fetchWeather() async {
    if (_selectedCity.isEmpty || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите город и выберите дату')),
      );
      return;
    }
    final cityOnly = _selectedCity.split(',').first.trim();
    await _getCoordinatesForCity(cityOnly);

    // print('ARCHIVE');
    // print(_selectedCity);
    // print(_selectedDate);
    //Provider.of<MainWeatherModel>(context, listen: false).updateSelectedDate(_selectedDate);
    widget.controller.jumpToPage(0);
    /*
    // Здесь будет запрос к API для получения данных о погоде для выбранного города и даты
    final url = Uri.parse('https://api.weatherapi.com/v1/history.json?key=YOUR_API_KEY&q=$_selectedCity&dt=${DateFormat('yyyy-MM-dd').format(_selectedDate!)}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        _weatherData = {
          'city': _selectedCity,
          'date': DateFormat('dd.MM.yyyy').format(_selectedDate!),
          'temp': data['forecast']['forecastday'][0]['day']['avgtemp_c'],
          'description': data['forecast']['forecastday'][0]['day']['condition']['text'],
        };
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка загрузки данных о погоде')),
      );
    }*/
  }
}
