import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(MyApp());
}

//TODO: add icon type property, increase severity range from 1-5, incorporate risk hours/days into marker description

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //list of temp markers for user choice
  List <Marker> myMarker = [];
  //list of all created markers
  List <Marker> allMarkers = [];
  //marker properties
  var markerCount = 0;
  var descriptionInput = 'example description';
  var severity = 1;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          mapType: MapType.hybrid,
          initialCameraPosition: CameraPosition(
            target: const LatLng(40, -74),
            zoom: 6,
          ),
          markers: Set.from(allMarkers),
          onTap: _handleTap,
        ),
      )
    );
  }

  _handleTap(LatLng tappedPoint) {
    markerCount += 1;
    var markerHue = _setHueColor();
    LatLng pos = tappedPoint;
    print(pos);
    setState(() {
      myMarker = [];
      Marker curPin = Marker(
        markerId: MarkerId(markerCount.toString()),
        draggable: true,
        onDragEnd: (dragEndPosition) {
          pos = dragEndPosition;
          print(pos);
        },
        infoWindow: InfoWindow(
          title: 'Test Title',
          snippet: descriptionInput,
        ),
        position: pos,
        icon: markerHue,
      );
      myMarker.add(curPin);
      allMarkers.add(curPin);
    });
  }

  _setHueColor() {
    if(severity == 1) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
    } else if (severity == 2) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
    } else if (severity == 3) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    }
  }
}