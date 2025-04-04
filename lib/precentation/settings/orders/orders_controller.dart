
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zeroq/const/app_exports.dart';
import 'package:zeroq/models/order_status/order_status_models.dart';
import 'package:zeroq/server/app_storage.dart';
import 'package:zeroq/server/network_handler.dart';

class OrdersController extends GetxController {
  final AppNetworkHandler networkHandler = AppNetworkHandler();
  var getAllOrders = <OrderCreationByIdModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> openMap(
    String lat,
    lon,
  ) async {
    final String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
    const String appleMapsUrl = 'https://maps.apple.com/?q=37.7749,-122.4194';

    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl));
    } else if (await canLaunchUrl(Uri.parse(appleMapsUrl))) {
      await launchUrl(Uri.parse(appleMapsUrl));
    } else {
      throw 'Could not launch map';
    }
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    try {
      if (await canLaunchUrl(Uri.parse(launchUri.toString()))) {
        await launchUrl(Uri.parse(launchUri.toString()));
      } else {
        throw 'Could not launch $phoneNumber';
      }
    } catch (e) {
      print('Could not launch $phoneNumber: $e');
      // Handle the error appropriately in your app, for example show a dialog
    }
  }

  void fetchOrders() async {
    var userId = await AmdStorage().readCache('userId');
    print(userId);
    try {
      final response = await networkHandler.get(
        "${ApiConfig.getAllOrdersEndpoint}$userId",
      );
      if (kDebugMode) {
        print('${response.data}');
      }
      if (response.statusCode == 200) {
        List<dynamic> jsonList =
            response.data; // Directly use the response data as a list
        // List<dynamic> jsonList = json.decode(jsonString);
        List<OrderCreationByIdModel> orders = jsonList
            .map((json) => OrderCreationByIdModel.fromJson(json))
            .toList();
        getAllOrders.value = orders;
      }
      // if (response.statusCode == 200) {
      //   if (kDebugMode) {
      //     print('Error: ${response.data}');
      //   }
      //   var jsonString = response.data;
      //   getAllStore.value = ListRestaurant.fromJson(jsonString);
      // }
    } catch (error) {
      // Handle the error
      if (kDebugMode) {
        print('Error: $error');
      }
    }
  }
}
