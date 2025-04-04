// ignore: file_names
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:zeroq/Model/RestaurantModel.dart';

class GraphQLService {
  final String _graphqlEndpoint =
      "https://clicknpickapi.crestclimbers.com/graphql/";

  HttpLink get httpLink => HttpLink(_graphqlEndpoint);

  Future<List<Restaurant>> fetchRestaurants() async {
    final GraphQLClient client = GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(),
    );

    const String query = """
    query {
      restaurants(input: { searchText: "" }) {
        restaurantName
        restaurantId
        cuisineTypes {
          cuisineTypeId
          name
        }
        categories {
          menus {
            name
            menuId
            preparationTime
          }
        }
        imageUrl
        logo
        minimumLimitofPerPerson
        averageRating
        selfPickUpAvailbale
        deliveryAvailable
        branches {
          longitude
          latitude
          locality
          city
        }
      }
    }
    """;

    final QueryResult result =
        await client.query(QueryOptions(document: gql(query)));

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final List<dynamic> data = result.data!["restaurants"];
    return data.map((json) => Restaurant.fromJson(json)).toList();
  }
}
