import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather_model.dart';

import 'state_value.dart';

class DetailsScreen extends StatefulWidget {
  final CurrentWeather? weather;
  // ignore: prefer_typing_uninitialized_variables
  final weatherServices;
  const DetailsScreen(
      {super.key, required this.weather, required this.weatherServices});
  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('building widget inside detail screen..');
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
        final double hrTemp = widget.weather?.dayhrTemp[i] ?? 0.00;
        if (kDebugMode) {
          print('$hrTemp');
        }
        final int hrDay = widget.weather?.dayhrIsDay[i] ?? 1;
        if (kDebugMode) {
          print('$hrDay');
        }
        final String condition = widget.weather?.dayhrCondition[i] ?? 'Sunny';
        if (kDebugMode) {
          print(condition);
        }
        if (hrTemp > 45.0) {
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

    //week icon location
    List<String> weekIcon() {
      if (kDebugMode) {
        print('getting week icon location..');
      }

      List<String> iconLoc = List.filled(7, '', growable: false);
      for (var i = 0; i < 7; i++) {
        if (kDebugMode) {
          print('getting $i day icon location..');
        }
        final double weekTemp = widget.weather?.weekMaxTemp[i] ?? 0.00;
        if (kDebugMode) {
          print('$weekTemp');
        }
        final String condition = widget.weather?.weekCondition[i] ?? 'Sunny';
        if (kDebugMode) {
          print(condition);
        }
        if (weekTemp > 45.0) {
          iconLoc[i] = 'assets/images/weather_icon/sunny_summer.png';
        } else {
          String newCondition = condition;
          if (kDebugMode) {
            print('looking for $newCondition..');
          }
          iconLoc[i] = iconValue[newCondition];
        }
        if (kDebugMode) {
          print('$i day icon location found successfully..');
        }
      }
      if (kDebugMode) {
        print('week icons location found successfully..');
      }
      return iconLoc;
    }

    //next 7 days
    List<String> next7Days = [];
    DateTime today = DateTime.now();
    DateTime tomorrow =
        today.add(const Duration(days: 1)); // Start from tomorrow

    for (int i = 0; i < 7; i++) {
      DateTime nextDay = tomorrow.add(Duration(days: i));
      String formattedDay = DateFormat('EEEE').format(nextDay);
      next7Days.add(formattedDay);
    }

    List<String> weekIconLocation = weekIcon();

    final String moonphase = widget.weather?.dayAstroMoonPhase ?? '';
    final int day = widget.weather?.rtmIsDay ?? 1;
    final String condition = widget.weather?.rtmConditionText ?? 'Sunny';

    List<String> hoursList = widget.weatherServices.getRemainingHoursList();

    final length = hoursList.length;
    List hrIconLocation = hrIcons(length);

    final String backgroundLocation = bgLoc(moonphase, day, condition);

    String moonphaseIcon = 'assets/images/icon/moonphase.png';
    if(moonphase == 'Full Moon'){
      moonphaseIcon = 'assets/images/icon/fullmoon.png';
    }

    final screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Stack(children: [
      //backgroundimage
      Container(
          width: screenSize.width,
          height: screenSize.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(backgroundLocation), fit: BoxFit.fill))),

      //Background
      SizedBox(
        width: screenSize.width,
        height: screenSize.height,
      ).asGlass(blurX: 50.00, blurY: 50.00),

      SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //space
              const SizedBox(
                height: 12,
              ),
                    
              //Top Banner
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //location
                  Text(
                    widget.weather?.rtmCityName ?? 'Loading City',
                    style: const TextStyle(
                        fontFamily: 'Ubuntu-Regular',
                        fontSize: 34,
                        fontWeight: FontWeight.normal),
                  ),
          
                  //temp & condition
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Temperature
                      Text(
                        '${widget.weather?.rtmTemperature} °C',
                        style: const TextStyle(
                          fontFamily: 'Ubuntu-Bold',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                        ),
                      ),
          
                      //space
                      const SizedBox(
                        width: 4,
                        height: 20,
                      ),
          
                      //separator
                      Container(
                        width: 2,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: Colors.white70,
                        ),
                      ),
          
                      //space
                      const SizedBox(
                        width: 4,
                        height: 20,
                      ),
          
                      //Weather condition
                      Text(
                        widget.weather?.rtmConditionText ?? 'Loading',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Ubuntu-Bold',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  )
                ],
              ),
          
              //space
              const SizedBox(
                height: 12,
              ),
          
              //triad info
              Stack(alignment: Alignment.center, children: [
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //icon
                          Container(
                              width: 30.0,
                              height: 30.0,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/icon/rain.png'),
                                      fit: BoxFit.fill)
                              )
                          ),
          
                          //text
                          Text(
                            '${widget.weather?.dayChanceOfRain} %',
                            style: const TextStyle(
                                fontFamily: 'Ubuntu-Bold',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ]),
          
                    //humidity
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //icon
                        Container(
                            width: 30.0,
                            height: 30.0,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/icon/humidity_white.png'),
                                    fit: BoxFit.fill)
                            )
                        ),
          
                        //text
                        Text(
                          '${widget.weather?.rtmHumidity} %',
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //icon
                        Container(
                            width: 30.0,
                            height: 30.0,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/icon/wind.png'),
                                    fit: BoxFit.fill)
                            )
                          ),
          
                        //text
                        Text(
                          '${widget.weather?.rtmWind} kmph',
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
              ]),
          
              //space
              const SizedBox(
                height: 12,
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
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        margin: const EdgeInsets.all(12),
                        width: 60,
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 5,
                              spreadRadius: 5,
                              color: Colors.black12,
                            )
                          ],
                        ),
                        child: //details
                            Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        image:
                                            AssetImage(hrIconLocation[index]),
                                        fit: BoxFit.fill)
                                )
                              ),
          
                            //temperature
                            Text(
                              '${widget.weather?.dayhrTemp[index]} °C',
                              style: const TextStyle(
                                  fontFamily: 'Ubuntu-Bold',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
          
              //space
              const SizedBox(
                height: 12,
              ),
          
              //weekly forecst
              Stack(
                alignment: Alignment.topCenter,
                children: [
                //background
                Container(
                  width: screenSize.width - 20,
                  height: screenSize.height / 4,
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
          
                //weekly Forecast
                Container(
                  width: screenSize.width - 36,
                  height: screenSize.height / 4,
                  alignment: AlignmentDirectional.topCenter,
                  child: ListView.builder(
                    itemCount: 7,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 100,
                            child: Text(next7Days[index],
                                style: const TextStyle(
                                    fontFamily: 'Ubuntu-Medium',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600)),
                          ),
                        
                          //icon
                          Container(
                              width: 30.0,
                              height: 30.0,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          weekIconLocation[index]),
                                      fit: BoxFit.fill)
                              )
                          ),
                        
                          SizedBox(
                            width: 65,
                            child: Text(
                                '${widget.weather!.weekMaxTemp[index]}°C',
                                style: const TextStyle(
                                    fontFamily: 'Ubuntu-Medium',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600)
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ]),
          
              //space
              const SizedBox(
                height: 28,
              ),
          
              //sunrise & sunset
              Stack(
                alignment: Alignment.center,
                children: [
                  //background
                  Container(
                  width: screenSize.width - 20,
                  height: screenSize.height / 5,
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
                  
                  //details
                  Container( 
                  width: screenSize.width - 20,
                  height: screenSize.height / 5,
                  alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //sunrise
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              const Text('Sunrise',
                                  style: TextStyle(
                                      fontFamily: 'Ubuntu-Medium',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600)
                              ),
                              Text(widget.weather!.dayAstroSunrise,
                                  style:const TextStyle(
                                      fontFamily: 'Ubuntu-Bold',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)
                              ),
                    
                             //weather icon
                              Container(
                                width:190,
                                height: 60,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image:
                                              AssetImage('assets/images/icon/sunrise.png'),
                                          fit: BoxFit.fill)
                                  )
                                ), 
                          
                          ],
                        ),
                    
                        //sunset
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              const Text('Sunset',
                                  style: TextStyle(
                                      fontFamily: 'Ubuntu-Medium',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600)
                              ),
                              Text(widget.weather!.dayAstroSunset,
                                  style:const TextStyle(
                                      fontFamily: 'Ubuntu-Bold',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)
                              ),
                    
                             //weather icon
                              Container(
                                width:190,
                                height: 60,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image:
                                              AssetImage('assets/images/icon/sunset.png'),
                                          fit: BoxFit.fill)
                                  )
                                ), 
                              ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            
              //space
              const SizedBox(
                height: 28,
              ),
          
              //uv wind humidity
              Stack(
                alignment: Alignment.center,
                children : [
                  //background
                  Container(
                    width: screenSize.width - 20,
                    height: screenSize.height / 5,
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

                  //details
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      //uv
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                        //weather icon
                        Container(
                          width: 100,
                          height: 100,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                             image:
                                 AssetImage('assets/images/icon/uv.png'),
                             fit: BoxFit.fill)
                            )
                          ), 

                        const Text('UV Index',
                                  style: TextStyle(
                                      fontFamily: 'Ubuntu-Medium',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)
                              ),
                        
                        Text('${widget.weather!.rtmUV}',
                                  style: const TextStyle(
                                      fontFamily: 'Ubuntu-Medium',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)
                              ),
                        ],
                      ),
                    
                      //humidity
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                        //weather icon
                        Container(
                          width: 100,
                          height: 100,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                             image:
                                 AssetImage('assets/images/icon/humidity_white.png'),
                             fit: BoxFit.fill)
                            )
                          ), 

                        const Text('Humidity',
                                  style: TextStyle(
                                      fontFamily: 'Ubuntu-Medium',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)
                              ),
                        
                        Text('${widget.weather!.rtmHumidity}%',
                                  style: const TextStyle(
                                      fontFamily: 'Ubuntu-Medium',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)
                              ),
                        ],
                      ),
                    
                     //wind
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                        //weather icon
                        Container(
                          width: 95,
                          height: 95,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                             image:
                                 AssetImage('assets/images/icon/wind.png'),
                             fit: BoxFit.fill)
                            )
                          ), 

                        const Text('Wind',
                                  style: TextStyle(
                                      fontFamily: 'Ubuntu-Medium',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)
                              ),
                        
                        Text('${widget.weather!.rtmWind} Kmph',
                                  style: const TextStyle(
                                      fontFamily: 'Ubuntu-Medium',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)
                              ),
                        ],
                      ),
                    
                    ],
                  )
                ]
              ),

              //space
              const SizedBox(
                height: 28,
              ),
            
              //AQI visibility precip clouds moonphase
              Stack(
                alignment: Alignment.center,
                children : [
                  //background
                  Container(
                    width: screenSize.width - 20,
                    height: screenSize.height / 3,
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
                  
                  Column(
                    children: [
                      //AQI
                      ListTile(
                        leading: 
                        Container(
                          width: 45,
                          height: 45,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                             image:
                                 AssetImage('assets/images/icon/aqi.png'),
                             fit: BoxFit.fill)
                            )
                          ),
                        title:
                        const Text('AQI',
                                  style: TextStyle(
                                      fontFamily: 'Ubuntu-Bold',
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)
                              ),
                        trailing:
                        Text('${widget.weather!.dayAirQuality.round()}',
                                  style: const TextStyle(
                                      fontFamily: 'Ubuntu-Bold',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600)
                              ),
                      ),
                    
                      //visiblilty
                      ListTile(
                        leading: 
                        Container(
                          width: 45,
                          height: 45,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                             image:
                                 AssetImage('assets/images/icon/driving_difficulty.png'),
                             fit: BoxFit.fill)
                            )
                          ),
                        title:
                        const Text('Driving Difficulty',
                                  style: TextStyle(
                                      fontFamily: 'Ubuntu-Bold',
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)
                              ),
                        trailing:
                        Text('${widget.weather!.rtmVis}',
                                  style: const TextStyle(
                                      fontFamily: 'Ubuntu-Bold',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600)
                              ),
                      ),

                      //cloud
                      ListTile(
                        leading: 
                        Container(
                          width: 45,
                          height: 45,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                             image:
                                 AssetImage('assets/images/icon/clouds.png'),
                             fit: BoxFit.fill)
                            )
                          ),
                        title:
                        const Text('Clouds',
                                  style: TextStyle(
                                      fontFamily: 'Ubuntu-Bold',
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)
                              ),
                        trailing:
                        Text('${widget.weather!.rtmCloud} %',
                                  style: const TextStyle(
                                      fontFamily: 'Ubuntu-Bold',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600)
                              ),
                      ),

                      //precipitation
                      ListTile(
                        leading: 
                        Container(
                          width: 45,
                          height: 45,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                             image:
                                 AssetImage('assets/images/icon/precip.png'),
                             fit: BoxFit.fill)
                            )
                          ),
                        title:
                        const Text('Precipitation',
                                  style: TextStyle(
                                      fontFamily: 'Ubuntu-Bold',
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)
                              ),
                        trailing:
                        Text('${widget.weather!.rtmPrecip} mm',
                                  style: const TextStyle(
                                      fontFamily: 'Ubuntu-Bold',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600)
                              ),
                      ),

                      //moonphase
                      ListTile(
                        leading: 
                        Container(
                          width: 45,
                          height: 45,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                             image:
                                 AssetImage(moonphaseIcon),
                             fit: BoxFit.fill)
                            )
                          ),
                        title:
                        const Text('Moonphase',
                                  style: TextStyle(
                                      fontFamily: 'Ubuntu-Bold',
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)
                              ),
                        trailing:
                        Text(widget.weather!.dayAstroMoonPhase,
                                  style: const TextStyle(
                                      fontFamily: 'Ubuntu-Bold',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600)
                              ),
                      ),

                    ],
                  )
                  ]
              ),

              //space
              const SizedBox(
                height: 28,
              ),
            ],
          ),
        ),
      ),
    ]
    )
    );
  }
}
