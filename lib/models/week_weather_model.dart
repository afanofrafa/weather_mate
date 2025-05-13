import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WeekWeatherModel with ChangeNotifier {
  // Приватные поля данных
  List<List<FlSpot>> _temperatureSpots = [];
  List<List<FlSpot>> _humiditySpots = [];
  List<List<FlSpot>> _dewPointSpots = [];
  List<List<FlSpot>> _pressureSpots = [];
  List<List<FlSpot>> _cloudCoverSpots = [];
  List<List<FlSpot>> _windSpeedSpots = [];
  List<List<FlSpot>> _precipitationSpots = [];
  List<List<FlSpot>> _snowfallSpots = [];
  List<List<FlSpot>> _precipitationProbabilitySpots = [];
  List<List<FlSpot>> _visibilitySpots = [];
  List<List<FlSpot>> _apparentTempSpots = [];
  List<List<FlSpot>> _windDirectionSpots = [];
  Map<String, List<FlSpot>> _weekMap = {};
  List<Map<String, String>> _dailySummaries = [];
  DateTime? _startDate = null;
  DateTime? _endDate = null;
  // Флаги загрузки
  bool _isTemperatureLoaded = false;
  bool _isHumidityLoaded = false;
  bool _isDewPointLoaded = false;
  bool _isPressureLoaded = false;
  bool _isCloudCoverLoaded = false;
  bool _isWindSpeedLoaded = false;
  bool _isPrecipitationLoaded = false;
  bool _isSnowfallLoaded = false;
  bool _isPrecipitationProbabilityLoaded = false;
  bool _isVisibilityLoaded = false;
  bool _isApparentTempLoaded = false;
  bool _isWindDirectionLoaded = false;

  // Геттеры
  List<List<FlSpot>> get temperatureSpots => _temperatureSpots;
  List<List<FlSpot>> get humiditySpots => _humiditySpots;
  List<List<FlSpot>> get dewPointSpots => _dewPointSpots;
  List<List<FlSpot>> get pressureSpots => _pressureSpots;
  List<List<FlSpot>> get cloudCoverSpots => _cloudCoverSpots;
  List<List<FlSpot>> get windSpeedSpots => _windSpeedSpots;
  List<List<FlSpot>> get precipitationSpots => _precipitationSpots;
  List<List<FlSpot>> get snowfallSpots => _snowfallSpots;
  List<List<FlSpot>> get precipitationProbabilitySpots => _precipitationProbabilitySpots;
  List<List<FlSpot>> get visibilitySpots => _visibilitySpots;
  List<List<FlSpot>> get apparentTempSpots => _apparentTempSpots;
  List<List<FlSpot>> get windDirectionSpots => _windDirectionSpots;
  Map<String, List<FlSpot>> get weekMap => _weekMap;
  List<Map<String, String>> get dailySummaries => _dailySummaries;

  bool get isTemperatureLoaded => _isTemperatureLoaded;
  bool get isHumidityLoaded => _isHumidityLoaded;
  bool get isDewPointLoaded => _isDewPointLoaded;
  bool get isPressureLoaded => _isPressureLoaded;
  bool get isCloudCoverLoaded => _isCloudCoverLoaded;
  bool get isWindSpeedLoaded => _isWindSpeedLoaded;
  bool get isPrecipitationLoaded => _isPrecipitationLoaded;
  bool get isSnowfallLoaded => _isSnowfallLoaded;
  bool get isPrecipitationProbabilityLoaded => _isPrecipitationProbabilityLoaded;
  bool get isVisibilityLoaded => _isVisibilityLoaded;
  bool get isApparentTempLoaded => _isApparentTempLoaded;
  bool get isWindDirectionLoaded => _isWindDirectionLoaded;

  // Геттеры для дат
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  // Сеттеры для дат с уведомлением слушателей
  set startDate(DateTime? newStartDate) {
    _startDate = newStartDate;
    notifyListeners();
  }

  set dailySummaries(List<Map<String, String>> newDailySummaries) {
    _dailySummaries = newDailySummaries;
    notifyListeners();
  }

  set endDate(DateTime? newEndDate) {
    _endDate = newEndDate;
    notifyListeners();
  }
  // Методы обновления отдельных полей
  void updateTemperatureSpots(List<List<FlSpot>> data) {
    _temperatureSpots = data;
    _isTemperatureLoaded = true;
    notifyListeners();
  }

  void updateHumiditySpots(List<List<FlSpot>> data) {
    _humiditySpots = data;
    _isHumidityLoaded = true;
    notifyListeners();
  }

  void updateDewPointSpots(List<List<FlSpot>> data) {
    _dewPointSpots = data;
    _isDewPointLoaded = true;
    notifyListeners();
  }

  void updatePressureSpots(List<List<FlSpot>> data) {
    _pressureSpots = data;
    _isPressureLoaded = true;
    notifyListeners();
  }

  void updateCloudCoverSpots(List<List<FlSpot>> data) {
    _cloudCoverSpots = data;
    _isCloudCoverLoaded = true;
    notifyListeners();
  }

  void updateWindSpeedSpots(List<List<FlSpot>> data) {
    _windSpeedSpots = data;
    _isWindSpeedLoaded = true;
    notifyListeners();
  }

  void updatePrecipitationSpots(List<List<FlSpot>> data) {
    _precipitationSpots = data;
    _isPrecipitationLoaded = true;
    notifyListeners();
  }

  void updateSnowfallSpots(List<List<FlSpot>> data) {
    _snowfallSpots = data;
    _isSnowfallLoaded = true;
    notifyListeners();
  }

  void updatePrecipitationProbabilitySpots(List<List<FlSpot>> data) {
    _precipitationProbabilitySpots = data;
    _isPrecipitationProbabilityLoaded = true;
    notifyListeners();
  }

  void updateVisibilitySpots(List<List<FlSpot>> data) {
    _visibilitySpots = data;
    _isVisibilityLoaded = true;
    notifyListeners();
  }

  void updateApparentTempSpots(List<List<FlSpot>> data) {
    _apparentTempSpots = data;
    _isApparentTempLoaded = true;
    notifyListeners();
  }

  void updateWindDirectionSpots(List<List<FlSpot>> data) {
    _windDirectionSpots = data;
    _isWindDirectionLoaded = true;
    notifyListeners();
  }

  // Массовое обновление всех данных
  void update({
    required List<List<FlSpot>> temperatureSpots,
    required List<List<FlSpot>> humiditySpots,
    required List<List<FlSpot>> dewPointSpots,
    required List<List<FlSpot>> pressureSpots,
    required List<List<FlSpot>> cloudCoverSpots,
    required List<List<FlSpot>> windSpeedSpots,
    required List<List<FlSpot>> precipitationSpots,
    required List<List<FlSpot>> snowfallSpots,
    required List<List<FlSpot>> precipitationProbabilitySpots,
    required List<List<FlSpot>> visibilitySpots,
    required List<List<FlSpot>> apparentTempSpots,
    required List<List<FlSpot>> windDirectionSpots,
  }) {
    _temperatureSpots = temperatureSpots;
    _humiditySpots = humiditySpots;
    _dewPointSpots = dewPointSpots;
    _pressureSpots = pressureSpots;
    _cloudCoverSpots = cloudCoverSpots;
    _windSpeedSpots = windSpeedSpots;
    _precipitationSpots = precipitationSpots;
    _snowfallSpots = snowfallSpots;
    _precipitationProbabilitySpots = precipitationProbabilitySpots;
    _visibilitySpots = visibilitySpots;
    _apparentTempSpots = apparentTempSpots;
    _windDirectionSpots = windDirectionSpots;

    _isTemperatureLoaded = true;
    _isHumidityLoaded = true;
    _isDewPointLoaded = true;
    _isPressureLoaded = true;
    _isCloudCoverLoaded = true;
    _isWindSpeedLoaded = true;
    _isPrecipitationLoaded = true;
    _isSnowfallLoaded = true;
    _isPrecipitationProbabilityLoaded = true;
    _isVisibilityLoaded = true;
    _isApparentTempLoaded = true;
    _isWindDirectionLoaded = true;

    notifyListeners();
  }
  void updateWeekMap(Map<String, List<FlSpot>> data) {
    _weekMap = data;
    notifyListeners();
  }

  // Сброс всех данных
  void reset() {
    _temperatureSpots = [];
    _humiditySpots = [];
    _dewPointSpots = [];
    _pressureSpots = [];
    _cloudCoverSpots = [];
    _windSpeedSpots = [];
    _precipitationSpots = [];
    _snowfallSpots = [];
    _precipitationProbabilitySpots = [];
    _visibilitySpots = [];
    _apparentTempSpots = [];
    _windDirectionSpots = [];

    _isTemperatureLoaded = false;
    _isHumidityLoaded = false;
    _isDewPointLoaded = false;
    _isPressureLoaded = false;
    _isCloudCoverLoaded = false;
    _isWindSpeedLoaded = false;
    _isPrecipitationLoaded = false;
    _isSnowfallLoaded = false;
    _isPrecipitationProbabilityLoaded = false;
    _isVisibilityLoaded = false;
    _isApparentTempLoaded = false;
    _isWindDirectionLoaded = false;

    notifyListeners();
  }

  // Проверка, что все флаги false
  bool areAllFlagsFalse() {
    return !_isTemperatureLoaded &&
        !_isHumidityLoaded &&
        !_isDewPointLoaded &&
        !_isPressureLoaded &&
        !_isCloudCoverLoaded &&
        !_isWindSpeedLoaded &&
        !_isPrecipitationLoaded &&
        !_isSnowfallLoaded &&
        !_isPrecipitationProbabilityLoaded &&
        !_isVisibilityLoaded &&
        !_isApparentTempLoaded &&
        !_isWindDirectionLoaded;
  }
}
