import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
// import 'package:printing/printing.dart';
import 'dash_painter.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:math' as math;

enum DrawingTool { pen, line, rectangle, circle, ellipse, text, select }

class WhiteboardWidget extends StatefulWidget {
  final Function(bool)? onOverlayModeChanged;

  const WhiteboardWidget({super.key, this.onOverlayModeChanged});

  @override
  State<WhiteboardWidget> createState() => _WhiteboardWidgetState();
}

class _WhiteboardWidgetState extends State<WhiteboardWidget> {
  List<DrawingObject> objects = <DrawingObject>[];
  DrawingObject? currentObject;
  DrawingTool selectedTool = DrawingTool.pen;
  Color selectedColor = Colors.black;
  Color fillColor = Colors.transparent;
  double selectedWidth = 3.0;
  bool isFilled = false;
  bool isOverlayMode = false;
  GlobalKey paintKey = GlobalKey();

  // Selection variables
  List<DrawingObject> selectedObjects = [];
  Rect? selectionRect;
  Offset? selectionStart;
  bool isDragging = false;
  Offset? dragOffset;

  // Text editing
  TextEditingController textController = TextEditingController();
  bool isEditingText = false;
  Offset? textPosition;

  @override
  Widget build(BuildContext context) {
    if (isOverlayMode) {
      return _buildOverlayMode();
    }

    return Column(children: [_buildToolbar(), _buildDrawingArea()]);
  }

  Widget _buildOverlayMode() {
    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          // Compact overlay toolbar only - no title bar
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            margin: const EdgeInsets.all(8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Back to whiteboard button
                IconButton(
                  onPressed: () {
                    setState(() => isOverlayMode = false);
                    widget.onOverlayModeChanged?.call(false);
                  },
                  icon: const Icon(Icons.fullscreen_exit, color: Colors.white),
                  tooltip: 'Exit Overlay Mode',
                ),

                const VerticalDivider(color: Colors.white24),

                // Essential tools
                _buildCompactToolButton(DrawingTool.pen, Icons.edit, 'Pen'),
                _buildCompactToolButton(
                  DrawingTool.select,
                  Icons.open_with,
                  'Select',
                ),

                const VerticalDivider(color: Colors.white24),

                // Quick colors
                ...Colors.primaries
                    .take(4)
                    .map((color) => _buildCompactColorButton(color)),

                const VerticalDivider(color: Colors.white24),

                // Clear button
                IconButton(
                  onPressed: _clearAll,
                  icon: const Icon(Icons.clear_all, color: Colors.white),
                  tooltip: 'Clear All',
                ),

                const VerticalDivider(color: Colors.white24),

                // System tray indicator
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.minimize, color: Colors.white54, size: 12),
                      SizedBox(width: 4),
                      Text(
                        'In Tray',
                        style: TextStyle(color: Colors.white54, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Transparent drawing area
          Expanded(
            child: Container(
              color: Colors.transparent,
              child: GestureDetector(
                onTapDown: _onTapDown,
                onPanStart: _onPanStart,
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
                child: Container(
                  key: paintKey,
                  width: double.infinity,
                  height: double.infinity,
                  child: CustomPaint(
                    painter: WhiteboardPainter(
                      objects: objects,
                      currentObject: currentObject,
                      selectedObjects: selectedObjects,
                      selectionRect: selectionRect,
                    ),
                    size: Size.infinite,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Drawing tools
            _buildToolButton(DrawingTool.pen, Icons.edit, 'Pen'),
            _buildToolButton(DrawingTool.line, Icons.remove, 'Line'),
            _buildToolButton(
              DrawingTool.rectangle,
              Icons.crop_square,
              'Rectangle',
            ),
            _buildToolButton(
              DrawingTool.circle,
              Icons.radio_button_unchecked,
              'Circle',
            ),
            _buildToolButton(
              DrawingTool.ellipse,
              Icons.panorama_fish_eye,
              'Ellipse',
            ),
            _buildToolButton(DrawingTool.text, Icons.text_fields, 'Text'),
            _buildToolButton(DrawingTool.select, Icons.open_with, 'Select'),

            const VerticalDivider(),

            // Color picker for stroke
            const Text('Stroke: '),
            ...Colors.primaries
                .take(6)
                .map((color) => _buildColorButton(color, false)),
            _buildColorButton(Colors.black, false),

            const SizedBox(width: 10),

            // Fill toggle and color
            Checkbox(
              value: isFilled,
              onChanged: (value) => setState(() => isFilled = value ?? false),
            ),
            Text(selectedTool == DrawingTool.select ? 'Paint: ' : 'Fill: '),
            ...Colors.primaries
                .take(6)
                .map((color) => _buildColorButton(color, true)),
            _buildColorButton(Colors.white, true),

            // Fill mode indicator for Select tool
            if (selectedTool == DrawingTool.select && isFilled)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.blue),
                ),
                child: const Text(
                  'Paint Mode',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            const SizedBox(width: 10),

            // Brush size
            Text('Size: ${selectedWidth.toInt()}'),
            SizedBox(
              width: 100,
              child: Slider(
                value: selectedWidth,
                min: 1.0,
                max: 20.0,
                divisions: 19,
                onChanged: (value) => setState(() => selectedWidth = value),
              ),
            ),

            const VerticalDivider(),

            // Export PDF button
            ElevatedButton.icon(
              onPressed: _exportToPdf,
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Export PDF'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(width: 8),

            // Overlay mode button
            ElevatedButton.icon(
              onPressed: () {
                setState(() => isOverlayMode = true);
                widget.onOverlayModeChanged?.call(true);
              },
              icon: const Icon(Icons.picture_in_picture_alt),
              label: const Text('Overlay'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            // Clear and Delete buttons
            ElevatedButton(
              onPressed: _clearAll,
              child: const Text('Clear All'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _deleteSelected,
              child: const Text('Delete Selected'),
            ),
            const SizedBox(width: 8),

            // System tray info
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.info_outline, size: 16, color: Colors.blue),
                  SizedBox(width: 6),
                  Text(
                    'Close window to minimize to system tray',
                    style: TextStyle(fontSize: 11, color: Colors.blue),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _exportToPdf() async {
    {
      // 4K target size
      const double targetWidth = 3840.0;
      const double targetHeight = 2160.0;
      // Get current whiteboard size
      final renderBox =
          paintKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Whiteboard size unavailable.')),
        );
        return;
      }
      final Size whiteboardSize = renderBox.size;
      final double scaleX = targetWidth / whiteboardSize.width;
      final double scaleY = targetHeight / whiteboardSize.height;
      // Use uniform scale to preserve aspect ratio
      final double scaleValue = scaleX < scaleY ? scaleX : scaleY;

      final pdf = pw.Document();
      final pageFormat = PdfPageFormat(targetWidth, targetHeight);
      pdf.addPage(
        pw.Page(
          pageFormat: pageFormat,
          margin: pw.EdgeInsets.all(0),
          build: (pw.Context context) {
            final double scale = scaleValue;
            // Helper to rotate a point 90deg CCW (landscape)
            Offset rotatePoint(Offset p) {
              return Offset(p.dx * scale, p.dy * scale);
            }

            final canvas = context.canvas;
            for (final obj in objects) {
              if (obj is DrawnLine) {
                if (obj.path.length < 2) continue;
                final pdfColor = PdfColor.fromInt(obj.color.value);
                canvas.setStrokeColor(pdfColor);
                canvas.setLineWidth(obj.width * scale);
                final points = obj.path
                    .map(
                      (p) =>
                          Offset(p.dx * scale, targetHeight - (p.dy * scale)),
                    )
                    .toList();
                canvas.moveTo(points.first.dx, points.first.dy);
                for (int i = 1; i < points.length; i++) {
                  canvas.lineTo(points[i].dx, points[i].dy);
                }
                canvas.strokePath();
              } else if (obj is DrawnShape) {
                final start = rotatePoint(obj.startPoint);
                final end = rotatePoint(obj.endPoint);
                final left = math.min(start.dx, end.dx);
                final right = math.max(start.dx, end.dx);
                final top = math.min(start.dy, end.dy);
                final bottom = math.max(start.dy, end.dy);
                final w = right - left;
                final h = bottom - top;
                final color = PdfColor.fromInt(obj.color.value);
                final fillColor =
                    obj.isFilled && obj.fillColor != Colors.transparent
                    ? PdfColor.fromInt(obj.fillColor.value)
                    : null;
                canvas.setLineWidth(obj.width * scale);
                canvas.setStrokeColor(color);
                switch (obj.type) {
                  case ShapeType.rectangle:
                    if (fillColor != null) {
                      canvas.setFillColor(fillColor);
                      canvas.drawRect(left, top, w, h);
                      canvas.fillPath();
                    }
                    canvas.drawRect(left, top, w, h);
                    canvas.strokePath();
                    break;
                  case ShapeType.circle:
                    final cx = (left + right) / 2;
                    final cy = (top + bottom) / 2;
                    final r = (w > h ? h : w) / 2;
                    if (fillColor != null) {
                      canvas.setFillColor(fillColor);
                      canvas.drawEllipse(cx, cy, r, r);
                      canvas.fillPath();
                    }
                    canvas.drawEllipse(cx, cy, r, r);
                    canvas.strokePath();
                    break;
                  case ShapeType.ellipse:
                    final cx = (left + right) / 2;
                    final cy = (top + bottom) / 2;
                    if (fillColor != null) {
                      canvas.setFillColor(fillColor);
                      canvas.drawEllipse(cx, cy, w / 2, h / 2);
                      canvas.fillPath();
                    }
                    canvas.drawEllipse(cx, cy, w / 2, h / 2);
                    canvas.strokePath();
                    break;
                  case ShapeType.line:
                    canvas.moveTo(start.dx, start.dy);
                    canvas.lineTo(end.dx, end.dy);
                    canvas.strokePath();
                    break;
                }
              }
            }
            // Return text widgets as overlay, rotated
            return pw.FullPage(
              ignoreMargins: true,
              child: pw.Stack(
                children: [
                  ...objects.whereType<DrawnText>().map((obj) {
                    final pos = rotatePoint(obj.position);
                    return pw.Positioned(
                      left: pos.dx,
                      top: pos.dy,
                      child: pw.Text(
                        obj.text,
                        style: pw.TextStyle(
                          color: PdfColor.fromInt(obj.color.value),
                          fontSize: obj.fontSize * scale,
                          font: pw.Font.helvetica(),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        ),
      );
      await saveFile(
        bytes: await pdf.save(),
        fileName: 'whiteboard_export',
        fileExtension: 'pdf',
      );
    }
  }

  Future<String?> saveFile({
    required List<int> bytes,
    String? fileName,
    String? fileExtension,
  }) async {
    String? outputPath;
    try {
      String? path = await FilePicker.platform.saveFile(
        dialogTitle: 'Save File',
        fileName: fileName,
        type: FileType.custom,
        allowedExtensions: fileExtension != null ? [fileExtension] : null,
      );
      if (path != null) {
        final file = File(path);
        await file.writeAsBytes(bytes, flush: true);
        outputPath = path;
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save file: $e')));
    }
    return outputPath;
  }

  Widget _buildDrawingArea() {
    return Expanded(
      child: Stack(
        children: [
          Container(
            color: Colors.white,
            width: double.infinity,
            child: GestureDetector(
              onTapDown: _onTapDown,
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: Container(
                key: paintKey,
                width: double.infinity,
                height: double.infinity,
                child: CustomPaint(
                  painter: WhiteboardPainter(
                    objects: objects,
                    currentObject: currentObject,
                    selectedObjects: selectedObjects,
                    selectionRect: selectionRect,
                  ),
                  size: Size.infinite,
                ),
              ),
            ),
          ),

          // Text editing overlay
          if (isEditingText && textPosition != null)
            Positioned(
              left: textPosition!.dx,
              top: textPosition!.dy,
              child: Container(
                width: 200,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: TextField(
                  controller: textController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Enter text...',
                    border: InputBorder.none,
                  ),
                  onSubmitted: _finishTextEditing,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildToolButton(DrawingTool tool, IconData icon, String tooltip) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Tooltip(
        message: tooltip,
        child: IconButton(
          onPressed: () => setState(() {
            selectedTool = tool;
            selectedObjects.clear();
            selectionRect = null;
          }),
          icon: Icon(icon),
          color: selectedTool == tool ? Colors.blue : Colors.black,
          style: IconButton.styleFrom(
            backgroundColor: selectedTool == tool
                ? Colors.blue.withOpacity(0.2)
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildCompactToolButton(
    DrawingTool tool,
    IconData icon,
    String tooltip,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Tooltip(
        message: tooltip,
        child: IconButton(
          onPressed: () => setState(() {
            selectedTool = tool;
            selectedObjects.clear();
            selectionRect = null;
          }),
          icon: Icon(icon, size: 18),
          color: selectedTool == tool ? Colors.orange : Colors.white,
          style: IconButton.styleFrom(
            backgroundColor: selectedTool == tool
                ? Colors.orange.withOpacity(0.3)
                : null,
            minimumSize: const Size(30, 30),
          ),
        ),
      ),
    );
  }

  Widget _buildColorButton(Color color, bool isForFill) {
    final currentColor = isForFill ? fillColor : selectedColor;
    return GestureDetector(
      onTap: () => setState(() {
        if (isForFill) {
          fillColor = color;
        } else {
          selectedColor = color;
        }
      }),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: color,
          border: currentColor == color
              ? Border.all(color: Colors.black, width: 2)
              : Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildCompactColorButton(Color color) {
    return GestureDetector(
      onTap: () => setState(() => selectedColor = color),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 1),
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: color,
          border: selectedColor == color
              ? Border.all(color: Colors.white, width: 2)
              : Border.all(color: Colors.white54, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _onTapDown(TapDownDetails details) {
    if (selectedTool == DrawingTool.text) {
      final renderBox =
          paintKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final localPosition = renderBox.globalToLocal(details.globalPosition);
        setState(() {
          textPosition = localPosition;
          isEditingText = true;
          textController.clear();
        });
      }
    } else if (selectedTool == DrawingTool.select && isFilled) {
      // Fill mode in select tool - fill clicked object
      final renderBox =
          paintKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final localPosition = renderBox.globalToLocal(details.globalPosition);
        final clickedObject = _findObjectAtPoint(localPosition);
        if (clickedObject != null) {
          _fillObject(clickedObject);
        }
      }
    }
  }

  void _onPanStart(DragStartDetails details) {
    final renderBox = paintKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final localPosition = renderBox.globalToLocal(details.globalPosition);

    if (selectedTool == DrawingTool.select) {
      // Check if we're clicking on an existing object
      final clickedObject = _findObjectAtPoint(localPosition);

      if (clickedObject != null) {
        // If fill mode is enabled, fill the object instead of selecting
        if (isFilled) {
          _fillObject(clickedObject);
          return;
        }

        // Normal selection behavior
        if (!selectedObjects.contains(clickedObject)) {
          selectedObjects.clear();
          selectedObjects.add(clickedObject);
        }
        isDragging = true;
        dragOffset = localPosition;
      } else {
        // Start selection rectangle
        selectedObjects.clear();
        selectionStart = localPosition;
        selectionRect = Rect.fromLTWH(localPosition.dx, localPosition.dy, 0, 0);
      }
    } else {
      // Create new drawing object
      selectedObjects.clear();
      selectionRect = null;

      switch (selectedTool) {
        case DrawingTool.pen:
          currentObject = DrawnLine(
            path: [localPosition],
            color: selectedColor,
            width: selectedWidth,
          );
          break;
        case DrawingTool.line:
          currentObject = DrawnShape(
            type: ShapeType.line,
            startPoint: localPosition,
            endPoint: localPosition,
            color: selectedColor,
            fillColor: Colors.transparent,
            width: selectedWidth,
            isFilled: false,
          );
          break;
        case DrawingTool.rectangle:
          currentObject = DrawnShape(
            type: ShapeType.rectangle,
            startPoint: localPosition,
            endPoint: localPosition,
            color: selectedColor,
            fillColor: isFilled ? fillColor : Colors.transparent,
            width: selectedWidth,
            isFilled: isFilled,
          );
          break;
        case DrawingTool.circle:
          currentObject = DrawnShape(
            type: ShapeType.circle,
            startPoint: localPosition,
            endPoint: localPosition,
            color: selectedColor,
            fillColor: isFilled ? fillColor : Colors.transparent,
            width: selectedWidth,
            isFilled: isFilled,
          );
          break;
        case DrawingTool.ellipse:
          currentObject = DrawnShape(
            type: ShapeType.ellipse,
            startPoint: localPosition,
            endPoint: localPosition,
            color: selectedColor,
            fillColor: isFilled ? fillColor : Colors.transparent,
            width: selectedWidth,
            isFilled: isFilled,
          );
          break;
        default:
          break;
      }
    }
    setState(() {});
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final renderBox = paintKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final localPosition = renderBox.globalToLocal(details.globalPosition);

    if (selectedTool == DrawingTool.select) {
      if (isDragging && selectedObjects.isNotEmpty && dragOffset != null) {
        // Move selected objects
        final delta = localPosition - dragOffset!;
        for (final obj in selectedObjects) {
          obj.move(delta);
        }
        dragOffset = localPosition;
      } else if (selectionStart != null) {
        // Update selection rectangle
        selectionRect = Rect.fromPoints(selectionStart!, localPosition);
      }
    } else if (currentObject != null) {
      if (currentObject is DrawnLine) {
        // Add point to free drawing
        final line = currentObject as DrawnLine;
        if ((localPosition - line.path.last).distance > 2.0) {
          final updatedLine = DrawnLine(
            path: List.from(line.path)..add(localPosition),
            color: line.color,
            width: line.width,
          );
          currentObject = updatedLine;
        }
      } else if (currentObject is DrawnShape) {
        // Update shape end point
        final shape = currentObject as DrawnShape;
        currentObject = DrawnShape(
          type: shape.type,
          startPoint: shape.startPoint,
          endPoint: localPosition,
          color: shape.color,
          fillColor: shape.fillColor,
          width: shape.width,
          isFilled: shape.isFilled,
        );
      }
    }
    setState(() {});
  }

  void _onPanEnd(DragEndDetails details) {
    if (selectedTool == DrawingTool.select) {
      if (selectionRect != null && selectionStart != null) {
        // Find objects in selection rectangle
        selectedObjects.clear();
        for (final obj in objects) {
          if (obj.intersects(selectionRect!)) {
            selectedObjects.add(obj);
          }
        }
        selectionRect = null;
        selectionStart = null;
      }
      isDragging = false;
      dragOffset = null;
    } else if (currentObject != null) {
      objects.add(currentObject!);
      currentObject = null;
    }
    setState(() {});
  }

  DrawingObject? _findObjectAtPoint(Offset point) {
    // Search from top to bottom (last drawn first)
    for (int i = objects.length - 1; i >= 0; i--) {
      if (objects[i].containsPoint(point)) {
        return objects[i];
      }
    }
    return null;
  }

  void _finishTextEditing(String text) {
    if (text.isNotEmpty && textPosition != null) {
      final textObject = DrawnText(
        text: text,
        position: textPosition!,
        color: selectedColor,
        fontSize: selectedWidth * 4, // Scale font size with brush size
      );
      objects.add(textObject);
    }
    setState(() {
      isEditingText = false;
      textPosition = null;
      textController.clear();
    });
  }

  void _clearAll() {
    setState(() {
      objects.clear();
      selectedObjects.clear();
      currentObject = null;
      selectionRect = null;
    });
  }

  void _deleteSelected() {
    setState(() {
      for (final obj in selectedObjects) {
        objects.remove(obj);
      }
      selectedObjects.clear();
    });
  }

  void _fillObject(DrawingObject object) {
    setState(() {
      if (object is DrawnShape) {
        // Create a new shape with updated fill properties
        final newShape = DrawnShape(
          type: object.type,
          startPoint: object.startPoint,
          endPoint: object.endPoint,
          color: object.color,
          fillColor: fillColor,
          width: object.width,
          isFilled: true,
        );

        // Replace the old object with the new one
        final index = objects.indexOf(object);
        if (index != -1) {
          objects[index] = newShape;

          // Update selection if this object was selected
          final selectionIndex = selectedObjects.indexOf(object);
          if (selectionIndex != -1) {
            selectedObjects[selectionIndex] = newShape;
          }
        }
      } else if (object is DrawnText) {
        // Update text color
        final newText = DrawnText(
          text: object.text,
          position: object.position,
          color: fillColor,
          fontSize: object.fontSize,
        );

        final index = objects.indexOf(object);
        if (index != -1) {
          objects[index] = newText;

          final selectionIndex = selectedObjects.indexOf(object);
          if (selectionIndex != -1) {
            selectedObjects[selectionIndex] = newText;
          }
        }
      } else if (object is DrawnLine) {
        // Update line stroke color
        final newLine = DrawnLine(
          path: List.from(object.path),
          color: fillColor,
          width: object.width,
        );

        final index = objects.indexOf(object);
        if (index != -1) {
          objects[index] = newLine;

          final selectionIndex = selectedObjects.indexOf(object);
          if (selectionIndex != -1) {
            selectedObjects[selectionIndex] = newLine;
          }
        }
      }
    });
  }
}

// Base class for all drawing objects
abstract class DrawingObject {
  void move(Offset delta);
  bool containsPoint(Offset point);
  bool intersects(Rect rect);
  void draw(Canvas canvas);
}

// Free drawing line
class DrawnLine extends DrawingObject {
  List<Offset> path;
  final Color color;
  final double width;

  DrawnLine({required this.path, required this.color, required this.width});

  @override
  void move(Offset delta) {
    path = path.map((point) => point + delta).toList();
  }

  @override
  bool containsPoint(Offset point) {
    const tolerance = 10.0;
    for (int i = 0; i < path.length - 1; i++) {
      final distance = _distanceToLineSegment(point, path[i], path[i + 1]);
      if (distance <= tolerance) return true;
    }
    return false;
  }

  @override
  bool intersects(Rect rect) {
    return path.any((point) => rect.contains(point));
  }

  @override
  void draw(Canvas canvas) {
    if (path.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = width
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    if (path.length == 1) {
      canvas.drawCircle(path.first, width / 2, paint);
    } else {
      final pathObj = Path();
      pathObj.moveTo(path.first.dx, path.first.dy);
      for (int i = 1; i < path.length; i++) {
        pathObj.lineTo(path[i].dx, path[i].dy);
      }
      canvas.drawPath(pathObj, paint);
    }
  }

  double _distanceToLineSegment(
    Offset point,
    Offset lineStart,
    Offset lineEnd,
  ) {
    final lineLength = (lineEnd - lineStart).distance;
    if (lineLength == 0) return (point - lineStart).distance;

    final t =
        ((point - lineStart).dx * (lineEnd - lineStart).dx +
            (point - lineStart).dy * (lineEnd - lineStart).dy) /
        (lineLength * lineLength);

    final clampedT = t.clamp(0.0, 1.0);
    final projection = lineStart + (lineEnd - lineStart) * clampedT;
    return (point - projection).distance;
  }
}

// Geometric shapes
enum ShapeType { line, rectangle, circle, ellipse }

class DrawnShape extends DrawingObject {
  final ShapeType type;
  Offset startPoint;
  Offset endPoint;
  final Color color;
  final Color fillColor;
  final double width;
  final bool isFilled;

  DrawnShape({
    required this.type,
    required this.startPoint,
    required this.endPoint,
    required this.color,
    required this.fillColor,
    required this.width,
    required this.isFilled,
  });

  @override
  void move(Offset delta) {
    startPoint += delta;
    endPoint += delta;
  }

  @override
  bool containsPoint(Offset point) {
    switch (type) {
      case ShapeType.line:
        const tolerance = 10.0;
        final distance = _distanceToLineSegment(point, startPoint, endPoint);
        return distance <= tolerance;
      case ShapeType.rectangle:
        final rect = Rect.fromPoints(startPoint, endPoint);
        return rect.contains(point);
      case ShapeType.circle:
        final center = (startPoint + endPoint) / 2;
        final radius = (endPoint - startPoint).distance / 2;
        return (point - center).distance <= radius;
      case ShapeType.ellipse:
        final rect = Rect.fromPoints(startPoint, endPoint);
        final center = rect.center;
        final a = rect.width / 2;
        final b = rect.height / 2;
        if (a == 0 || b == 0) return false;
        final dx = (point.dx - center.dx) / a;
        final dy = (point.dy - center.dy) / b;
        return (dx * dx + dy * dy) <= 1;
    }
  }

  @override
  bool intersects(Rect rect) {
    switch (type) {
      case ShapeType.line:
        return rect.contains(startPoint) || rect.contains(endPoint);
      case ShapeType.rectangle:
      case ShapeType.circle:
      case ShapeType.ellipse:
        final shapeRect = Rect.fromPoints(startPoint, endPoint);
        return rect.overlaps(shapeRect);
    }
  }

  @override
  void draw(Canvas canvas) {
    final strokePaint = Paint()
      ..color = color
      ..strokeWidth = width
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    switch (type) {
      case ShapeType.line:
        canvas.drawLine(startPoint, endPoint, strokePaint);
        break;
      case ShapeType.rectangle:
        final rect = Rect.fromPoints(startPoint, endPoint);
        if (isFilled && fillColor != Colors.transparent) {
          canvas.drawRect(rect, fillPaint);
        }
        canvas.drawRect(rect, strokePaint);
        break;
      case ShapeType.circle:
        final center = (startPoint + endPoint) / 2;
        final radius = (endPoint - startPoint).distance / 2;
        if (isFilled && fillColor != Colors.transparent) {
          canvas.drawCircle(center, radius, fillPaint);
        }
        canvas.drawCircle(center, radius, strokePaint);
        break;
      case ShapeType.ellipse:
        final rect = Rect.fromPoints(startPoint, endPoint);
        if (isFilled && fillColor != Colors.transparent) {
          canvas.drawOval(rect, fillPaint);
        }
        canvas.drawOval(rect, strokePaint);
        break;
    }
  }

  double _distanceToLineSegment(
    Offset point,
    Offset lineStart,
    Offset lineEnd,
  ) {
    final lineLength = (lineEnd - lineStart).distance;
    if (lineLength == 0) return (point - lineStart).distance;

    final t =
        ((point - lineStart).dx * (lineEnd - lineStart).dx +
            (point - lineStart).dy * (lineEnd - lineStart).dy) /
        (lineLength * lineLength);

    final clampedT = t.clamp(0.0, 1.0);
    final projection = lineStart + (lineEnd - lineStart) * clampedT;
    return (point - projection).distance;
  }
}

// Text objects
class DrawnText extends DrawingObject {
  String text;
  Offset position;
  final Color color;
  final double fontSize;

  DrawnText({
    required this.text,
    required this.position,
    required this.color,
    required this.fontSize,
  });

  @override
  void move(Offset delta) {
    position += delta;
  }

  @override
  bool containsPoint(Offset point) {
    // Approximate text bounds
    final textWidth = text.length * fontSize * 0.6;
    final textHeight = fontSize;
    final rect = Rect.fromLTWH(
      position.dx,
      position.dy - textHeight,
      textWidth,
      textHeight,
    );
    return rect.contains(point);
  }

  @override
  bool intersects(Rect rect) {
    final textWidth = text.length * fontSize * 0.6;
    final textHeight = fontSize;
    final textRect = Rect.fromLTWH(
      position.dx,
      position.dy - textHeight,
      textWidth,
      textHeight,
    );
    return rect.overlaps(textRect);
  }

  @override
  void draw(Canvas canvas) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: color, fontSize: fontSize, fontFamily: 'Arial'),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, position);
  }
}

// Custom painter for the whiteboard
class WhiteboardPainter extends CustomPainter {
  final List<DrawingObject> objects;
  final DrawingObject? currentObject;
  final List<DrawingObject> selectedObjects;
  final Rect? selectionRect;

  WhiteboardPainter({
    required this.objects,
    this.currentObject,
    required this.selectedObjects,
    this.selectionRect,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw all objects
    for (final obj in objects) {
      obj.draw(canvas);
    }

    // Draw current object being created
    currentObject?.draw(canvas);

    // Draw selection indicators
    final selectionPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    for (final obj in selectedObjects) {
      _drawSelectionBounds(canvas, obj, selectionPaint);
    }

    // Draw selection rectangle
    if (selectionRect != null) {
      DashPainter.drawDashedRect(canvas, selectionRect!, selectionPaint);
    }
  }

  void _drawSelectionBounds(Canvas canvas, DrawingObject obj, Paint paint) {
    Rect bounds;

    if (obj is DrawnLine) {
      if (obj.path.isEmpty) return;
      double minX = obj.path.first.dx;
      double maxX = obj.path.first.dx;
      double minY = obj.path.first.dy;
      double maxY = obj.path.first.dy;

      for (final point in obj.path) {
        minX = minX < point.dx ? minX : point.dx;
        maxX = maxX > point.dx ? maxX : point.dx;
        minY = minY < point.dy ? minY : point.dy;
        maxY = maxY > point.dy ? maxY : point.dy;
      }
      bounds = Rect.fromLTRB(minX - 5, minY - 5, maxX + 5, maxY + 5);
    } else if (obj is DrawnShape) {
      bounds = Rect.fromPoints(obj.startPoint, obj.endPoint).inflate(5);
    } else if (obj is DrawnText) {
      final textWidth = obj.text.length * obj.fontSize * 0.6;
      final textHeight = obj.fontSize;
      bounds = Rect.fromLTWH(
        obj.position.dx - 5,
        obj.position.dy - textHeight - 5,
        textWidth + 10,
        textHeight + 10,
      );
    } else {
      return;
    }

    DashPainter.drawDashedRect(canvas, bounds, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
