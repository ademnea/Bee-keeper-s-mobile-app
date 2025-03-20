import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'farm_model.dart';
import 'farm_card.dart';

class Apiaries extends StatefulWidget {
  final String token;

  const Apiaries({Key? key, required this.token}) : super(key: key);

  @override
  State<Apiaries> createState() => _ApiariesState();
}

class _ApiariesState extends State<Apiaries> {
  List<Farm> farms = [];

  @override
  void initState() {
    super.initState();
    getApiaries();
  }

  Future<void> getApiaries() async {
    try {
      String sendToken = "Bearer ${widget.token}";

      var headers = {
        'Accept': 'application/json',
        'Authorization': sendToken,
      };
      var response = await http.get(
        Uri.parse('http://196.43.168.57/api/v1/farms'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        setState(() {
          farms = data.map((farm) => Farm.fromJson(farm)).toList();
        });
      } else {
        //  print('Failed to load farms: ${response.reasonPhrase}');
      }
    } catch (error) {
      //  print('Error fetching Apiary data: $error');
    }
  }

  Future<void> _handleRefresh() async {
    return await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LiquidPullToRefresh(
        onRefresh: _handleRefresh,
        color: Colors.orange,
        height: 150,
        animSpeedFactor: 2,
        showChildOpacityTransition: true,
        child: ListView(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 125,
                      width: 2000,
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
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Row(
                              children: [
                                Container(
                                  child: Image.asset(
                                    'lib/images/log-1.png',
                                    height: 80,
                                    width: 80,
                                  ),
                                ),
                                const SizedBox(
                                  width: 100,
                                ),
                                const Text(
                                  'Apiaries',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
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
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: farms.length,
                      itemBuilder: (context, index) {
                        return buildFarmCard(farms[index], context, widget.token);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}