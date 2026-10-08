import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'map_shell.dart';

void setWebStyleJSON(String domId, String styleJsonStr) {}

void flyToWeb(String domId, double lng, double lat, double zoom) {}

void addMarkerWeb(String domId, double lng, double lat, String iconUrl, String markerId, VoidCallback onTap) {}

void clearMarkersWeb(String domId) {}

void setModalOpenWeb(bool isOpen) {}

void registerSidebarScrollCallback(void Function(double deltaY)? callback) {}

Widget buildPlatformMapWidget({
  required String viewId,
  required double initialLongitude,
  required double initialLatitude,
  required double initialZoom,
  String? initialStyleAsset,
  required void Function(MapShellController controller) onMapReady,
  required void Function(double zoom, double lat) onCameraChange,
}) {
  return MapWidget(
    key: ValueKey('mapbox_mobile_$viewId'),
    styleUri: MapboxStyles.SATELLITE_STREETS,
    cameraOptions: CameraOptions(
      center: Point(coordinates: Position(initialLongitude, initialLatitude)),
      zoom: initialZoom,
      pitch: 0.0,
      bearing: 0.0,
    ),
    onMapCreated: (mapboxMap) async {
      final controller = MapShellController();
      controller.mapboxMap = mapboxMap;

      if (initialStyleAsset != null && initialStyleAsset.isNotEmpty) {
        await controller.setStyleFromAsset(initialStyleAsset);
      }

      try {
        await mapboxMap.style.setProjection(StyleProjection(name: StyleProjectionName.globe));
      } catch (_) {}

      try {
        controller.pointAnnotationManager = await mapboxMap.annotations.createPointAnnotationManager();
      } catch (_) {}

      onMapReady(controller);
    },
    onCameraChangeListener: (data) {},
  );
}
