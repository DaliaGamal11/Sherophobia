import 'package:flutter/material.dart';
import 'package:sherophopia/Models/SearchViewModel.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



class MapPage extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String name;

  MapPage({
    required this.latitude,
    required this.longitude,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: MarkerId(name),
            position: LatLng(latitude, longitude),
            infoWindow: InfoWindow(
              title: name,
            ),
          ),
        },
      ),
    );
  }
}