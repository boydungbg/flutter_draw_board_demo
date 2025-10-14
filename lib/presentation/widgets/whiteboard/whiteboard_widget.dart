import 'package:flutter/material.dart';

class WhiteboardWidget extends StatefulWidget {
  const WhiteboardWidget({super.key});

  @override
  State<WhiteboardWidget> createState() => _WhiteboardWidgetState();
}

class _WhiteboardWidgetState extends State<WhiteboardWidget> {
  List<DrawnLine> lines = <DrawnLine>[];
  DrawnLine? line;
  Color selectedColor = Colors.black;
  double selectedWidth = 3.0;
  GlobalKey paintKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Toolbar
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
          ),
          child: Row(
            children: [
              // Color picker
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    const Text('Color: '),
                    ...Colors.primaries.take(8).map((color) => 
                      GestureDetector(
                        onTap: () => setState(() => selectedColor = color),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: color,
                            border: selectedColor == color 
                                ? Border.all(color: Colors.black, width: 2)
                                : null,
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => selectedColor = Colors.black),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          border: selectedColor == Colors.black 
                              ? Border.all(color: Colors.white, width: 2)
                              : null,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              // Brush size
              Text('Size: ${selectedWidth.toInt()}'),
              Slider(
                value: selectedWidth,
                min: 1.0,
                max: 15.0,
                divisions: 14,
                onChanged: (value) => setState(() => selectedWidth = value),
              ),
              const Spacer(),
              // Clear button
              ElevatedButton(
                onPressed: () => setState(() => lines.clear()),
                child: const Text('Clear'),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
        // Drawing area
        Expanded(
          child: Container(
            color: Colors.white,
            width: double.infinity,
            child: GestureDetector(
              onPanStart: (details) {
                final renderBox = paintKey.currentContext?.findRenderObject() as RenderBox?;
                if (renderBox != null) {
                  final localPosition = renderBox.globalToLocal(details.globalPosition);
                  line = DrawnLine([localPosition], selectedColor, selectedWidth);
                }
              },
              onPanUpdate: (details) {
                final renderBox = paintKey.currentContext?.findRenderObject() as RenderBox?;
                if (renderBox != null && line != null) {
                  final localPosition = renderBox.globalToLocal(details.globalPosition);
                  
                  // Add some distance filtering to avoid too many close points
                  final lastPoint = line!.path.isNotEmpty ? line!.path.last : null;
                  if (lastPoint == null || (localPosition - lastPoint).distance > 2.0) {
                    final updatedLine = DrawnLine(
                      List.from(line!.path)..add(localPosition),
                      selectedColor,
                      selectedWidth,
                    );
                    setState(() {
                      line = updatedLine;
                    });
                  }
                }
              },
              onPanEnd: (details) {
                if (line != null) {
                  setState(() {
                    lines.add(line!);
                    line = null;
                  });
                }
              },
              child: Container(
                key: paintKey,
                width: double.infinity,
                height: double.infinity,
                child: CustomPaint(
                  painter: WhiteboardPainter(lines, line),
                  size: Size.infinite,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DrawnLine {
  final List<Offset> path;
  final Color color;
  final double width;

  DrawnLine(this.path, this.color, this.width);

  // Method to get smoothed path points
  List<Offset> getSmoothedPath() {
    if (path.length < 3) return path;
    
    List<Offset> smoothedPath = [path.first];
    
    for (int i = 1; i < path.length - 1; i++) {
      final prev = path[i - 1];
      final current = path[i];
      final next = path[i + 1];
      
      // Simple smoothing by averaging adjacent points
      final smoothed = Offset(
        (prev.dx + current.dx + next.dx) / 3,
        (prev.dy + current.dy + next.dy) / 3,
      );
      smoothedPath.add(smoothed);
    }
    
    smoothedPath.add(path.last);
    return smoothedPath;
  }
}

class WhiteboardPainter extends CustomPainter {
  final List<DrawnLine> lines;
  final DrawnLine? currentLine;

  WhiteboardPainter(this.lines, this.currentLine);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw completed lines
    for (final line in lines) {
      _drawLine(canvas, line);
    }

    // Draw current line being drawn
    if (currentLine != null) {
      _drawLine(canvas, currentLine!);
    }
  }

  void _drawLine(Canvas canvas, DrawnLine line) {
    if (line.path.isEmpty) return;

    final paint = Paint()
      ..color = line.color
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = line.width
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    // Use smoothed path for better line quality
    final smoothedPath = line.getSmoothedPath();

    if (smoothedPath.length == 1) {
      // Draw a single point as a circle
      canvas.drawCircle(smoothedPath.first, line.width / 2, paint);
    } else if (smoothedPath.length == 2) {
      // Draw a straight line for two points
      canvas.drawLine(smoothedPath.first, smoothedPath.last, paint);
    } else {
      // Create smooth curves using quadratic bezier curves
      final path = Path();
      path.moveTo(smoothedPath.first.dx, smoothedPath.first.dy);
      
      for (int i = 1; i < smoothedPath.length - 1; i++) {
        final current = smoothedPath[i];
        final next = smoothedPath[i + 1];
        
        // Calculate control point for smooth curve
        final controlPoint = Offset(
          (current.dx + next.dx) / 2,
          (current.dy + next.dy) / 2,
        );
        
        path.quadraticBezierTo(
          current.dx,
          current.dy,
          controlPoint.dx,
          controlPoint.dy,
        );
      }
      
      // Add the last point
      if (smoothedPath.length > 1) {
        path.lineTo(smoothedPath.last.dx, smoothedPath.last.dy);
      }
      
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}