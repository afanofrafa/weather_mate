import 'package:flutter/material.dart';

class MainWeatherScreen extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const MainWeatherScreen({
    Key? key,
    required this.isDarkMode,
    required this.onToggleTheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backgroundImage = isDarkMode
        ? 'assets/images/testimage.jpg'
        : 'assets/images/sunnyweather.webp';

    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subTextColor = isDarkMode ? Colors.white70 : Colors.black54;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: onToggleTheme,
        child: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
      ),
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
                  'STOCKHOLM',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Sunday, Aug 29th',
                  style: TextStyle(color: subTextColor, fontSize: 14),
                ),
              ],
            ),
            Icon(Icons.wb_sunny, size: 100, color: textColor),
            Text(
              '72°F',
              style: TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Text(
              'Sunny',
              style: TextStyle(
                fontSize: 22,
                color: textColor,
              ),
            ),
            Text(
              '0.0% • High',
              style: TextStyle(
                fontSize: 14,
                color: subTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
