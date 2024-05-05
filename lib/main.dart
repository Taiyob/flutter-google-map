import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Map(),
    );
  }
}

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  Position? position;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _onScreenStart();
    _listenCurrentLocation();
  }

  Future<void> _onScreenStart() async{
    bool isEnabled = await Geolocator.isLocationServiceEnabled();
    print(isEnabled);

    print(await Geolocator.getLastKnownPosition(),);

    LocationPermission permission = await  Geolocator.checkPermission();
    if(permission == LocationPermission.whileInUse || permission == LocationPermission.always){
      position =  await Geolocator.getCurrentPosition();
      print(position);
    }else{
      LocationPermission requestPermission = await Geolocator.requestPermission();
      if(requestPermission == LocationPermission.whileInUse || requestPermission == LocationPermission.always){
        _onScreenStart();
      }else{
        print('Permission Denied');
      }
    }
  }

  void _listenCurrentLocation() {
    Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 1,
        timeLimit: Duration(seconds: 3),
      )
    ).listen((event) {print(event);});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      //body: GoogleMap(zoomControlsEnabled:true, initialCameraPosition: CameraPosition(target: LatLng(23.79216364422902, 90.38867408028997),),),
      body: Center(child: Text('Current Location ${position?.latitude}, ${position?.longitude}'),),
    );
  }
}


