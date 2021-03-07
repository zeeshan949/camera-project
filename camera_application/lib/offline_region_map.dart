import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class OfflineRegionMap extends StatefulWidget {
  OfflineRegionMap(this.item);

  final OfflineRegionDefinition item;

  @override
  _OfflineRegionMapState createState() => _OfflineRegionMapState();
}

class _OfflineRegionMapState extends State<OfflineRegionMap> {

  MapboxMapController controller;

  void _onMapCreated(MapboxMapController controller) {
    this.controller = controller;
    this.controller.addSymbol(_getSymbolOptions(25.197525, 55.274288));
  }

  SymbolOptions _getSymbolOptions(double latitude, double longitude){
    LatLng geometry = LatLng(latitude, longitude);
    return SymbolOptions(
      geometry: geometry, iconImage: "assets/custom-icon.png"
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offline Map'),
      ),
      body: MapboxMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: widget.item.minZoom,
        ),
        minMaxZoomPreference: MinMaxZoomPreference(
          widget.item.minZoom,
          widget.item.maxZoom,
        ),
        styleString: widget.item.mapStyleUrl,
        cameraTargetBounds: CameraTargetBounds(
          widget.item.bounds,
        ),
      ),
    );
  }

  LatLng get _center {

    return LatLng(25.197525, 55.274288);
  }
}