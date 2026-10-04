// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:js' as js;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'map_shell.dart';

final Map<String, VoidCallback> _webMarkerCallbacks = {};
final Map<String, html.DivElement> _registeredWebDivs = {};

void setWebStyleJSON(String domId, String styleJsonStr) {
  if (js.context.hasProperty('mapboxGlobeSetStyleJSONWeb')) {
    js.context.callMethod('mapboxGlobeSetStyleJSONWeb', [domId, styleJsonStr]);
  }
}

void flyToWeb(String domId, double lng, double lat, double zoom) {
  if (js.context.hasProperty('mapboxGlobeFlyToWeb')) {
    js.context.callMethod('mapboxGlobeFlyToWeb', [domId, lng, lat, zoom]);
  }
}

void addMarkerWeb(String domId, double lng, double lat, String iconUrl, String markerId, VoidCallback onTap) {
  final callbackKey = 'mapbox_marker_cb_${markerId}_$domId';
  _webMarkerCallbacks[markerId] = onTap;

  js.context[callbackKey] = (String id) {
    final cb = _webMarkerCallbacks[id];
    if (cb != null) {
      cb();
    }
  };

  if (js.context.hasProperty('mapboxGlobeAddMarkerWeb')) {
    js.context.callMethod('mapboxGlobeAddMarkerWeb', [domId, lng, lat, iconUrl, markerId, callbackKey]);
  }
}

void clearMarkersWeb(String domId) {
  if (js.context.hasProperty('mapboxGlobeClearMarkersWeb')) {
    js.context.callMethod('mapboxGlobeClearMarkersWeb', [domId]);
  }
}

Widget buildPlatformMapWidget({
  required String viewId,
  required double initialLongitude,
  required double initialLatitude,
  required double initialZoom,
  String? initialStyleAsset,
  required void Function(MapShellController controller) onMapReady,
  required void Function(double zoom, double lat) onCameraChange,
}) {
  final domId = 'mapbox_globe_container_$viewId';

  // Register HTML view factory for Web
  ui_web.platformViewRegistry.registerViewFactory(domId, (int id) {
    final div = html.DivElement()
      ..id = domId
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.position = 'absolute'
      ..style.top = '0'
      ..style.left = '0'
      ..style.right = '0'
      ..style.bottom = '0'
      ..style.overflow = 'hidden'
      ..style.backgroundColor = '#0b0b19';
    _registeredWebDivs[domId] = div;
    return div;
  });

  return _MapboxWebWidget(
    domId: domId,
    initialLongitude: initialLongitude,
    initialLatitude: initialLatitude,
    initialZoom: initialZoom,
    initialStyleAsset: initialStyleAsset,
    onMapReady: onMapReady,
  );
}

class _MapboxWebWidget extends StatefulWidget {
  final String domId;
  final double initialLongitude;
  final double initialLatitude;
  final double initialZoom;
  final String? initialStyleAsset;
  final void Function(MapShellController controller) onMapReady;

  const _MapboxWebWidget({
    required this.domId,
    required this.initialLongitude,
    required this.initialLatitude,
    required this.initialZoom,
    this.initialStyleAsset,
    required this.onMapReady,
  });

  @override
  State<_MapboxWebWidget> createState() => _MapboxWebWidgetState();
}

class _MapboxWebWidgetState extends State<_MapboxWebWidget> {
  late final MapShellController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MapShellController(webDomId: widget.domId);

    // Give DOM element time to attach before initializing Mapbox GL JS
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      String? styleJson;
      if (widget.initialStyleAsset != null && widget.initialStyleAsset!.isNotEmpty) {
        try {
          styleJson = await rootBundle.loadString(widget.initialStyleAsset!);
        } catch (_) {}
      }

      final targetDiv = _registeredWebDivs[widget.domId];

      if (js.context.hasProperty('initMapboxGlobeWeb')) {
        js.context.callMethod('initMapboxGlobeWeb', [
          widget.domId,
          targetDiv,
          widget.initialLongitude,
          widget.initialLatitude,
          widget.initialZoom,
          styleJson,
        ]);
      }

      widget.onMapReady(_controller);
    });
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: widget.domId);
  }
}
