import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

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
    Position res = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    await getSetAddress(Coordinates(res.latitude, res.longitude));
    setState(() {
      position = res;
      _child = mapWidget();
    });
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
