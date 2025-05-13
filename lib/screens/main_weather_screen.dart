import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';


import '../widgets/city_search_widget.dart';
import '../models/location_model.dart';
import '../models/main_weather_model.dart';
import '../models/week_weather_model.dart';
import '../models/daily_weather_model.dart';

import '../tools/tools.dart';

class MainWeatherScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const MainWeatherScreen({
    Key? key,
    required this.isDarkMode,
    required this.onToggleTheme,
  }) : super(key: key);

  @override
  State<MainWeatherScreen> createState() => _MainWeatherScreenState();
}

class _MainWeatherScreenState extends State<MainWeatherScreen> {
  late String _selectedDate;

  @override
  void initState() {
    super.initState();
    _initDate();
    Future.microtask(() => _conditionallyFetchWeather());
  }

  void _initDate() {
    print('MAIN BEFORE INIT');
    if (!Provider.of<MainWeatherModel>(context, listen: false).isArchiveScreenCall) {
      print('MAIN INIT');
      final now = DateTime.now();
      const weekdays = [
        'понедельник',
        'вторник',
        'среда',
        'четверг',
        'пятница',
        'суббота',
        'воскресенье'
      ];
      const months = [
        'января',
        'февраля',
        'марта',
        'апреля',
        'мая',
        'июня',
        'июля',
        'августа',
        'сентября',
        'октября',
        'ноября',
        'декабря'
      ];
      _selectedDate =
      'Сегодня, ${weekdays[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}';

      Provider.of<MainWeatherModel>(context, listen: false).updateSelectedDate(
          _selectedDate, now);
    }
  }

  Future<void> _conditionallyFetchWeather() async {
    //final location = Provider.of<LocationModel>(context, listen: false);
    final weatherModel = Provider.of<MainWeatherModel>(context, listen: false);

    if (weatherModel.isTemperatureLoaded &&
        weatherModel.isPrecipitationLoaded &&
        weatherModel.isWeatherDescLoaded &&
        weatherModel.isSelectedDateLoaded) {
      print('[INFO] Используем кэшированные погодные данные.');
      return;
    }

    await _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    print('FETCH WEATHER');
    final location = Provider.of<LocationModel>(context, listen: false);
    final weatherModel = Provider.of<MainWeatherModel>(context, listen: false);
    late bool isHistorical;

    print('[LOG] Получение погоды для ${location.city} (${location.latitude}, ${location.longitude})');

    final DateTime now = DateTime.now();
    final DateTime selected = weatherModel.selectedDateTime;
    final String formattedDate = DateFormat('yyyy-MM-dd').format(selected);

    late Uri weatherUrl = Uri();

    if (!weatherModel.isArchiveScreenCall) {
      print('[URL]:current');
      // Текущий экран — не архив: только текущая погода и осадки
      weatherUrl = Uri.parse(
        'https://api.open-meteo.com/v1/forecast'
            '?latitude=${location.latitude}'
            '&longitude=${location.longitude}'
            '&current_weather=true'
            '&daily=precipitation_sum'
            '&timezone=auto',
      );
    } else {
      // Экран архивной погоды, выбор между archive и forecast по дате
      final now = DateTime.now();
      final difference = now.difference(weatherModel.selectedDateTime).inDays;

      isHistorical = difference > 79;//79;

      final String baseUrl = isHistorical
          ? 'https://historical-forecast-api.open-meteo.com/v1/forecast'
          : 'https://api.open-meteo.com/v1/forecast';

      print('[URL]:$baseUrl');
      final String weatherCodeParam = isHistorical ? 'weather_code' : 'weathercode';

      weatherUrl = Uri.parse(
        '$baseUrl'
            '?latitude=${location.latitude}'
            '&longitude=${location.longitude}'
            '&daily=temperature_2m_max,temperature_2m_min,precipitation_sum,$weatherCodeParam'
            '&start_date=$formattedDate'
            '&end_date=$formattedDate'
            '&timezone=auto',
      );
    }

    print('[URL]:$weatherUrl');
    try {
      final response = await http.get(weatherUrl);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('[RESPONSE DATA]: $data');

        if (!weatherModel.isArchiveScreenCall) {
          final current = data['current_weather'];
          final daily = data['daily'];

          weatherModel.updateTemperature(current['temperature']?.toDouble() ?? 0.0);
          weatherModel.updateWeatherDesc(mapWeatherCodeToDescription(current['weathercode']));
          weatherModel.updatePrecipitation(daily['precipitation_sum'][0]?.toDouble() ?? 0.0);
        } else {
          final daily = data['daily'];

          final tempMax = daily['temperature_2m_max'][0]?.toDouble() ?? 0.0;
          final tempMin = daily['temperature_2m_min'][0]?.toDouble() ?? 0.0;
          final precipitation = daily['precipitation_sum'][0]?.toDouble() ?? 0.0;
          late dynamic weatherCode;
          if (isHistorical) {
            weatherCode = daily['weather_code'][0];
          }
          else {
            weatherCode = daily['weathercode'][0];
          }

          weatherModel.updateTemperature((tempMax + tempMin) / 2);
          weatherModel.updateWeatherDesc(mapWeatherCodeToDescription(weatherCode));
          weatherModel.updatePrecipitation(precipitation);
        }

        print('Погода обновлена: ${weatherModel.weatherDesc}');
      } else {
        print('[ERROR] Ошибка погоды: ${response.statusCode}');
      }
    } catch (e) {
      print('[ERROR] Ошибка получения погоды: $e');
    }
  }


  Future<void> _getCoordinatesForCity(String city) async {
    /*final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);

    final weatherUrl = Uri.parse(
      'https://api.open-meteo.com/v1/forecast'
          '?latitude=${location.latitude}'
          '&longitude=${location.longitude}'
          '&daily=temperature_2m_max,temperature_2m_min,precipitation_sum,weathercode'
          '&start_date=$formattedDate'
          '&end_date=$formattedDate'
          '&timezone=auto',
    );*/

    final url = Uri.parse(
      'https://geocoding-api.open-meteo.com/v1/search?name=$city&count=1&language=ru&format=json',
    );

    try {
      final response = await http.get(url);
      print('GEY CURL');
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

          Provider.of<MainWeatherModel>(context, listen: false).updateTemperature(Provider.of<MainWeatherModel>(context, listen: false).temperature);
          Provider.of<MainWeatherModel>(context, listen: false).updateArchiveScreenCall(false);

          print('RESET DAILY');
          Provider.of<DailyWeatherModel>(context, listen: false).reset();

          Provider.of<WeekWeatherModel>(context, listen: false).reset();

          await _fetchWeather();
        }
      }
    } catch (e) {
      print('[ERROR] Ошибка получения координат: $e');
    }
  }

  void _openCitySearch() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CitySearchWidget(
            onCitySelected: (displayName, cityOnly) async {
              Navigator.pop(context);
              await _getCoordinatesForCity(cityOnly);
              },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final location = Provider.of<LocationModel>(context);
    final weather = Provider.of<MainWeatherModel>(context);
    final backgroundImage = widget.isDarkMode ? 'assets/images/darkTheme.png' : 'assets/images/lightTheme.png';
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
                  '${location.city.toUpperCase()}, ${location.countryCode}',
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
                  weather.selectedDate,
                  style: TextStyle(color: subTextColor, fontSize: 14),
                ),
              ],
            ),
            Icon(getWeatherIcon(
                Provider.of<MainWeatherModel>(context, listen: false).weatherDesc),
                size: 120.0,
            ),
            Text(
              '${weather.temperature.toStringAsFixed(0)}°С',
              style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: textColor),
            ),
            Text(
              weather.weatherDesc,
              style: TextStyle(fontSize: 22, color: textColor),
            ),
            Text(
              '${weather.precipitation.toStringAsFixed(1)} мм осадков',
              style: TextStyle(fontSize: 14, color: subTextColor),
            ),
          ],
        ),
      ),
    );
  }
}
