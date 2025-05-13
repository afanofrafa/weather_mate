import 'package:flutter/material.dart';

class LocationModel extends ChangeNotifier {
  String _city;
  String _countryCode;  // Новый параметр для кода страны
  double _latitude;
  double _longitude;

  LocationModel(this._city, this._countryCode, this._latitude, this._longitude);

  String get city => _city;
  String get countryCode => _countryCode;  // Геттер для кода страны
  double get latitude => _latitude;
  double get longitude => _longitude;

  void updateLocation(String newCity, String newCountryCode, double newLat, double newLon) {
    _city = newCity;
    _countryCode = newCountryCode;  // Обновление кода страны
    _latitude = newLat;
    _longitude = newLon;
    notifyListeners();  // Уведомляет всех подписчиков
  }
}
