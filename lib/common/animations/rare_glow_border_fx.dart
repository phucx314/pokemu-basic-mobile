import 'dart:ui' as ui; // Cần cho Shader
import 'package:flutter/material.dart';

class RarityGlowBorder extends StatefulWidget {
  final Widget child;
  final int? rarityId;
  final double cardWidth;
  final double cardHeight;
  final double borderRadius;

  const RarityGlowBorder({
    super.key,
    required this.child,
    required this.rarityId,
    required this.cardWidth,
    required this.cardHeight,
    this.borderRadius = 10.0,
  });

  @override
  State<RarityGlowBorder> createState() => _RarityGlowBorderState();
}

class _RarityGlowBorderState extends State<RarityGlowBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isRare = false;

  @override
  void initState() {
    super.initState();
    _isRare = (widget.rarityId ?? 1) >= 4; // Very Rare+

    if (_isRare) {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 3000), // Tốc độ: 3 giây 1 vòng
      )..repeat(); 

      _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.linear),
      );
    }
  }

  @override
  void dispose() {
    if (_isRare) {
      _controller.dispose();
    }
    super.dispose();
  }

  Color _getRarityColor() {
    switch (widget.rarityId) {
      // case 4: return Colors.blue.shade500;
      // case 5: return Colors.red.shade500;
      // case 6: return Colors.purple.shade500;
      case 4: return Colors.white;
      case 5: return Colors.purple.shade300;
      case 6: return Colors.yellow.shade500;
      default: return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isRare) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          // Dùng "foregroundPainter" để vẽ đè lên 'child'
          // (đè lên cả cạnh trong và ngoài)
          foregroundPainter: _GlowPainter(
            animationValue: _animation.value,
            glowColor: _getRarityColor(),
            width: widget.cardWidth,
            height: widget.cardHeight,
            borderRadius: widget.borderRadius,
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

// LỚP VẼ 
class _GlowPainter extends CustomPainter {
  final double animationValue; // 0.0 đến 1.0
  final Color glowColor;
  final double width;
  final double height;
  final double borderRadius;

  _GlowPainter({
    required this.animationValue,
    required this.glowColor,
    required this.width,
    required this.height,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Tạo viền bo góc
    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, width, height),
      Radius.circular(borderRadius),
    );
    final Path path = Path()..addRRect(rrect);

    // 2. Lấy thông số đường viền
    final ui.PathMetric pathMetric = path.computeMetrics().first;
    final double pathLength = pathMetric.length;

    // 3. Tính toán "đuôi" (20% chu vi)
    final double tailLength = pathLength * 0.20;
    // Tính điểm "đầu" của ánh sáng (chạy từ 0 -> 1.0)
    final double headPosition = pathLength * animationValue;
    // Tính điểm "đuôi" của ánh sáng
    final double tailPosition = (headPosition - tailLength);

    // 4. Lấy tọa độ (Offset) thật của "đầu" và "đuôi"
    final ui.Tangent? headTangent = pathMetric.getTangentForOffset(headPosition);
    final ui.Tangent? tailTangent = pathMetric.getTangentForOffset(tailPosition < 0 ? tailPosition + pathLength : tailPosition);

    if (headTangent == null || tailTangent == null) return;

    // 5. Trích xuất (extract) cái "đuôi"
    Path segmentPath = Path();
    if (tailPosition < 0) {
      // Nếu đuôi bị "vòng" qua điểm 0
      segmentPath.addPath(pathMetric.extractPath(tailPosition + pathLength, pathLength), Offset.zero);
      segmentPath.addPath(pathMetric.extractPath(0, headPosition), Offset.zero);
    } else {
      segmentPath = pathMetric.extractPath(tailPosition, headPosition);
    }

    // --- LỚP 1: LÕI SÁNG (Sắc nét) ---
    final Paint solidPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 5.0; // Độ dày lõi

    // 6. Dùng tọa độ thật để vẽ Gradient
    solidPaint.shader = ui.Gradient.linear(
      tailTangent.position, // << Tọa độ đuôi
      headTangent.position, // << Tọa độ đầu
      [
        glowColor.withOpacity(0.0), // Đuôi (mờ)
        Colors.white, // Đầu (sáng chói)
      ],
    );
    canvas.drawPath(segmentPath, solidPaint);

    // --- LỚP 2: VIỀN "GLOW" (Tỏa sáng) ---
    final Paint blurPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 12.0 // Độ dày vùng glow
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0); // Blur (mờ)
    
    // 7. Dùng cùng 1 Shader
    blurPaint.shader = solidPaint.shader;
    
    canvas.drawPath(segmentPath, blurPaint);
  }

  @override
  bool shouldRepaint(covariant _GlowPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}