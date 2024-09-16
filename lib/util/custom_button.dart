import 'package:flutter/material.dart';

class CustomRoundedRectangleBorder extends OutlinedBorder {
  final double topLeftRadius;
  final double topRightRadius;
  final double bottomLeftRadius;
  final double bottomRightRadius;

  const CustomRoundedRectangleBorder({
    this.topLeftRadius = 0,
    this.topRightRadius = 0,
    this.bottomLeftRadius = 0,
    this.bottomRightRadius = 0,
    BorderSide side = BorderSide.none,
  }) : super(side: side);

  @override
  OutlinedBorder copyWith({BorderSide? side}) {
    return CustomRoundedRectangleBorder(
      topLeftRadius: topLeftRadius,
      topRightRadius: topRightRadius,
      bottomLeftRadius: bottomLeftRadius,
      bottomRightRadius: bottomRightRadius,
      side: side ?? this.side,
    );
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(rect.deflate(side.width), textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..moveTo(rect.left + topLeftRadius, rect.top)
      ..lineTo(rect.right - topRightRadius, rect.top)
      ..quadraticBezierTo(
          rect.right, rect.top, rect.right, rect.top + topRightRadius)
      ..lineTo(rect.right, rect.bottom - bottomRightRadius)
      ..quadraticBezierTo(
          rect.right, rect.bottom, rect.right - bottomRightRadius, rect.bottom)
      ..lineTo(rect.left + bottomLeftRadius, rect.bottom)
      ..quadraticBezierTo(
          rect.left, rect.bottom, rect.left, rect.bottom - bottomLeftRadius)
      ..lineTo(rect.left, rect.top + topLeftRadius)
      ..quadraticBezierTo(
          rect.left, rect.top, rect.left + topLeftRadius, rect.top)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    switch (side.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        canvas.drawPath(
            getOuterPath(rect, textDirection: textDirection), side.toPaint());
    }
  }

  @override
  ShapeBorder scale(double t) {
    return CustomRoundedRectangleBorder(
      topLeftRadius: topLeftRadius * t,
      topRightRadius: topRightRadius * t,
      bottomLeftRadius: bottomLeftRadius * t,
      bottomRightRadius: bottomRightRadius * t,
      side: side.scale(t),
    );
  }
}
