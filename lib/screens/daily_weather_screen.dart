import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Добавить в pubspec.yaml

class DailyWeatherScreen extends StatelessWidget {
  final bool isDarkMode;

  const DailyWeatherScreen({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subTextColor = isDarkMode ? Colors.white70 : Colors.black54;
    final backgroundColor = isDarkMode ? Colors.black54 : Colors.white;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              isDarkMode
                  ? 'assets/images/testimage.jpg'
                  : 'assets/images/sunnyweather.webp',
            ),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Дневная погода',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Сегодня, 29 августа',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: subTextColor,
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: Column(
                  children: [
                    Icon(Icons.cloud, size: 100, color: textColor),
                    Text(
                      '68°F',
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

              // График температуры
              // График температуры
              Text('Температура по часам', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12), // Уменьшает ширину графика
                child: SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      minX: -0.5,
                      maxX: 5.5,
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, _) {
                              final hours = ['6ч', '9ч', '12ч', '15ч', '18ч', '21ч'];
                              if (value.toInt() >= 0 && value.toInt() < hours.length) {
                                return Text(hours[value.toInt()], style: TextStyle(color: textColor));
                              }
                              return const Text('');
                            },
                            interval: 1,
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            FlSpot(0, 14),
                            FlSpot(1, 17),
                            FlSpot(2, 20),
                            FlSpot(3, 22),
                            FlSpot(4, 19),
                            FlSpot(5, 16),
                          ],
                          isCurved: true,
                          color: Colors.orange,
                          dotData: FlDotData(show: true),
                          belowBarData: BarAreaData(show: false),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Таблица погодных условий
              Text('Текущие условия', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
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
}
