class Farm {
  final int id;
  final int ownerId;
  final String name;
  final String district;
  final String address;
  final double? average_temperature;
  final double? average_weight;
  final double? honeypercent;
  final String? createdAt;
  final String? updatedAt;

  Farm({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.district,
    required this.average_temperature,
    required this.average_weight,
    required this.honeypercent,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Farm.fromJson(Map<String, dynamic> json) {
    return Farm(
      id: json['id'],
      ownerId: json['ownerId'],
      name: json['name'],
      district: json['district'],
      address: json['address'],
      average_temperature: json['average_temperature']?.toDouble(),
      average_weight: json['average_weight']?.toDouble(),
      honeypercent: json['average_honey_percentage']?.toDouble(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}