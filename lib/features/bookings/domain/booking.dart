class Booking {
  Booking({
    required this.id,
    required this.type,
    required this.customerId,
    this.mechanicId,
    required this.serviceType,
    this.scheduledAt,
    required this.locationOption,
    required this.address,
    required this.status,
    required this.priceBase,
    this.priceAdjustment = 0,
    required this.createdAt,
  });

  final String id;
  final String type;
  final String customerId;
  final String? mechanicId;
  final String serviceType;
  final DateTime? scheduledAt;
  final String locationOption;
  final String address;
  final String status;
  final double priceBase;
  final double priceAdjustment;
  final DateTime createdAt;

  double get priceFinal => priceBase + priceAdjustment;

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'customerId': customerId,
        'mechanicId': mechanicId,
        'serviceType': serviceType,
        'scheduledAt': scheduledAt?.toIso8601String(),
        'locationOption': locationOption,
        'address': address,
        'status': status,
        'priceBase': priceBase,
        'priceAdjustment': priceAdjustment,
        'priceFinal': priceFinal,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        id: json['id'] as String,
        type: json['type'] as String,
        customerId: json['customerId'] as String,
        mechanicId: json['mechanicId'] as String?,
        serviceType: json['serviceType'] as String,
        scheduledAt: json['scheduledAt'] == null ? null : DateTime.parse(json['scheduledAt'] as String),
        locationOption: json['locationOption'] as String,
        address: json['address'] as String,
        status: json['status'] as String,
        priceBase: (json['priceBase'] as num).toDouble(),
        priceAdjustment: (json['priceAdjustment'] as num?)?.toDouble() ?? 0,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
