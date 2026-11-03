// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';

const String _kGeospatialDocViewType = 'geospatial_unified_doc_viewer_iframe';
bool _isFactoryRegistered = false;

void _ensureFactoryRegistered() {
  if (_isFactoryRegistered) return;
  _isFactoryRegistered = true;

  ui_web.platformViewRegistry.registerViewFactory(_kGeospatialDocViewType, (int id) {
    final iframe = html.IFrameElement()
      ..src = 'geospatial_viewer.html'
      ..id = 'geospatial_viewer_iframe_$id'
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.position = 'absolute'
      ..style.top = '0'
      ..style.left = '0'
      ..style.right = '0'
      ..style.bottom = '0'
      ..style.backgroundColor = '#FAF6EE';

    return iframe;
  });
}

Widget buildGeospatialDocViewerPlatform({
  required String pdfAssetPath,
  required String xlsxAssetPath,
}) {
  _ensureFactoryRegistered();
  return const SizedBox.expand(
    child: HtmlElementView(viewType: _kGeospatialDocViewType),
  );
}
