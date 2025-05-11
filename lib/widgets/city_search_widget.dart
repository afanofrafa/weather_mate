import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CitySearchWidget extends StatefulWidget {
  final Function(String cityName) onCitySelected;

  const CitySearchWidget({Key? key, required this.onCitySelected}) : super(key: key);

  @override
  _CitySearchWidgetState createState() => _CitySearchWidgetState();
}

class _CitySearchWidgetState extends State<CitySearchWidget> {
  final TextEditingController _controller = TextEditingController();
  List<String> _suggestions = [];

  Future<void> _fetchCitySuggestions(String query) async {
    if (query.length < 3) return;

    final url = Uri.parse('https://wft-geo-db.p.rapidapi.com/v1/geo/cities?namePrefix=$query&limit=5');
    final response = await http.get(url, headers: {
      'X-RapidAPI-Key': '993922b5f3mshc1d0a910a76c84bp1ad143jsne70a7f222492',
      'X-RapidAPI-Host': 'wft-geo-db.p.rapidapi.com',
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final cities = data['data'] as List;

      setState(() {
        _suggestions = cities
            .map((city) => '${city['city']}, ${city['countryCode']}')
            .toList();
      });
    } else {
      setState(() {
        _suggestions = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Search city...',
            suffixIcon: Icon(Icons.search),
          ),
          onChanged: _fetchCitySuggestions,
        ),
        const SizedBox(height: 8),
        ..._suggestions.map((city) => ListTile(
          title: Text(city),
          onTap: () {
            widget.onCitySelected(city);
            _controller.text = city;
            setState(() => _suggestions = []);
          },
        )),
      ],
    );
  }
}
