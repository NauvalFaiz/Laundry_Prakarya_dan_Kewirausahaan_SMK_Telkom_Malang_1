class LaundryModel {
  final int id;
  final String? name;
  final String? email;
  final String? laundryName;
  final String? laundryAddress;
  final String? phone;
  final String? status;
  final List<ServiceModel>? services;

  LaundryModel({
    required this.id,
    this.name,
    this.email,
    this.laundryName,
    this.laundryAddress,
    this.phone,
    this.status,
    this.services,
  });

  factory LaundryModel.fromJson(Map<String, dynamic> json) {
    return LaundryModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      laundryName: json['laundry_name'],
      laundryAddress: json['laundry_address'],
      phone: json['phone'],
      status: json['status'],
      services: json['services'] != null
          ? (json['services'] as List).map((e) => ServiceModel.fromJson(e)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'laundry_name': laundryName,
      'laundry_address': laundryAddress,
      'phone': phone,
      'status': status,
      'services': services?.map((e) => e.toJson()).toList(),
    };
  }
}

class ServiceModel {
  final int id;
  final int? ownerId;
  final String name;
  final String? unitType;
  final int price;
  final bool isActive;
  final String? imageUrl;
  final LaundryModel? owner;

  ServiceModel({
    required this.id,
    this.ownerId,
    required this.name,
    this.unitType,
    required this.price,
    this.isActive = true,
    this.imageUrl,
    this.owner,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      ownerId: json['owner_id'],
      name: json['name'] ?? '',
      unitType: json['unit_type'],
      price: json['price'] ?? 0,
      isActive: json['is_active'] == 1 || json['is_active'] == true,
      imageUrl: json['image_url'],
      owner: json['owner'] != null ? LaundryModel.fromJson(json['owner']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner_id': ownerId,
      'name': name,
      'unit_type': unitType,
      'price': price,
      'is_active': isActive,
      'image_url': imageUrl,
      'owner': owner?.toJson(),
    };
  }
}

class CreateOrderRequest {
  final int ownerId;
  final int serviceId;
  final String laundryLocation;
  final String? deliveryType;
  final String pickupType;
  final String paymentMethod;
  final List<OrderItemRequest> items;

  CreateOrderRequest({
    required this.ownerId,
    required this.serviceId,
    required this.laundryLocation,
    this.deliveryType,
    required this.pickupType,
    required this.paymentMethod,
    required this.items,
  });

  Map<String, dynamic> toJson() => {
    'owner_id': ownerId,
    'service_id': serviceId,
    'laundry_location': laundryLocation,
    'delivery_type': deliveryType,
    'pickup_type': pickupType,
    'payment_method': paymentMethod,
    'items': items.map((e) => e.toJson()).toList(),
  };
}

class OrderItemRequest {
  final String serviceName;
  final int price;
  final int qty;

  OrderItemRequest({
    required this.serviceName,
    required this.price,
    required this.qty,
  });

  Map<String, dynamic> toJson() => {
    'service_name': serviceName,
    'price': price,
    'qty': qty,
  };
}
