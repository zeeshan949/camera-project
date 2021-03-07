
import 'package:camera_application/gallary.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'application_config.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'offline_region_map.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {

  LatLngBounds dubaiBounds = LatLngBounds(
    southwest: const LatLng(24.1156, 54.0067),
    northeast: const LatLng(25.8603, 55.8446),
  );

  bool isMapLoaded = false;

  OfflineRegionDefinition dubaiRegionDefinition = null;

  @override
  void initState() {
    super.initState();

    dubaiRegionDefinition = OfflineRegionDefinition(
      bounds: dubaiBounds,
      minZoom: 13.0,
      maxZoom: 16.0,
      mapStyleUrl: MapboxStyles.MAPBOX_STREETS,
    );

    _downloadRegion();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async => false,
        child: new Scaffold(
          appBar: AppBar(
              title: Text('Your Uploaded Images'),
              elevation: 24.0,
              automaticallyImplyLeading: false,
              centerTitle: true,
              actions: <Widget>[
                new IconButton(
                  icon: new Icon(Icons.logout),
                  onPressed: () {
                    _showDialog(context);
                  },
                ),
              ]),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(onPressed: (){
//                  if(!isMapLoaded) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) =>
                            OfflineRegionMap(dubaiRegionDefinition)));
                /*
                }else{
                    Fluttertoast.showToast(
                        msg: "Offline Maps are not loaded yet.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.blueGrey,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                  */
                },
                    icon: Icon(Icons.map, color: Colors.red),
                    label: Text("Open Map")),
                ElevatedButton.icon(onPressed: (){

                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => GallaryPage()));
                },
                    icon: Icon(Icons.camera_enhance, color: Colors.amberAccent),
                    label: Text("Open Gallery")),
              ],
            )
          )
        ));
  }

  void _downloadRegion() async {
    try {
      final downloadingRegion = await downloadOfflineRegion(
        dubaiRegionDefinition,
        metadata: {
          'name': "Dubai",
        },
        accessToken: ACCESS_TOKEN,
      ).then((value) => {
        setState(() {
          isMapLoaded = true;
          Fluttertoast.showToast(
              msg: "Offline Maps are loaded successfuly.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.blueGrey,
              textColor: Colors.white,
              fontSize: 16.0);
        })
      });



      // Done downloading
    } on Exception catch (_) {
      return;
    }
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
                int count = 0;
                Navigator.of(context).popUntil((_) => count++ >= 2);
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