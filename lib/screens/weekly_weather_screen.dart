import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WeeklyWeatherScreen extends StatelessWidget {
  final bool isDarkMode;

  const WeeklyWeatherScreen({Key? key, required this.isDarkMode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subTextColor = isDarkMode ? Colors.white70 : Colors.black54;

    final temperatureSpots = [
      FlSpot(0, -60),
      FlSpot(1, 10),
      FlSpot(2, 13),
      FlSpot(3, 17),
      FlSpot(4, 60),
      FlSpot(5, 23),
      FlSpot(6, 20),
    ];

    final cloudinessSpots = [
      FlSpot(0, 0),
      FlSpot(1, 60),
      FlSpot(2, 70),
      FlSpot(3, 80),
      FlSpot(4, 100),
      FlSpot(5, 60),
      FlSpot(6, 0),
    ];

    final daysOfWeek = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];

    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

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
              isDarkMode
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
                child: Text(
                  'Средняя температура: 18°C, облачность: переменная, осадки возможны в четверг и пятницу.',
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: Text(
                  'Температура по дням',
                  style: TextStyle(
                      color: textColor, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SizedBox(
                  height: 260,
                  child: Stack(
                    children: [
                      LineChart(
                        LineChartData(
                          minX: -1,
                          maxX: 7,
                          minY: -70,
                          // Установим значение ниже минимума
                          maxY: 70,
                          // Установим значение выше максимума
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                                sideTitles: bottomTitles()),
                            leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: temperatureSpots,
                              isCurved: true,
                              color: isDarkMode ? Colors.purpleAccent : Colors
                                  .orange,
                              dotData: FlDotData(show: true),
                              belowBarData: BarAreaData(show: false),
                            ),
                          ],
                          lineTouchData: LineTouchData(enabled: false),
                        ),
                      ),
                      // Добавляем иконки температуры
                      ...temperatureSpots.map((spot) {
                        final chartWidth = MediaQuery
                            .of(context)
                            .size
                            .width * 0.85;
                        final spotX = ((spot.x + 0.5) / 7) * chartWidth - 10;
                        final spotY = 240 -
                            ((spot.y + 70) / 140) * 240; // С учетом отступов

                        return Positioned(
                          left: spotX.clamp(0, chartWidth - 40),
                          top: spotY.clamp(20, 240), // Ограничиваем верх и низ
                          child: Column(
                            children: [
                              Icon(Icons.thermostat, size: 18,
                                  color: isDarkMode
                                      ? Colors.purpleAccent
                                      : Colors.orange),
                              Text(
                                '${spot.y.toInt()}°',
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.purpleAccent
                                      : Colors.orange,
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
              const SizedBox(height: 40),
              Center(
                child: Text(
                  'Облачность по дням',
                  style: TextStyle(
                      color: textColor, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SizedBox(
                  height: 260,
                  child: Stack(
                    children: [
                      LineChart(
                        LineChartData(
                          minX: -1,
                          maxX: 7,
                          minY: -5,
                          maxY: 110,
                          // Изменяем на значение больше
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                                sideTitles: bottomTitles()),
                            leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: cloudinessSpots,
                              isCurved: true,
                              color: isDarkMode ? Colors.cyanAccent : Colors
                                  .blue,
                              dotData: FlDotData(show: true),
                              belowBarData: BarAreaData(show: false),
                            ),
                          ],
                          lineTouchData: LineTouchData(enabled: false),
                        ),
                      ),
                      // Добавляем иконки облачности
                      ...cloudinessSpots.map((spot) {
                        final chartWidth = MediaQuery
                            .of(context)
                            .size
                            .width * 0.85;
                        final spotX = ((spot.x + 0.5) / 7) * chartWidth - 10;
                        final spotY = 240 - ((spot.y) / 100) * 240 - 30;

                        return Positioned(
                          left: spotX.clamp(0, chartWidth - 40),
                          top: spotY.clamp(20, 240), // Ограничиваем верх и низ
                          child: Column(
                            children: [
                              Icon(Icons.cloud, size: 18,
                                  color: isDarkMode ? Colors.cyanAccent : Colors
                                      .blue),
                              Text(
                                '${spot.y.toInt()}%',
                                style: TextStyle(
                                  color: isDarkMode ? Colors.cyanAccent : Colors
                                      .blue,
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
          ),
        ),
      ),
    );
  }
}