class UserData {
  Data? data;

  UserData({this.data});

  UserData.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  UserDetailsWithAddress? userDetailsWithAddress;

  Data({this.userDetailsWithAddress});

  Data.fromJson(Map<String, dynamic> json) {
    userDetailsWithAddress = json['userDetailsWithAddress'] != null
        ? UserDetailsWithAddress.fromJson(json['userDetailsWithAddress'])
        : null;
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (userDetailsWithAddress != null) {
      data['userDetailsWithAddress'] = userDetailsWithAddress!.toJson();
    }
    return data;
  }
}

class UserDetailsWithAddress {
  String? email;
  bool? isEmailVerified;
  bool? isMobileVerified;
  String? phoneNumber;
  int? userId;
  String? userName;
  List<UserRegularAddresses>? userRegularAddresses;
  List<UserProfiles>? userProfiles;

  UserDetailsWithAddress({
    this.email,
    this.isEmailVerified,
    this.isMobileVerified,
    this.phoneNumber,
    this.userId,
    this.userName,
    this.userRegularAddresses,
    this.userProfiles,
  });

  UserDetailsWithAddress.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    isEmailVerified = json['isEmailVerified'];
    isMobileVerified = json['isMobileVerified'];
    phoneNumber = json['phoneNumber'];
    userId = json['userId'];
    userName = json['userName'];

    if (json['userRegularAddresses'] != null) {
      userRegularAddresses = (json['userRegularAddresses'] as List)
          .map((v) => UserRegularAddresses.fromJson(v))
          .toList();
    }

    if (json['userProfiles'] != null) {
      userProfiles = (json['userProfiles'] as List)
          .map((v) => UserProfiles.fromJson(v))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['email'] = email;
    data['isEmailVerified'] = isEmailVerified;
    data['isMobileVerified'] = isMobileVerified;
    data['phoneNumber'] = phoneNumber;
    data['userId'] = userId;
    data['userName'] = userName;

    if (userRegularAddresses != null) {
      data['userRegularAddresses'] =
          userRegularAddresses!.map((v) => v.toJson()).toList();
    }
    if (userProfiles != null) {
      data['userProfiles'] = userProfiles!.map((v) => v.toJson()).toList();
    }
    return data;
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

  UserRegularAddresses.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    addressId = json['addressId'];
    addressType = json['addressType'];
    city = json['city'];
    createdAt = json['createdAt'];
    houseName = json['houseName'];
    houseNumber = json['houseNumber'];
    landmark = json['landmark'];
    latitude = json['latitude']?.toDouble();
    locality = json['locality'];
    longitude = json['longitude']?.toDouble();
    postalCode = json['postalCode'];
    state = json['state'];
    streetName = json['streetName'];
    updatedAt = json['updatedAt'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['address'] = address;
    data['addressId'] = addressId;
    data['addressType'] = addressType;
    data['city'] = city;
    data['createdAt'] = createdAt;
    data['houseName'] = houseName;
    data['houseNumber'] = houseNumber;
    data['landmark'] = landmark;
    data['latitude'] = latitude;
    data['locality'] = locality;
    data['longitude'] = longitude;
    data['postalCode'] = postalCode;
    data['state'] = state;
    data['streetName'] = streetName;
    data['updatedAt'] = updatedAt;
    data['userId'] = userId;
    return data;
  }
}

class UserProfiles {
  String? dateOfBirth;
  String? firstName;
  String? gender;
  String? lastName;
  String? profilePictureUrl;
  int? userId;
  int? userProfileId;

  UserProfiles({
    this.dateOfBirth,
    this.firstName,
    this.gender,
    this.lastName,
    this.profilePictureUrl,
    this.userId,
    this.userProfileId,
  });

  UserProfiles.fromJson(Map<String, dynamic> json) {
    dateOfBirth = json['dateOfBirth']?.toString();
    firstName = json['firstName'];
    gender = json['gender'];
    lastName = json['lastName'];
    profilePictureUrl = json['profilePictureUrl'];
    userId = json['userId'];
    userProfileId = json['userProfileId'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['dateOfBirth'] = dateOfBirth;
    data['firstName'] = firstName;
    data['gender'] = gender;
    data['lastName'] = lastName;
    data['profilePictureUrl'] = profilePictureUrl;
    data['userId'] = userId;
    data['userProfileId'] = userProfileId;
    return data;
  }
}
