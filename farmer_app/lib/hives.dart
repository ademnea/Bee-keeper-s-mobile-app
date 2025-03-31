import 'package:HPGM/records_form.dart';
import 'package:flutter/material.dart';
import 'package:HPGM/hivedetails.dart';
import 'package:http/http.dart' as http;
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:HPGM/components/custom_progress_bar.dart';
import 'package:HPGM/components/pop_up.dart';
import 'dart:convert';

class Hives extends StatefulWidget {
  final int farmId;
  final String token;
  final String apiaryLocation;
  final String farmName;

  const Hives({
    Key? key,
    required this.farmId,
    required this.token,
    required this.apiaryLocation,
    required this.farmName,
  }) : super(key: key);

  @override
  State<Hives> createState() => _HivesState();
}

class Hive {
  final int id;
  final String longitude;
  final String latitude;
  final int farmId;
  final String? createdAt;
  final String? updatedAt;
  final double? weight;
  final double? honeyLevel;
  final double? temperature;
  final bool isConnected;
  final bool isColonized;

  Hive({
    required this.id,
    required this.longitude,
    required this.latitude,
    required this.farmId,
    required this.createdAt,
    required this.updatedAt,
    required this.weight,
    required this.temperature,
    required this.honeyLevel,
    required this.isConnected,
    required this.isColonized,
  });

  factory Hive.fromJson(Map<String, dynamic> json) {
    return Hive(
      id: json['id'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      farmId: json['farm_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      weight: json['state']['weight']['record']?.toDouble(),
      temperature:
          json['state']['temperature']['interior_temperature']?.toDouble(),
      honeyLevel: json['state']['weight']['honey_percentage']?.toDouble(),
      isConnected: json['state']['connection_status']['Connected'],
      isColonized: json['state']['colonization_status']['Colonized'],
    );
  }
}

class _HivesState extends State<Hives> {
  List<Hive> hives = [];

  @override
  void initState() {
    super.initState();
    getHives(widget.farmId);
  }

  Future<void> getHives(int farmId) async {
    try {
      String sendToken = "Bearer ${widget.token}";

      var headers = {
        'Authorization': sendToken,
      };

      var url = 'http://196.43.168.57/api/v1/farms/$farmId/hives';
      var response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          hives = data.map((hive) => Hive.fromJson(hive)).toList();
        });
      } else {
        print('Failed to load hive data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching hives: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      body: LiquidPullToRefresh(
        color: Colors.orange,
        height: 150,
        animSpeedFactor: 2,
        onRefresh: () async {
          await getHives(widget.farmId);
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 120,
              backgroundColor: Colors.orange,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  '${widget.farmName} Hives',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "Sans",
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                centerTitle: true,
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.orange.withOpacity(0.8),
                        Colors.orange.withOpacity(0.6),
                        Colors.orange.withOpacity(0.4),
                        Colors.orange.withOpacity(0.2),
                      ],
                    ),
                  ),
                ),
              ),
              leading: IconButton(
                icon: const Icon(
                  Icons.chevron_left_rounded,
                  color: Colors.white,
                  size: 32,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16),
                    child: buildHiveCard(hives[index]),
                  );
                },
                childCount: hives.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHiveCard(Hive hive) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      color: Colors.brown[300],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                Icon(
                  Icons.hexagon,
                  color: Colors.orange[700],
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Hive ${hive.id}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Sans",
                      color: Colors.white,
                    ),
                  ),
                ),
                Icon(
                  hive.isConnected ? Icons.link : Icons.link_off,
                  color: hive.isConnected ? Colors.green : Colors.red,
                  size: 24,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Status Indicators
            Row(
              children: [
                Expanded(
                  child: _buildStatusIndicator(
                    icon: Icons.thermostat,
                    label: 'Temperature',
                    value: hive.temperature ?? 0,
                    maxValue: 50,
                    unit: '°C',
                    onTap: () => showModalBottomSheet(
                      context: context,
                      builder: (context) => buildTempSheet(
                        "Temperature Details",
                        hive.temperature ?? 0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatusIndicator(
                    icon: Icons.scale,
                    label: 'Honey Level',
                    value: hive.honeyLevel ?? 0,
                    maxValue: 100,
                    unit: '%',
                    onTap: () => showModalBottomSheet(
                      context: context,
                      builder: (context) => buildHoneySheet(
                        "Honey Levels",
                        hive.honeyLevel ?? 0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Colonization Status
            _buildInfoRow(
              icon: Icons.grass,
              label: 'Colonization Status',
              value: hive.isColonized ? 'Colonized' : 'Not Colonized',
              valueColor: hive.isColonized ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 20),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HiveDetails(
                            hiveId: hive.id,
                            token: widget.token,
                            honeyLevel: hive.honeyLevel,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'View Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[600],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecordsForm(
                            apiaryLocation: widget.apiaryLocation,
                            hiveId: 'Hive ${hive.id}',
                            farmName: widget.farmName,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Inspect',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Colors.orange[700],
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Sans",
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? Colors.white,
                  fontFamily: "Sans",
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusIndicator({
    required IconData icon,
    required String label,
    required double value,
    required double maxValue,
    required String unit,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.brown[400]?.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.brown[500]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Colors.orange[700],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontFamily: "Sans",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${value.toStringAsFixed(1)}$unit',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: "Sans",
                  ),
                ),
                SizedBox(
                  width: 50,
                  height: 12,
                  child: LiquidLinearProgressIndicator(
                    value: value / maxValue,
                    valueColor: AlwaysStoppedAnimation(
                      label == 'Honey Level' ? Colors.amber : Colors.orange,
                    ),
                    backgroundColor: Colors.amber[100]!,
                    borderColor: Colors.transparent,
                    borderWidth: 0,
                    borderRadius: 6,
                    direction: Axis.horizontal,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}