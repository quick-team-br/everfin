import 'dart:ui';

import 'package:flutter/material.dart';

class DashedOutlineBorder extends OutlinedBorder {
  @override
  final BorderSide side;
  final BorderRadius borderRadius;
  final double dashPattern;

  const DashedOutlineBorder({
    this.side = BorderSide.none,
    this.borderRadius = BorderRadius.zero,
    this.dashPattern = 5.0,
  });

  @override
  DashedOutlineBorder copyWith({
    BorderSide? side,
    BorderRadius? borderRadius,
    double? dashPattern,
  }) {
    return DashedOutlineBorder(
      side: side ?? this.side,
      borderRadius: borderRadius ?? this.borderRadius,
      dashPattern: dashPattern ?? this.dashPattern,
    );
  }

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(
      borderRadius.resolve(textDirection).toRRect(rect).deflate(side.width),
    );
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(borderRadius.resolve(textDirection).toRRect(rect));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final Paint paint =
        Paint()
          ..color = side.color
          ..strokeWidth = side.width
          ..style = PaintingStyle.stroke;

    final Path outerPath = getOuterPath(rect, textDirection: textDirection);
    final Path dashedPath = Path();
    final PathMetrics pathMetrics = outerPath.computeMetrics();
    double currentDistance = 0.0;

    for (final PathMetric pathMetric in pathMetrics) {
      while (currentDistance < pathMetric.length) {
        final tangent = pathMetric.getTangentForOffset(currentDistance);
        if (tangent != null) {
          final segmentEnd = currentDistance + dashPattern;
          dashedPath.addPath(
            pathMetric.extractPath(currentDistance, segmentEnd),
            Offset.zero,
          );
          currentDistance += 2 * dashPattern;
        } else {
          break;
        }
      }
      currentDistance = 0.0;
    }

    canvas.drawPath(dashedPath, paint);
  }

  @override
  ShapeBorder scale(double t) => DashedOutlineBorder(
    side: side.scale(t),
    borderRadius: borderRadius * t,
    dashPattern: dashPattern * t,
  );
}
