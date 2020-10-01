import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  // GoogleMap.init('AIzaSyB8iXVlMJLUZK3Y25vgI5M0zBOm3m0LqaE');
  WidgetsFlutterBinding.ensureInitialized();
  runApp(FzMaps());
}

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
  Widget _child = Container();
  String _resultAddress = '';

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getCurrentLocation() async {
    var isGpsEnabled = await Geolocator().isLocationServiceEnabled();
    print('isGPSEnabled = ' + isGpsEnabled.toString());
    if (isGpsEnabled) {
      Position res = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      await getSetAddress(Coordinates(res.latitude, res.longitude));
      setState(() {
        position = res;
        _child = mapWidget();
      });
    } else {
      _checkGps();
    }
  }

  /*Show dialog if GPS not enabled and open settings location*/
  Future _checkGps() async {
    if (!(await Geolocator().isLocationServiceEnabled())) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Can't get gurrent location"),
                content:
                    const Text('Please make sure you enable GPS and try again'),
                actions: <Widget>[
                  FlatButton(
                      child: Text('OK'),
                      onPressed: () {
                        final AndroidIntent intent = AndroidIntent(
                            action:
                                'android.settings.LOCATION_SOURCE_SETTINGS');
                        intent.launch();
                        Navigator.of(context, rootNavigator: true).pop();
                        getCurrentLocation();
                      })
                ],
              );
            });
      }
    }
  }

  getSetAddress(Coordinates coordinates) async {
    final addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      _resultAddress = addresses.first.addressLine;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Frazile Maps'),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            _child,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * .99,
                height: MediaQuery.of(context).size.height * .12,
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(
                    10.0,
                  ),
                ),
                child: Text(
                  _resultAddress,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.courierPrime(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget mapWidget() => GoogleMap(
        mapType: MapType.normal,
        markers: _createMarker(),
        initialCameraPosition: CameraPosition(
          target: LatLng(
            position.latitude,
            position.longitude,
          ),
          zoom: 17.0,
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
