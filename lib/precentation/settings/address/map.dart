import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zeroq/const/app_colors.dart';

class MapScreen extends StatefulWidget {
  final LatLng initialLocation;

  const MapScreen({super.key, required this.initialLocation});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  LatLng? _selectedLocation;
  String _currentAddress = "Fetching address...";
  bool _isLoading = true;
  LatLng? _currentLatLng; // Store user location
  Placemark? _currentPlacemark;

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
          latLng.latitude, latLng.longitude
      );

      if (placemarks.isNotEmpty) {
        _currentPlacemark = placemarks.first;

        setState(() {
          _selectedLocation = latLng;
          _currentAddress =
          " ${_currentPlacemark?.name ?? ''},${_currentPlacemark?.thoroughfare ?? ''}, "
              "${_currentPlacemark?.subLocality ?? ''}, ${_currentPlacemark?.locality ?? ''}, "
              "${_currentPlacemark?.postalCode ?? ''} ${_currentPlacemark?.administrativeArea ?? ''},";
        });

        debugPrint('Placemark: $_currentPlacemark');
        debugPrint('Address: $_currentAddress');
      }
    } catch (e) {
      debugPrint('Failed to get address: $e');
    }
  }

  void _confirmLocation() {
    if (_selectedLocation != null && _currentPlacemark != null) {
      Navigator.pop(context, {
        'address': _currentAddress,
        'houseNumber': _currentPlacemark?.name ?? '',
        'street': _currentPlacemark?.thoroughfare ?? '',
        'landmark': _currentPlacemark?.thoroughfare ?? '',
        'locality': _currentPlacemark?.subLocality ?? '',
        'city': _currentPlacemark?.locality ?? '',
        'state': _currentPlacemark?.administrativeArea ?? '',
        'postalCode': _currentPlacemark?.postalCode ?? '',
        'latitude': _selectedLocation!.latitude.toString(),
        'longitude': _selectedLocation!.longitude.toString(),
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            FontAwesomeIcons.chevronLeft,
            color: AppColors.greenColor,
          ),
        ),
        title: const Text("Select Location"),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: AppColors.greenColor),
            onPressed: _confirmLocation, // ✅ Use the method directly here
          ),
        ],

      ),
      body: Stack(
        children: [
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentLatLng ?? widget.initialLocation,
              zoom: 15,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
              if (_currentLatLng != null) {
                _controller!.animateCamera(
                  CameraUpdate.newLatLngZoom(_currentLatLng!, 17),
                );
              }
            },
            markers: _selectedLocation != null
                ? {
              Marker(
                markerId: const MarkerId('selected-location'),
                position: _selectedLocation!,
              ),
            }
                : {},
            onTap: (LatLng latLng) {
              _updateLocation(latLng);
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),

          // Floating Action Button Positioned at Bottom Left
          Positioned(
            bottom: 20,
            left: MediaQuery.of(context).size.width / 1.5,
            child: FloatingActionButton(
              onPressed: _getUserLocation,
              backgroundColor: AppColors.greenColor,
              child: const Icon(Icons.my_location, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}