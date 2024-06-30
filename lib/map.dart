import 'package:flutter/material.dart';
import 'package:fur_guardian/community.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;

  LatLng _center = LatLng(4.3085, 101.1537);
  bool _locationObtained = false; // Flag to track if location is obtained

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _goToUserLocation() async {
    if (!_locationObtained) {
      // If location is not obtained yet, return
      return;
    }

    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(
        _center,
        15.0,
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationAlertDialog();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      _showLocationPermissionSettingsAlertDialog();
      return;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      setState(() {
        _locationObtained =
            false; // Set flag to false before obtaining location
      });

      // Show loading indicator while obtaining location
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent dialog from being dismissed
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Getting Location"),
            content: CircularProgressIndicator(),
          );
        },
      );

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _center = LatLng(position.latitude, position.longitude);
        _locationObtained = true; // Set flag to true once location is obtained
      });

      // Close the loading indicator dialog
      Navigator.of(context).pop();

      _showSuccessGetLocationDialog(position);

      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          _center,
          15.0,
        ),
      );
    }
  }

  void _showSuccessGetLocationDialog(Position position) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("User Location Get"),
          content: Text(
              "Latitude: ${position.latitude} Longitude: ${position.longitude}"),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showLocationAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location Services Disabled'),
          content: Text('Please enable location services on your device.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showLocationPermissionSettingsAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location Permission Denied'),
          content: Text(
              'Please enable location access permission in your device settings.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => MapPage()));
            }
          },
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 15.0,
            ),
          ),
          Positioned(
            bottom: 16.0,
            left: 16.0,
            child: FloatingActionButton(
              onPressed: _goToUserLocation,
              child: Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MapPage(),
  ));
}
