class CurrentWeather{
  final String rtmCityName;
  final double rtmTemperature;
  final String rtmConditionText;
  final double rtmPrecip;
  final int rtmCloud;
  final int rtmHumidity;
  final double rtmWind;
  final double rtmUV;
  final int rtmIsDay;
  final double rtmVis;

  final String todayDate;
  final int dayChanceOfRain;
  final double dayAirQuality;
  final double dayMaximumTemp;
  final double dayMinimumTemp;
  final String dayAstroSunrise;
  final String dayAstroSunset;
  final String dayAstroMoonPhase;
  
  final List <String> dayhrTime;
  final List <double> dayhrTemp;
  final List <String> dayhrCondition;
  final List <int> dayhrIsDay;

  final List <String> weekDate;
  final List <double> weekMaxTemp;
  final List <double> weekMinTemp;
  final List <String> weekCondition;

  CurrentWeather({
    required this.rtmCityName,
    required this.rtmTemperature,
    required this.rtmConditionText,
    required this.rtmPrecip,
    required this.rtmCloud,
    required this.rtmHumidity,
    required this.rtmWind,
    required this.rtmUV,
    required this.rtmIsDay,
    required this.rtmVis,
    
    required this.todayDate,
    required this.dayChanceOfRain,
    required this.dayAirQuality,
    required this.dayMaximumTemp,
    required this.dayMinimumTemp,
    required this.dayAstroSunrise,
    required this.dayAstroSunset,
    required this.dayAstroMoonPhase,
    
    required this.dayhrTime,
    required this.dayhrTemp,
    required this.dayhrCondition,
    required this.dayhrIsDay,
    
    required this.weekDate,
    required this.weekMaxTemp,
    required this.weekMinTemp,
    required this.weekCondition,
  });
}
