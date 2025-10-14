import 'package:flutter/material.dart';

class DashPainter {
  static void drawDashedRect(Canvas canvas, Rect rect, Paint paint, {List<double>? dashArray}) {
    dashArray ??= [5.0, 5.0];
    
    // Top edge
    _drawDashedLine(canvas, rect.topLeft, rect.topRight, paint, dashArray);
    // Right edge  
    _drawDashedLine(canvas, rect.topRight, rect.bottomRight, paint, dashArray);
    // Bottom edge
    _drawDashedLine(canvas, rect.bottomRight, rect.bottomLeft, paint, dashArray);
    // Left edge
    _drawDashedLine(canvas, rect.bottomLeft, rect.topLeft, paint, dashArray);
  }
  
  static void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint, List<double> dashArray) {
    final distance = (end - start).distance;
    final direction = (end - start) / distance;
    
    double currentDistance = 0;
    bool isDash = true;
    int dashIndex = 0;
    
    while (currentDistance < distance) {
      final dashLength = dashArray[dashIndex % dashArray.length];
      final nextDistance = (currentDistance + dashLength).clamp(0.0, distance);
      
      if (isDash) {
        final dashStart = start + direction * currentDistance;
        final dashEnd = start + direction * nextDistance;
        canvas.drawLine(dashStart, dashEnd, paint);
      }
      
      currentDistance = nextDistance;
      isDash = !isDash;
      dashIndex++;
    }
  }
}