import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:HPGM/Services/notifi_service.dart';
import 'package:HPGM/components/pop_up.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';

class Home extends StatefulWidget {
  final String token;
  final bool notify;

  const Home({Key? key, required this.token, required this.notify})
      : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class HomeData {
  final int farms;
  final int hives;
  final String apiaryName;
  final double averageHoneyPercentage;
  final double averageWeight;
  final double daysToEndSeason;
  final double percentage_time_left;
  // final double averageTemperatureLast7Days;
  // final String supplementaryApiaryName;

  HomeData({
    required this.farms,
    required this.hives,
    required this.apiaryName,
    required this.averageHoneyPercentage,
    required this.averageWeight,
    required this.daysToEndSeason,
    required this.percentage_time_left,
    // required this.averageTemperatureLast7Days,
    // required this.supplementaryApiaryName,
  });

  factory HomeData.fromJson(
      Map<String, dynamic> countJson,
      Map<String, dynamic> productiveJson,
      Map<String, dynamic> seasonJson,
      Map<String, dynamic> supplementData
      //List<dynamic> supplementData

      ) {
    return HomeData(
      farms: countJson['total_farms'],
      hives: countJson['total_hives'],
      apiaryName: productiveJson['most_productive_farm']['name'],
      averageHoneyPercentage:
          productiveJson['average_honey_percentage'].toDouble(),
      averageWeight: productiveJson['average_weight'].toDouble(),
      daysToEndSeason: seasonJson['time_until_harvest']['days'].toDouble(),
      percentage_time_left:
          seasonJson['time_until_harvest']['percentage_time_left'].toDouble(),
      // averageTemperatureLast7Days: supplementData[7].toDouble(),
      // supplementaryApiaryName: supplementData[2],
    );
  }
}

class _HomeState extends State<Home> {
  HomeData? homeData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
    startPeriodicTemperatureCheck();
  }

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });

    try {
      String sendToken = "Bearer ${widget.token}";

      var headers = {
        'Accept': 'application/json',
        'Authorization': sendToken,
      };

      // Concurrent requests
      var responses = await Future.wait([
        http.get(Uri.parse('https://www.ademnea.net/api/v1/farms/count'),
            headers: headers),
        http.get(
            Uri.parse('https://www.ademnea.net/api/v1/farms/most-productive'),
            headers: headers),
        http.get(
            Uri.parse(
                'https://www.ademnea.net/api/v1/farms/time-until-harvest'),
            headers: headers),
        http.get(
            Uri.parse(
                'https://www.ademnea.net/api/v1/farms/supplementary-feeding'),
            headers: headers),
      ]);

      if (responses[0].statusCode == 200 &&
          responses[1].statusCode == 200 &&
          responses[2].statusCode == 200 &&
          responses[3].statusCode == 200) {
        Map<String, dynamic> countData = jsonDecode(responses[0].body);
        Map<String, dynamic> productiveData = jsonDecode(responses[1].body);
        Map<String, dynamic> seasonData = jsonDecode(responses[2].body);
        Map<String, dynamic> supplementData = jsonDecode(responses[2].body);
        List<dynamic> supplementDat = jsonDecode(responses[3].body);

        // print('.........................................');
        // print(supplementDat);
        // print('.........................................');

        setState(() {
          homeData = HomeData.fromJson(
              countData, productiveData, seasonData, supplementData);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        // Handle error
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      // Handle error
    }
  }

  Timer? _timer;

  // Add this variable

  void startPeriodicTemperatureCheck() {
    _checkNotifications();
    _timer = Timer.periodic(const Duration(minutes: 60), (timer) {
      _checkNotifications();
    });
  }

  Future<void> _checkNotifications() async {
    try {
      bool shouldTriggerNotification = widget.notify;
      double daystoseason = homeData?.daysToEndSeason ?? 0.0;

      if (daystoseason <= 10 && !shouldTriggerNotification) {
        NotificationService().showNotification(
          id: 1,
          title: 'Honey harvest season',
          body:
              'The Honey harvest season is here, check your hives and harvest the honey.',
        );
        // Set the flag to true once notification is triggered
      }

      //double avgtemp = homeData?.averageTemperatureLast7Days ?? 0.0;
      //  String apiaryName = homeData?.supplementaryApiaryName ?? '';

// the if statement to check for the apiary temperatures.
      String myname = '${homeData?.apiaryName ?? 'prototype'}';

      print(myname);

      if (40 >= 30 && !shouldTriggerNotification) {
        NotificationService().showNotification(
          id: 2,
          title: "Supplementary Feeding",
          body:
              '$myname temperature soaring above 30°C!, please check it out. supplementary feeding may be required.',
        );
        // Set the flag to true once notification is triggered
      }
    } catch (error) {
      print('Error fetching temperature: $error');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.orange.withOpacity(0.8),
                                    Colors.orange.withOpacity(0.6),
                                    Colors.orange.withOpacity(0.4),
                                    Colors.orange.withOpacity(0.2),
                                    Colors.orange.withOpacity(0.1),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 50.0),
                              child: Row(
                                children: [
                                  Container(
                                    child: Image.asset(
                                      'lib/images/log-1.png',
                                      height: 80,
                                      width: 80,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.person,
                                    color: Color.fromARGB(255, 206, 109, 40),
                                    size: 65,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 150.0),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Apiaries: ${homeData?.farms ?? 0}',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Sans",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Hives: ${homeData?.hives ?? 0}',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Sans",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Most productive apiary',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Sans',
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: SizedBox(
                          height: 250,
                          width: 300,
                          child: LiquidLinearProgressIndicator(
                            //value: 0.64,
                            value: (homeData?.averageHoneyPercentage != null
                                ? homeData!.averageHoneyPercentage / 100
                                : 0.0),

                            valueColor:
                                const AlwaysStoppedAnimation(Colors.amber),
                            backgroundColor: Colors.amber[100]!,
                            borderColor: Colors.brown,
                            borderWidth: 5.0,
                            borderRadius: 12.0,
                            direction: Axis.vertical,
                            center: TextButton(
                              onPressed: () {
                                // lets show honey levels when this is pressed.
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => buildHoneySheet(
                                    "Average Honey Levels for ${homeData?.apiaryName} apiary",
                                    homeData?.averageHoneyPercentage ?? 0,
                                  ),
                                );
                              },
                              child: Text(
                                "${homeData?.apiaryName ?? '--'} apiary\n${(homeData?.averageHoneyPercentage.toStringAsFixed(2) ?? '--')}%\n${homeData?.averageWeight.toStringAsFixed(1) ?? '--'}Kg",
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontFamily: "Sans",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Apiaries requiring supplementary feeding',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: "Sans",
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: SizedBox(
                            width: 350,
                            child: Card(
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              color: Colors.orange[100],
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 22, bottom: 12),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.brightness_1,
                                            color: Colors.black,
                                            size: 10,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            '${homeData?.apiaryName ?? '--'} at 32.2°C',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16,
                                              fontFamily: "Sans",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Honey Harvest Season',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: "Sans",
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: CircularPercentIndicator(
                          animation: true,
                          animationDuration: 1000,
                          radius: 130,
                          lineWidth: 30,
                          percent: (homeData?.percentage_time_left ?? 0) / 100,
                          progressColor: Colors.amber,
                          backgroundColor: Colors.amber[100] ?? Colors.amber,
                          circularStrokeCap: CircularStrokeCap.round,
                          center: Text(
                            homeData?.daysToEndSeason != null &&
                                    homeData!.daysToEndSeason <= 10
                                ? "In Season"
                                : "${homeData?.daysToEndSeason.toStringAsFixed(0)} days \nto \nharvest season",
                            style: const TextStyle(
                              fontSize: 20,
                              fontFamily: "Sans",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
