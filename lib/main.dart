import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(FzMaps());

class FzMaps extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Maps',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: Maps(),
    );
  }
}

class Maps extends StatefulWidget {
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  // Completer<GoogleMapController> _controller = Completer();

  // static const LatLng _center = const LatLng(28.5277474, 77.297967);

  // void _onMapCreated(GoogleMapController controller) {
  //   _controller.complete(controller);
  // }

  GoogleMapController _controller;
  Position position;
  Widget _child;

  @override
  void initState() {
    // TODO: implement initState
    getCurrentLocation();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void getCurrentLocation() async {
    Position res = await Geolocator().getCurrentPosition();
    setState(() {
      position = res;
      _child = mapWidget();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Frazile Maps'),
          centerTitle: true,
        ),
        body: _child,
      );

  Widget mapWidget() => GoogleMap(
        mapType: MapType.normal,
        markers: _createMarker(),
        initialCameraPosition: CameraPosition(
          target: LatLng(
            position.latitude,
            position.longitude,
          ),
          zoom: 12.0,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
      );

  Set<Marker> _createMarker() => <Marker>[
        Marker(
          markerId: MarkerId(
            'Work',
          ),
          position: LatLng(
            position.latitude,
            position.longitude,
          ),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(
            title: 'Work',
          ),
        ),
      ].toSet();
}
