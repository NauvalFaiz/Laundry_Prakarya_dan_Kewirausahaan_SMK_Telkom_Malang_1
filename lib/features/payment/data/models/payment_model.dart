class PaymentModel {
  final String? token;
  final String? paymentUrl;
  final String? expiresAt;
  final String? message;
  final bool success;

  PaymentModel({
    this.token,
    this.paymentUrl,
    this.expiresAt,
    this.message,
    this.success = true,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return PaymentModel(
      token: data?['token'],
      paymentUrl: data?['payment_url'],
      expiresAt: data?['expires_at'],
      message: json['message'],
      success: json['success'] ?? true,
    );
  }
}

class OrderDetailModel {
  final int id;
  final int? userId;
  final int? ownerId;
  final int? serviceId;
  final String? laundryLocation;
  final String? deliveryType;
  final String? pickupType;
  final String? paymentMethod;
  final String? paymentCode;
  final String? paymentToken;
  final String? paymentTokenExpiresAt;
  final String? promoCode;
  final int discount;
  final int totalPrice;
  final String status;
  final String paymentStatus;
  final String? paidAt;
  final String? imageUrl;
  final int? pointsGranted;
  final String? createdAt;
  final List<OrderItemModel>? items;
  final List<OrderHistoryModel>? histories;

  OrderDetailModel({
    required this.id,
    this.userId,
    this.ownerId,
    this.serviceId,
    this.laundryLocation,
    this.deliveryType,
    this.pickupType,
    this.paymentMethod,
    this.paymentCode,
    this.paymentToken,
    this.paymentTokenExpiresAt,
    this.promoCode,
    this.discount = 0,
    this.totalPrice = 0,
    this.status = 'pending',
    this.paymentStatus = 'unpaid',
    this.paidAt,
    this.imageUrl,
    this.pointsGranted,
    this.createdAt,
    this.items,
    this.histories,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      id: json['id'],
      userId: json['user_id'],
      ownerId: json['owner_id'],
      serviceId: json['service_id'],
      laundryLocation: json['laundry_location'],
      deliveryType: json['delivery_type'],
      pickupType: json['pickup_type'],
      paymentMethod: json['payment_method'],
      paymentCode: json['payment_code'],
      paymentToken: json['payment_token'],
      paymentTokenExpiresAt: json['payment_token_expires_at'],
      promoCode: json['promo_code'],
      discount: json['discount'] ?? 0,
      totalPrice: json['total_price'] ?? 0,
      status: json['status'] ?? 'pending',
      paymentStatus: json['payment_status'] ?? 'unpaid',
      paidAt: json['paid_at'],
      imageUrl: json['image_url'],
      pointsGranted: json['points_granted'],
      createdAt: json['created_at'],
      items: json['items'] != null
          ? (json['items'] as List)
              .map((e) => OrderItemModel.fromJson(e))
              .toList()
          : null,
      histories: json['histories'] != null
          ? (json['histories'] as List)
              .map((e) => OrderHistoryModel.fromJson(e))
              .toList()
          : null,
    );
  }

  /// Check if payment token is expired
  bool get isTokenExpired {
    if (paymentTokenExpiresAt == null) return true;
    final expires = DateTime.tryParse(paymentTokenExpiresAt!);
    if (expires == null) return true;
    return DateTime.now().isAfter(expires);
  }

  /// Remaining seconds until token expires
  int get remainingSeconds {
    if (paymentTokenExpiresAt == null) return 0;
    final expires = DateTime.tryParse(paymentTokenExpiresAt!);
    if (expires == null) return 0;
    final diff = expires.difference(DateTime.now()).inSeconds;
    return diff > 0 ? diff : 0;
  }
}

class OrderItemModel {
  final int? id;
  final String? name;
  final int? qty;
  final int? price;

  OrderItemModel({this.id, this.name, this.qty, this.price});

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'],
      name: json['name'],
      qty: json['qty'],
      price: json['price'],
    );
  }
}

class OrderHistoryModel {
  final int? id;
  final String? status;
  final String? note;
  final String? createdAt;

  OrderHistoryModel({this.id, this.status, this.note, this.createdAt});

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) {
    return OrderHistoryModel(
      id: json['id'],
      status: json['status'],
      note: json['note'],
      createdAt: json['created_at'],
    );
  }
}

class PaymentStatusModel {
  final int? id;
  final String? status;
  final String? paymentStatus;
  final String? paidAt;
  final bool success;

  PaymentStatusModel({
    this.id,
    this.status,
    this.paymentStatus,
    this.paidAt,
    this.success = true,
  });

  factory PaymentStatusModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return PaymentStatusModel(
      id: data?['id'],
      status: data?['status'],
      paymentStatus: data?['payment_status'],
      paidAt: data?['paid_at'],
      success: json['success'] ?? true,
    );
  }
}
