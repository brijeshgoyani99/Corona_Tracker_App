import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../constant.dart';
import 'dart:async';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();
  int inc;
  @override
  void initState() {
    super.initState();
    GetLocation();
    inc = 0;
  }

  @override
  void dispose() {
    super.dispose();
    
  }

  //for getting current location----------------------------
  Position currentLocation;
  var patients = [];
  bool mapToggle = false;
  GoogleMapController mapController;

  // void getlocation() async {
  //   Geolocator()
  //       .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
  //       .then((value) {
  //     setState(() {
  //       currentlocation = value;
  //       mapToggle = true;
  //       print(currentlocation);
  //       fetchPatients();
  //     });
  //   });
  // }

  fetchPatients() {
    patients = [];

    FirebaseFirestore.instance
        .collection('marker_position')
        .get()
        .then((docs) {
      if (docs.docs.isNotEmpty) {
        print(docs.docs);
        for (int i = 0; i < docs.docs.length; i++) {
          print(docs.docs[i]);
          patients.add(docs.docs[i]);
          initMarker(docs.docs[i]);
        }
      }
    });
  }

  GetLocation() async {
Position value =  await  Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
     setState(() {
       currentLocation = value;
     });
    fetchPatients();
    setState(() {
      mapToggle = true;
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId("curr_loc"),
          position: LatLng(currentLocation.latitude, currentLocation.longitude),
          infoWindow: InfoWindow(title: 'Your Location'),
        ),
      );
      //  print(_markers);
    });

    print(currentLocation);
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 17.0,
        tilt: 45,
      ),
    ));
  }

  final List<Marker> _markers = [];

  initMarker(patients) {
    inc ++;
    setState(() {
      _markers.add(
        Marker(
            markerId: MarkerId(inc.toString()),
            position: LatLng(
                patients['position'].latitude, patients['position'].longitude),
            infoWindow: InfoWindow(title: patients['name'])),
            
            
      );
    });
    
  }
//

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kAppBarHeadingColor,
          title: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "Corona Tracker".toUpperCase(),
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
          ),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: mapToggle
                  ? GoogleMap(
                      mapType: MapType.hybrid,
                      initialCameraPosition: CameraPosition(
                        target :
                        LatLng(currentLocation.latitude,
                            currentLocation.longitude),
                        zoom: 14.4746,
                        tilt: 45,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        setState(() {
                           _controller.complete(controller);
                        });
                      },
                      myLocationEnabled: true,
                      markers: _markers.toSet(),
                    )
                  : Text("Loading Please waitt.........."),
            ),
            FloatingActionButton.extended(
              onPressed: GetLocation,
              label: Text('My Location'),
              icon: Icon(Icons.location_on),
            ),
          ],
        ),
      ),
    );
  }





}
