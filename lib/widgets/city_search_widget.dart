import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CitySearchWidget extends StatefulWidget {
  final Function(String displayName, String cityOnlyName) onCitySelected;

  const CitySearchWidget({Key? key, required this.onCitySelected}) : super(key: key);

  @override
  _CitySearchWidgetState createState() => _CitySearchWidgetState();
}

class _CitySearchWidgetState extends State<CitySearchWidget> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> _suggestions = [];

  Future<void> _fetchCitySuggestions(String query) async {
    if (query.length < 3) return;

    final url = Uri.parse('https://wft-geo-db.p.rapidapi.com/v1/geo/cities?namePrefix=$query&limit=10');
    final response = await http.get(url, headers: {
      'X-RapidAPI-Key': '993922b5f3mshc1d0a910a76c84bp1ad143jsne70a7f222492',
      'X-RapidAPI-Host': 'wft-geo-db.p.rapidapi.com',
    });

    if (response.statusCode == 200) {

      final data = json.decode(response.body);
      final cities = data['data'] as List;

      setState(() {
        _suggestions = cities.map((city) {
          final cityName = city['city']?.toString() ?? '';
          final country = city['countryCode']?.toString() ?? '';
          return {
            'display': '$cityName, $country',
            'query': cityName,
          };
        }).toList();
      });
    } else {
      setState(() {
        _suggestions = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? const Color(0xFF2C2C2E) : Colors.white;
    final borderColor = isDarkMode ? Colors.grey[600]! : Colors.grey[400]!;
    final iconColor = isDarkMode ? Colors.white : Colors.black54;
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor),
          ),
          child: TextField(
            controller: _controller,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText: 'Search city...',
              hintStyle: TextStyle(color: iconColor),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              suffixIcon: Icon(Icons.search, color: iconColor),
            ),
            onChanged: _fetchCitySuggestions,
          ),
        ),
        const SizedBox(height: 8),
        ..._suggestions.map((entry) => ListTile(
          title: Text(entry['display']!, style: TextStyle(color: textColor)),
          tileColor: backgroundColor.withOpacity(0.9),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          onTap: () {
            widget.onCitySelected(entry['display']!, entry['query']!);
            _controller.text = entry['display']!;
            setState(() => _suggestions = []);
          },
        )),
      ],
    );
  }
}
