import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather_model.dart';
import 'package:http/http.dart' as http;

class Services{
  final String apiKey;

  Services(this.apiKey);

  //remaining
    List<String> getRemainingHoursList() {
      DateTime now = DateTime.now();
      List<String> remainingHours = [];

      // Start from the previous hour
      int startHour = now.hour - 1;

      for (int i = startHour; i < 24; i++) {
        // Check if the hour is negative, which can happen if the current hour is 0
        if (i >= 0) {
          // Create a DateTime object for the hour
          DateTime hourDateTime = DateTime(now.year, now.month, now.day, i);
          // Format the hour in 'hh a' format
          String formattedHour = DateFormat('hh a').format(hourDateTime);
          // Add the formatted hour to the list
          remainingHours.add(formattedHour);
        }
      }

      return remainingHours;
    }


  Future getCurrentWeather(String cityName) async{
    if (kDebugMode) {
      print('inside getCurrentWeather..');
    }

    const baseUrl = 'http://api.weatherapi.com/v1/forecast.json';

    if (kDebugMode) {
      print('response requested..');
    }
    final response = await http.get(Uri.parse('$baseUrl?q=$cityName&key=$apiKey&days=8&aqi=yes'));
    if (kDebugMode) {
      print('response received..');
    }

    Map weatherData = (jsonDecode(response.body));
    if (kDebugMode) {
      print('response mapping successful..');
    }

      if (kDebugMode) {
        print('mapping for realtime weather ..');
      }
      Map locData =  weatherData['location'];
            final String rtmCityName = locData['name'];
              if (kDebugMode) {
                print(rtmCityName);
              }
      Map currentdata = weatherData['current'];
          final double rtmTemperature = currentdata['temp_c'];
            if (kDebugMode) {
              print('$rtmTemperature');
            }
          Map rtmCondition = currentdata['condition'];
            final String rtmConditionText = rtmCondition['text'];
              if (kDebugMode) {
                print(rtmConditionText);
              }
          final double rtmPrecip = currentdata['precip_mm'];
            if (kDebugMode) {
              print('$rtmPrecip');
            }
          final int rtmCloud = currentdata['cloud'];
            if (kDebugMode) {
              print('$rtmCloud');
            }
          final int rtmHumidity = currentdata['humidity'];
            if (kDebugMode) {
              print('$rtmHumidity');
            }
          final double rtmWind = currentdata['wind_kph'];
            if (kDebugMode) {
              print('$rtmWind');
            }
          final double rtmUV = currentdata['uv'];
            if (kDebugMode) {
              print('$rtmUV');
            }
          final int rtmIsDay = currentdata['is_day'];
            if (kDebugMode) {
              print('$rtmIsDay');
            }
          final double rtmVis = currentdata['vis_km'];
            if (kDebugMode) {
              print('$rtmVis');
            }
      if (kDebugMode) {
        print('mapping for realtime weather  successful..');
      }

      if (kDebugMode) {
        print('mapping for day weather..');
      }
      Map forecastData = weatherData['forecast'];
        List forecastDayData = forecastData['forecastday'];
          final String todayDate = forecastDayData[0]['date'];
               if (kDebugMode) {
                 print(todayDate);
               }
          Map forecastDay = forecastDayData[0]['day'];
            final double dayMaximumTemp = forecastDay['maxtemp_c'];
              if (kDebugMode) {
                print('$dayMaximumTemp');
              }
            final double dayMinimumTemp = forecastDay['mintemp_c'];
              if (kDebugMode) {
                print('$dayMinimumTemp');
              }
            final int dayChanceOfRain = forecastDay['daily_chance_of_rain'];
              if (kDebugMode) {
                print('$dayChanceOfRain');
              }
            Map airQualityData = forecastDay['air_quality']; 
              final double dayAirQuality = airQualityData['pm2_5'];
                if (kDebugMode) {
                  print('$dayAirQuality');
                }
          Map astroData = forecastDayData[0]['astro'];
            final String dayAstroSunrise = astroData['sunrise'];
              if (kDebugMode) {
                print(dayAstroSunrise);
              }
            final String dayAstroSunset = astroData['sunset'];
              if (kDebugMode) {
                print(dayAstroSunset);
              }
            final String dayAstroMoonPhase = astroData['moon_phase'];
               if (kDebugMode) {
                 print(dayAstroMoonPhase);
               }
      if (kDebugMode) {
        print('mapping for day weather successful..');
      }

      if (kDebugMode) {
        print('mapping for current day hour..');
        print('mapping for current day..');
      }
      final String currentDay = forecastDayData[0]['date'];
          if (kDebugMode) {
            print(currentDay);
          }
            
      if (kDebugMode) {
        print('mapping for current day hours weather..');
      }
      List hourData = forecastDayData[0]['hour'];
            
        final timeFormatter = DateFormat('HH');
        final DateTime now = DateTime.now();
        final formattedTime = timeFormatter.format(now);
        if (kDebugMode) {
          print('current hour is $formattedTime..');
        }

        final initialized = formattedTime == '00' ? int.parse(formattedTime) :int.parse(formattedTime)-1;
        var length= getRemainingHoursList().length;
        
        if (kDebugMode) {
          print('current day hours remaining $length..');
        }  
        List <String> dayhrTime = List.filled(length,'',growable: false);
        List <double> dayhrTemp = List.filled(length,0.0,growable: false);
        List <String> dayhrCondition = List.filled(length,'',growable: false);
        List <int> dayhrIsDay= List.filled(length,1,growable: false);
              
        for (var i = 0; i < length; i++){
          if (kDebugMode) {
            print('mapping for hour_$i..');
          }
          final String time = hourData[initialized+i]['time'];
            if (kDebugMode) {
              print(time);
            }
            dayhrTime[i]=time;
          final double temp = hourData[initialized+i]['temp_c'];
            if (kDebugMode) {
              print('$temp');
            }
            dayhrTemp[i]=temp;
          final int isDay = hourData[initialized+i]['is_day'];
            if (kDebugMode) {
              print('$isDay');
            }
            dayhrIsDay[i]=isDay;
          Map condition = hourData[initialized+i]['condition'];
            final String conditionText =condition['text'];
              if (kDebugMode) {
                print(conditionText);
              }
              dayhrCondition[i]=conditionText;
        if (kDebugMode) {
          print('mapping for hour_$i successful..');
        }
        }
      if (kDebugMode) {
        print('mapping for current day hours weather successful..');
      }
      

      if (kDebugMode) {
        print('mapping for weekly weather..');
      }
      List <String> date = List.filled(7,'',growable: false);
      List <double> maxTemp = List.filled(7, 0.0,growable: false);
      List <double> minTemp = List.filled(7, 0.0,growable: false);
      List <String> condition = List.filled(7, "",growable: false);

          for (var i = 0; i < 7; i++){
            if (kDebugMode) {
              print('mapping for day_$i..');
            }
          final String dateDay = forecastDayData[i+1]['date'];
              if (kDebugMode) {
                print(dateDay);
              }
              date[i]=dateDay;
          Map forecastDay = forecastDayData[i+1]['day'];    
            final double maxTempDay = forecastDay['maxtemp_c'];
                if (kDebugMode) {
                  print('$maxTempDay');
                }
                maxTemp[i]=maxTempDay;     
            final double minTempDay = forecastDay['mintemp_c'];
                if (kDebugMode) {
                  print('$minTempDay');
                }
                minTemp[i]=minTempDay;
              Map conditionData = forecastDay['condition'];
              final String conditionDay = conditionData['text'];
                if (kDebugMode) {
                  print(conditionDay);
                }
                condition[i]=conditionDay;
          if (kDebugMode) {
            print('mapping for day_$i successful..');
          }
          }
      if (kDebugMode) {
        print('mapping for weekly weather successful..');
      }



    if (kDebugMode) {
      print('Creating CurrentWeather object..');
    }
    CurrentWeather currentWeather = CurrentWeather(
      rtmCityName: rtmCityName, 
      rtmTemperature: rtmTemperature, 
      rtmConditionText: rtmConditionText, 
      rtmPrecip: rtmPrecip, 
      rtmCloud: rtmCloud, 
      rtmHumidity: rtmHumidity, 
      rtmWind: rtmWind, 
      rtmUV: rtmUV, 
      rtmIsDay: rtmIsDay, 
      rtmVis: rtmVis, 
      
      todayDate: todayDate, 
      dayChanceOfRain: dayChanceOfRain, 
      dayAirQuality: dayAirQuality, 
      dayMaximumTemp: dayMaximumTemp, 
      dayMinimumTemp: dayMinimumTemp, 
      dayAstroSunrise: dayAstroSunrise, 
      dayAstroSunset: dayAstroSunset, 
      dayAstroMoonPhase: dayAstroMoonPhase, 

      dayhrTime: dayhrTime, 
      dayhrTemp: dayhrTemp, 
      dayhrCondition: dayhrCondition, 
      dayhrIsDay: dayhrIsDay,

      weekDate: date, 
      weekMaxTemp: maxTemp, 
      weekMinTemp: minTemp, 
      weekCondition: condition,
      );
    if (kDebugMode) {
      print('CurrentWeather object created successfully..');
    }
  
  if (kDebugMode) {
    print('returning CurrentWeather object from getCurrentWeather..');
  }
  return currentWeather;

  }
}
