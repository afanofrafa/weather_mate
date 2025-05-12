import 'dart:convert';
import 'package:flutter/material.dart';
import '../widgets/city_search_widget.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class ArchiveWeatherScreen extends StatefulWidget {
  final bool isDarkMode;

  const ArchiveWeatherScreen({Key? key, required this.isDarkMode}) : super(key: key);

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
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                    onCitySelected: (cityName) {
                      setState(() {
                        _selectedCity = cityName;
                        _cityController.text = cityName;
                      });
                    },
                    //isDarkMode: widget.isDarkMode,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _pickDate,
                    child: Text(_selectedDate == null
                        ? 'Выбрать дату'
                        : DateFormat('dd.MM.yyyy').format(_selectedDate!)),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _fetchWeather,
                    child: const Text('Показать погоду'),
                  ),
                  const SizedBox(height: 20),
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
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2000),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: widget.isDarkMode
              ? ThemeData.dark()
              : ThemeData.light(),
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

  Future<void> _fetchWeather() async {
    if (_selectedCity.isEmpty || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите город и выберите дату')),
      );
      return;
    }

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
    }
  }
}
