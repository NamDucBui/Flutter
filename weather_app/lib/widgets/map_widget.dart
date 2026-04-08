import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatelessWidget {
  final double lat;
  final double lon;

  const MapWidget({super.key, required this.lat, required this.lon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      // L4: Listener(onPointerDown: (_) {}) là no-op → xóa
      child: FlutterMap(
        options: MapOptions(initialCenter: LatLng(lat, lon), initialZoom: 10),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            // M9: dùng package name thực thay vì com.example để tuân thủ OSM policy
            userAgentPackageName: 'com.immortal.weather_app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(lat, lon),
                width: 40,
                height: 40,
                child: const Icon(Icons.location_pin, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
