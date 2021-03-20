import 'package:camera_application/mbtiles_image_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class OfflineMap extends StatefulWidget {
  @override
  _OfflineRegionState createState() => _OfflineRegionState();
}

class _OfflineRegionState extends State<OfflineMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offline Map'),
      ),
      body: FlutterMap(
          options: MapOptions(
            center: LatLng(
                25.197525, 55.274288
            ),
            swPanBoundary: LatLng(24.1156 , 54.0067),
            nePanBoundary: LatLng(25.8603, 55.8446),
            zoom: 12.0,
          ),
          layers: [
            TileLayerOptions(
              tileProvider: FileTileProvider(),
              urlTemplate: "/data/user/0/com.cameraapp.camera_application/app_flutter/maps/{z}/{x}/{y}.png",
            ),
          ],
        ),
    );
  }
}
