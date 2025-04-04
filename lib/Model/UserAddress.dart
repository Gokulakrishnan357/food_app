class UserAddress {
  Data? data;

  UserAddress({this.data});

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
    };
  }
}

class Data {
  UserDetails? userDetails;

  Data({this.userDetails});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      userDetails: json['userDetails'] != null
          ? UserDetails.fromJson(json['userDetails'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userDetails': userDetails?.toJson(),
    };
  }
}

class UserDetails {
  int? userId;
  List<UserRegularAddresses>? userRegularAddresses;

  UserDetails({this.userId, this.userRegularAddresses});

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      userId: json['userId'],
      userRegularAddresses: json['userRegularAddresses'] != null
          ? (json['userRegularAddresses'] as List)
          .map((e) => UserRegularAddresses.fromJson(e))
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userRegularAddresses': userRegularAddresses?.map((e) => e.toJson()).toList(),
    };
  }
}

class UserRegularAddresses {
  String? address;
  int? addressId;
  String? addressType;
  String? city;
  String? createdAt;
  String? houseName;
  String? houseNumber;
  String? landmark;
  double? latitude;
  String? locality;
  double? longitude;
  String? postalCode;
  String? state;
  String? streetName;
  String? updatedAt;
  int? userId;

  UserRegularAddresses({
    this.address,
    this.addressId,
    this.addressType,
    this.city,
    this.createdAt,
    this.houseName,
    this.houseNumber,
    this.landmark,
    this.latitude,
    this.locality,
    this.longitude,
    this.postalCode,
    this.state,
    this.streetName,
    this.updatedAt,
    this.userId,
  });

  factory UserRegularAddresses.fromJson(Map<String, dynamic> json) {
    return UserRegularAddresses(
      address: json['address'],
      addressId: json['addressId'],
      addressType: json['addressType'],
      city: json['city'],
      createdAt: json['createdAt'],
      houseName: json['houseName'],
      houseNumber: json['houseNumber'],
      landmark: json['landmark'],
      latitude: (json['latitude'] != null) ? json['latitude'].toDouble() : null,
      locality: json['locality'],
      longitude: (json['longitude'] != null) ? json['longitude'].toDouble() : null,
      postalCode: json['postalCode'],
      state: json['state'],
      streetName: json['streetName'],
      updatedAt: json['updatedAt'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'addressId': addressId,
      'addressType': addressType,
      'city': city,
      'createdAt': createdAt,
      'houseName': houseName,
      'houseNumber': houseNumber,
      'landmark': landmark,
      'latitude': latitude,
      'locality': locality,
      'longitude': longitude,
      'postalCode': postalCode,
      'state': state,
      'streetName': streetName,
      'updatedAt': updatedAt,
      'userId': userId,
    };
  }
}
