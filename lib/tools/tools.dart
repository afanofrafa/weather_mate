import 'package:weather_icons/weather_icons.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

IconData getWeatherIcon(String description) {
  print('getIcon weatherDesc: $description');
  switch (description.toLowerCase()) {
    case 'ясно':
      return WeatherIcons.day_sunny;
    case 'переменная облачность':
      return WeatherIcons.day_cloudy;
    case 'туман':
      return WeatherIcons.fog;
    case 'дождь':
      return WeatherIcons.rain;
    case 'снег':
      return WeatherIcons.snow;
    case 'ливень':
      return WeatherIcons.rain;
    case 'гроза':
      return WeatherIcons.thunderstorm;
    default:
      return WeatherIcons.na;
  }
}
Color getHueShiftedColor(Color baseColor, {double shift = 10}) {
  final hsl = HSLColor.fromColor(baseColor);
  final shiftedHue = (hsl.hue + shift) % 360;
  return hsl.withHue(shiftedHue).toColor();
}
Widget buildLineChart({
  required List<FlSpot> spots,
  required Color lineColor,
  required Color dotColor,
  required String title,
  required double minY,
  required double maxY,
  required double minX,
  required double maxX,
  required BuildContext context,
  required bool isDarkMode,
  required IconData icon,
  required String unit,
  required int iconOffsetY,
  required int graphicDeleter,
  required List<String> bottomTitlesList,
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
                      minX: minX,
                      maxX: maxX,
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
                              if (value.toInt() >= 0 && value.toInt() < bottomTitlesList.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    bottomTitlesList[value.toInt()],
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
                final normalizedX = (spot.x - minX) / (maxX - minX);
                final spotX = normalizedX * chartWidth - 10;
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
double median(List<FlSpot> spots) {
  if (spots.isEmpty) return 0;
  final sorted = spots.map((e) => e.y).toList()..sort();
  final middle = sorted.length ~/ 2;

  if (sorted.length.isOdd) {
    return sorted[middle];
  } else {
    return (sorted[middle - 1] + sorted[middle]) / 2;
  }
}
TableRow buildRow(String label, String value, Color textColor) {
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
String mapWeatherCodeToDescription(int code) {
  if (code == 0) return 'Ясно';
  if ([1, 2, 3].contains(code)) return 'Переменная облачность';
  if ([45, 48].contains(code)) return 'Туман';
  if ([51, 53, 55, 61, 63, 65].contains(code)) return 'Дождь';
  if ([66, 67, 71, 73, 75, 77].contains(code)) return 'Снег';
  if ([80, 81, 82].contains(code)) return 'Ливень';
  if ([95, 96, 99].contains(code)) return 'Гроза';
  return 'Неизвестно';
}
int getWeatherPriority(int code) {
  if ([95, 96, 99].contains(code)) return 6;
  if ([80, 81, 82].contains(code)) return 5;
  if ([66, 67, 71, 73, 75, 77].contains(code)) return 4;
  if ([51, 53, 55, 61, 63, 65].contains(code)) return 3;
  if ([45, 48].contains(code)) return 2;
  if ([1, 2, 3].contains(code)) return 1;
  if (code == 0) return 0;
  return -1; // неизвестный код
}
List<Map<String, String>> summarizeWeatherDetailed(List<int> weatherCodes) {
  List<Map<String, String>> dailySummaries = [];

  for (int i = 0; i < weatherCodes.length; i += 24) {
    List<int> dayCodes = weatherCodes.sublist(i, i + 24);

    Map<String, List<int>> dayParts = {
      'Утро': dayCodes.sublist(6, 12),    // 06:00–11:00
      'День': dayCodes.sublist(12, 18),   // 12:00–17:00
      'Вечер': dayCodes.sublist(18, 24),  // 18:00–23:00
    };

    Map<String, String> summary = {};

    dayParts.forEach((part, codes) {
      int maxPriority = -1;
      int representativeCode = -1;

      for (int code in codes) {
        int priority = getWeatherPriority(code);
        if (priority > maxPriority) {
          maxPriority = priority;
          representativeCode = code;
        }
      }

      summary[part] = mapWeatherCodeToDescription(representativeCode);
    });

    dailySummaries.add(summary);
  }

  return dailySummaries;
}
String getWeekdayNameFromIndex(int index) {
  const weekdays = [
    'Понедельник',
    'Вторник',
    'Среда',
    'Четверг',
    'Пятница',
    'Суббота',
    'Воскресенье',
  ];
  return weekdays[index % 7];
}

