import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(MyApp());
}

//TODO: add icon type property(dependent on risk type)

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var riskDescriptions = {1 :'Large Group: ', 2 :'No Masks', 3 : 'Other: '};
  //list of temp markers for user choice
  List <Marker> myMarker = [];
  //list of all created markers
  List <Marker> allMarkers = [];
  //marker properties
  var markerCount = 0;
  var descriptionInput = 'example description';
  //int from 1-5
  var severity = 1;
  var riskHours = '4pm';
  var riskDays = 'January 16th';
  //
  var riskType = 1;

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
    var risk = riskDescriptions[riskType];
    var description = riskHours + ' on ' + riskDays + ' : ' + descriptionInput;
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
          title: risk,
          snippet: description,
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
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    } else if (severity == 2) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    } else if (severity == 3) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
    } else if (severity == 4) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
    } else if (severity == 5) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    }
  }
}