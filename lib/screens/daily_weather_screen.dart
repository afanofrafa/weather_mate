import 'dart:convert';
import '../models/location_model.dart';
import '../models/main_weather_model.dart';
import '../models/daily_weather_model.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../tools/tool_icons.dart';
import 'package:weather_icons/weather_icons.dart';

class DailyWeatherScreen extends StatefulWidget {
  final bool isDarkMode;

  const DailyWeatherScreen({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  _DailyWeatherScreenState createState() => _DailyWeatherScreenState();
}

class _DailyWeatherScreenState extends State<DailyWeatherScreen> {
  //late List<FlSpot> temperatureSpots = [];
  //late List<FlSpot> humiditySpots = [];
  late DailyWeatherModel dailyWeatherModel;
  @override
  void initState() {
    super.initState();
    // Безопасно использовать listen: false в initState
    dailyWeatherModel = Provider.of<DailyWeatherModel>(context, listen: false);
    _fetchWeatherData();
  }

  // Метод для получения данных о погоде
  Future<void> _fetchWeatherData() async {
    print('fetch started');

    if (!dailyWeatherModel.areAllFlagsFalse()) {
      print('return from fetch');
      return;
    }

    print('fetch doing api request');
    final locationModel = Provider.of<LocationModel>(context, listen: false);
    final selectedDate = DateTime.now();
    final dateStr = '${selectedDate.year.toString().padLeft(4, '0')}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';

    print('[LOG] Получение погоды для ${locationModel.city} (${locationModel.latitude}, ${locationModel.longitude})');
    print('[LOG] Выбранная дата: $dateStr');

    final url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast'
          '?latitude=${locationModel.latitude}'
          '&longitude=${locationModel.longitude}'
          '&hourly=temperature_2m,relativehumidity_2m,dew_point_2m,apparent_temperature,pressure_msl,cloud_cover,wind_speed_10m,wind_direction_10m,precipitation,snowfall,precipitation_probability,weather_code,visibility'
          '&start_date=$dateStr'
          '&end_date=$dateStr'
          '&timezone=auto',
    );

    try {
      final response = await http.get(url);
      print(response.body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final hourlyData = data['hourly'];

        final timeList = hourlyData['time'] as List<dynamic>;
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
        final weatherCodeList = hourlyData['weather_code'] as List<dynamic>;
        final visibilityList = hourlyData['visibility'] as List<dynamic>;

        final targetHours = ['00:00', '03:00', '06:00', '09:00', '12:00', '15:00', '18:00', '21:00'];

        final tempSpots = <FlSpot>[];
        final humidSpots = <FlSpot>[];
        final dewPointSpots = <FlSpot>[];
        final apparentTempSpots = <FlSpot>[];
        final pressureSpots = <FlSpot>[];
        final cloudCoverSpots = <FlSpot>[];
        final windSpeedSpots = <FlSpot>[];
        final windDirectionSpots = <FlSpot>[];
        final precipitationSpots = <FlSpot>[];
        final snowfallSpots = <FlSpot>[];
        final precipProbabilitySpots = <FlSpot>[];
        final visibilitySpots = <FlSpot>[];

        for (int i = 0; i < timeList.length; i++) {
          final timeStr = timeList[i] as String;
          final dateTime = DateTime.parse(timeStr);
          final formattedTime = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

          if (targetHours.contains(formattedTime)) {
            print('[LOG] Добавляем данные за ${dateTime.hour}: '
                'Темп = ${temperatureList[i]}, '
                'Влажн = ${humidityList[i]}, '
                'Точка росы = ${dewPointList[i]}, '
                'Ощущаемая = ${apparentTempList[i]}, '
                'Давление = ${pressureList[i]}, '
                'Облачность = ${cloudCoverList[i]}, '
                'Скорость ветра = ${windSpeedList[i]}, '
                'Направление ветра = ${windDirectionList[i]}, '
                'Осадки = ${precipitationList[i]}, '
                'Снег = ${snowfallList[i]}, '
                'Вероятность осадков = ${precipProbabilityList[i]}, '
                'Код погоды = ${weatherCodeList[i]}, '
                'Видимость = ${visibilityList[i]}');

            tempSpots.add(FlSpot(tempSpots.length.toDouble(), temperatureList[i].toDouble()));
            humidSpots.add(FlSpot(humidSpots.length.toDouble(), humidityList[i].toDouble()));
            dewPointSpots.add(FlSpot(dewPointSpots.length.toDouble(), dewPointList[i].toDouble()));
            apparentTempSpots.add(FlSpot(apparentTempSpots.length.toDouble(), apparentTempList[i].toDouble()));
            pressureSpots.add(FlSpot(pressureSpots.length.toDouble(), pressureList[i].toDouble()));
            cloudCoverSpots.add(FlSpot(cloudCoverSpots.length.toDouble(), cloudCoverList[i].toDouble()));
            windSpeedSpots.add(FlSpot(windSpeedSpots.length.toDouble(), windSpeedList[i].toDouble()));
            windDirectionSpots.add(FlSpot(windDirectionSpots.length.toDouble(), windDirectionList[i].toDouble()));
            precipitationSpots.add(FlSpot(precipitationSpots.length.toDouble(), precipitationList[i].toDouble()));
            snowfallSpots.add(FlSpot(snowfallSpots.length.toDouble(), snowfallList[i].toDouble()));
            precipProbabilitySpots.add(FlSpot(precipProbabilitySpots.length.toDouble(), precipProbabilityList[i].toDouble()));
            visibilitySpots.add(FlSpot(visibilitySpots.length.toDouble(), visibilityList[i].toDouble()));
          }
        }

        if (!mounted) return;

        setState(() {
          dailyWeatherModel.updateTemperatureSpots(tempSpots);
          dailyWeatherModel.updateHumiditySpots(humidSpots);
          dailyWeatherModel.updateDewPointSpots(dewPointSpots);
          dailyWeatherModel.updateApparentTempSpots(apparentTempSpots);
          dailyWeatherModel.updatePressureSpots(pressureSpots);
          dailyWeatherModel.updateCloudCoverSpots(cloudCoverSpots);
          dailyWeatherModel.updateWindSpeedSpots(windSpeedSpots);
          dailyWeatherModel.updateWindDirectionSpots(windDirectionSpots);
          dailyWeatherModel.updatePrecipitationSpots(precipitationSpots);
          dailyWeatherModel.updateSnowfallSpots(snowfallSpots);
          dailyWeatherModel.updatePrecipitationProbabilitySpots(precipProbabilitySpots);
          dailyWeatherModel.updateVisibilitySpots(visibilitySpots);
        });
      } else {
        print('[ERROR] Ошибка получения данных о погоде: ${response.statusCode}');
        print('[ERROR] Тело ответа: ${response.body}');
      }
    } catch (e) {
      print('[ERROR] Ошибка при запросе погоды: $e');
    }
  }


  TableRow _buildRow(String label, String value, Color textColor) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            label,
            style: TextStyle(color: textColor),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLineChart({
    required List<FlSpot> spots,
    required Color lineColor,
    required Color dotColor,
    required String title,
    required double minY,
    required double maxY,
    required BuildContext context,
    required bool isDarkMode,
    required IconData icon,
    required String unit,
    required int iconOffsetY,
  }) {
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    return Column(
      children: [
        Center(
          child: Text(
            title,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SizedBox(
            height: 260,
            child: Stack(
              children: [
                // Основной график
                Builder(
                  builder: (context) {
                    return LineChart(
                      LineChartData(
                        minX: -1,
                        maxX: 8,
                        minY: minY,
                        maxY: maxY,
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              reservedSize: 32,
                              getTitlesWidget: (value, _) {
                                final hours = ['0ч', '3ч', '6ч', '9ч', '12ч', '15ч', '18ч', '21ч'];
                                if (value.toInt() >= 0 && value.toInt() < hours.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      hours[value.toInt()],
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,
                            isCurved: true,
                            color: lineColor,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(show: false),
                          ),
                        ],
                        lineTouchData: LineTouchData(enabled: false),
                      ),
                    );
                  },
                ),

                // Добавляем точки с данными и иконки
                ...spots.map((spot) {
                  final chartWidth = MediaQuery.of(context).size.width * 0.85;
                  final spotX = ((spot.x + 0.5) / 8) * chartWidth - 10;
                  final spotY = 240 - ((spot.y - minY) / (maxY - minY)) * 240 - iconOffsetY;

                  return Positioned(
                    left: spotX.clamp(0, chartWidth - 40),
                    top: spotY.clamp(20, 240),
                    child: Column(
                      children: [
                        Icon(icon, size: 18, color: dotColor), // Добавляем иконку
                        Text(
                          '${spot.y.toInt()} $unit',  // Добавляем единицы измерения
                          style: TextStyle(
                            color: dotColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    final locationModel = Provider.of<LocationModel>(context);
    final textColor = widget.isDarkMode ? Colors.white : Colors.black87;
    final subTextColor = widget.isDarkMode ? Colors.white70 : Colors.black54;
    final temperature = Provider.of<MainWeatherModel>(context).temperature;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              widget.isDarkMode ? 'assets/images/darkTheme.png' : 'assets/images/lightTheme.png',
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
                  'Погода на день в ${locationModel.city}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Сегодня, ${_formatFullDate(DateTime.now())}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: subTextColor,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: Column(
                  children: [
                    Icon(getWeatherIcon(
                        Provider.of<MainWeatherModel>(context, listen: false).weatherDesc),
                        size: 80.0,
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      '$temperature°С',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      Provider.of<MainWeatherModel>(context, listen: false).weatherDesc,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // График температуры
              buildLineChart(
                spots: dailyWeatherModel.temperatureSpots,
                lineColor: getHueShiftedColor(widget.isDarkMode ? Colors.purpleAccent : Colors.orange, shift: 20), // Сдвиг цвета для линии
                dotColor: getHueShiftedColor(widget.isDarkMode ? Colors.purpleAccent : Colors.orange, shift: -20), // Сдвиг цвета для точек
                title: 'Температура по часам',
                minY: -80,
                maxY: 80,
                context: context,
                isDarkMode: widget.isDarkMode,
                icon: Icons.thermostat,
                unit: '°C',
                iconOffsetY: 10,
              ),
              const SizedBox(height: 32),
              // График влажности
              buildLineChart(
                spots: dailyWeatherModel.humiditySpots,
                lineColor: getHueShiftedColor(widget.isDarkMode ? Colors.cyanAccent : Colors.blue, shift: 20),
                dotColor: getHueShiftedColor(widget.isDarkMode ? Colors.cyanAccent : Colors.blue, shift: -20),
                title: 'Влажность по часам',
                minY: -10,
                maxY: 120,
                context: context,
                isDarkMode: widget.isDarkMode,
                icon: Icons.water_drop,
                unit: '%',
                iconOffsetY: 10,
              ),
              const SizedBox(height: 32),

              // График облачности
              buildLineChart(
                spots: dailyWeatherModel.cloudCoverSpots,
                lineColor: getHueShiftedColor(widget.isDarkMode ? Colors.grey : Colors.lightBlue, shift: 15),
                dotColor: getHueShiftedColor(widget.isDarkMode ? Colors.grey : Colors.lightBlue, shift: -15),
                title: 'Облачность по часам',
                minY: -10,
                maxY: 120,
                context: context,
                isDarkMode: widget.isDarkMode,
                icon: Icons.cloud,
                unit: '%',
                iconOffsetY: 10,
              ),
              const SizedBox(height: 32),

              // График давления
              buildLineChart(
                spots: dailyWeatherModel.pressureSpots,
                lineColor: getHueShiftedColor(widget.isDarkMode ? Colors.greenAccent : Colors.deepPurple, shift: 25),
                dotColor: getHueShiftedColor(widget.isDarkMode ? Colors.greenAccent : Colors.deepPurple, shift: -25),
                title: 'Атмосферное давление по часам',
                minY: 700,
                maxY: 1200,
                context: context,
                isDarkMode: widget.isDarkMode,
                icon: WeatherIcons.barometer,
                unit: 'hPa',
                iconOffsetY: 10,
              ),
              const SizedBox(height: 32),

              // График скорости ветра
              buildLineChart(
                spots: dailyWeatherModel.windSpeedSpots,
                lineColor: getHueShiftedColor(widget.isDarkMode ? Colors.tealAccent : Colors.indigo, shift: 10),
                dotColor: getHueShiftedColor(widget.isDarkMode ? Colors.tealAccent : Colors.indigo, shift: -10),
                title: 'Скорость ветра по часам',
                minY: -10,
                maxY: 300,
                context: context,
                isDarkMode: widget.isDarkMode,
                icon: Icons.air,
                unit: 'km/h',
                iconOffsetY: 10,
              ),
              const SizedBox(height: 32),

              // График осадков
              buildLineChart(
                spots: dailyWeatherModel.precipitationSpots,
                lineColor: getHueShiftedColor(widget.isDarkMode ? Colors.pinkAccent : Colors.yellow, shift: 30),
                dotColor: getHueShiftedColor(widget.isDarkMode ? Colors.pinkAccent : Colors.yellow, shift: -30),
                title: 'Осадки по часам',
                minY: -10,
                maxY: 310,
                context: context,
                isDarkMode: widget.isDarkMode,
                icon: Icons.beach_access,
                unit: 'mm',
                iconOffsetY: 10,
              ),
              const SizedBox(height: 32),
              // Точка росы
              buildLineChart(
                spots: dailyWeatherModel.dewPointSpots,
                lineColor: getHueShiftedColor(widget.isDarkMode ? Colors.lightGreenAccent : Colors.brown, shift: 20),
                dotColor: getHueShiftedColor(widget.isDarkMode ? Colors.lightGreenAccent : Colors.brown, shift: -20),
                title: 'Точка росы по часам',
                minY: -80,
                maxY: 80,
                context: context,
                isDarkMode: widget.isDarkMode,
                icon: Icons.ac_unit,
                unit: '°C',
                iconOffsetY: 10,
              ),
              const SizedBox(height: 32),

              // Ощущаемая температура
              buildLineChart(
                spots: dailyWeatherModel.apparentTempSpots,
                lineColor: getHueShiftedColor(widget.isDarkMode ? Colors.deepOrangeAccent : Colors.deepOrange, shift: 10),
                dotColor: getHueShiftedColor(widget.isDarkMode ? Colors.deepOrangeAccent : Colors.deepOrange, shift: -10),
                title: 'Ощущаемая температура по часам',
                minY: -80,
                maxY: 80,
                context: context,
                isDarkMode: widget.isDarkMode,
                icon: Icons.device_thermostat,
                unit: '°C',
                iconOffsetY: 10,
              ),
              const SizedBox(height: 32),

              // Снегопад
              buildLineChart(
                spots: dailyWeatherModel.snowfallSpots,
                lineColor: getHueShiftedColor(widget.isDarkMode ? Colors.white70 : Colors.cyan, shift: 10),
                dotColor: getHueShiftedColor(widget.isDarkMode ? Colors.white70 : Colors.cyan, shift: -10),
                title: 'Снегопад по часам',
                minY: -10,
                maxY: 120,
                context: context,
                isDarkMode: widget.isDarkMode,
                icon: Icons.ac_unit_outlined,
                unit: 'cm',
                iconOffsetY: 10,
              ),
              const SizedBox(height: 32),

              // Вероятность осадков
              buildLineChart(
                spots: dailyWeatherModel.precipitationProbabilitySpots,
                lineColor: getHueShiftedColor(widget.isDarkMode ? Colors.amberAccent : Colors.red, shift: 15),
                dotColor: getHueShiftedColor(widget.isDarkMode ? Colors.amberAccent : Colors.red, shift: -15),
                title: 'Вероятность осадков по часам',
                minY: -10,
                maxY: 120,
                context: context,
                isDarkMode: widget.isDarkMode,
                icon: Icons.umbrella,
                unit: '%',
                iconOffsetY: 10,
              ),
              const SizedBox(height: 32),

              // Видимость
              buildLineChart(
                spots: dailyWeatherModel.visibilitySpots,
                lineColor: getHueShiftedColor(widget.isDarkMode ? Colors.blueGrey : Colors.lightGreen, shift: 20),
                dotColor: getHueShiftedColor(widget.isDarkMode ? Colors.blueGrey : Colors.lightGreen, shift: -20),
                title: 'Видимость по часам',
                minY: -10,
                maxY: 100000,
                context: context,
                isDarkMode: widget.isDarkMode,
                icon: Icons.remove_red_eye,
                unit: 'm',
                iconOffsetY: 10,
              ),
              const SizedBox(height: 32),

              // Направление ветра
              buildLineChart(
                spots: dailyWeatherModel.windDirectionSpots,
                lineColor: getHueShiftedColor(widget.isDarkMode ? Colors.limeAccent : Colors.deepOrangeAccent, shift: 30),
                dotColor: getHueShiftedColor(widget.isDarkMode ? Colors.limeAccent : Colors.deepOrangeAccent, shift: -30),
                title: 'Направление ветра по часам',
                minY: -10,
                maxY: 380,
                context: context,
                isDarkMode: widget.isDarkMode,
                icon: Icons.explore,
                unit: '°',
                iconOffsetY: 10,
              ),
              const SizedBox(height: 32),

              // // Таблица условий
              // Center(
              //   child: Text(
              //     'Текущие условия',
              //     style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
              //   ),
              // ),
              // const SizedBox(height: 12),
              // Container(
              //   decoration: BoxDecoration(
              //     color: widget.isDarkMode ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.8),
              //     borderRadius: BorderRadius.circular(12),
              //   ),
              //   padding: const EdgeInsets.all(16),
              //   child: Table(
              //     defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              //     columnWidths: const {
              //       0: FlexColumnWidth(2),
              //       1: FlexColumnWidth(3),
              //     },
              //     children: [
              //       _buildRow('Влажность', '65%', textColor),
              //       _buildRow('Давление', '1012 hPa', textColor),
              //       _buildRow('Ветер', '5 м/с', textColor),
              //       _buildRow('UV-индекс', '3 (умеренный)', textColor),
              //       _buildRow('Ощущается как', '28°С', textColor),
              //       _buildRow('Облачность', '45%', textColor),
              //       _buildRow('Видимость', '10 км', textColor),
              //       _buildRow('Точка росы', '16°С', textColor),
              //     ],
              //
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatFullDate(DateTime date) {
    const weekdays = ['воскресенье', 'понедельник', 'вторник', 'среда', 'четверг', 'пятница', 'суббота'];
    return '${weekdays[date.weekday]} ${date.day} ${_getMonthName(date.month)}';
  }

  String _getMonthName(int month) {
    const months = ['', 'января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'];
    return months[month];
  }
}
