import 'dart:math';
import 'package:flutter/material.dart';

/// Authentic native Mapbox / GIS Map Scale Bar widget matching Mapbox Android SDK 10.x.
/// Renders distance labels (0, 500 km, 1000 km) directly above a high-contrast ruler bar
/// with tick marks and transparent background.
class MapScaleBar extends StatelessWidget {
  final double zoom;
  final double latitude;
  final Alignment alignment;
  final EdgeInsets padding;

  const MapScaleBar({
    super.key,
    required this.zoom,
    required this.latitude,
    this.alignment = Alignment.topLeft,
    this.padding = const EdgeInsets.only(left: 16, top: 16),
  });

  @override
  Widget build(BuildContext context) {
    // Ground resolution in meters per pixel for standard Web Mercator projection
    final metersPerPixel = (156543.03392 * cos(latitude * pi / 180.0)) / pow(2.0, zoom);

    // Target width on screen around 140 - 220 logical pixels
    const targetWidth = 160.0;
    final targetDistanceMeters = targetWidth * metersPerPixel;

    // Standard round distance steps (in meters)
    const steps = [
      10.0,
      20.0,
      50.0,
      100.0,
      200.0,
      500.0,
      1000.0,
      2000.0,
      5000.0,
      10000.0,
      20000.0,
      50000.0,
      100000.0,
      200000.0,
      500000.0,
      1000000.0,
      2000000.0,
      5000000.0,
    ];

    double chosenDistance = steps.last;
    for (final s in steps) {
      if (s >= targetDistanceMeters) {
        chosenDistance = s;
        break;
      }
    }

    final calculatedPixelWidth = (chosenDistance / metersPerPixel).clamp(110.0, 260.0);

    String formatUnit(double distMeters) {
      if (distMeters >= 1000) {
        final km = distMeters / 1000;
        return km % 1 == 0 ? '${km.toInt()} كم' : '${km.toStringAsFixed(1)} كم';
      } else {
        return '${distMeters.toInt()} م';
      }
    }

    final midDistance = chosenDistance / 2;
    final leftLabel = '0';
    final midLabel = formatUnit(midDistance);
    final rightLabel = formatUnit(chosenDistance);

    return Align(
      alignment: alignment,
      child: Padding(
        padding: padding,
        child: SizedBox(
          width: calculatedPixelWidth + 30,
          height: 32,
          child: CustomPaint(
            painter: _MapboxScaleBarPainter(
              barWidth: calculatedPixelWidth,
              leftText: leftLabel,
              midText: midLabel,
              rightText: rightLabel,
            ),
          ),
        ),
      ),
    );
  }
}

class _MapboxScaleBarPainter extends CustomPainter {
  final double barWidth;
  final String leftText;
  final String midText;
  final String rightText;

  _MapboxScaleBarPainter({
    required this.barWidth,
    required this.leftText,
    required this.midText,
    required this.rightText,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 11.5,
      fontWeight: FontWeight.bold,
      fontFamily: 'NotoKufi',
      shadows: [
        Shadow(color: Colors.white, blurRadius: 3, offset: Offset(0, 0)),
        Shadow(color: Colors.white, blurRadius: 3, offset: Offset(1, 1)),
        Shadow(color: Colors.white, blurRadius: 3, offset: Offset(-1, -1)),
        Shadow(color: Colors.white, blurRadius: 3, offset: Offset(1, -1)),
        Shadow(color: Colors.white, blurRadius: 3, offset: Offset(-1, 1)),
      ],
    );

    // Left text
    final leftPainter = TextPainter(
      text: TextSpan(text: leftText, style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    leftPainter.paint(canvas, Offset(0, 0));

    // Mid text
    final midPainter = TextPainter(
      text: TextSpan(text: midText, style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    midPainter.paint(canvas, Offset((barWidth / 2) - (midPainter.width / 2), 0));

    // Right text
    final rightPainter = TextPainter(
      text: TextSpan(text: rightText, style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    rightPainter.paint(canvas, Offset(barWidth - rightPainter.width, 0));

    final lineY = leftPainter.height + 2;
    const tickHeight = 6.0;

    // Ruler path: |____|____|
    final rulerPath = Path()
      // Left tick
      ..moveTo(0, lineY + tickHeight)
      ..lineTo(0, lineY)
      // Horizontal bar
      ..lineTo(barWidth, lineY)
      // Right tick
      ..lineTo(barWidth, lineY + tickHeight)
      // Mid tick
      ..moveTo(barWidth / 2, lineY)
      ..lineTo(barWidth / 2, lineY + tickHeight);

    // Outer white stroke for maximum contrast over any satellite image or terrain
    final whitePaint = Paint()
      ..color = Colors.white.withOpacity(0.95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.6
      ..strokeCap = StrokeCap.square;

    // Inner dark core
    final blackPaint = Paint()
      ..color = const Color(0xFF1B1B1B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.square;

    canvas.drawPath(rulerPath, whitePaint);
    canvas.drawPath(rulerPath, blackPaint);
  }

  @override
  bool shouldRepaint(covariant _MapboxScaleBarPainter oldDelegate) {
    return oldDelegate.barWidth != barWidth ||
        oldDelegate.leftText != leftText ||
        oldDelegate.midText != midText ||
        oldDelegate.rightText != rightText;
  }
}
