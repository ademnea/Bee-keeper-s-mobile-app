import 'package:HPGM/components/custom_progress_bar.dart';
import 'package:HPGM/components/pop_up.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'farm_model.dart';
import 'hives.dart';

Widget buildFarmCard(Farm farm, BuildContext context, String token) {
  return Center(
    child: SizedBox(
      width: 350,
      child: Card(
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
                    Icons.hive,
                    color: Colors.orange[700],
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      farm.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Sans",
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Location Row
              _buildInfoRow(
                icon: Icons.location_on,
                label: 'Location',
                value: '${farm.district}, ${farm.address}',
              ),
              const SizedBox(height: 16),

              // Status Indicators
              Row(
                children: [
                  Expanded(
                    child: _buildStatusIndicator(
                      icon: Icons.thermostat,
                      label: 'Temperature',
                      value: farm.average_temperature ?? 0,
                      maxValue: 50,
                      unit: '°C',
                      onTap: () => showModalBottomSheet(
                        context: context,
                        builder: (context) => buildTempSheet(
                          "Temperature Details",
                          farm.average_temperature ?? 0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatusIndicator(
                      icon: Icons.scale,
                      label: 'Honey Level',
                      value: farm.honeypercent ?? 0,
                      maxValue: 100,
                      unit: '%',
                      onTap: () => showModalBottomSheet(
                        context: context,
                        builder: (context) => buildHoneySheet(
                          "Honey Levels",
                          farm.honeypercent ?? 0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Action Button
              SizedBox(
                width: double.infinity,  // Fixed typo here
                child: ElevatedButton(  // Fixed typo here
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Hives(
                          farmId: farm.id,
                          token: token,
                          apiaryLocation: '${farm.district}, ${farm.address}',
                          farmName: farm.name,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'View Hives',
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
        ),
      ),
    ),
  );
}

Widget _buildInfoRow({
  required IconData icon,
  required String label,
  required String value,
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
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
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
                width: 60,
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