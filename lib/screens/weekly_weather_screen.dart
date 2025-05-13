import 'dart:convert';
import '../models/location_model.dart';
import '../models/main_weather_model.dart';
import '../models/week_weather_model.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../tools/tools.dart';
import 'package:weather_icons/weather_icons.dart';

class WeeklyWeatherScreen extends StatefulWidget {
  final bool isDarkMode;
  
  const WeeklyWeatherScreen({Key? key, required this.isDarkMode})
      : super(key: key);

  @override
  _WeaklyWeatherScreenState createState() => _WeaklyWeatherScreenState();
}
class _WeaklyWeatherScreenState extends State<WeeklyWeatherScreen>  {
  late WeekWeatherModel weekWeatherModel;
  late DateTime selectedDateTime;
  late DateTime startOfWeek;
  late DateTime endOfWeek;
  @override
  void initState() {
    super.initState();
    selectedDateTime = Provider.of<MainWeatherModel>(context, listen: false).selectedDateTime;
    startOfWeek = selectedDateTime.subtract(Duration(days: selectedDateTime.weekday - 1));
    endOfWeek = startOfWeek.add(const Duration(days: 6));
    // Безопасно использовать listen: false в initState
    weekWeatherModel = Provider.of<WeekWeatherModel>(context, listen: false);
    weekWeatherModel.startDate = startOfWeek;
    weekWeatherModel.endDate = endOfWeek;
    _fetchWeatherData();
  }
  Future<void> _fetchWeatherData() async {
    print('fetch started week');

    if (!weekWeatherModel.areAllFlagsFalse()) {
      print('return from fetch week');
      return;
    }

    selectedDateTime = Provider.of<MainWeatherModel>(context, listen: false).selectedDateTime;
    startOfWeek = selectedDateTime.subtract(Duration(days: selectedDateTime.weekday - 1));
    endOfWeek = startOfWeek.add(const Duration(days: 6));

    weekWeatherModel = Provider.of<WeekWeatherModel>(context, listen: false);
    weekWeatherModel.startDate = startOfWeek;
    final maxAllowedDate = DateTime.now().add(Duration(days: 14));
    if (endOfWeek.isAfter(maxAllowedDate)) {
      endOfWeek = maxAllowedDate;
    }
    weekWeatherModel.endDate = endOfWeek;
    final locationModel = Provider.of<LocationModel>(context, listen: false);
    final startDateStr = _formatDate(startOfWeek);
    final endDateStr = _formatDate(endOfWeek);

    // Границы API
    final now = DateTime.now();
    final currentApiStart = now.subtract(const Duration(days: 79));
    final currentApiEnd = now.add(const Duration(days: 15));
    final historicalApiStart = now.subtract(const Duration(days: 1512));
    String baseUrl;
    final difference = now.difference(endOfWeek).inDays;
    final diffStartEnd = endOfWeek.difference(startOfWeek).inDays + 1;
    print('diffStartEnd: $diffStartEnd');
    final isHistorical = difference > 79;//79;
    if (isHistorical) {
      baseUrl = 'https://historical-forecast-api.open-meteo.com/v1/forecast';
    }
    else {
      baseUrl = 'https://api.open-meteo.com/v1/forecast';
    }
    //
    // // Проверка, весь ли диапазон недели попадает в один из API
    // if (endOfWeek.isBefore(currentApiStart) || endOfWeek.isAtSameMomentAs(currentApiStart)) {
    //   // Только историческое API
    //   baseUrl = 'https://historical-forecast-api.open-meteo.com/v1/forecast';
    // } else if (startOfWeek.isAfter(currentApiEnd) || startOfWeek.isAtSameMomentAs(currentApiEnd)) {
    //   // Данные ещё недоступны
    //   print('[ERROR] Данные за выбранную неделю еще недоступны в API.');
    //   return;
    // } else if (startOfWeek.isAfter(currentApiStart) && endOfWeek.isBefore(currentApiEnd)) {
    //   // Только обычное API
    //   baseUrl = 'https://api.open-meteo.com/v1/forecast';
    // } else if (startOfWeek.isBefore(currentApiStart) && endOfWeek.isAfter(currentApiStart)) {
    //   // Смешанный диапазон, часть данных из исторического, часть из обычного
    //   print('[ERROR] Диапазон недели пересекает границы API. Такой случай пока не обрабатывается.');
    //   //return;
    // } else {
    //   print('[ERROR] Не удалось определить подходящий API для указанного диапазона.');
    //   //return;
    // }

    final url = Uri.parse(
      '$baseUrl'
          '?latitude=${locationModel.latitude}'
          '&longitude=${locationModel.longitude}'
          '&hourly=temperature_2m,relativehumidity_2m,dew_point_2m,apparent_temperature,pressure_msl,cloud_cover,wind_speed_10m,wind_direction_10m,precipitation,snowfall,precipitation_probability,weather_code,visibility'
          '&start_date=$startDateStr'
          '&end_date=$endDateStr'
          '&timezone=auto',
    );

    print('[URL]: $url');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print(response.body);
        final data = json.decode(response.body);
        final hourlyData = data['hourly'];

        final weatherCodeList = hourlyData['weather_code'] as List<dynamic>;
        final weatherCodes = weatherCodeList.map((e) => e as int).toList();

        final temperatureList = hourlyData['temperature_2m'] as List<dynamic>;
        final humidityList = hourlyData['relativehumidity_2m'] as List<dynamic>;
        final dewPointList = hourlyData['dew_point_2m'] as List<dynamic>;
        final apparentTempList = hourlyData['apparent_temperature'] as List<dynamic>;
        final pressureList = hourlyData['pressure_msl'] as List<dynamic>;
        final cloudCoverList = hourlyData['cloud_cover'] as List<dynamic>;
        final windSpeedList = hourlyData['wind_speed_10m'] as List<dynamic>;
        final windDirectionList = hourlyData['wind_direction_10m'] as List<dynamic>;
        final precipitationList = hourlyData['precipitation'] as List<dynamic>;
        final snowfallList = hourlyData['snowfall'] as List<dynamic>;
        final precipProbabilityList = hourlyData['precipitation_probability'] as List<dynamic>;
        final visibilityList = hourlyData['visibility'] as List<dynamic>;

        List<List<FlSpot>> splitIntoDays(List<dynamic> data) {
          List<List<FlSpot>> result = List.generate(diffStartEnd, (_) => []);
          for (int i = 0; i < data.length; i++) {
            int dayIndex = i ~/ 24;
            int hour = i % 24;
            if (dayIndex < diffStartEnd) {
              result[dayIndex].add(FlSpot(hour.toDouble(), (data[i] as num).toDouble()));
            }
          }
          return result;
        }

        List<FlSpot> computeDailyMedians(List<List<FlSpot>> dailySpots) {
          return List.generate(diffStartEnd, (i) => FlSpot(i.toDouble(), median(dailySpots[i])));
        }

        final temperatureDaily = splitIntoDays(temperatureList);
        final humidityDaily = splitIntoDays(humidityList);
        final dewPointDaily = splitIntoDays(dewPointList);
        final apparentTempDaily = splitIntoDays(apparentTempList);
        final pressureDaily = splitIntoDays(pressureList);
        final cloudCoverDaily = splitIntoDays(cloudCoverList);
        final windSpeedDaily = splitIntoDays(windSpeedList);
        final windDirectionDaily = splitIntoDays(windDirectionList);
        final precipitationDaily = splitIntoDays(precipitationList);
        final snowfallDaily = splitIntoDays(snowfallList);
        final precipProbabilityDaily = splitIntoDays(precipProbabilityList);
        final visibilityDaily = splitIntoDays(visibilityList);

        if (!mounted) return;
        setState(() {
          weekWeatherModel.dailySummaries = summarizeWeatherDetailed(weatherCodes);
          weekWeatherModel.update(
            temperatureSpots: temperatureDaily,
            humiditySpots: humidityDaily,
            dewPointSpots: dewPointDaily,
            pressureSpots: pressureDaily,
            cloudCoverSpots: cloudCoverDaily,
            windSpeedSpots: windSpeedDaily,
            precipitationSpots: precipitationDaily,
            snowfallSpots: snowfallDaily,
            precipitationProbabilitySpots: precipProbabilityDaily,
            visibilitySpots: visibilityDaily,
            apparentTempSpots: apparentTempDaily,
            windDirectionSpots: windDirectionDaily,
          );

          weekWeatherModel.updateWeekMap({
            'temperature': computeDailyMedians(temperatureDaily),
            'humidity': computeDailyMedians(humidityDaily),
            'dew_point': computeDailyMedians(dewPointDaily),
            'pressure': computeDailyMedians(pressureDaily),
            'cloud_cover': computeDailyMedians(cloudCoverDaily),
            'wind_speed': computeDailyMedians(windSpeedDaily),
            'precipitation': computeDailyMedians(precipitationDaily),
            'snowfall': computeDailyMedians(snowfallDaily),
            'precipitation_probability': computeDailyMedians(precipProbabilityDaily),
            'visibility': computeDailyMedians(visibilityDaily),
            'apparent_temperature': computeDailyMedians(apparentTempDaily),
            'wind_direction': computeDailyMedians(windDirectionDaily),
          });
        });
      } else {
        print('[ERROR] Ошибка получения данных о погоде: ${response.statusCode}');
        print('[ERROR] Тело ответа: ${response.body}');
      }
    } catch (e) {
      print('[ERROR] Ошибка при запросе погоды: $e');
    }
  }

  String _formatDate(DateTime dt) =>
      '${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';


  @override
  Widget build(BuildContext context) {
    final textColor = widget.isDarkMode ? Colors.white : Colors.black87;
    final subTextColor = widget.isDarkMode ? Colors.white70 : Colors.black54;

    final daysOfWeek = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];



    String getFormattedDateRange(DateTime start, DateTime end) {
      final months = [
        '', 'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
        'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'
      ];
      return 'Неделя, ${start.day} - ${end.day} ${months[end.month]}';
    }

    SideTitles bottomTitles() =>
        SideTitles(
          showTitles: true,
          interval: 1,
          getTitlesWidget: (value, _) {
            final index = value.toInt();
            if (index >= 0 && index < daysOfWeek.length) {
              return Text(
                daysOfWeek[index],
                style: TextStyle(color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              );
            }
            return const SizedBox.shrink();
          },
        );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              widget.isDarkMode
                  ? 'assets/images/darkTheme.png'
                  : 'assets/images/lightTheme.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Погода на неделю',
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  getFormattedDateRange(startOfWeek, endOfWeek),
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                    color: subTextColor,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(weekWeatherModel.dailySummaries.length, (index) {
                    final daySummary = weekWeatherModel.dailySummaries[index];
                    final weekdayName = getWeekdayNameFromIndex(index);
                    final date = weekWeatherModel.startDate!.add(Duration(days: index));
                    final formattedDate = '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}';

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        color: widget.isDarkMode ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.8),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$weekdayName, $formattedDate',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...daySummary.entries.map(
                                    (entry) => Row(
                                  children: [
                                    Icon(
                                      getWeatherIcon(entry.value),
                                      size: 14.0,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${entry.key}: ${entry.value}',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: textColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 40),
              // График температуры
              buildLineChart(
                spots: weekWeatherModel.weekMap['temperature'] ?? [],
                lineColor: getHueShiftedColor(widget.isDarkMode ? Colors.purpleAccent : Colors.orange, shift: 20), // Сдвиг цвета для линии
                dotColor: getHueShiftedColor(widget.isDarkMode ? Colors.purpleAccent : Colors.orange, shift: -20), // Сдвиг цвета для точек
                title: 'Медианная температура',
                minY: -80,
                maxY: 80,
                minX: -1,
                maxX: 7,
                context: context,
                isDarkMode: widget.isDarkMode,
                icon: Icons.thermostat,
                unit: '°C',
                iconOffsetY: 10,
                graphicDeleter: 7,
                bottomTitlesList: ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'],
              ),
              const SizedBox(height: 32),
              buildLineChart(
                spots: weekWeatherModel.weekMap['humidity'] ?? [],
                lineColor: getHueShiftedColor(widget.isDarkMode ? Colors.cyanAccent : Colors.blue, shift: 20),
                dotColor: getHueShiftedColor(widget.isDarkMode ? Colors.cyanAccent : Colors.blue, shift: -20),
                title: 'Медианная влажность',
                minY: -10,
                maxY: 120,
                minX: -1,
                maxX: 7,
                context: context,
                isDarkMode: widget.isDarkMode,
                icon: Icons.water_drop,
                unit: '%',
                iconOffsetY: 10,
                graphicDeleter: 7,
                bottomTitlesList: ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'],
              ),
              const SizedBox(height: 32),

              // График облачности
              buildLineChart(
                spots: weekWeatherModel.weekMap['cloud_cover'] ?? [],
                lineColor: getHueShiftedColor(widget.isDarkMode ? Colors.grey : Colors.lightBlue, shift: 15),
                dotColor: getHueShiftedColor(widget.isDarkMode ? Colors.grey : Colors.lightBlue, shift: -15),
                title: 'Медианная облачность',
                minY: -10,
                maxY: 120,
                minX: -1,
                maxX: 7,
                context: context,
                isDarkMode: widget.isDarkMode,
                icon: Icons.cloud,
                unit: '%',
                iconOffsetY: 10,
                graphicDeleter: 7,
                bottomTitlesList: ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'],
              ),
              const SizedBox(height: 32),

// График давления
              buildLineChart(
                spots: weekWeatherModel.weekMap['pressure'] ?? [],
                lineColor: getHueShiftedColor(widget.isDarkMode ? Colors.greenAccent : Colors.deepPurple, shift: 25),
                dotColor: getHueShiftedColor(widget.isDarkMode ? Colors.greenAccent : Colors.deepPurple, shift: -25),
                title: 'Медианное атмосферное давление',
                minY: 700,
                maxY: 1200,
                minX: -1,
                maxX: 7,
                context: context,
                isDarkMode: widget.isDarkMode,
                icon: WeatherIcons.barometer,
                unit: 'hPa',
                iconOffsetY: 10,
                graphicDeleter: 7,
                bottomTitlesList: ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'],
              ),
              const SizedBox(height: 32),

// График скорости ветра
              buildLineChart(
                spots: weekWeatherModel.weekMap['wind_speed'] ?? [],
                lineColor: getHueShiftedColor(widget.isDarkMode ? Colors.tealAccent : Colors.indigo, shift: 10),
                dotColor: getHueShiftedColor(widget.isDarkMode ? Colors.tealAccent : Colors.indigo, shift: -10),
                title: 'Медианная скорость ветра',
                minY: -10,
                maxY: 300,
                minX: -1,
                maxX: 7,
                context: context,
                isDarkMode: widget.isDarkMode,
                icon: Icons.air,
                unit: 'km/h',
                iconOffsetY: 10,
                graphicDeleter: 7,
                bottomTitlesList: ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'],
              ),
              const SizedBox(height: 32),

// График осадков
              buildLineChart(
                spots: weekWeatherModel.weekMap['precipitation'] ?? [],
                lineColor: getHueShiftedColor(widget.isDarkMode ? Colors.pinkAccent : Colors.yellow, shift: 30),
                dotColor: getHueShiftedColor(widget.isDarkMode ? Colors.pinkAccent : Colors.yellow, shift: -30),
                title: 'Медианные осадки',
                minY: -10,
                maxY: 310,
                minX: -1,
                maxX: 7,
                context: context,
                isDarkMode: widget.isDarkMode,
                icon: Icons.beach_access,
                unit: 'mm',
                iconOffsetY: 10,
                graphicDeleter: 7,
                bottomTitlesList: ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'],
              ),
              const SizedBox(height: 32),

// Точка росы
              buildLineChart(
                spots: weekWeatherModel.weekMap['dew_point'] ?? [],
                lineColor: getHueShiftedColor(widget.isDarkMode ? Colors.lightGreenAccent : Colors.brown, shift: 20),
                dotColor: getHueShiftedColor(widget.isDarkMode ? Colors.lightGreenAccent : Colors.brown, shift: -20),
                title: 'Медианная точка росы',
                minY: -80,
                maxY: 80,
                minX: -1,
                maxX: 7,
                context: context,
                isDarkMode: widget.isDarkMode,
                icon: Icons.ac_unit,
                unit: '°C',
                iconOffsetY: 10,
                graphicDeleter: 7,
                bottomTitlesList: ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'],
              ),
              const SizedBox(height: 32),

// Ощущаемая температура
              buildLineChart(
                spots: weekWeatherModel.weekMap['apparent_temperature'] ?? [],
                lineColor: getHueShiftedColor(widget.isDarkMode ? Colors.deepOrangeAccent : Colors.deepOrange, shift: 10),
                dotColor: getHueShiftedColor(widget.isDarkMode ? Colors.deepOrangeAccent : Colors.deepOrange, shift: -10),
                title: 'Медианная ощущаемая температура',
                minY: -80,
                maxY: 80,
                minX: -1,
                maxX: 7,
                context: context,
                isDarkMode: widget.isDarkMode,
                icon: Icons.device_thermostat,
                unit: '°C',
                iconOffsetY: 10,
                graphicDeleter: 7,
                bottomTitlesList: ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'],
              ),
              const SizedBox(height: 32),

// Снегопад
              buildLineChart(
                spots: weekWeatherModel.weekMap['snowfall'] ?? [],
                lineColor: getHueShiftedColor(widget.isDarkMode ? Colors.white70 : Colors.cyan, shift: 10),
                dotColor: getHueShiftedColor(widget.isDarkMode ? Colors.white70 : Colors.cyan, shift: -10),
                title: 'Медианный снегопад',
                minY: -10,
                maxY: 120,
                minX: -1,
                maxX: 7,
                context: context,
                isDarkMode: widget.isDarkMode,
                icon: Icons.ac_unit_outlined,
                unit: 'cm',
                iconOffsetY: 10,
                graphicDeleter: 7,
                bottomTitlesList: ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'],
              ),
              const SizedBox(height: 32),

// Вероятность осадков
              buildLineChart(
                spots: weekWeatherModel.weekMap['precipitation_probability'] ?? [],
                lineColor: getHueShiftedColor(widget.isDarkMode ? Colors.amberAccent : Colors.red, shift: 15),
                dotColor: getHueShiftedColor(widget.isDarkMode ? Colors.amberAccent : Colors.red, shift: -15),
                title: 'Медианная вероятность осадков',
                minY: -10,
                maxY: 120,
                minX: -1,
                maxX: 7,
                context: context,
                isDarkMode: widget.isDarkMode,
                icon: Icons.umbrella,
                unit: '%',
                iconOffsetY: 10,
                graphicDeleter: 7,
                bottomTitlesList: ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'],
              ),
              const SizedBox(height: 32),

// Видимость
              buildLineChart(
                spots: weekWeatherModel.weekMap['visibility'] ?? [],
                lineColor: getHueShiftedColor(widget.isDarkMode ? Colors.blueGrey : Colors.lightGreen, shift: 20),
                dotColor: getHueShiftedColor(widget.isDarkMode ? Colors.blueGrey : Colors.lightGreen, shift: -20),
                title: 'Медианная видимость',
                minY: -10,
                maxY: 100000,
                minX: -1,
                maxX: 7,
                context: context,
                isDarkMode: widget.isDarkMode,
                icon: Icons.remove_red_eye,
                unit: 'm',
                iconOffsetY: 10,
                graphicDeleter: 7,
                bottomTitlesList: ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'],
              ),
              const SizedBox(height: 32),

// Направление ветра
              buildLineChart(
                spots: weekWeatherModel.weekMap['wind_direction'] ?? [],
                lineColor: getHueShiftedColor(widget.isDarkMode ? Colors.limeAccent : Colors.deepOrangeAccent, shift: 30),
                dotColor: getHueShiftedColor(widget.isDarkMode ? Colors.limeAccent : Colors.deepOrangeAccent, shift: -30),
                title: 'Медианное направление ветра',
                minY: -10,
                maxY: 380,
                minX: -1,
                maxX: 7,
                context: context,
                isDarkMode: widget.isDarkMode,
                icon: Icons.explore,
                unit: '°',
                iconOffsetY: 10,
                graphicDeleter: 7,
                bottomTitlesList: ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'],
              ),
              const SizedBox(height: 32),

              // Заголовок таблицы
              Center(
                child: Text(
                  'Медианные погодные условия за неделю',
                  style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),

// Таблица со средними значениями
              Container(
                decoration: BoxDecoration(
                  color: widget.isDarkMode ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(3),
                  },
                  children: [
                    buildRow('Температура', '${median(weekWeatherModel.weekMap['temperature'] ?? []).toStringAsFixed(1)} °C', textColor),
                    buildRow('Влажность', '${median(weekWeatherModel.weekMap['humidity'] ?? []).toStringAsFixed(1)} %', textColor),
                    buildRow('Точка росы', '${median(weekWeatherModel.weekMap['dew_point'] ?? []).toStringAsFixed(1)} °C', textColor),
                    buildRow('Ощущается как', '${median(weekWeatherModel.weekMap['apparent_temperature'] ?? []).toStringAsFixed(1)} °C', textColor),
                    buildRow('Давление', '${median(weekWeatherModel.weekMap['pressure'] ?? []).toStringAsFixed(1)} hPa', textColor),
                    buildRow('Облачность', '${median(weekWeatherModel.weekMap['cloud_cover'] ?? []).toStringAsFixed(1)} %', textColor),
                    buildRow('Скорость ветра', '${median(weekWeatherModel.weekMap['wind_speed'] ?? []).toStringAsFixed(1)} км/ч', textColor),
                    buildRow('Направление ветра', '${median(weekWeatherModel.weekMap['wind_direction'] ?? []).toStringAsFixed(0)} °', textColor),
                    buildRow('Осадки', '${median(weekWeatherModel.weekMap['precipitation'] ?? []).toStringAsFixed(1)} мм', textColor),
                    buildRow('Вероятность осадков', '${median(weekWeatherModel.weekMap['precipitation_probability'] ?? []).toStringAsFixed(1)} %', textColor),
                    buildRow('Снегопад', '${median(weekWeatherModel.weekMap['snowfall'] ?? []).toStringAsFixed(1)} см', textColor),
                    buildRow('Видимость', '${(median(weekWeatherModel.weekMap['visibility'] ?? []) / 1000).toStringAsFixed(1)} км', textColor),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}