import 'dart:io';

import 'package:zeroq/models/cart/local_cart_items.dart';
import 'package:decimal/decimal.dart';

class GraphQuery {
  //static const String graphClient = 'http://foodapp.crestclimbers.com/graphql/';
  static const String graphClient =
      "https://clicknpickapi.crestclimbers.com/graphql/";

  //splash screen quries
  static String getSplashScreen = '''
  query Example {
  splashDetails {
    branchId
    branchName
    createdAt
    description
    displayOrder
    imageUrl
    isActive
    link
    restaurantId
    restaurantName
    splashId
    title
    updatedAt
  }
}
  ''';

  static String queryRestaurantByLocation({
    required double latitude,
    required double longitude,
    String? cuisine,
  }) {
    return '''
         query {
  restaurantsByFilter(
    searchText: null
    isVeg: null
    isDeliveryAvailable: null
    isSelfPickup: null
    rating: null
    customerLatitude: 13.051486466580032
    customerLongitude: 80.22634932404135
    radiusKm: 5
    price: null
    sortByOption: null
  )  {
      averageRating
      createdAt
      deliveryAvailable
      deliveryPlatformFeeId
      imagedata
      imagename
      imageUrl
      isActive
      logo
      logourl
      minimumLimitofPerPerson
      rating
      ratingsCount
      restaurantId
      restaurantName
      selfPickUpAvailbale
      selfPickupPlatformFeeId
      updatedAt

      menus {
        availableTimeFrom
        availableTimeTo
        avalaibleQuatityofMenu
        averageRating
        cuisineType
        description
        imagedata
        imagename
        imageUrl
        isAvailable
        isVeg
        menuId
        name
        preparationTime
        price
        rating
        ratingsCount
        restaurantId
      }

      branches {
        address
        longitude
        locality
        latitude
      }

      cuisineTypes {
        cuisineTypeId
        imagename
        name
      }

      categories {
        menus {
          name
          menuId
          preparationTime
        }
      }
    
  }
}
      ''';
  }

  static String querygetdeliveryByName(String categoryName) {
    return '''
    query {
  restaurants(
    input: {
      categoryName: "$categoryName"
      searchText: ""
      deliveryAvailable: true
      maxPrice: null
    }
  ) {
    averageRating
    createdAt
    deliveryAvailable
    deliveryPlatformFeeId
    imagedata
    imagename
    imageUrl
    isActive
    logo
    logourl
    minimumLimitofPerPerson
    rating
    ratingsCount
    restaurantId
    restaurantName
    selfPickUpAvailbale
    selfPickupPlatformFeeId
    updatedAt
    menus {
      availableTimeFrom
      availableTimeTo
      avalaibleQuatityofMenu
      averageRating
      cuisineType
      description
      imagedata
      imagename
      imageUrl
      isAvailable
      isVeg
      menuId
      name
      preparationTime
      price
      rating
      ratingsCount
      restaurantId
    }
    branches {
      address
      longitude
      locality
      latitude
    }
    cuisineTypes {
      cuisineTypeId
      imagename
      name
    }
  }
}
  ''';
  }

  static String querycategory200(
    String categoryName,
    String deliveryAvailable,
  ) {
    return '''
   query {
  restaurants(
    input: {
      categoryName: "$categoryName"
      searchText: ""
      deliveryAvailable: null
      selfPickUpAvailbale: true
    }
    where: { minimumLimitofPerPerson: { lt: 201 } }
  ) {
    averageRating
    createdAt
    deliveryAvailable
    deliveryPlatformFeeId
    imagedata
    imagename
    imageUrl
    isActive
    logo
    logourl
    minimumLimitofPerPerson
    rating
    ratingsCount
    restaurantId
    restaurantName
    selfPickUpAvailbale
    selfPickupPlatformFeeId
    updatedAt
    menus {
      availableTimeFrom
      availableTimeTo
      avalaibleQuatityofMenu
      averageRating
      cuisineType
      description
      imagedata
      imagename
      imageUrl
      isAvailable
      isVeg
      menuId
      name
      preparationTime
      price
      rating
      ratingsCount
      restaurantId
    }
    branches {
      address
      longitude
      locality
      latitude
    }
    cuisineTypes {
      cuisineTypeId
      imagename
      name
    }
  }
}
  ''';
  }

  static const String queryGetAllRestraunt = """
      query Example {
  restaurants(input: { searchText: "" }) {
    averageRating
    createdAt
    deliveryAvailable
    deliveryPlatformFeeId
    imagedata
    imagename
    imageUrl
    isActive
    logo
    logourl
    minimumLimitofPerPerson
    rating
    ratingsCount
    restaurantId
    restaurantName
    selfPickUpAvailbale
    selfPickupPlatformFeeId
    updatedAt
    images {
      imageType
      imageUrl
      isActive
      menuImageId
      uploadDate
    }
    branches {
      address
      branchId
      createdAt
      latitude
      longitude
      phoneNumber
      updatedAt
      images {
        imageType
        imageUrl
        isActive
        menuImageId
        uploadDate
      }
    }
    cuisineTypes {
      cuisineTypeId
      name
    }
    restaurantId
  }
}
    """;

  static const String queryGetAllRestraunts = """
      query Example {
  restaurants(input: { searchText: "" }) {
    averageRating
    createdAt
    deliveryAvailable
    deliveryPlatformFeeId
    imagedata
    imagename
    imageUrl
    isActive
    logo
    logourl
    minimumLimitofPerPerson
    rating
    ratingsCount
    restaurantId
    restaurantName
    selfPickUpAvailbale
    selfPickupPlatformFeeId
    updatedAt
    images {
      imageType
      imageUrl
      isActive
      menuImageId
      uploadDate
    }
    branches {
      address
      branchId
      createdAt
      latitude
      longitude
      phoneNumber
      updatedAt
      images {
        imageType
        imageUrl
        isActive
        menuImageId
        uploadDate
      }
    }
    cuisineTypes {
      cuisineTypeId
      name
    }
    restaurantId
  }
}
    """;

  static get categoryName => null;

  static String queryGetHotelDelivery() {
    return '''
  query Example {
    restaurants(
      input: { searchText: "", deliveryAvailable: true }
    ) {
      averageRating
      createdAt
      rating
      ratingsCount
      restaurantId
      restaurantName
      updatedAt
      imageUrl
      images {
        imageType
        imageUrl
        isActive
        menuImageId
        uploadDate
      }
      branches {
        address
        branchId
        createdAt
        latitude
        longitude
        phoneNumber
        updatedAt
      }
      cuisineTypes {
        cuisineTypeId
        name
      }
    }
  }
  ''';
  }

  static String queryRestaurantById(String restaurantId) {
    return '''  query Example{
  restaurants(
    input: { searchText: "" }
    where: { restaurantId: { eq: $restaurantId } }
  ) {
    averageRating
    createdAt
    rating
    ratingsCount
    restaurantId
    restaurantName
    minimumLimitofPerPerson
    updatedAt
    imageUrl
    images {
      imageType
      imageUrl
      isActive
      menuImageId
      uploadDate
    }
    branches {
      address
      branchId
      createdAt
      latitude
      longitude
      phoneNumber
      updatedAt
    }
    cuisineTypes {
      cuisineTypeId
      name
    }
    categories {
      menus {
        preparationTime
      }
    }
  }
}''';
  }

  static String queryRestaurantByName(String restaurantName) {
    return ''' query Example {
    
   restaurants(input: { searchText: "$restaurantName" }) {
   
      averageRating
      createdAt
      deliveryAvailable
      deliveryPlatformFeeId
      imagedata
      imagename
      imageUrl
      isActive
      logo
      logourl
      minimumLimitofPerPerson
      rating
      ratingsCount
      restaurantId
      restaurantName
      selfPickUpAvailbale
      selfPickupPlatformFeeId
      updatedAt

      menus {
        availableTimeFrom
        availableTimeTo
        avalaibleQuatityofMenu
        averageRating
        cuisineType
        description
        imagedata
        imagename
        imageUrl
        isAvailable
        isVeg
        menuId
        name
        preparationTime
        price
        rating
        ratingsCount
        restaurantId
      }

      branches {
        address
        longitude
        locality
        latitude
      }

      cuisineTypes {
        cuisineTypeId
        imagename
        name
      }

      categories {
        menus {
          name
          menuId
          preparationTime
        }
      }
    
  }
}
''';
  }

  static String querygetRestaurantByName(String categoryName) {
    return '''
    query {
    
    restaurants(input: { categoryName: "$categoryName", searchText: "" }) {
    averageRating
    createdAt
    deliveryAvailable
    deliveryPlatformFeeId
    imagedata
    imagename
    imageUrl
    isActive
    logo
    logourl
    minimumLimitofPerPerson
    rating
    ratingsCount
    restaurantId
    restaurantName
    selfPickUpAvailbale
    selfPickupPlatformFeeId
    updatedAt
    menus {
      availableTimeFrom
      availableTimeTo
      avalaibleQuatityofMenu
      averageRating
      cuisineType
      description
      imagedata
      imagename
      imageUrl
      isAvailable
      isVeg
      menuId
      name
      preparationTime
      price
      rating
      ratingsCount
      restaurantId
    }
    branches {
      address
      longitude
      locality
      latitude
    }
    cuisineTypes {
      cuisineTypeId
      imagename
      name
    }
    }
  }
  ''';
  }

  static String querygetSearchRestaurant() {
    return '''
    query {
  restaurants(
    input: { searchText: "", deliveryAvailable: null, selfPickUpAvailbale: true }
  ) {
    averageRating
    createdAt
    deliveryAvailable
    deliveryPlatformFeeId
    imagedata
    imagename
    imageUrl
    isActive
    logo
    logourl
    minimumLimitofPerPerson
    rating
    ratingsCount
    restaurantId
    restaurantName
    selfPickUpAvailbale
    selfPickupPlatformFeeId
    updatedAt
    menus {
      availableTimeFrom
      availableTimeTo
      avalaibleQuatityofMenu
      averageRating
      cuisineType
      description
      imagedata
      imagename
      imageUrl
      isAvailable
      isVeg
      menuId
      name
      preparationTime
      price
      rating
      ratingsCount
      restaurantId
    }
    branches {
      address
      longitude
      locality
      latitude
    }
    categories {
      menus {
        name
        menuId
        preparationTime
      }
    }
    cuisineTypes {
      cuisineTypeId
      imagename
      name
    }
  }
}
  ''';
  }

  static String getRestaurantMenuById(String restaurantId) {
    return '''
     query Example {
    restaurants(input: { searchText: "" }, where: { restaurantId: { eq: $restaurantId } }) {
      restaurantId
      restaurantName
      averageRating
      rating
      ratingsCount
      imageUrl
      logo
      logourl
      isActive
      deliveryAvailable
      selfPickUpAvailbale
      categories {
        categoryId
        categoryName
        imageUrl
        menus {
          menuId
          name
          description
          cuisineType
          price
          isAvailable
          isVeg
          rating
          averageRating
          ratingsCount
          availableTimeFrom
          availableTimeTo
          avalaibleQuatityofMenu
          preparationTime
          imageUrl
        }
      }
    }
  }
  ''';
  }

  static String getCategory() {
    return '''
  query Example {

   categorys  {
                categoryId
                categoryName
                imageUrl
         }
    }

  ''';
  }

  //user auth query
  static String verifyOTP(String OTP, String mobileNumber) {
    return '''
mutation {
  verifyOtp(input: { otpCode: "$OTP", phoneNumber: "$mobileNumber" }) {
    message
    success
    data {
      isVerified
      message
      userId
    }
  }
}
''';
  }

  static String loginRegisterUser(String phoneNumber) {
    return '''
  mutation {
  registerOrLoginUser(phoneNumber: "$phoneNumber") {
    data {
      otpCode
      user {
        address
        createdAt
        email
        isEmailVerified
        isMobileVerified
        password
        phoneNumber
        updatedAt
        userId
        username
        carts {
          cartId
          status
          updatedAt
        }
      }
    }
    message
    success
  }
}
''';
  }

  static String createCart(
    int restaurantId,
    int userId,
    CartItems items, {
    Decimal? selfPickupPlatformFee,
    int? platformFeeId,
    Decimal? deliveryPlatformFee,
  }) {
    String itemString = '''
 { menuItemId: ${items.menuId}, discountAmount: ${items.discountAmount}, gstAmount: ${items.gstAmount}, quantity: ${items.quantity} }''';

    return '''
mutation {
  createCart(
    input: {
      restaurantId: $restaurantId
      status: "active"
      userId: $userId
      items: [$itemString]
      feeType: "SELF_PICKUP"
      selfPickupPlatformFee: ${selfPickupPlatformFee != null ? selfPickupPlatformFee.toString() : "null"}
      platformFeeId: 2
      deliveryPlatformFee: $deliveryPlatformFee
    }
  ) {
    message
    success
    data {
      cart {
        cartId
        createdAt
        discountAmount
        finalAmount
        gstamount
        itemTotal
        restaurantId
        status
        updatedAt
        userId
        selfPickupPlatformFee
        platformFeeId
        deliveryPlatformFee
        cartItems {
          cartItemId
          menuItemId
          quantity
          totalPrice
          unitPrice
        }
      }
    }
  }
}

''';
  }

  static String getCartByCartId(int cartId) {
    return ''' query {
  cart(cartId: $cartId) {
    cartId
    createdAt
    discountAmount
    finalAmount
    gstAmount
    itemTotal
    packagingCharges
    restaurantId
    restaurantName
    serviceCharge
    status
    updatedAt
    userId
    cartItems {
      cartItemId
      discountAmount
      gstAmount
      menuItemId
      menuItemName
      quantity
      totalPrice
      unitPrice
    }
  }
}''';
  }

  static String getCartByUserId(int userId) {
    return '''
query {
  cartByUserId(userId: $userId) {
    cartId
    createdAt
    discountAmount
    finalAmount
    gstAmount
    itemTotal
    packagingCharges
    restaurantId
    restaurantName
    serviceCharge
    status
    updatedAt
    userId
    cartItems {
      cartItemId
      discountAmount
      gstAmount
      menuItemId
      menuItemName
      quantity
      totalPrice
      unitPrice
      imageUrl
      preparationTime
      preparationTimeForamtted
    }
    imageUrl
    platformFee {
      feeType
      fixedAmount
      percentage
      platformFeeId
    }
    fixedAmount
    rating
    ratingsCount
    selfPickUpAvailbale
    selfPickupPlatformFee
    userName
    platformFees {
      feeType
      fixedAmount
      percentage
      platformFeeId
    }
  }
}
 ''';
  }

  static String updateCartDetails(
    int cartId,
    int menuItemId,
    int quantity,
    double gstAmount,
    double discountAmount, {
    Decimal? selfPickupPlatformFee,
    int? platformFeeId,
    Decimal? deliveryPlatformFee,
  }) {
    return '''
  mutation {
    updateCartNew(
      input: {
        cartId: $cartId  # Keep this as an integer
        discountCode: ""
        items: {
          discountAmount: $discountAmount
          gstAmount: $gstAmount
          menuItemId: $menuItemId  # Keep this as an integer
          quantity: $quantity  # Keep this as an integer
        }
        feeType: "SELF_PICKUP"
        selfPickupPlatformFee: ${selfPickupPlatformFee != null ? selfPickupPlatformFee.toDouble() : "null"}
        platformFeeId: ${platformFeeId != null ? platformFeeId : "null"}
        deliveryPlatformFee: ${deliveryPlatformFee != null ? deliveryPlatformFee.toDouble() : "null"}
      }
    ) {
      message
      success
      data {
        cart {
          cartId
          cartItems {
            cartId
            cartItemId
            discountAmount
            gstamount
            menuItemId
            quantity
            totalPrice
            unitPrice
          }
          finalAmount
          discountAmount
          deliveryPlatformFee
          selfPickupPlatformFee
        }
      }
    }
  }
  ''';
  }

  static String deleteCart(int cartId) {
    return '''
    mutation {
  deleteCart(input: { cartId: $cartId }) {
    message
    success
    data {
      success
    }
  }
}
    ''';
  }

  // order related query
  static String createOrder(
    String cartId,
    String deliveryAddress,
    String paymentMethod,
    String userId,
  ) {
    return '''
  mutation {
  createOrder(
    input: { cartId: $cartId, deliveryAddress: "$deliveryAddress", paymentMethod: "$paymentMethod", userId: $userId,applicationType: MOBILE }
  ) {
    message
    success
    data {
      order {
        actualDeliveryTime
        branchId
        createdAt
        deliveryAddress
        estimatedDeliveryTime
        orderDate
        orderId
        orderPaymentStatus
        orderTrackStatus
        paymentMethod
        totalAmount
        updatedAt
        userId
      }
    }
  }
}

''';
  }

  static String handlePayment(double amount, int orderId) {
    return '''
    mutation {
  handlePayment(input: { amount: $amount, orderId: $orderId }) {
    status
    transactionDate
    transactionId
    transactionType
    orderId
    paymentGateway
    razorpayOrderId
  }
}''';
  }

  static String completePayment(
    String razorPayOrderId,
    String razorPayPaymentId,
  ) {
    return '''
mutation {
  completePayment(input: { razorpayOrderId: "$razorPayPaymentId", razorpayPaymentId: "$razorPayOrderId" }) {
    status
    transactionDate
    transactionId
    orderId
    cartId
    amount
    paymentGateway
    transactionType
  }
}
''';
  }

  //user details related queries

  static String userAllOrderDetails(int userId) {
    return '''
query {

  userDetails(id: $userId) {
    orders {
      actualDeliveryTime
      createdAt
      deliveryAddress
      estimatedDeliveryTime
      orderDate
      orderId
      orderStatus
      paymentMethod
      totalAmount
      updatedAt
      userId
      orderDetails {
        menuId
        orderDetailId
        price
        quantity
        menu {
          itemName
          menuId
          price
        }
      }
      restaurant {
        restaurantId
        restaurantName
        imageUrl
        branch {
          locality
          address
        }
        
      }
    }
  }
}
''';
  }

  static String userProfileDetails(int id) {
    print("📡 Generating userDetails query for userId: $id");
    return '''
  query {
    userDetails(id: $id, orderStatus: null, where: null, order: null) {
      userId
      phoneNumber
      userProfiles {
        userProfileId
        userId
        firstName
        lastName
        dateOfBirth
        gender
        profilePictureUrl
      }
    }
  }
  ''';
  }

  static String userDetails(int id) {
    return '''
  query {
    userDetailsWithAddress(id: $id) {
      userId
      email
      isEmailVerified
      isMobileVerified
      phoneNumber
      userName
      userProfiles {
        userProfileId
        userId
        firstName
        lastName
        dateOfBirth
        gender
        profilePictureUrl
      }
      userRegularAddresses {
        addressId
        userId
        address
        addressType
        city
        state
        postalCode
        locality
        streetName
        houseName
        houseNumber
        landmark
        latitude
        longitude
        createdAt
        updatedAt
      }
    }
  }
  ''';
  }


  static String userDetailsWithAddress(int id) {
    return '''
    query {
    
    userDetailsWithAddress(id: $id) {
    phoneNumber
    userId
    userName
    userRegularAddresses {
      address
      addressId
      addressType
      city
      createdAt
      houseName
      houseNumber
      landmark
      latitude
      locality
      longitude
      postalCode
      state
      streetName
      updatedAt
      userId
    }
  }
}
''';
  }

  static String getUserDetails(int userId) {
    return '''
  query {
    userDetails(id:$userId) {
        email
        isEmailVerified
        isMobileVerified
        phoneNumber
        userId
        userName
        userProfiles {
          firstName
          lastName
          dateOfBirth
          gender
          profilePictureUrl
          userProfileId
        }
    }
  }
  ''';
  }

  static String deleteUserAddress(int addressId) {
    return '''
          mutation {
          deleteUserRegularAddress(addressId: $addressId) {
          message
          success
        }
    }
''';
  }

  static String getAllCategoriesQuery() {
    return '''
      query {
        categories {
          id
          name
        }
      }
    ''';
  }

  static String createUserRegularAddress(
    int userId,
    String? address,
    String? addressType,
    String? houseNumber,
    String? streetName,
    String? landmark,
    String? locality,
    String? city,
    String? state,
    String? postalCode,
    Decimal? latitude,
    Decimal? longitude,
  ) {
    return '''
  mutation {
    createUserRegularAddress(
      userId: $userId,
      address: ${address != null ? '"$address"' : null},
      addressType: ${addressType != null ? '"$addressType"' : null},
      houseNumber: ${houseNumber != null ? '"$houseNumber"' : null},
      streetName: ${streetName != null ? '"$streetName"' : null},
      landmark: ${landmark != null ? '"$landmark"' : null},
      locality: ${locality != null ? '"$locality"' : null},
      city: ${city != null ? '"$city"' : null},
      state: ${state != null ? '"$state"' : null},
      postalCode: ${postalCode != null ? '"$postalCode"' : null},
      latitude: $latitude,
      longitude: $longitude
    ) {
      message
      success
      data {
        address
        addressType
        city
        createdAt
        houseNumber
        landmark
        latitude
        locality
        longitude
        postalCode
        state
        streetName
        updatedAt
        userId
      }
    }
  }
''';
  }

  static String updateUserRegularAddress(
    int addressId,
    String? address,
    String? addressType,
    String? houseNumber,
    String? houseName,
    String? streetName,
    String? landmark,
    String? locality,
    String? city,
    String? state,
    String? postalCode,
    Decimal? latitude,
    Decimal? longitude,
  ) {
    return '''
  mutation {
    updateUserRegularAddress(
      addressId: $addressId,
      address: ${address != null ? '"$address"' : null},
      addressType: ${addressType != null ? '"$addressType"' : null},
      houseNumber: ${houseNumber != null ? '"$houseNumber"' : null},
      houseName: ${houseName != null ? '"$houseName"' : null},
      streetName: ${streetName != null ? '"$streetName"' : null},
      landmark: ${landmark != null ? '"$landmark"' : null},
      locality: ${locality != null ? '"$locality"' : null},
      city: ${city != null ? '"$city"' : null},
      state: ${state != null ? '"$state"' : null},
      postalCode: ${postalCode != null ? '"$postalCode"' : null},
      latitude: $latitude,
      longitude: $longitude
    ) {
      message
      success
      data {
        address
        addressType
        city
        createdAt
        houseName
        houseNumber
        landmark
        latitude
        locality
        longitude
        postalCode
        state
        streetName
        updatedAt
        userId
      }
    }
  }
''';
  }

  static String getOrderStatus(int userID, int orderID) {
    return '''
query {
  ordersStatusByUserId(userid: $userID, orderid: $orderID) {
    orders {
      actualDeliveryTime
      email
      estimatedDeliveryTime
      orderDate
      orderId
      orderPaymentStatus
      orderStatus
      phoneNumber
      totalAmount
      userId
      userName
    }
  }
}
''';
  }

  static String updateUserDetails1({
    required int id,
    String? firstName,
    String? lastName,
    String? dateOfBirth,
    String? gender,
    File? profileImg,
  }) {
    return '''
  mutation UpdateUserProfile(
    \$id: Int!,
    \$firstName: String,
    \$lastName: String,
    \$dateOfBirth: String,
    \$gender: String,
    \$profileImg: Upload
  ) {
    updateUserProfile(
      id: \$id,
      firstName: \$firstName,
      lastName: \$lastName,
      dateOfBirth: \$dateOfBirth,
      gender: \$gender,
      profileImg: \$profileImg
    ) {
      success
      message
      data {
        userProfileId
        firstName
        lastName
        dateOfBirth
        gender
        profilePictureUrl
      }
    }
  }
  ''';
  }

  static String getUserAddressDetails(int userId) {
    return '''
  query {
    userDetails(id: $userId) {
    userId
    userRegularAddresses {
      address
      addressId
      addressType
      city
      createdAt
      houseName
      houseNumber
      landmark
      latitude
      locality
      longitude
      postalCode
      state
      streetName
      updatedAt
      userId
     }
   }
 }
  ''';
  }

  static String createUserProfile({
    required int userId,
    String? firstName,
    String? lastName,
    String? dateOfBirth,
    String? gender,
    String? email,
    File? profileImg,
  }) {
    return '''
  mutation CreateUserProfile(\$profileImg: Upload) {
    createUserProfile(
      userId: $userId
      firstName: ${firstName != null ? '"$firstName"' : null}
      lastName: ${lastName != null ? '"$lastName"' : null}
      dateOfBirth: ${dateOfBirth != null ? '"$dateOfBirth"' : null}
      gender: ${gender != null ? '"$gender"' : null}
      email: ${email != null ? '"$email"' : null}
      profileImg: \$profileImg
    ) {
      success
      message
      data {
        userId
        userProfileId
        firstName
        lastName
        email
        dateOfBirth
        gender
        profilePictureUrl
      }
    }
  }
  ''';
  }

  /// ✅ Update User Details Mutation
  static String updateUserDetails({
    required int id,
    String? firstName,
    String? lastName,
    String? gender,
    String? email,
    File? profileImg,
  }) {
    return '''
    mutation {
      updateUserProfile(
        id: $id
        firstName: ${firstName != null ? '"$firstName"' : null}
        lastName: ${lastName != null ? '"$lastName"' : null}
        gender: ${gender != null ? '"$gender"' : null}
        email: ${email != null ? '"$email"' : null}
        profileImg: ${profileImg != null ? '"$profileImg"' : null}
      ) {
        success
        message
        data {
          userProfileId
          firstName
          lastName
          email
          gender
          profilePictureUrl
        }
      }
    }
  ''';
  }

  static String querygetlessthan200() {
    return '''
    query {
  restaurants(
    input: { searchText: "", selfPickUpAvailbale: null, deliveryAvailable: null }
    where: { minimumLimitofPerPerson: { lt: 201 } }
  ) {
    averageRating
    createdAt
    deliveryAvailable
    deliveryPlatformFeeId
    imagedata
    imagename
    imageUrl
    isActive
    logo
    logourl
    minimumLimitofPerPerson
    rating
    ratingsCount
    restaurantId
    restaurantName
    selfPickUpAvailbale
    selfPickupPlatformFeeId
    updatedAt
    menus {
      availableTimeFrom
      availableTimeTo
      avalaibleQuatityofMenu
      averageRating
      cuisineType
      description
      imagedata
      imagename
      imageUrl
      isAvailable
      isVeg
      menuId
      name
      preparationTime
      price
      rating
      ratingsCount
      restaurantId
    }
    branches {
      address
      longitude
      locality
      latitude
    }
    categories {
      menus {
        name
        menuId
        preparationTime
      }
    }
    cuisineTypes {
      cuisineTypeId
      imagename
      name
    }
  }
}
  ''';
  }

  static String querydeliveryRestaurant() {
    return '''
    query {
  restaurants(
    input: { searchText: "", selfPickUpAvailbale: null, deliveryAvailable:true }
  ) {
    averageRating
    createdAt
    deliveryAvailable
    deliveryPlatformFeeId
    imagedata
    imagename
    imageUrl
    isActive
    logo
    logourl
    minimumLimitofPerPerson
    rating
    ratingsCount
    restaurantId
    restaurantName
    selfPickUpAvailbale
    selfPickupPlatformFeeId
    updatedAt
    menus {
      availableTimeFrom
      availableTimeTo
      avalaibleQuatityofMenu
      averageRating
      cuisineType
      description
      imagedata
      imagename
      imageUrl
      isAvailable
      isVeg
      menuId
      name
      preparationTime
      price
      rating
      ratingsCount
      restaurantId
    }
    branches {
      address
      longitude
      locality
      latitude
    }
    categories {
      menus {
        name
        menuId
        preparationTime
      }
    }
    cuisineTypes {
      cuisineTypeId
      imagename
      name
    }
  }
}
  ''';
  }
}
