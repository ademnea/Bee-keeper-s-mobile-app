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
