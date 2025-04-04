import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../pick_up/pick_up_controller.dart';

const String googleApiKey = "AIzaSyDxV3x0-Ra1FsFY2m2wPPwEbGAPNDbSSEQ";

class LiveLocationMap extends StatefulWidget {
  final LatLng initialLocation;

  const LiveLocationMap({super.key, required this.initialLocation});

  @override
  LiveLocationMapState createState() => LiveLocationMapState();
}

class LiveLocationMapState extends State<LiveLocationMap> {
  GoogleMapController? _controller;
  LatLng? _selectedLocation;
  String _currentAddress = "Fetching address...";
  bool _isLoading = true;
  LatLng? _currentLatLng;
  Placemark? _currentPlacemark;
  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  final Set<Marker> _markers = {};

  RxString latitude = 'Getting Latitude...'.obs;
  RxString longitude = 'Getting Longitude...'.obs;
  RxString currentAddress = 'Getting Address...'.obs;
  RxString currentCity = 'Getting City...'.obs;
  RxString formattedAddress = 'Getting City...'.obs;

  final PickUpController controller = Get.put(PickUpController());

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _isLoading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      LatLng currentLatLng = LatLng(position.latitude, position.longitude);

      setState(() {
        _currentLatLng = currentLatLng;
        _selectedLocation = currentLatLng;
        _isLoading = false;
      });

      _updateLocation(currentLatLng);

      _controller?.animateCamera(CameraUpdate.newLatLngZoom(currentLatLng, 17));
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateLocation(LatLng latLng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );

      if (placemarks.isNotEmpty) {
        _currentPlacemark = placemarks.first;

        setState(() {
          _selectedLocation = latLng;
          _currentAddress =
              "${_currentPlacemark?.name ?? ''}, ${_currentPlacemark?.thoroughfare ?? ''}, "
              "${_currentPlacemark?.subLocality ?? ''}, ${_currentPlacemark?.locality ?? ''}, "
              "${_currentPlacemark?.postalCode ?? ''} ${_currentPlacemark?.administrativeArea ?? ''}";
          _markers.clear();
          _markers.add(
            Marker(markerId: const MarkerId('selected'), position: latLng),
          );
        });
      }
    } catch (e) {
      debugPrint('Failed to get address: $e');
    }
  }

  void _confirmLocation() {
    if (_selectedLocation != null && _currentPlacemark != null) {
      double selectedLat = _selectedLocation!.latitude;
      double selectedLon = _selectedLocation!.longitude;

      // Update formattedAddress in the controller
      controller.formattedAddress.value =
          "${_currentPlacemark?.subLocality ?? ''}, ${_currentPlacemark?.locality ?? ''}";

      // Update other location values
      controller.latitude.value = selectedLat.toString();
      controller.longitude.value = selectedLon.toString();
      controller.currentCity.value =
          _currentPlacemark?.locality ?? 'Unknown City';

      // Debugging logs
      if (kDebugMode) {
        print("✅ Location Confirmed: ${controller.formattedAddress.value}");
        print("📍 Lat: $selectedLat, Lon: $selectedLon");
      }

      // Fetch restaurants near the selected location
      controller.fetchSearchRestaurantsFromGraph(
        newLat: selectedLat,
        newLon: selectedLon,
      );

      // Pass data back to previous screen
      Navigator.pop(context, {
        'city': controller.currentCity.value,
        'address': controller.formattedAddress.value,
        'latitude': selectedLat.toString(),
        'longitude': selectedLon.toString(),
      });
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchLocation(query);
    });
  }

  Future<void> _searchLocation(String query) async {
    if (query.isEmpty) {
      setState(() => _searchResults.clear());
      return;
    }

    final url = Uri.parse(
      "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$googleApiKey",
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "OK") {
        setState(() => _searchResults = data["predictions"]);
      }
    }
  }

  Future<void> _getPlaceDetails(String placeId) async {
    final url = Uri.parse(
      "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleApiKey",
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "OK") {
        final location = data["result"]["geometry"]["location"];
        LatLng newLocation = LatLng(location["lat"], location["lng"]);

        setState(() {
          _selectedLocation = newLocation;
        });

        _updateLocation(newLocation);
        _controller?.animateCamera(CameraUpdate.newLatLngZoom(newLocation, 17));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(FontAwesomeIcons.chevronLeft, color: Colors.green),
        ),
        title: const Text("Select Location"),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.green),
            onPressed: _confirmLocation,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _searchController,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF4F4F4),
                    hintText: "Search your location",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(
                        color: Color(0xFF58B01F), // Default border color
                        width: 2.0, // Border width
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(
                        color: Color(0xFF58B01F), // Border color when not focused
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(
                        color: Color(0xFF58B01F), // Border color when focused
                        width: 2.0,
                      ),
                    ),
                  ),
                  onChanged: _onSearchChanged,
                ),

                if (_searchResults.isNotEmpty)
                  Container(
                    height: 200,
                    color: Colors.white,
                    child: ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_searchResults[index]["description"]),
                          onTap: () {
                            _getPlaceDetails(_searchResults[index]["place_id"]);
                            setState(() => _searchResults.clear());
                            FocusScope.of(context).unfocus();
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: widget.initialLocation,
                zoom: 15,
              ),
              onMapCreated: (controller) => _controller = controller,
              markers: _markers,
              onTap: _updateLocation,
            ),
          ),
        ],
      ),
    );
  }
}
