class UserModel {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final bool isActive;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.isActive = true,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      isActive: json['is_active'] == null || json['is_active'] == 1 || json['is_active'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'is_active': isActive,
    };
  }
}

class BusinessProfileModel {
  final int id;
  final int userId;
  final String businessName;
  final String? ownerName;
  final String? gstin;
  final String? phone;
  final String? email;
  final String? address;

  BusinessProfileModel({
    required this.id,
    required this.userId,
    required this.businessName,
    this.ownerName,
    this.gstin,
    this.phone,
    this.email,
    this.address,
  });

  factory BusinessProfileModel.fromJson(Map<String, dynamic> json) {
    return BusinessProfileModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      userId: json['user_id'] is int ? json['user_id'] : int.parse(json['user_id'].toString()),
      businessName: json['business_name']?.toString() ?? 'My Business',
      ownerName: json['owner_name']?.toString(),
      gstin: json['gstin']?.toString(),
      phone: json['phone']?.toString(),
      email: json['email']?.toString(),
      address: json['address']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'business_name': businessName,
      'owner_name': ownerName,
      'gstin': gstin,
      'phone': phone,
      'email': email,
      'address': address,
    };
  }
}
