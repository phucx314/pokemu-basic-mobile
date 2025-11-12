import 'package:flutter/material.dart';

// 1. TẠO 1 CLASS GradientTransform TÙY CHỈNH
//    Nó sẽ "trượt" (slide) cái gradient của m
class _SlideGradientTransform extends GradientTransform {
  final double slidePercent; // 0.0 (bắt đầu) -> 1.0 (kết thúc)

  const _SlideGradientTransform(this.slidePercent);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    // 2. Dịch (translate) cái gradient
    //    slidePercent = 0.0 -> slide = -1.0 (gradient ở ngoài, bên trái)
    //    slidePercent = 0.5 -> slide = 0.0 (gradient ở giữa)
    //    slidePercent = 1.0 -> slide = 1.0 (gradient ở ngoài, bên phải)
    final slide = (slidePercent * 2.0) - 1.0; 
    
    // 3. Trượt chéo (từ TopLeft -> BottomRight)
    return Matrix4.translationValues(bounds.width * slide, bounds.height * slide, 0.0);
  }
}

// 4. WIDGET CHÍNH (M SẼ DÙNG CÁI NÀY)
class HoloCardEffect extends StatefulWidget {
  final Widget child; // Đây là cái ảnh card của m
  final bool isRare;    // Chỉ chạy hiệu ứng nếu card hiếm
  final Duration duration;

  const HoloCardEffect({
    super.key,
    required this.child,
    this.isRare = false,
    this.duration = const Duration(milliseconds: 2500), // Tốc độ chạy: 2.5 giây
  });

  @override
  State<HoloCardEffect> createState() => _HoloCardEffectState();
}

class _HoloCardEffectState extends State<HoloCardEffect>
    with SingleTickerProviderStateMixin { // <<< 5. Cần Ticker
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // 6. Chỉ khởi tạo animation nếu card hiếm
    if (widget.isRare) {
      _controller = AnimationController(
        vsync: this,
        duration: widget.duration,
      )..repeat(reverse: false); // Lặp lại vô hạn
    }
  }

  @override
  void dispose() {
    if (widget.isRare) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isRare) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          // --- SỬA BLENDMODE Ở ĐÂY ---
          // BlendMode.overlay: Pha trộn màu sắc và độ sáng theo cách "phim ảnh" hơn.
          //                    Màu sáng sẽ làm sáng hơn, màu tối sẽ làm tối hơn.
          // BlendMode.hardLight: Tương tự overlay nhưng mạnh hơn.
          // BlendMode.colorDodge: Làm sáng các vùng ảnh theo màu của gradient.
          blendMode: BlendMode.hardLight, // <<<< Đổi thành `overlay` hoặc `hardLight`
                                        //      (Thử cả 2 xem cái nào đẹp hơn)
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.transparent,
                Colors.white.withOpacity(0.1), 
                Colors.white.withOpacity(0.4), 
                Colors.white.withOpacity(0.1), 
                Colors.transparent,
              ],
              stops: const [
                0.0,
                0.4,
                0.5,
                0.6,
                1.0,
              ],
              transform: _SlideGradientTransform(_controller.value),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}