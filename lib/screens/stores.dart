import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../utils/common.dart';
import '/components/custom_button.dart';
import '/utils/application_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:ui' as ui;

class StoresScreen extends StatefulWidget {
  const StoresScreen({Key? key}) : super(key: key);

  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        Container(
            child:  Text(
          'officedllocations'.tr,
              textAlign: ui.TextAlign.center,
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25.0),
        )),
        const SizedBox(
          height: 20,
        ),
        Container(
            child:  Text(
              'zoominmap'.tr,
              textAlign: ui.TextAlign.center,
              style: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0),
            )),
        const SizedBox(
          height: 10,
        ),
        const SizedBox(
          height: 450,
          child: MapScreen(),
        ),
      ],
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // created controller for displaying Google Maps
  Completer<GoogleMapController> _controller = Completer();
  Completer<GoogleMapController> mapController= Completer();
  final Set<Marker> markers = new Set(); //markers for google map
  static const LatLng showLocation = const LatLng(40.006097188553326, -83.12867346237141); //location to show in map
  Uint8List? marketimages;
  List<String> images = [
    'images/car.png',
    'images/bus.png',
    'images/travelling.png',
    'images/bycicle.png',
    'images/food-delivery.png'
  ];

  // created empty list of markers
  final List<Marker> _markers = <Marker>[];

  // created list of coordinates of various locations
  final List<LatLng> _latLen = <LatLng>[
    LatLng(19.0759837, 72.8776559),
    LatLng(28.679079, 77.069710),
    LatLng(26.850000, 80.949997),
    LatLng(24.879999, 74.629997),
    LatLng(16.166700, 74.833298),
    LatLng(12.971599, 77.594563),
  ];

  // declared method to get Images
  Future<Uint8List> getImages(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // initialize loadData method
    loadData();
  }

  // created method for displaying custom markers according to index
  loadData() async {
    for (int i = 0; i < images.length; i++) {
      final Uint8List markIcons = await getImages(images[i], 100);
      // makers added according to index
      _markers.add(Marker(
        // given marker id
        markerId: MarkerId(i.toString()),
        // given marker icon
        icon: BitmapDescriptor.fromBytes(markIcons),
        // given position
        position: _latLen[i],
        infoWindow: InfoWindow(
          // given title for marker
          title: 'Location: ' + i.toString(),
        ),
      ));
      setState(() {});
    }
  }

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(19.0759837, 72.8776559),
    zoom: 15,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
        initialCameraPosition: const CameraPosition( //innital position in map
                      target: showLocation, //initial position
                      zoom: 3.0, //initial zoom level
                    ),
        markers: getmarkers(),
        onMapCreated: (GoogleMapController controller){
                _controller.complete(controller);
            },
      ),
    );
  }

  Set<Marker> getmarkers() { //markers to place on map
    setState(() {
      markers.add(Marker( //add first marker
        markerId: MarkerId(showLocation.toString()),
        position: showLocation, //position of marker
        infoWindow: const InfoWindow( //popup info 
          title: 'Wilsonart',
          snippet: '2500 International St, Columbus, OH 43228, United States',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

      markers.add(Marker( //add second marker
        markerId: MarkerId(showLocation.toString()),
        position: const LatLng(40.750273709463784, -73.48765488627795), //position of marker
        infoWindow: const InfoWindow( //popup info 
          title: 'Wilsonart',
          snippet: '11 Twosome Dr, Moorestown, NJ 08057, United States',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

      markers.add(Marker( //add third marker
        markerId: MarkerId(showLocation.toString()),
        position: const LatLng(39.95021936378007, -74.90500392984201), //position of marker
        infoWindow: const InfoWindow( //popup info 
          title: 'Wilsonart',
          snippet: '999 S Oyster Bay Rd, Bethpage, NY 11714, United States',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));


      markers.add(Marker( //add third marker
        markerId: MarkerId(showLocation.toString()),
        position: const LatLng(43.62278007969104, -79.68932002031876), //position of marker
        infoWindow: const InfoWindow( //popup info
          title: 'Wilsonart',
          snippet: 'J8F3+3V Mississauga, Ontario, Canada',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

      markers.add(Marker( //add third marker
        markerId: MarkerId(showLocation.toString()),
        position: const LatLng(29.77992165033735, -95.29047260459579), //position of marker
        infoWindow: const InfoWindow( //popup info
          title: 'Wilsonart',
          snippet: '552 Garden Oaks Blvd, Houston, TX 77018, United States',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

      markers.add(Marker( //add third marker
        markerId: MarkerId(showLocation.toString()),
        position: const LatLng(32.78385730768931, -96.78461318439064), //position of marker
        infoWindow: const InfoWindow( //popup info
          title: 'Wilsonart',
          snippet: '4051 La Reunion Pkwy #140, Dallas, TX 75212, United States',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

      markers.add(Marker( //add third marker
        markerId: MarkerId(showLocation.toString()),
        position: const LatLng(25.79222628856615, -80.29742006050441), //position of marker
        infoWindow: const InfoWindow( //popup info
          title: 'Wilsonart',
          snippet: '1331 NW 82nd Ave, Miami, FL 33126, United States',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

      markers.add(Marker( //add third marker
        markerId: MarkerId(showLocation.toString()),
        position: const LatLng(33.37180822958461, -111.93435110065782), //position of marker
        infoWindow: const InfoWindow( //popup info
          title: 'Wilsonart',
          snippet: '5333 S Kyrene Rd #103, Tempe, AZ 85283, United States',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

       //add more markers here 
    });

    return markers;
  }

}
