import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DailyWeatherScreen extends StatelessWidget {
  final bool isDarkMode;

  const DailyWeatherScreen({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subTextColor = isDarkMode ? Colors.white70 : Colors.black54;
    final backgroundColor = isDarkMode ? Colors.black54 : Colors.white;

    final temperatureSpots = [
      FlSpot(0, 7),
      FlSpot(1, 10),
      FlSpot(2, 13),
      FlSpot(3, 17),
      FlSpot(4, 20),
      FlSpot(5, 23),
      FlSpot(6, 20),
      FlSpot(7, 17),
    ];

    final cloudinessSpots = [
      FlSpot(0, 100),
      FlSpot(1, 60),
      FlSpot(2, 65),
      FlSpot(3, 50),
      FlSpot(4, 40),
      FlSpot(5, 30),
      FlSpot(6, 20),
      FlSpot(7, 0),
    ];

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
                  'Погода на день',
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
                    Icon(Icons.cloud, size: 100, color: textColor),
                    Text(
                      '13°С',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Облачно',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Температура
              Center(
                child: Text(
                  'Температура по часам',
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
                      LineChart(
                        LineChartData(
                          minX: -1,
                          maxX: 8,
                          minY: -70,
                          maxY: 70,
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
                              spots: temperatureSpots,
                              isCurved: true,
                              color: isDarkMode ? Colors.purpleAccent : Colors.orange,
                              dotData: FlDotData(show: false),
                              belowBarData: BarAreaData(show: false),
                            ),
                          ],
                          lineTouchData: LineTouchData(enabled: false),
                        ),
                      ),
                      ...temperatureSpots.map((spot) {
                        final chartWidth = MediaQuery.of(context).size.width * 0.85;
                        final spotX = ((spot.x + 0.5) / 8) * chartWidth - 10;
                        final spotY = 240 - ((spot.y + 70) / 140) * 240;

                        return Positioned(
                          left: spotX.clamp(0, chartWidth - 40),
                          top: spotY.clamp(20, 240),
                          child: Column(
                            children: [
                              Icon(Icons.thermostat, size: 18, color: isDarkMode ? Colors.purpleAccent : Colors.orange),
                              Text(
                                '${spot.y.toInt()}°C',
                                style: TextStyle(
                                  color: isDarkMode ? Colors.purpleAccent : Colors.orange,
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
              const SizedBox(height: 32),

              // Облачность
              Center(
                child: Text(
                  'Облачность по часам',
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
                      LineChart(
                        LineChartData(
                          minX: -1,
                          maxX: 8,
                          minY: -5,
                          maxY: 110,
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
                              spots: cloudinessSpots,
                              isCurved: true,
                              color: isDarkMode ? Colors.cyanAccent : Colors.blue,
                              dotData: FlDotData(show: false),
                              belowBarData: BarAreaData(show: false),
                            ),
                          ],
                          lineTouchData: LineTouchData(enabled: false),
                        ),
                      ),
                      ...cloudinessSpots.map((spot) {
                        final chartWidth = MediaQuery.of(context).size.width * 0.85;
                        final spotX = ((spot.x + 0.5) / 8) * chartWidth - 10;
                        final spotY = 240 - ((spot.y) / 100) * 240 - 30;

                        return Positioned(
                          left: spotX.clamp(0, chartWidth - 40),
                          top: spotY.clamp(20, 240),
                          child: Column(
                            children: [
                              Icon(Icons.water_drop, size: 18, color: isDarkMode ? Colors.cyanAccent : Colors.blue),
                              Text(
                                '${spot.y.toInt()}%',
                                style: TextStyle(
                                  color: isDarkMode ? Colors.cyanAccent : Colors.blue,
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

              // Таблица условий
              Center(
                child: Text(
                  'Текущие условия',
                  style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: backgroundColor.withOpacity(0.8),
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
                    _buildRow('Влажность', '65%', textColor),
                    _buildRow('Давление', '1012 hPa', textColor),
                    _buildRow('Ветер', '5 м/с', textColor),
                    _buildRow('UV-индекс', '3 (умеренный)', textColor),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildRow(String label, String value, Color textColor) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(label, style: TextStyle(color: textColor)),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(value, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
      ),
    ]);
  }

  String _formatFullDate(DateTime date) {
    const weekdays = [
      'воскресенье', 'понедельник', 'вторник', 'среда',
      'четверг', 'пятница', 'суббота'
    ];
    const months = [
      'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
      'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'
    ];
    final weekday = weekdays[date.weekday % 7];
    final month = months[date.month - 1];
    return '$weekday, ${date.day} $month';
  }
}
