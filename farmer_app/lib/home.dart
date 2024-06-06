import 'package:HPGM/components/bar_graph.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:HPGM/Services/notifi_service.dart';
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

  HomeData({
    required this.farms,
    required this.hives,
    required this.apiaryName,
    required this.averageHoneyPercentage,
    required this.averageWeight,
    required this.daysToEndSeason,
  });

  factory HomeData.fromJson(
    Map<String, dynamic> countJson,
    Map<String, dynamic> productiveJson,
    Map<String, dynamic> seasonJson,
  ) {
    return HomeData(
      farms: countJson['total_farms'],
      hives: countJson['total_hives'],
      apiaryName: productiveJson['most_productive_farm']['name'],
      averageHoneyPercentage:
          productiveJson['average_honey_percentage'].toDouble(),
      averageWeight: productiveJson['average_weight'].toDouble(),
      daysToEndSeason: seasonJson['time_until_harvest']['days'].toDouble(),
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
    startPeriodicTemperatureCheck(1);
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
      ]);

      if (responses[0].statusCode == 200 &&
          responses[1].statusCode == 200 &&
          responses[2].statusCode == 200) {
        Map<String, dynamic> countData = jsonDecode(responses[0].body);
        Map<String, dynamic> productiveData = jsonDecode(responses[1].body);
        Map<String, dynamic> seasonData = jsonDecode(responses[2].body);

        //print(seasonData);
        //print(productiveData);

        setState(() {
          homeData = HomeData.fromJson(countData, productiveData, seasonData);
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

  void startPeriodicTemperatureCheck(int hiveId) {
    _checkTemperature(hiveId);
    _timer = Timer.periodic(const Duration(minutes: 60), (timer) {
      _checkTemperature(hiveId);
    });
  }

  Future<void> _checkTemperature(int hiveId) async {
    try {
      bool shouldTriggerNotification = widget.notify;
      String hiveName = 'Honey harvest season';
      double daystoseason = homeData?.daysToEndSeason ?? 0.0;

      if (daystoseason <= 10 && shouldTriggerNotification) {
        NotificationService().showNotification(
          title: hiveName,
          body:
              'The Honey harvest season is here, check your hives and get the honey.',
        );
        // Set the flag to true once notification is triggered
      }
    } catch (error) {
      print('Error fetching temperature: $error');
    }
  }

  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  List<double> weeklySummary = [
    80.40,
    2.50,
    42.42,
    10.50,
    100.20,
    68.99,
    90.10,
  ];

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
                                          const Icon(
                                            Icons.house,
                                            color:
                                                Color.fromARGB(255, 63, 59, 59),
                                          ),
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
                                          const Icon(
                                            Icons.house,
                                            color:
                                                Color.fromARGB(255, 63, 59, 59),
                                          ),
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
                      const Center(),
                      Center(
                        child: SizedBox(
                          height: 250,
                          width: 300,
                          child: LiquidLinearProgressIndicator(
                            //value: 0.64,
                            value: homeData?.averageHoneyPercentage ?? 0,
                            valueColor:
                                const AlwaysStoppedAnimation(Colors.amber),
                            backgroundColor: Colors.amber[100]!,
                            borderColor: Colors.brown,
                            borderWidth: 5.0,
                            borderRadius: 12.0,
                            direction: Axis.vertical,
                            center: TextButton(
                              onPressed: () {
                                // Define what happens when the button is pressed
                              },
                              child: Text(
                                "${homeData?.apiaryName ?? '--'} apiary\n${homeData?.averageHoneyPercentage?.toStringAsFixed(1) ?? '--'}%\n${homeData?.averageWeight?.toStringAsFixed(1) ?? '--'}Kg",
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
                      const SizedBox(height: 20),
                      const Text(
                        'Hottest Apiary',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: "Sans",
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: SizedBox(
                            width: 350,
                            height: 250,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: MyBarGraph(
                                weeklySummary: weeklySummary,
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
                          percent: 0.2,
                          progressColor:
                              const Color.fromARGB(255, 206, 109, 40),
                          backgroundColor:
                              const Color.fromARGB(255, 255, 206, 175),
                          circularStrokeCap: CircularStrokeCap.round,
                          center: Text(
                            homeData?.daysToEndSeason != null &&
                                    homeData!.daysToEndSeason <= 10
                                ? "In Season"
                                : "${homeData?.daysToEndSeason?.toStringAsFixed(0)} days \nto \nharvest season",
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
