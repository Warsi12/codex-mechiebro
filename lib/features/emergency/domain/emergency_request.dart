class EmergencyRequest {
  EmergencyRequest({
    required this.id,
    required this.customerId,
    required this.issueType,
    required this.status,
    required this.lat,
    required this.lng,
    this.note,
    this.assignedMechanicId,
    required this.createdAt,
  });

  final String id;
  final String customerId;
  final String issueType;
  final String status;
  final double lat;
  final double lng;
  final String? note;
  final String? assignedMechanicId;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'customerId': customerId,
        'issueType': issueType,
        'status': status,
        'location': {'lat': lat, 'lng': lng},
        'note': note,
        'assignedMechanicId': assignedMechanicId,
        'createdAt': createdAt.toIso8601String(),
      };

  factory EmergencyRequest.fromJson(Map<String, dynamic> json) => EmergencyRequest(
        id: json['id'] as String,
        customerId: json['customerId'] as String,
        issueType: json['issueType'] as String,
        status: json['status'] as String,
        lat: (json['location']['lat'] as num).toDouble(),
        lng: (json['location']['lng'] as num).toDouble(),
        note: json['note'] as String?,
        assignedMechanicId: json['assignedMechanicId'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
