class UserData {
  final String userId;
  final String email;
  final bool isEmailVerified;
  final bool isMobileVerified;
  final String phoneNumber;
  final String dateOfBirth;
  final String firstName;
  final String gender;
  final String lastName;
  final String profilePictureUrl;
  late final List<UserRegularAddress> userRegularAddresses;
  final String userName;
  final List<UserProfiles>? userProfiles;

  UserData({
    required this.userId,
    required String email,
    required this.isEmailVerified,
    required this.isMobileVerified,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.firstName,
    required this.gender,
    required this.lastName,
    required this.profilePictureUrl,
    required this.userRegularAddresses,
    required this.userProfiles,
  }) : email = email.isNotEmpty ? email : "$firstName@gmail.com",
       userName = email.isNotEmpty ? email : "$firstName@gmail.com";

  factory UserData.fromJson(Map<String, dynamic> json) {
    String firstName =
        (json['userProfiles'] != null && json['userProfiles'].isNotEmpty)
            ? json['userProfiles'][0]['firstName'] ?? ''
            : '';

    String defaultEmail =
        json['email'] != null && json['email'].isNotEmpty
            ? json['email']
            : "$firstName@gmail.com";

    return UserData(
      userId: json['userId']?.toString() ?? '',
      email: defaultEmail, // Set default email
      isEmailVerified: json['isEmailVerified'] ?? false,
      isMobileVerified: json['isMobileVerified'] ?? false,
      phoneNumber: json['phoneNumber'] ?? '',
      dateOfBirth:
          json['userProfiles'] != null && json['userProfiles'].isNotEmpty
              ? json['userProfiles'][0]['dateOfBirth'] ?? ''
              : '',
      firstName: firstName,
      gender:
          json['userProfiles'] != null && json['userProfiles'].isNotEmpty
              ? json['userProfiles'][0]['gender'] ?? ''
              : '',
      lastName:
          json['userProfiles'] != null && json['userProfiles'].isNotEmpty
              ? json['userProfiles'][0]['lastName'] ?? ''
              : '',
      profilePictureUrl:
          json['userProfiles'] != null && json['userProfiles'].isNotEmpty
              ? json['userProfiles'][0]['profilePictureUrl'] ?? ''
              : '',
      userRegularAddresses:
          (json['userRegularAddresses'] as List?)
              ?.map((address) => UserRegularAddress.fromJson(address))
              .toList() ??
          [],
      userProfiles:
          (json['userProfiles'] as List?)
              ?.map((profile) => UserProfiles.fromJson(profile))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'userName': userName,
      'isEmailVerified': isEmailVerified,
      'isMobileVerified': isMobileVerified,
      'phoneNumber': phoneNumber,
      'userProfiles': [
        {
          'dateOfBirth': dateOfBirth,
          'firstName': firstName,
          'gender': gender,
          'lastName': lastName,
          'profilePictureUrl': profilePictureUrl,
        },
      ],
      'userRegularAddresses':
          userRegularAddresses.map((address) => address.toJson()).toList(),
      if (userProfiles != null)
        'userProfiles':
            userProfiles!.map((profile) => profile.toJson()).toList(),
    };
  }
}

class UserRegularAddress {
  final String address;
  final int addressId;
  final String addressType;
  final String city;
  final String createdAt;
  final String houseNumber;
  final String latitude;
  final String locality;
  final String longitude;
  final String postalCode;
  final String state;
  final String streetName;
  final String updatedAt;
  final String houseName;

  UserRegularAddress({
    required this.address,
    required this.addressId,
    required this.addressType,
    required this.city,
    required this.createdAt,
    required this.houseNumber,
    required this.latitude,
    required this.locality,
    required this.longitude,
    required this.postalCode,
    required this.state,
    required this.streetName,
    required this.updatedAt,
    required this.houseName,
  });

  factory UserRegularAddress.fromJson(Map<String, dynamic> json) {
    return UserRegularAddress(
      address: json['address'] ?? '',
      addressId: json['addressId'] ?? 0,
      addressType: json['addressType'] ?? '',
      city: json['city'] ?? '',
      createdAt: json['createdAt'] ?? '',
      houseNumber: json['houseNumber'] ?? '',
      latitude: json['latitude']?.toString() ?? '',
      locality: json['locality'] ?? '',
      longitude: json['longitude']?.toString() ?? '',
      postalCode: json['postalCode']?.toString() ?? '',
      state: json['state'] ?? '',
      houseName: json['houseName'] ?? '',
      streetName: json['streetName'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'addressId': addressId,
      'addressType': addressType,
      'city': city,
      'createdAt': createdAt,
      'houseNumber': houseNumber,
      'houseName': houseName,
      'latitude': latitude,
      'locality': locality,
      'longitude': longitude,
      'postalCode': postalCode,
      'state': state,
      'streetName': streetName,
      'updatedAt': updatedAt,
    };
  }
}

class UserProfiles {
  int? userProfileId;
  String? dateOfBirth;
  String? firstName;
  String? gender;
  String? lastName;
  String? email;
  String? profilePictureUrl;

  UserProfiles({
    this.userProfileId,
    this.dateOfBirth,
    this.firstName,
    this.gender,
    this.email,
    this.lastName,
    this.profilePictureUrl,
  });

  UserProfiles.fromJson(Map<String, dynamic> json) {
    userProfileId = json['userProfileId'];
    dateOfBirth = json['dateOfBirth'];
    firstName = json['firstName'];
    gender = json['gender'];
    lastName = json['lastName'];
    email = json['email'];
    profilePictureUrl = json['profilePictureUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['userProfileId'] = userProfileId;
    data['dateOfBirth'] = dateOfBirth;
    data['firstName'] = firstName;
    data['gender'] = gender;
    data['email'] = email;
    data['lastName'] = lastName;
    data['profilePictureUrl'] = profilePictureUrl;
    return data;
  }
}
