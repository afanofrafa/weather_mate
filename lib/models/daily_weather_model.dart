import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DailyWeatherModel with ChangeNotifier {
  // Приватные поля данных
  List<FlSpot> _temperatureSpots = [];
  List<FlSpot> _humiditySpots = [];
  List<FlSpot> _dewPointSpots = [];
  List<FlSpot> _pressureSpots = [];
  List<FlSpot> _cloudCoverSpots = [];
  List<FlSpot> _windSpeedSpots = [];
  List<FlSpot> _precipitationSpots = [];
  List<FlSpot> _snowfallSpots = [];
  List<FlSpot> _precipitationProbabilitySpots = [];
  List<FlSpot> _visibilitySpots = [];
  List<FlSpot> _apparentTempSpots = [];
  List<FlSpot> _windDirectionSpots = [];

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
  List<FlSpot> get temperatureSpots => _temperatureSpots;
  List<FlSpot> get humiditySpots => _humiditySpots;
  List<FlSpot> get dewPointSpots => _dewPointSpots;
  List<FlSpot> get pressureSpots => _pressureSpots;
  List<FlSpot> get cloudCoverSpots => _cloudCoverSpots;
  List<FlSpot> get windSpeedSpots => _windSpeedSpots;
  List<FlSpot> get precipitationSpots => _precipitationSpots;
  List<FlSpot> get snowfallSpots => _snowfallSpots;
  List<FlSpot> get precipitationProbabilitySpots => _precipitationProbabilitySpots;
  List<FlSpot> get visibilitySpots => _visibilitySpots;
  List<FlSpot> get apparentTempSpots => _apparentTempSpots;
  List<FlSpot> get windDirectionSpots => _windDirectionSpots;

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

  // Методы обновления отдельных полей
  void updateTemperatureSpots(List<FlSpot> data) {
    _temperatureSpots = data;
    _isTemperatureLoaded = true;
    notifyListeners();
  }

  void updateHumiditySpots(List<FlSpot> data) {
    _humiditySpots = data;
    _isHumidityLoaded = true;
    notifyListeners();
  }

  void updateDewPointSpots(List<FlSpot> data) {
    _dewPointSpots = data;
    _isDewPointLoaded = true;
    notifyListeners();
  }

  void updatePressureSpots(List<FlSpot> data) {
    _pressureSpots = data;
    _isPressureLoaded = true;
    notifyListeners();
  }

  void updateCloudCoverSpots(List<FlSpot> data) {
    _cloudCoverSpots = data;
    _isCloudCoverLoaded = true;
    notifyListeners();
  }

  void updateWindSpeedSpots(List<FlSpot> data) {
    _windSpeedSpots = data;
    _isWindSpeedLoaded = true;
    notifyListeners();
  }

  void updatePrecipitationSpots(List<FlSpot> data) {
    _precipitationSpots = data;
    _isPrecipitationLoaded = true;
    notifyListeners();
  }

  void updateSnowfallSpots(List<FlSpot> data) {
    _snowfallSpots = data;
    _isSnowfallLoaded = true;
    notifyListeners();
  }

  void updatePrecipitationProbabilitySpots(List<FlSpot> data) {
    _precipitationProbabilitySpots = data;
    _isPrecipitationProbabilityLoaded = true;
    notifyListeners();
  }

  void updateVisibilitySpots(List<FlSpot> data) {
    _visibilitySpots = data;
    _isVisibilityLoaded = true;
    notifyListeners();
  }

  void updateApparentTempSpots(List<FlSpot> data) {
    _apparentTempSpots = data;
    _isApparentTempLoaded = true;
    notifyListeners();
  }

  void updateWindDirectionSpots(List<FlSpot> data) {
    _windDirectionSpots = data;
    _isWindDirectionLoaded = true;
    notifyListeners();
  }

  // Массовое обновление всех данных
  void update({
    required List<FlSpot> temperatureSpots,
    required List<FlSpot> humiditySpots,
    required List<FlSpot> dewPointSpots,
    required List<FlSpot> pressureSpots,
    required List<FlSpot> cloudCoverSpots,
    required List<FlSpot> windSpeedSpots,
    required List<FlSpot> precipitationSpots,
    required List<FlSpot> snowfallSpots,
    required List<FlSpot> precipitationProbabilitySpots,
    required List<FlSpot> visibilitySpots,
    required List<FlSpot> apparentTempSpots,
    required List<FlSpot> windDirectionSpots,
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
