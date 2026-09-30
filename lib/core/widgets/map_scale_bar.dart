import 'dart:math';
import 'package:flutter/material.dart';

/// A dynamic GIS Map Scale Bar widget matching native Mapbox / GIS scale bars.
/// Displays tick marks and distances (e.g., 0, 500 km, 1000 km at Saudi Arabia overview).
class MapScaleBar extends StatelessWidget {
  final double zoom;
  final double latitude;
  final Alignment alignment;
  final EdgeInsets padding;

  const MapScaleBar({
    super.key,
    required this.zoom,
    required this.latitude,
    this.alignment = Alignment.bottomLeft,
    this.padding = const EdgeInsets.only(left: 16, bottom: 24),
  });

  @override
  Widget build(BuildContext context) {
    // Ground resolution in meters per pixel for standard Web Mercator projection
    final metersPerPixel = (156543.03392 * cos(latitude * pi / 180.0)) / pow(2.0, zoom);

    // Target width on screen between 110 and 190 logical pixels
    const targetWidth = 140.0;
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

    // At Saudi Arabia national overview (zoom ~4.5 - 5.5), chosenDistance is ~1,000,000 m (1000 km)
    // with midpoint at 500 km, giving the iconic: 0 | 500 km | 1000 km
    final calculatedPixelWidth = (chosenDistance / metersPerPixel).clamp(90.0, 240.0);

    String formatUnit(double distMeters) {
      if (distMeters >= 1000) {
        final km = distMeters / 1000;
        return km % 1 == 0 ? '${km.toInt()} km' : '${km.toStringAsFixed(1)} km';
      } else {
        return '${distMeters.toInt()} m';
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
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.68),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withOpacity(0.35), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Distance Labels (0, 500 km, 1000 km)
              SizedBox(
                width: calculatedPixelWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      leftLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NotoKufi',
                      ),
                    ),
                    Text(
                      midLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NotoKufi',
                      ),
                    ),
                    Text(
                      rightLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NotoKufi',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 3),
              // Segmented Scale Ruler Bar (alternating white/black with border and ticks)
              SizedBox(
                width: calculatedPixelWidth,
                height: 7,
                child: Stack(
                  children: [
                    // Base alternating bar
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black, width: 0.8),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(2),
                                bottomLeft: Radius.circular(2),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF2C1810),
                              border: Border.all(color: Colors.white, width: 0.8),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(2),
                                bottomRight: Radius.circular(2),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Center tick
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: 1.5,
                        height: 7,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
