class ApiConfig {
  static const String baseUrl =
      'https://clicknpickapi.crestclimbers.com/graphql/';

  // Define endpoints as needed
  static const String getAllOnBoardingEndpoint = "${baseUrl}SplahScreen/GetAll";
  static const String getAllResaurantEndpoint = "${baseUrl}Restaurant/GetAll";
  static const String getResaurantSearchEndpoint =
      "${baseUrl}Restaurant/RestaurantSearchBycuisine?name=";
  static const String getResaurantByIdEndpoint =
      "${baseUrl}Restaurant/GetRestaurantById?id=";
  static const String getResaurantMenuByIdEndpoint =
      "${baseUrl}RestaurantMenu/GetAllMenuById?restaurantId=";
  static const String getResaurantCategoryEndpoint =
      "${baseUrl}RestaurantCategory/GetAll";
  static const String addToCartEndpoint = "${baseUrl}FoodCart/AddToCart";
  static const String getCartEndpoint = "${baseUrl}FoodCart/GetCartItemsById)";
  static const String paymentResponseEndpoint = "${baseUrl}PaymentResponse/Add";

  /// dinein
  static const String getAllDineinResaurantEndpoint =
      "${baseUrl}DineInRestaurants/GetAll";
  static const String getAllDineinResaurantSearchEndpoint =
      "${baseUrl}DineInRestaurants/SearchAllRestaurantandMenu?searAll=";
  static const String getAllDineinResaurantByIdEndpoint =
      "${baseUrl}DineInRestaurants/";
  static const String createOrderEndpoint = "${baseUrl}FoodCart/AddToCart";
  static const String getAllOrdersEndpoint =
      "${baseUrl}OrderCreation/GetMyOrders?userId=";
  static const String orderCreationEndpoint =
      "${baseUrl}OrderCreation/OrderCreation";

  /// auth api
  static const String signUpEndpoint = "${baseUrl}Registration/AddRegistration";
  static const String signInEndpoint = "${baseUrl}Registration/signin";
}
