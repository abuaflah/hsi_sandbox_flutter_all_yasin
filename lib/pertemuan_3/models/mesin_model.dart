class Mesin {
  final String deviceId;
  final bool status;

  Mesin({
    required this.deviceId,
    required this.status,
  });

  factory Mesin.fromJson(Map<String, dynamic> json) {
    return Mesin(
      deviceId: json['deviceid'] ?? 'Unknown',
      status: json['status'] ?? false,
    );
  }
}
