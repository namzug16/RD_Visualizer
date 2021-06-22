import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sqlvisualizer/Controllers/CanvasController.dart';
import 'package:sqlvisualizer/Providers/TableProvider.dart';

class VisualizerCanvas extends StatefulHookWidget {
  final double width;
  final double height;

  const VisualizerCanvas({Key? key, required this.width, required this.height})
      : super(key: key);

  @override
  _VisualizerCanvasState createState() => _VisualizerCanvasState();
}

class _VisualizerCanvasState extends State<VisualizerCanvas> {
  late Size sizeCanvas;

  @override
  void initState() {
    super.initState();
    sizeCanvas = Size(widget.width, widget.height);
  }

  @override
  Widget build(BuildContext context) {
    final cActions = useProvider(canvasControllerProvider.notifier);
    final c = useProvider(canvasControllerProvider);
    final tables = useProvider(tableProvider);

    useEffect(() {
      setState(() {});
    }, [tables]);

    final cursor = useState(SystemMouseCursors.basic);

    return MouseRegion(
      cursor: cursor.value,
      child: Container(
        width: sizeCanvas.width,
        height: sizeCanvas.height,
        child: Listener(
          behavior: HitTestBehavior.opaque,
          onPointerHover: (details) {
            if (cActions.verifyHoover(details) == 2) {
              cursor.value = SystemMouseCursors.precise;
            } else if (cActions.verifyHoover(details) == 1) {
              cursor.value = SystemMouseCursors.click;
            } else {
              cursor.value = SystemMouseCursors.basic;
            }
          },
          onPointerSignal: (details) {
            setState(() {
              if (details is PointerScrollEvent) {
                GestureBinding.instance!.pointerSignalResolver.register(details,
                    (event) {
                  if (event is PointerScrollEvent) {
                    double zoomDelta = (-event.scrollDelta.dy / 300);
                    cActions.scale = cActions.scale + zoomDelta / 10;
                  }
                });
              }
            });
          },
          onPointerDown: (details) {
            cActions.addPointer(details);
          },
          onPointerUp: (details) {
            cActions.onPointerUp(details, tables);
          },
          onPointerMove: (details) {
            setState(() {
              cActions.moveObject(details);
            });
          },
          child: CustomPaint(
            size: sizeCanvas,
            painter: VisualizerCustomPainter(c: c, cActions: cActions),
          ),
        ),
      ),
    );
  }
}

class VisualizerCustomPainter extends CustomPainter {
  List<CanvasObject> c;
  CanvasController cActions;

  VisualizerCustomPainter({required this.c, required this.cActions});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 5
      ..color = Color(0xFF393e46);

    canvas.drawPaint(Paint()..color = Color(0xFF222831));
    // canvas.drawPaint(Paint()..color = Colors.black12);

    double scale = cActions.scale;
    double padding = 20.0 * scale;
    double maxWidth = 150.0 * scale + padding;
    double typeSpaceWidth = 30 * scale;
    double radiusD = 10 * scale;
    Radius radius = Radius.circular(radiusD);
    double heightSeparator = 5 * scale;
    double widthSeparator = maxWidth - radiusD;

    void drawContainer(
        double dx, double dy, double height, Color color, bool start) {
      final Rect rect = Offset(dx, dy) & Size(maxWidth + padding, height);
      if (start == false) {
        canvas.drawLine(
            Offset(dx + radiusD, dy - heightSeparator / 2),
            Offset(dx + 2 * radiusD + widthSeparator, dy - heightSeparator / 2),
            Paint()
              ..color = color
              ..style = PaintingStyle.stroke
              ..strokeWidth = heightSeparator
              ..strokeCap = StrokeCap.round
              ..strokeJoin = StrokeJoin.round);
      }
      canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), paint);
    }

    void drawRelation(List<Offset> points1, List<Offset> points2) {
      final leftOffsets = points1[0].dx < points2[0].dx ? points1 : points2;
      final rightOffsets = leftOffsets == points1 ? points2 : points1;
      final margin = 40 * scale;
      late Offset leftPoint;
      late Offset rightPoint;
      int pathIndex = 0;

      if (rightOffsets[0].dx - leftOffsets[1].dx > margin) {
        leftPoint = leftOffsets[1];
        rightPoint = rightOffsets[0];
        pathIndex = 0;
      } else {
        leftPoint = leftOffsets[0];
        rightPoint = rightOffsets[0];
        pathIndex = 1;
      }

      final middleX = (rightPoint.dx - leftPoint.dx) / 2;
      final path1 = Path()
        ..moveTo(leftPoint.dx, leftPoint.dy)
        ..lineTo(leftPoint.dx + middleX, leftPoint.dy)
        ..lineTo(leftPoint.dx + middleX, rightPoint.dy)
        ..lineTo(rightPoint.dx, rightPoint.dy);
      final path2 = Path()
        ..moveTo(leftPoint.dx, leftPoint.dy)
        ..lineTo(leftPoint.dx - margin, leftPoint.dy)
        ..lineTo(leftPoint.dx - margin, rightPoint.dy)
        ..lineTo(rightPoint.dx, rightPoint.dy);
      canvas.drawPath(
          pathIndex == 0 ? path1 : path2,
          Paint()
            ..color = Colors.white30
            ..style = PaintingStyle.stroke
            ..strokeJoin = StrokeJoin.round
            ..strokeCap = StrokeCap.round
            ..strokeWidth = 5 * scale);
    }

    void drawContent(int index, int indexContent, CanvasObject object) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: object.tableC!.columns![indexContent].indexType == "None"
              ? object.tableC!.columns![indexContent].name
              : object.tableC!.columns![indexContent].indexType +
                  " - " +
                  object.tableC!.columns![indexContent].name!,
          style: GoogleFonts.quicksand(
            color: Colors.white,
            fontSize: 15 * scale,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      final textPainterTypeData = TextPainter(
        text: object.tableC!.columns![indexContent].nullable
            ? TextSpan(
                text: object.tableC!.columns![indexContent].dataType + "?",
                style: GoogleFonts.quicksand(
                  color: Colors.white,
                  fontSize: 15 * scale,
                ),
              )
            : TextSpan(
                text: object.tableC!.columns![indexContent].dataType,
                style: GoogleFonts.quicksand(
                  color: Colors.white,
                  fontSize: 15 * scale,
                ),
              ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(maxWidth: maxWidth - typeSpaceWidth * 2 - padding / 2);
      textPainterTypeData.layout(maxWidth: 70);
      final maxHeight =
          textPainter.size.height > textPainterTypeData.size.height
              ? textPainter.size.height
              : textPainterTypeData.size.height;
      drawContainer(
          object.dx * scale,
          object.dy * scale + cActions.getSizeI(index).height,
          maxHeight + padding,
          object.tableC!.color!,
          false);
      textPainter.paint(
          canvas,
          Offset(
              object.dx * scale + padding / 2,
              object.dy * scale +
                  padding / 2 +
                  cActions.getSizeI(index).height));
      textPainterTypeData.paint(
          canvas,
          Offset(
              object.dx * scale + padding / 2 + maxWidth - typeSpaceWidth * 2,
              object.dy * scale +
                  padding / 2 +
                  cActions.getSizeI(index).height));
      // ? ==========================================================Middle Points of Columns
      cActions.setMiddlePoints(index, indexContent, [
        Offset(
            object.dx * scale,
            object.dy * scale +
                cActions.getSizeI(index).height +
                (maxHeight + padding) / 2),
        Offset(
            object.dx * scale + maxWidth + padding,
            object.dy * scale +
                cActions.getSizeI(index).height +
                (maxHeight + padding) / 2)
      ]);
      cActions.setSizeI(
          index,
          Size(
              maxWidth + padding,
              cActions.getSizeI(index).height +
                  maxHeight +
                  padding +
                  heightSeparator));
    }

    for (var i = 0; i < c.length; i++) {
      final obj = c[i];
      final textPainter = TextPainter(
        text: TextSpan(
          text: obj.tableC!.name,
          style: GoogleFonts.quicksand(
            color: Colors.white,
            fontSize: 20 * scale,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(maxWidth: maxWidth);
      cActions.setSizeI(
          i,
          Size(maxWidth + padding,
              textPainter.size.height + padding + heightSeparator));
      drawContainer(obj.dx * scale, obj.dy * scale,
          textPainter.size.height + padding, obj.tableC!.color!, true);
      cActions.setAmountColumns(i, obj.tableC!.columns!.length);
      for (var j = 0; j < obj.tableC!.columns!.length; j++) {
        drawContent(i, j, obj);
      }
      textPainter.paint(canvas,
          Offset(obj.dx * scale + padding / 2, obj.dy * scale + padding / 2));
    }

    for (var i = 0; i < cActions.middlePointsColumns.length; i++) {
      for (var off in cActions.middlePointsColumns[i]) {
        canvas.drawCircle(off[0], cActions.sizeOfPrecise * scale,
            Paint()..color = Color(0xFF00adb5));
        canvas.drawCircle(off[1], cActions.sizeOfPrecise * scale,
            Paint()..color = Color(0xFF00adb5));
      }
    }

    for (var i = 0; i < c.length; i++) {
      final obj = c[i];
      if (obj.tableC!.relations.length > 0) {
        for (var rel in obj.tableC!.relations) {
          print(obj.tableC!.relations
              .map((e) => [e.ownColumnIndex, e.tableIndex, e.columnIndex]));
          drawRelation(cActions.middlePointsColumns[i][rel.ownColumnIndex],
              cActions.middlePointsColumns[rel.tableIndex][rel.columnIndex]);
        }
      }
    }

    if (cActions.pointsOfRelation != null) {
      drawRelation(
          [cActions.pointsOfRelation![0], cActions.pointsOfRelation![0]],
          [cActions.pointsOfRelation![1], cActions.pointsOfRelation![1]]);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
