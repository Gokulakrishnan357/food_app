//
// import 'package:zeroq/const/app_exports.dart';
// import 'package:zeroq/models/restaurant_models/restaurand_by_id_model.dart';
// import 'package:zeroq/models/restaurant_models/restaurant_menu_by_id.dart';
// import 'package:zeroq/server/network_handler.dart';
//
// import '../../../../Model/MenuModel.dart';
//
// // Redux Actions
// class FetchRestaurantByIdAction {
//   final String restaurantId;
//   FetchRestaurantByIdAction(this.restaurantId);
// }
//
// class FetchRestaurantMenuByIdAction {
//   final String restaurantId;
//   FetchRestaurantMenuByIdAction(this.restaurantId);
// }
//
// class SetRestaurantDataAction {
//   final GetRestaurantsById restaurantData;
//   SetRestaurantDataAction(this.restaurantData);
// }
//
// class SetRestaurantMenuAction {
//   final GetRestaurantMenuById menuData;
//   SetRestaurantMenuAction(this.menuData);
// }
//
// // Redux Reducers
// GetRestaurantsById restaurantReducer(GetRestaurantsById state, dynamic action) {
//   if (action is SetRestaurantDataAction) {
//     return action.restaurantData;
//   }
//   return state;
// }
//
// GetRestaurantMenuById menuReducer(GetRestaurantMenuById state, dynamic action) {
//   if (action is SetRestaurantMenuAction) {
//     return action.menuData;
//   }
//   return state;
// }
//
// // Redux Store State
// class AppState {
//   final GetRestaurantsById restaurant;
//   final GetRestaurantMenuById menu;
//
//   AppState({
//     required this.restaurant,
//     required this.menu,
//   });
// }
//
// AppState appReducer(AppState state, dynamic action) {
//   return AppState(
//     restaurant: restaurantReducer(state.restaurant, action),
//     menu: menuReducer(state.menu, action),
//   );
// }
//
// // Middleware
// void fetchRestaurantData(Store<AppState> store, FetchRestaurantByIdAction action, NextDispatcher next) async {
//   try {
//     if (action.restaurantId == "0") return;
//     final response = await GraphQLClientService.fetchData(
//       query: GraphQuery.queryRestaurantById(action.restaurantId),
//     );
//     if (response.data != null && response.data!['restaurants'] is List) {
//       store.dispatch(SetRestaurantDataAction(GetRestaurantsById.fromList(response.data!['restaurants'])));
//     }
//   } catch (error) {
//     print('Error fetching restaurant data: $error');
//   }
// }
//
// void fetchRestaurantMenu(Store<AppState> store, FetchRestaurantMenuByIdAction action, NextDispatcher next) async {
//   try {
//     if (action.restaurantId == "0") return;
//     final response = await GraphQLClientService.fetchData(
//       query: GraphQuery.getRestaurantMenuById(action.restaurantId),
//     );
//     if (response.data != null && response.data!['restaurants'] is List) {
//       store.dispatch(SetRestaurantMenuAction(GetRestaurantMenuById.fromMap(response.data!['restaurants'])));
//     }
//   } catch (error) {
//     print('Error fetching menu data: $error');
//   }
// }
//
// final store = Store<AppState>(
//   appReducer,
//   initialState: AppState(
//     restaurant: GetRestaurantsById(),
//     menu: GetRestaurantMenuById(),
//   ),
//   middleware: [
//     fetchRestaurantData,
//     fetchRestaurantMenu,
//   ],
// );
