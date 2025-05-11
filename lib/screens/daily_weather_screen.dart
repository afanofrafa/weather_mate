import 'package:flutter/material.dart';

class DailyWeatherScreen extends StatelessWidget {
  final bool isDarkMode;

  const DailyWeatherScreen({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Получаем цвета из темы, в зависимости от того, включен ли темный режим
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subTextColor = isDarkMode ? Colors.white70 : Colors.black54;

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок с использованием актуальных стилей TextTheme
            Text(
              'Дневная погода',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: textColor, // Цвет для текста в зависимости от темы
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Подзаголовок с использованием актуальных стилей TextTheme
            Text(
              'Сегодня, 29 августа',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: subTextColor, // Цвет для подзаголовка
              ),
            ),
            const SizedBox(height: 32),

            // Центральная секция с иконкой и текстом
            Center(
              child: Column(
                children: [
                  // Иконка облака
                  Icon(Icons.cloud, size: 100, color: textColor),

                  // Температура
                  Text(
                    '68°F',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Состояние погоды
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

            // Заглушка для графиков и таблиц
            Center(
              child: Text(
                'График температуры / облачности здесь',
                style: TextStyle(color: subTextColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
