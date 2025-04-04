import 'dart:async';
import 'dart:io';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/io_client.dart';
import 'graph_query.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class GraphQLClientService {
  static String url = GraphQuery.graphClient;

  /// Bypass SSL verification (Only if required, not recommended for production)
  static IOClient _bypassSSLVerificationHttpClient() {
    final iOClient = HttpClient();
    iOClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return IOClient(iOClient);
  }

  /// Fetch Data with Retry and Exponential Backoff
  static Future<QueryResult> fetchData({
    required String query,
    Map<String, dynamic>? variables,
    Duration timeout = const Duration(seconds: 3),
    int maxRetries = 3,
    Map<String, http.MultipartFile>? file,
  }) async {
    final HttpLink httpLink = HttpLink(
      url,
      httpClient: _bypassSSLVerificationHttpClient(),
    );

    final GraphQLClient client = GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: InMemoryStore()),
    );

    final QueryOptions options = QueryOptions(
      document: gql(query),
      variables: variables ?? {},
      fetchPolicy: FetchPolicy.networkOnly,
    );

    int attempt = 0;
    while (attempt < maxRetries) {
      try {
        attempt++;
        debugPrint("📡 Attempt $attempt: Sending GraphQL request...");

        final QueryResult result = await client.query(options).timeout(timeout);

        if (result.hasException) {
          debugPrint("❌ GraphQL Error: ${result.exception}");

          if (result.exception?.graphqlErrors.isNotEmpty ?? false) {
            debugPrint(
              "🛑 GraphQL Error Details: ${result.exception!.graphqlErrors}",
            );
          }

          throw Exception('GraphQL Error: ${result.exception.toString()}');
        }

        debugPrint("✅ GraphQL Request Successful: ${result.data}");
        return result;
      } catch (e) {
        if (attempt >= maxRetries) {
          debugPrint("⛔ GraphQL Request Failed after $maxRetries retries: $e");
          throw Exception('GraphQL Request Failed: $e');
        }

        int delaySeconds = 2 * attempt; // Exponential backoff
        debugPrint("🔄 Retrying GraphQL request in $delaySeconds seconds...");

        await Future.delayed(Duration(seconds: delaySeconds));
      }
    }

    throw Exception('GraphQL Request Failed: Unknown error');
  }

  /// 🛠 **File Upload Handling**
  static Future<dynamic> uploadFile({
    required String query,
    required Map<String, dynamic> variables,
    required Map<String, http.MultipartFile> files,
  }) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // ✅ Add GraphQL query and variables
    request.fields['operations'] = json.encode({
      'query': query,
      'variables': variables,
    });

    // ✅ Map file key to index in the request
    request.fields['map'] = json.encode(
      files.map((key, value) => MapEntry(key, ['0'])),
    );

    // ✅ Add files to request
    files.forEach((key, value) {
      request.files.add(value);
    });

    debugPrint('📤 Uploading file...');
    debugPrint('➡️ Query: $query');
    debugPrint('➡️ Variables: $variables');
    debugPrint('➡️ Files: ${files.keys}');

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        debugPrint('✅ Upload Successful: $responseData');
        return json.decode(responseData);
      } else {
        debugPrint('❌ Failed to send request: ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      debugPrint('❌ Error sending request: $e');
      return null;
    }
  }
}
