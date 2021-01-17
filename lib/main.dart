import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

//TODO: add icon type property(dependent on risk type)

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
  //int from 1-5
  int severity = 1;
  var button = false;

  String sevInput = '';
  String descriptionInput = '';
  String riskTime = '';

  createAlert(BuildContext context) {
    TextEditingController rangeControl = TextEditingController();
    TextEditingController descControl = TextEditingController();
    TextEditingController timeControl = TextEditingController();

    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('Report Information'),
        content: Form(
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: rangeControl,
                decoration: const InputDecoration(
                  hintText: 'Risk Range',
                ),
              ),
              TextFormField(
                controller: descControl,
                decoration: const InputDecoration(
                  hintText: 'Description',
                ),
              ),
              TextFormField(
                controller: timeControl,
                decoration: const InputDecoration(
                  hintText: 'Time reported',
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          MaterialButton(
            elevation: 10.0,
            child: Text('Select location'),
            onPressed: (){
              setState(() {
                sevInput = rangeControl.text;
                descriptionInput = descControl.text;
                riskTime = timeControl.text;
                severity = int.parse(sevInput);
                print('INPUT');
                print(sevInput);
                print(descriptionInput);
                print(riskTime);
                Navigator.of(context).pop();
              });
            },
          )
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Covid Spy'),
          backgroundColor: Colors.lightBlueAccent,
        ),
        body:
         Stack(
           children: [
             GoogleMap(
               mapType: MapType.hybrid,
               initialCameraPosition: CameraPosition(
                 target: const LatLng(40.7128, -74.0060),
                 zoom: 13,
               ),
               markers: Set.from(_setMarkers()),
               onTap: _handleTap,
             ),
             FloatingActionButton(onPressed: () {
               createAlert(context);
               button = true;
               print('button val: ' + button.toString());
             },
               elevation: 50,
               child: Icon(Icons.add),
             ),
           ],
         )
      )
    );
  }

  _setMarkers() {
    if(button){
      myMarker = [];
      return myMarker;
    } else {
      return allMarkers;
    }
  }

  _handleTap(LatLng tappedPoint) {
    markerCount += 1;
    var markerHue = _setHueColor();
    var description = riskTime + ' : ' + descriptionInput;
    LatLng pos = tappedPoint;
    if(button){
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
            title: 'Severity : ' + sevInput,
            snippet: description,
          ),
          position: pos,
          icon: markerHue,
        );
        allMarkers.add(curPin);
        button = false;
        print('button val: ' + button.toString());
      });
    }
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