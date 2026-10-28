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
  // callbackKey must be unique per marker+page so that two pages with the
  // same markerId values don't overwrite each other's callbacks.
  final callbackKey = 'mapbox_marker_cb_${markerId}_$domId';
  _webMarkerCallbacks[callbackKey] = onTap; // ← keyed by full callbackKey

  js.context[callbackKey] = (String id) {
    // JS passes markerId; reconstruct the full key to look up the callback.
    final key = 'mapbox_marker_cb_${id}_$domId';
    final cb = _webMarkerCallbacks[key];
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

void setMarkersBatchWeb(String domId, String markersJsonStr, void Function(String markerId) onTap) {
  final callbackName = 'mapbox_batch_marker_cb_$domId';
  js.context[callbackName] = (String id) {
    onTap(id);
  };
  if (js.context.hasProperty('mapboxGlobeSetMarkersBatchWeb')) {
    js.context.callMethod('mapboxGlobeSetMarkersBatchWeb', [domId, markersJsonStr, callbackName]);
  }
}

void loadAllValleysWeb(String domId, String valleysJsonStr, String? selectedValleyKey) {
  if (js.context.hasProperty('mapboxGlobeLoadAllValleysWeb')) {
    js.context.callMethod('mapboxGlobeLoadAllValleysWeb', [domId, valleysJsonStr, selectedValleyKey]);
  }
}

void addGeoJsonLineLayerWeb(String domId, String sourceId, String layerId,
    String geoJsonString, String colorHex, double lineWidth) {
  if (js.context.hasProperty('mapboxGlobeAddGeoJsonLineLayer')) {
    js.context.callMethod('mapboxGlobeAddGeoJsonLineLayer',
        [domId, sourceId, layerId, geoJsonString, colorHex, lineWidth]);
  }
}

void clearGeoJsonLineLayersWeb(
    String domId, List<String> layerIds, List<String> sourceIds) {
  if (js.context.hasProperty('mapboxGlobeClearGeoJsonLineLayers')) {
    js.context.callMethod('mapboxGlobeClearGeoJsonLineLayers',
        [domId, layerIds.join(','), sourceIds.join(',')]);
  }
}

void updateValleyColorsWeb(String domId, String selectedValleyKey) {
  if (js.context.hasProperty('mapboxGlobeUpdateValleyColors')) {
    js.context.callMethod('mapboxGlobeUpdateValleyColors', [domId, selectedValleyKey]);
  }
}

void updateDamMarkersWeb(String domId, String selectedDamName) {
  if (js.context.hasProperty('mapboxGlobeUpdateDamMarkers')) {
    js.context.callMethod('mapboxGlobeUpdateDamMarkers', [domId, selectedDamName]);
  }
}

void registerFormationPolygonCallback(void Function(String layerKey)? callback) {
  if (callback == null) {
    js.context['onFormationPolygonClicked'] = null;
  } else {
    js.context['onFormationPolygonClicked'] = (dynamic key) {
      if (key is String) {
        callback(key);
      }
    };
  }
}

void registerValleyLineCallback(void Function(String layerKey)? callback) {
  if (callback == null) {
    js.context['onValleyLineClicked'] = null;
  } else {
    js.context['onValleyLineClicked'] = (dynamic key) {
      if (key is String) {
        callback(key);
      }
    };
  }
}

void setModalOpenWeb(bool isOpen) {
  if (js.context.hasProperty('setModalOpenWeb')) {
    js.context.callMethod('setModalOpenWeb', [isOpen]);
  }
}

void registerSidebarScrollCallback(void Function(double deltaY)? callback) {
  if (callback == null) {
    js.context['flutterSidebarScroll'] = null;
  } else {
    js.context['flutterSidebarScroll'] = (dynamic deltaY) {
      if (deltaY is num) {
        callback(deltaY.toDouble());
      }
    };
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
    div.onFocus.listen((_) {
      try {
        div.blur();
      } catch (_) {}
    });
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
      final styleAsset = (widget.initialStyleAsset != null && widget.initialStyleAsset!.isNotEmpty)
          ? widget.initialStyleAsset!
          : 'assets/maps/saudi_geo/sahel.json';
      try {
        styleJson = await rootBundle.loadString(styleAsset);
      } catch (_) {}

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

      // Wait until the JS map instance is fully initialised before notifying
      // Flutter. mapboxGlobeAddMarkerWeb queues markers internally, so
      // calling onMapReady now is safe — JS will flush queued markers on load.
      widget.onMapReady(_controller);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Focus(
      canRequestFocus: false,
      child: ExcludeSemantics(
        excluding: true,
        child: HtmlElementView(viewType: widget.domId),
      ),
    );
  }
}
