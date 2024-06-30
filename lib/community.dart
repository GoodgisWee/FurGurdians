import 'dart:ffi';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:fur_guardian/EventPage.dart';
import 'package:fur_guardian/main.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CommunityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  LatLng _center = LatLng(4.3085, 101.1537);
  bool _isLoading = true;  // New state variable to track loading
  final Set<Marker> _markers = {};
  final Set<Marker> _petMarkers = {};
  BitmapDescriptor ? customIcon;

  bool showForumBox = true;
  bool showEventBox = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadCustomMarker();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    setState(() {
      _isLoading = true;  // Show loading indicator
    });

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationServicesDialog();
    } else {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          _showPermissionDialog();
        } else {
          _fetchCurrentLocation();
        }
      } else {
        _fetchCurrentLocation();
      }
    }
  }

Future<void> _loadCustomMarker() async {
  customIcon = await BitmapDescriptor.fromAssetImage(
    ImageConfiguration(size: ui.Size(48, 48)),
    'assets/duck.png',
  );

  setState(() {
       _markers.add(Marker(
        markerId: MarkerId('marker_1'),
        position: LatLng(4.3349, 101.1351),
        infoWindow: InfoWindow(
          title: 'My Marker',
          snippet: 'A snippet of information',
        ),
        icon: customIcon!,
      ));
    });
}


  void _addPetMarkers() async {
    
   
  }

  void _fetchCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _center = LatLng(position.latitude, position.longitude);
      
      _markers.add(Marker(
        markerId: MarkerId('marker_1'),
        position: _center,
        infoWindow: InfoWindow(
          title: 'My Marker',
          snippet: 'A snippet of information',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ));
    });

    setState(() {
      _isLoading = false;  // Hide loading indicator
    });
    Fluttertoast.showToast(
        msg: "Successfully got user location: ${position.latitude}",
        toastLength: Toast.LENGTH_SHORT);

    mapController.animateCamera(CameraUpdate.newLatLngZoom(_center, 15.0));
  }

  void _showLocationServicesDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Location Services Disabled'),
              content: Text('Please enable location services on your device.'),
              actions: <Widget>[
                TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await Geolocator.openLocationSettings();
                      _getCurrentLocation(); // Retry getting location after settings
                    },
                    child: Text('Ok'))
              ]);
        });
  }

  void _showPermissionDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Permission Denied'),
              content: Text(
                  'Location permissions are denied. Please enable them in settings.'),
              actions: <Widget>[
                TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await Geolocator.openAppSettings();
                    },
                    child: Text('Open Settings'))
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Google Map'), backgroundColor: Colors.green),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 15,
            ),
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            markers: _markers
          ),
          if (_isLoading)  // Show loading indicator when loading
            Center(
              child: Container(height:100, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Fetching current location...'),
                ],
              ),)
            ),
          Column(
            children: <Widget>[
              buildCustomLabel(Icons.sports_basketball, 'Sports', Colors.red),
              buildCustomLabel(Icons.music_note, 'Music', Colors.blue),
              buildCustomLabel(Icons.dining, 'Food', Colors.green),
              buildCustomLabel(
                  Icons.local_hospital, 'Doctor', Colors.lightBlue),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white),
                      child: IconButton(
                          onPressed: () {
                             mapController.animateCamera(
                                CameraUpdate.newLatLngZoom(_center, 15.0)
                            );
                          },
                          icon: Icon(Icons.location_on),
                          iconSize: 40,
                          color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 10),
                  Visibility(
                      visible: showForumBox,
                      child: Container(
                          padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                          height: 130,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.local_fire_department_sharp,
                                          color: Colors.red),
                                      Text('Hot Question!',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  IconButton(
                                    iconSize: 25,
                                    icon: Icon(Icons.close),
                                    onPressed: () {
                                      setState(
                                        () {
                                          showForumBox = false;
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                              Text(
                                  'In pet’s mind, does pet really understand human language?',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14)),
                              Text(
                                  'Bemond: I don’t think so, because my dog mimi often get scold by me but......',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 10)),
                            ],
                          ))),
                  SizedBox(height: 10),
                  Visibility(
                      visible: showEventBox,
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => EventsPage()));
                        },
                        child: Container(
                        height: 130,
                        padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 130,
                              width: 90,
                              padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcThyIG7c9q0DX9sh0Rx0BMCuNXXy2cC9LFgUA&s',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          'Wed, Apr 28 - 5:30 PM',
                                          style: TextStyle(
                                              color: Colors.purple,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        IconButton(
                                          iconSize: 25,
                                          icon: Icon(Icons.close),
                                          onPressed: () {
                                            setState(() {
                                              showEventBox = false;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    Text(
                                        'BBQ night with your dearest sdsdsdsdsdsdsdsd',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        )),
                                    Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Row(
                                          children: <Widget>[
                                            Icon(Icons.location_city),
                                            Text(
                                                'Radius Gallery • Santa Cruz, CA',
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                      ) 
                      
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCustomLabel(IconData iconData, String label, Color iconColor) {
    return Container(
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        margin: EdgeInsets.fromLTRB(16, 8, 0, 0),
        padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
        child: Row(children: <Widget>[
          Icon(iconData, color: iconColor, size: 20),
          SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          )
        ]));
  }
}
