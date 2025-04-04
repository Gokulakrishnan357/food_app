import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:zeroq/models/dine_in/restaurant_model.dart';
import 'package:zeroq/server/app_storage.dart';

class AppNetworkHandler {
  late Dio _dio;
  final String baseUrl = "https://clicknpickapi.crestclimbers.com/graphql/";

  AppNetworkHandler() {
    _dio = Dio();
    // _dio.options.headers[HttpHeaders.authorizationHeader] = 'Bearer $tokens';
    // _dio.interceptors.add(LogInterceptor(
    //     requestBody: false,
    //     responseBody: false,
    //     request: false,
    //     responseHeader: false,
    //     requestHeader: false,
    //     error: true));
  }
  Future<Response> get(
    String path,
  ) async {
    try {
      final response = await _dio.get(
        path,
        options: Options(
            followRedirects: false,
            validateStatus: (status) => true,
            headers: {
              // 'Authorization': token,
              "accept": "text/plain"
            }),
      );
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error in GET request: $e');
      }
      rethrow;
    }
  }

  Future<Response> post(String url, dynamic data) async {
    try {
      var authToken = await AmdStorage().readCache('token');
      // print(authToken);
      final response = await _dio.post(url,
          options: Options(
            followRedirects: false,
            validateStatus: (status) => true,
            headers: {
              'Authorization': 'Bearer $authToken',
            },
          ),
          data: data);
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error in POST request: $e');
      }
      rethrow;
    }
  }

  Future<Restaurant?> getRestaurantDataByName(String restaurantName) async {
    final String query = """
      query {
        restaurantByFliter(name: "$restaurantName") {
          restaurantId
          restaurantName
          description
          image
          restaurantBannerImage
          rating
          latitude
          longitude
          distance
        }
      }
    """;

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({"query": query}),
    );

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      if (jsonData['data'] != null &&
          jsonData['data']['restaurantByFliter'] != null) {
        return Restaurant.fromJson(jsonData['data']['restaurantByFliter']);
      }
    } else {
      throw Exception("Failed to load restaurant data");
    }
    return null;
  }


  // Future<Response> put(String url, dynamic data) async {
  //   try {
  //     var authToken = await AmdStorage().readCache('token');
  //     return await _dio.put(url,
  //         options: Options(
  //             followRedirects: false,
  //             validateStatus: (status) => true,
  //             headers: {
  //               'Authorization': 'Bearer $authToken',
  //             }),
  //         data: data);
  //   } catch (e) {
  //     throw _handleError(e);
  //   }
  // }
  // // Future<Response> put(String path, {Map<String, dynamic>? data}) async {
  // //   try {
  // //     final response = await _dio.put(path, data: data);
  // //     return response;
  // //   } catch (e) {
  // //     if (kDebugMode) {
  // //       print('Error in PUT request: $e');
  // //     }
  // //     rethrow;
  // //   }
  // // }

  // Future<Response> delete(
  //   String url,
  // ) async {
  //   try {
  //     var authToken = await AmdStorage().readCache('token');
  //     return await _dio.delete(
  //       url,
  //       options: Options(
  //           followRedirects: false,
  //           validateStatus: (status) => true,
  //           headers: {
  //             'Authorization': 'Bearer $authToken',
  //           }),
  //     );
  //   } catch (e) {
  //     throw _handleError(e);
  //   }
  // }

  // // Future<Response> delete(String path) async {
  // //   try {
  // //     final response = await _dio.delete(path);
  // //     return response;
  // //   } catch (e) {
  // //     if (kDebugMode) {
  // //       print('Error in DELETE request: $e');
  // //     }
  // //     rethrow;
  // //   }
  // // }
  // Future<Response> uploadImage(String url, String filePath) async {
  //   try {
  //     var authToken = await AmdStorage().readCache('token');
  //     FormData formData = FormData.fromMap({
  //       'image': await MultipartFile.fromFile(filePath, filename: 'image.jpg'),
  //     });

  //     final response = await _dio.post(
  //       url,
  //       options: Options(
  //         followRedirects: false,
  //         validateStatus: (status) => true,
  //         headers: {
  //           'Authorization': 'Bearer $authToken',
  //         },
  //       ),
  //       data: formData,
  //     );
  //     return response;
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Error in POST request: $e');
  //     }
  //     rethrow;
  //   }
  // }
}

