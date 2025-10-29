import 'package:flutter/material.dart';
import 'dart:math' as math;

class HoloPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Vẽ các chấm sáng ngẫu nhiên
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final random = math.Random();
    for (int i = 0; i < 50; i++) { // Vẽ 50 chấm
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      canvas.drawCircle(Offset(x, y), random.nextDouble() * 1 + 0.5, paint); // Chấm nhỏ
    }

    // Vẽ các đường sáng mờ
    paint.color = Colors.blue.withOpacity(0.1);
    paint.strokeWidth = 1;
    for (int i = 0; i < 10; i++) {
      final x1 = random.nextDouble() * size.width;
      final y1 = random.nextDouble() * size.height;
      final x2 = random.nextDouble() * size.width;
      final y2 = random.nextDouble() * size.height;
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}