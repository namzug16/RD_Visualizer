import 'dart:async';
import 'package:flutter/material.dart';

enum TooltipDirection {
  topCenter,
  bottomCenter,
  centerLeft,
  centerRight,
}

class CustomTooltip extends StatefulWidget {
  final String tooltipText;
  final TextStyle style;
  final Color color;
  final Radius radius;
  final Widget child;
  final TooltipDirection direction;

  CustomTooltip({
    required this.child,
    required this.tooltipText,
    required this.direction,
    radius,
    style,
    color,
  }) : style = style ?? TextStyle(color: Colors.white, fontSize: 10),
        radius = radius ?? Radius.circular(8),
        color = color ?? Colors.grey;

  @override
  _CustomTooltipState createState() => _CustomTooltipState();
}

class _CustomTooltipState extends State<CustomTooltip> {
  OverlayEntry? _overlayEntry;

  Timer? _timerStart;
  Timer? _timerEnd;

  OverlayEntry _createOverlayEntry() {
    RenderBox? renderBox = context.findRenderObject() as RenderBox?;

    double top;
    double left;

    final textPainter = TextPainter(
      text: TextSpan(
          text: widget.tooltipText,
          style: TextStyle(color: Colors.white, fontSize: 15)),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    const double padding = 10;
    const double margin = 10;

    double heightTooltip = textPainter.height + padding + margin;
    double widthTooltip = textPainter.width + padding + margin;

    var translation;
    late Rect rect;

    if (renderBox != null) {
      translation = renderBox.getTransformTo(null).getTranslation();
      rect = renderBox.paintBounds.shift(Offset(translation.x, translation.y));
      switch (widget.direction) {
        case TooltipDirection.topCenter:
          top = rect.topCenter.dy - heightTooltip;
          left = rect.topCenter.dx - widthTooltip / 2;
          break;
        case TooltipDirection.bottomCenter:
          top = rect.bottomCenter.dy;
          left = rect.bottomCenter.dx - widthTooltip / 2;
          break;
        case TooltipDirection.centerLeft:
          top = rect.centerLeft.dy - heightTooltip / 2;
          left = rect.centerLeft.dx - widthTooltip;
          break;
        case TooltipDirection.centerRight:
          top = rect.centerRight.dy - heightTooltip / 2;
          left = rect.centerRight.dx;
          break;
      }
    } else {
      top = 0.0;
      left = 0.0;
    }

    return OverlayEntry(
      builder: (context) {
        return Positioned(
            left: left,
            top: top,
            child: CustomPaint(
              size: Size(widthTooltip, heightTooltip),
              painter: TooltipPainter(
                  textPainter: textPainter,
                  padding: padding,
                  margin: margin,
                  offset: Offset(left, top),
                  direction: widget.direction,
                  rectParent: rect,
                color: widget.color,
                style: widget.style,
                radius: widget.radius,
              ),
            ));
      },
    );
  }

  void _onEnterHandler() {
    if (_overlayEntry != _createOverlayEntry()) {
      _overlayEntry = _createOverlayEntry();
    }
    if (_timerEnd != null && _timerEnd!.isActive) {
      _timerEnd!.cancel();
    }
    _timerStart = Timer(Duration(seconds: 1), () {
      Overlay.of(context)!.insert(_overlayEntry!);
    });
  }

  void _onExitHandler() {
    if (_timerStart != null && _timerStart!.isActive) {
      _timerStart!.cancel();
    }
    if (_overlayEntry!.mounted) {
      _overlayEntry!.remove();
      _timerEnd = Timer(Duration(seconds: 1), () {
        _overlayEntry!.dispose();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _overlayEntry = _createOverlayEntry();
  }

  @override
  void dispose() {
    if (_timerStart != null && _timerStart!.isActive) {
      _timerStart!.cancel();
    }
    if (_timerEnd != null && _timerEnd!.isActive) {
      _timerEnd!.cancel();
    }
    if (_overlayEntry!.mounted) {
      _overlayEntry!.remove();
      // _overlayEntry!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onEnterHandler(),
      onExit: (_) => _onExitHandler(),
      child: widget.child,
    );
  }
}

class TooltipPainter extends CustomPainter {
  final TextPainter textPainter;
  final double padding;
  final double margin;
  final Offset offset;
  final TooltipDirection direction;
  final Rect rectParent;
  final Color color;
  final TextStyle style;
  final Radius radius;

  TooltipPainter({
    required this.textPainter,
    required this.padding,
    required this.margin,
    required this.offset,
    required this.direction,
    required this.rectParent,
    required this.color,
    required this.style,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    // * Draws Tooltip
    canvas.drawRRect(RRect.fromRectAndRadius(Offset(margin / 2, margin / 2) &
    Size(textPainter.width + padding, textPainter.height + padding), radius), paint);

    textPainter.paint(
        canvas, Offset(margin / 2 + padding / 2, margin / 2 + padding / 2));

    // * Draws Connection
    canvas.drawPath(
        getConnection(
            Size(textPainter.width + padding + margin,
                textPainter.height + padding + margin),
            offset,
            margin,
            direction),
        Paint()..color = color.withOpacity(0.7));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

Path getConnection(
  Size textPainterSize,
  Offset offset,
  double margin,
  TooltipDirection direction,
) {
  switch (direction) {
    case TooltipDirection.topCenter:
      return Path()
        ..moveTo(
            textPainterSize.width/2 - margin, textPainterSize.height - margin)
        ..lineTo(textPainterSize.width/2, textPainterSize.height)
        ..lineTo(
            textPainterSize.width/2 + margin, textPainterSize.height - margin)
        ..close();
    case TooltipDirection.bottomCenter:
      return Path()
        ..moveTo(
            textPainterSize.width/2 - margin, margin)
        ..lineTo(textPainterSize.width/2, 0)
        ..lineTo(
            textPainterSize.width/2 + margin, margin)
        ..close();
    case TooltipDirection.centerLeft:
      return Path()
        ..moveTo(
            textPainterSize.width - margin, textPainterSize.height / 2 - margin)
        ..lineTo(textPainterSize.width, textPainterSize.height / 2)
        ..lineTo(
            textPainterSize.width - margin, textPainterSize.height / 2 + margin)
        ..close();
    case TooltipDirection.centerRight:
      return Path()
        ..moveTo(
            margin, textPainterSize.height / 2 - margin)
        ..lineTo(0, textPainterSize.height / 2)
        ..lineTo(
            margin, textPainterSize.height / 2 + margin)
        ..close();
  }
  return Path();
}
