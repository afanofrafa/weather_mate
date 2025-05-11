import 'package:flutter/material.dart';
import '../widgets/city_search_widget.dart';

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
  String _selectedCity = 'Stockholm';
  String _selectedDate = 'Sunday, Aug 29th'; // можно сделать динамически позже

  void _openCitySearch() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CitySearchWidget(
            onCitySelected: (cityName) {
              setState(() => _selectedCity = cityName);
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final backgroundImage = widget.isDarkMode
        ? 'assets/images/testimage.jpg'
        : 'assets/images/sunnyweather.webp';

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
                  _selectedCity.toUpperCase(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _selectedDate,
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
