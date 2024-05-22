import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:weather/details_screen.dart';
import 'package:weather/state_value.dart';
import 'package:weather/weather_services.dart';
import 'package:weather/current_city.dart';
import 'package:weather/weather_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // api used = https://www.weatherapi.com/
  //api calling
  
  final _weatherservices = Services('YOUR API KEY'); //Replace with your API KEY
  CurrentWeather? _weather; // object of current weather
  _fetchCurrentWeather() async {
    if (kDebugMode) {
      print('inside homepage..');
    }
    if (kDebugMode) {
      print('inside fetchCurrentWeather..');
    }
    if (kDebugMode) {
      print('calling getCurrentCity..');
    }
    String cityName = await getCurrentCity();
    try {
      if (kDebugMode) {
        print('calling getCurrentWeather..');
      }
      final weather = await _weatherservices.getCurrentWeather(cityName);
      setState(() {
        if (kDebugMode) {
          print('calling set state..');
        }
        _weather = weather;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print('initializing..');
    }

    if (kDebugMode) {
      print('calling _fetchCurrentWeather..');
    }
    _fetchCurrentWeather();
    if (kDebugMode) {
      print('initialization successful..');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('building widget inside home screen..');
    }
    final screenSize = MediaQuery.of(context).size;

    //icon location
    String icons(double temp, String moonphase, int day, String condition) {
      if (kDebugMode) {
        print('getting icon location..');
      }
      String iconLoc = '';
      if (kDebugMode) {
        print('$temp');
      }
      if (kDebugMode) {
        print('$day');
      }
      if (kDebugMode) {
        print(condition);
      }
      if (temp > 45.0) {
        iconLoc = 'assets/images/weather_icon/sunny_summer.png';
      } else if (moonphase.contains('fullmoon')) {
        iconLoc = 'assets/images/weather_icon/clear_fullmoon.png';
      } else if (day == 1) {
        if (kDebugMode) {
          print('looking for $condition..');
        }
        iconLoc = iconValue[condition];
      } else {
        String newCondition = '$condition night';
        if (kDebugMode) {
          print('looking for $newCondition..');
        }
        iconLoc = iconValue[newCondition];
      }
      if (kDebugMode) {
        print('icon value found successfully..');
      }
      return iconLoc;
    }

    //background location
    String bgLoc(String moonphase, int day, String condition) {
      if (kDebugMode) {
        print('getting background location..');
      }
      String bgLoc = '';
      if (kDebugMode) {
        print('$day');
      }
      if (kDebugMode) {
        print(condition);
      }
      if (day == 1) {
        if (kDebugMode) {
          print('looking for $condition..');
        }
        bgLoc = bgValue[condition];
      } else if (moonphase.contains('fullmoon')) {
        bgLoc = 'assets/images/weather_icon/clear_fullmoon.png';
      } else {
        String newCondition = '$condition night';
        if (kDebugMode) {
          print('looking for $newCondition..');
        }
        bgLoc = bgValue[newCondition];
      }
      if (kDebugMode) {
        print('background value found successfully..');
      }
      return bgLoc;
    }

    final double temp = _weather?.rtmTemperature ?? 0.00;
    final String moonphase = _weather?.dayAstroMoonPhase ?? '';
    final int day = _weather?.rtmIsDay ?? 1;
    final String condition = _weather?.rtmConditionText ?? 'Sunny';

    List<String> hoursList = _weatherservices.getRemainingHoursList();
    String iconLocation = icons(temp, moonphase, day, condition);
    String backgroundLocation = bgLoc(moonphase, day, condition);

    //hr icon location
    List<String> hrIcons(int length) {
      if (kDebugMode) {
        print('getting hr icon location..');
      }
      if (kDebugMode) {
        print('getting $length hr icon location..');
      }

      List<String> iconLoc = List.filled(length, '', growable: false);
      for (var i = 0; i < length; i++) {
        if (kDebugMode) {
          print('getting $i hr icon location..');
        }
        final double hrTemp = _weather?.dayhrTemp[i] ?? 0.00;
        if (kDebugMode) {
          print('$hrTemp');
        }
        final int hrDay = _weather?.dayhrIsDay[i] ?? 1;
        if (kDebugMode) {
          print('$hrDay');
        }
        final String condition = _weather?.dayhrCondition[i] ?? 'Sunny';
        if (kDebugMode) {
          print(condition);
        }
        if (temp > 45.0) {
          iconLoc[i] = 'assets/images/weather_icon/sunny_summer.png';
        } else if (hrDay == 1) {
          if (kDebugMode) {
            print('looking for $condition..');
          }
          iconLoc[i] = iconValue[condition];
        } else {
          String newCondition = '$condition night';
          if (kDebugMode) {
            print('looking for $newCondition..');
          }
          iconLoc[i] = iconValue[newCondition];
        }
        if (kDebugMode) {
          print('$i hr icon location found successfully..');
        }
      }
      if (kDebugMode) {
        print('$length icons location found successfully..');
      }
      return iconLoc;
    }

    final length = hoursList.length;
    List hrIconLocation = hrIcons(length);

    return Scaffold(
      body: Stack(
        children: [
          //backgroundimage
          Container(
              width: screenSize.width,
              height: screenSize.height,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(backgroundLocation),
                      fit: BoxFit.fill)
              )
          ),

          //details
          Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //spacing from top
                SizedBox(
                  height: screenSize.height / 45,
                ),

                //current state
                InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailsScreen(weather: _weather,weatherServices: _weatherservices,)),
                    ),
                  child: Column(
                    children: [
                      //weather icon
                      Container(
                          width: 125.0,
                          height: 125.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(iconLocation),
                                  fit: BoxFit.fill))),
                  
                      //detailsbox
                      SizedBox(
                        width: screenSize.width / 2,
                        height: screenSize.height / 3,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            //Background
                            SizedBox(
                              width: screenSize.width / 2,
                              height: screenSize.height / 3,
                            ).asGlass(
                                clipBorderRadius: BorderRadius.circular(20)),
                  
                            //Textarea
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //location
                                Text(
                                  _weather?.rtmCityName ?? 'Loading City',
                                  style: const TextStyle(
                                      fontFamily: 'Ubuntu-Bold',
                                      fontSize: 34,
                                      fontWeight: FontWeight.bold),
                                ),
                  
                                //Temperature
                                Text(
                                  '${_weather?.rtmTemperature} °C',
                                  style: const TextStyle(
                                      fontFamily: 'Ubuntu-Bold',
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold),
                                ),
                  
                                //Weather condition
                                Text(
                                  _weather?.rtmConditionText ?? 'Loading',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: 'Ubuntu-Bold',
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white70,
                                  ),
                                ),
                  
                                //max & min temp
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    //max temp
                                    Text(
                                      '${_weather?.dayMaximumTemp} °C',
                                      style: const TextStyle(
                                          fontFamily: 'Ubuntu-Bold',
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                  
                                    //min temp
                                    Text(
                                      '${_weather?.dayMinimumTemp} °C',
                                      style: const TextStyle(
                                          fontFamily: 'Ubuntu-Bold',
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                //details
                Stack(
                  children: [
                    //background
                    SizedBox(
                      width: screenSize.width,
                      height: screenSize.height / 2.75,
                    ).asGlass(
                      clipBorderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20)),
                    ),
                    //drag
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //space
                        const SizedBox(
                          height: 16,
                        ),

                        //mark
                        InkWell(   
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => DetailsScreen(weather: _weather,weatherServices: _weatherservices,)),
                            ),
                          child: Container(
                            width: 75,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),

                        //space
                        const SizedBox(
                          height: 16,
                        ),
                         
                        //triad info
                        Stack(alignment: Alignment.center, 
                          children: [
                            //background
                            Container(
                              alignment: Alignment.center,
                              width: screenSize.width - 20,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white12,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: const [
                                  BoxShadow(
                                          blurRadius: 5,
                                          spreadRadius: 5,
                                          color: Colors.black12,
                                        )
                                      ],
                              ),
                            ),
                            //info
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                //rain
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      //icon
                                      Container(
                                          width: 30.0,
                                          height: 30.0,
                                          decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/icon/rain.png'),
                                                  fit: BoxFit.fill))),

                                      //text
                                      Text(
                                        '${_weather?.dayChanceOfRain} %',
                                        style: const TextStyle(
                                            fontFamily: 'Ubuntu-Bold',
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ]),

                                //humidity
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    //icon
                                    Container(
                                        width: 30.0,
                                        height: 30.0,
                                        decoration: const BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/icon/humidity_white.png'),
                                                fit: BoxFit.fill))),

                                    //text
                                    Text(
                                      '${_weather?.rtmHumidity} %',
                                      style: const TextStyle(
                                          fontFamily: 'Ubuntu-Bold',
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),

                                //wind
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    //icon
                                    Container(
                                        width: 30.0,
                                        height: 30.0,
                                        decoration: const BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/icon/wind.png'),
                                                fit: BoxFit.fill))),

                                    //text
                                    Text(
                                      '${_weather?.rtmWind} kmph',
                                      style: const TextStyle(
                                          fontFamily: 'Ubuntu-Bold',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                )
                              ],
                            )
                            ]
                          ),

                        //space
                        const SizedBox(
                            height: 16,
                          ),
                          
                          
                        // ListView Builder data
                          // hourly forecast
                        Container(
                            width: screenSize.width,
                            height: screenSize.height / 5,
                            alignment: Alignment.center,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: hoursList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    margin: const EdgeInsets.all(12),
                                    width: 60,
                                    height: 180,
                                    decoration: BoxDecoration(
                                      color: Colors.white24,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: const [
                                        BoxShadow(
                                          blurRadius: 5,
                                          spreadRadius: 4,
                                          color: Colors.black12,
                                        )
                                      ],
                                    ),
                                    child: //details
                                        Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        //hour
                                        Text(
                                          hoursList[index],
                                          style: const TextStyle(
                                              fontFamily: 'Ubuntu-Bold',
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),

                                        //weather icon
                                        Container(
                                            width: 40.0,
                                            height: 40.0,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        hrIconLocation[
                                                            index]),
                                                    fit: BoxFit.fill))),

                                        //temperature
                                        Text(
                                          '${_weather?.dayhrTemp[index]} °C',
                                          style: const TextStyle(
                                              fontFamily: 'Ubuntu-Bold',
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                            ),
                          ),
                       
                    ],
                  ),
                ],
              ),
            ]
          ),
        ],
      ),
    );
  }
}