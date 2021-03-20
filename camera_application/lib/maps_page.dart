import 'dart:async';

import 'package:camera_application/mbtiles_image_provider.dart';
import 'package:camera_application/state/application_state.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';
import 'main.dart';

class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  ApplicationState applicationState = null;
  StreamSubscription subscription = null;
  MapController _mapController;
  List<Marker> marketList = [];

  @override
  void initState() {
    super.initState();

    subscription = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          applicationState.isInternetAvailable = true;
          print('Data connection is available.');
          break;
        case DataConnectionStatus.disconnected:
          applicationState.isInternetAvailable = false;
          print('You are disconnected from the internet.');
          break;
      }
    });
  }

  @override
  dispose() {
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    applicationState = Provider.of<ApplicationState>(context);

    return Scaffold(
      appBar: AppBar(
          title: Text('Map'),
          elevation: 24.0,
          centerTitle: true,
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.logout),
              onPressed: () {
                _showDialog(context);
              },
            ),
          ]),
      body: Consumer<ApplicationState>(builder: (context, provider, child) {

        marketList = provider.marketList;
        
        marketList.clear();
        marketList.add(createMarker(LatLng(25.197525, 55.274288)));
        marketList.add(createMarker(LatLng(24.413, 54.4745)));

        if (provider.isInternetAvailable) {
          return FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: LatLng(25.197525, 55.274288),
              swPanBoundary: LatLng(24.1156, 54.0067),
              nePanBoundary: LatLng(25.8603, 55.8446),
              zoom: 12.0,
            ),
            layers: [
              TileLayerOptions(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c']
              ),MarkerLayerOptions(markers: marketList),
            ],
          );
        }

        return FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            center: LatLng(25.197525, 55.274288),
            swPanBoundary: LatLng(24.1156, 54.0067),
            nePanBoundary: LatLng(25.8603, 55.8446),
            zoom: 12.0,
            minZoom: 12.0,
            maxZoom: 16.0
          ),
          layers: [
            TileLayerOptions(
              tileProvider: FileTileProvider(),
              urlTemplate: applicationState.applicationDirectoryPath +
                  "/maps/{z}/{x}/{y}.png",
            ),MarkerLayerOptions(markers: marketList),
          ],
        );


      }),
    );
  }

  Marker createMarker(LatLng latLng, ){
    return Marker(
      width: 50.0,
      height: 50.0,
      point: latLng,
      builder: (ctx) => Container(
        child: Icon(Icons.location_on, color: Colors.redAccent,),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Log out"),
          content: new Text("Are you sure you want to logout?"),
          actions: <Widget>[
            new ElevatedButton(
              child: new Text("Yes"),
              onPressed: () {
                logOut();
                Navigator.pushNamedAndRemoveUntil(context, '/login', ModalRoute.withName('/login'));
              },
            ),
            new ElevatedButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future logOut() async {
    await storage.deleteAll();
  }
}
