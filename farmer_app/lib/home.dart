import 'package:farmer_app/components/bar_graph.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:farmer_app/Services/notifi_service.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';

class Home extends StatefulWidget {
  final String token;

  const Home({Key? key, required this.token}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class HomeData {
  final int farms;
  final int hives;

  HomeData({
    required this.farms,
    required this.hives,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      farms: json['total_farms'],
      hives: json['total_hives'],
    );
  }
}

class _HomeState extends State<Home> {
  HomeData? totalsdata;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
    startPeriodicTemperatureCheck(1);
  }

  Future<void> getData() async {
    try {
      String sendToken = "Bearer ${widget.token}";

      var headers = {
        'Accept': 'application/json',
        'Authorization': sendToken,
      };
      var response = await http.get(
        Uri.parse('https://www.ademnea.net/api/v1/farms/count'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);

        setState(() {
          totalsdata = HomeData.fromJson(data);
          isLoading = false;
        });

        //print(data);
      } else {
        setState(() {
          isLoading = false;
        });
        print('Failed to load farms: ${response.reasonPhrase}');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching Apiary data: $error');
    }
  }

  Timer? _timer;

  void startPeriodicTemperatureCheck(int hiveId) {
    _checkTemperature(hiveId);
    _timer = Timer.periodic(const Duration(minutes: 10), (timer) {
      _checkTemperature(hiveId);
    });
  }

  Future<void> _checkTemperature(int hiveId) async {
    try {
      String hiveName = 'Hive 1';
      double honeypercent = 50;
      if (honeypercent > 40) {
        NotificationService().showNotification(
          title: hiveName,
          body: 'Hive almost full! Please check this hive.',
        );
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
                                            'Apiaries: ${totalsdata?.farms ?? 0}',
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
                                            'Hives: ${totalsdata?.hives ?? 0}',
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
                            value: 0.65,
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
                              child: const Text(
                                "Mubende apiary at 65%",
                                style: TextStyle(
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
                          percent: 0.4,
                          progressColor: Colors.amber,
                          backgroundColor: Colors.amber.shade100,
                          circularStrokeCap: CircularStrokeCap.round,
                          center: Text(
                            "4 months left",
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.brown.shade700,
                              fontFamily: "Sans",
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
