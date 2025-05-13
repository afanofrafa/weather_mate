import 'package:flutter/material.dart';
class MainWeatherModel with ChangeNotifier {
  String _selectedDate = '';
  DateTime _selectedDateTime = DateTime.now();
  String _weatherDesc = '';
  double _temperature = 0.0;
  double _precipitation = 0.0;

  bool _isTemperatureLoaded = false;
  bool _isPrecipitationLoaded = false;
  bool _isWeatherDescLoaded = false;
  bool _isSelectedDateLoaded = false;
  bool _isArchiveScreenCall = false;

  double get temperature => _temperature;
  double get precipitation => _precipitation;
  String get selectedDate => _selectedDate;
  DateTime get selectedDateTime => _selectedDateTime;
  String get weatherDesc => _weatherDesc;

  bool get isTemperatureLoaded => _isTemperatureLoaded;
  bool get isPrecipitationLoaded => _isPrecipitationLoaded;
  bool get isWeatherDescLoaded => _isWeatherDescLoaded;
  bool get isSelectedDateLoaded => _isSelectedDateLoaded;
  bool get isArchiveScreenCall => _isArchiveScreenCall;

  void updateArchiveScreenCall(bool newArchiveScreenCall) {
    _isArchiveScreenCall = newArchiveScreenCall;
  }
  void updateTemperature(double newTemperature) {
    _temperature = newTemperature;
    _isTemperatureLoaded = true;
    notifyListeners();
  }

  void updatePrecipitation(double newPrecipitation) {
    _precipitation = newPrecipitation;
    _isPrecipitationLoaded = true;
    notifyListeners();
  }

  void updateWeatherDesc(String newWeatherDesc) {
    _weatherDesc = newWeatherDesc;
    _isWeatherDescLoaded = true;
    notifyListeners();
  }

  void updateSelectedDate(String newSelectedDate, DateTime newSelectedDateTime) {
    _selectedDate = newSelectedDate;
    _selectedDateTime = newSelectedDateTime;
    _isSelectedDateLoaded = true;
    notifyListeners();
  }
  void reset() {
    _selectedDate = '';
    _weatherDesc = '';
    _temperature = 0.0;
    _precipitation = 0.0;

    _isTemperatureLoaded = false;
    _isPrecipitationLoaded = false;
    _isWeatherDescLoaded = false;
    _isSelectedDateLoaded = false;

    notifyListeners();
  }
}
