import 'package:flutter/material.dart';
import 'dart:math' as math; // Import math cho sin/cos/pi

class InteractiveTiltImage extends StatefulWidget {
  final String imageUrl;
  final double maxTiltAngle; // Góc nghiêng tối đa
  final Duration animationDuration; // Thời gian ảnh trở về vị trí cũ

  final BoxFit boxFit;
  final double imageHeight;
  // final double? imageWidth;

  const InteractiveTiltImage({
    super.key,
    required this.imageUrl,
    this.maxTiltAngle = 0.1, // Góc nghiêng tối đa theo radian (khoảng 5.7 độ)
    this.animationDuration = const Duration(milliseconds: 200), 
    this.boxFit = BoxFit.cover, 
    this.imageHeight = 100, 
    // this.imageWidth = 100,
  });

  @override
  State<InteractiveTiltImage> createState() => _InteractiveTiltImageState();
}

class _InteractiveTiltImageState extends State<InteractiveTiltImage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _tiltAnimation;

  // Lưu trữ độ lệch (từ 0 đến 1) của ngón tay trên ảnh
  Offset _currentPanOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.animationDuration);
    _tiltAnimation = Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Hàm được gọi khi ngón tay bắt đầu chạm và di chuyển
  void _onPanUpdate(DragUpdateDetails details, BoxConstraints constraints) {
    setState(() {
      // Tính toán vị trí tương đối của ngón tay trên ảnh (từ -0.5 đến 0.5)
      // details.localPosition là vị trí chạm so với widget
      // constraints.maxWidth/height là kích thước của widget
      final x = (details.localPosition.dx / constraints.maxWidth) - 0.5;
      final y = (details.localPosition.dy / constraints.maxHeight) - 0.5;
      _currentPanOffset = Offset(x, y);
    });
  }

  // Hàm được gọi khi thả ngón tay
  void _onPanEnd(DragEndDetails details) {
    // Tạo animation để ảnh quay về vị trí ban đầu
    _tiltAnimation = Tween<Offset>(begin: _currentPanOffset, end: Offset.zero).animate(_controller);
    _controller.forward(from: 0.0).then((_) {
      setState(() {
        _currentPanOffset = Offset.zero; // Reset sau animation
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder( // Dùng LayoutBuilder để lấy kích thước của widget
      builder: (context, constraints) {
        return GestureDetector(
          onPanUpdate: (details) => _onPanUpdate(details, constraints),
          onPanEnd: _onPanEnd,
          child: AnimatedBuilder( // Dùng AnimatedBuilder để lắng nghe animation
            animation: _tiltAnimation,
            builder: (context, child) {
              final effectiveOffset = _controller.isAnimating ? _tiltAnimation.value : _currentPanOffset;   

              // Tính toán góc xoay dựa trên độ lệch và góc tối đa
              final double rotateX = effectiveOffset.dy * widget.maxTiltAngle; // Vuốt lên/xuống -> xoay quanh trục X
              final double rotateY = -effectiveOffset.dx * widget.maxTiltAngle;   // Vuốt trái/phải -> xoay quanh trục Y

              return Transform(
                alignment: FractionalOffset.center, // Điểm xoay là giữa ảnh
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // Thêm hiệu ứng phối cảnh 3D nhẹ
                  ..rotateX(rotateX)
                  ..rotateY(rotateY),
                child: child,
              );
            },
            child: Image.network(
              widget.imageUrl,
              fit: widget.boxFit,
              height: widget.imageHeight,
            ),
          ),
        );
      },
    );
  }
}

// // Sửa InteractiveTiltImage:
// class InteractiveTiltImage extends StatefulWidget {
//   final Widget child; // << Thay thế imageUrl bằng child
//   final double maxTiltAngle;
//   final Duration animationDuration;

//   const InteractiveTiltImage({
//     super.key,
//     required this.child, // << Yêu cầu child
//     this.maxTiltAngle = 0.1,
//     this.animationDuration = const Duration(milliseconds: 200),
//   });

//   @override
//   State<InteractiveTiltImage> createState() => _InteractiveTiltImageState();
// }

// class _InteractiveTiltImageState extends State<InteractiveTiltImage> with SingleTickerProviderStateMixin {

// late AnimationController _controller;
//   late Animation<Offset> _tiltAnimation;

//   // Lưu trữ độ lệch (từ 0 đến 1) của ngón tay trên ảnh
//   Offset _currentPanOffset = Offset.zero;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(vsync: this, duration: widget.animationDuration);
//     _tiltAnimation = Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(_controller);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   // Hàm được gọi khi ngón tay bắt đầu chạm và di chuyển
//   void _onPanUpdate(DragUpdateDetails details, BoxConstraints constraints) {
//     setState(() {
//       // Tính toán vị trí tương đối của ngón tay trên ảnh (từ -0.5 đến 0.5)
//       // details.localPosition là vị trí chạm so với widget
//       // constraints.maxWidth/height là kích thước của widget
//       final x = (details.localPosition.dx / constraints.maxWidth) - 0.5;
//       final y = (details.localPosition.dy / constraints.maxHeight) - 0.5;
//       _currentPanOffset = Offset(x, y);
//     });
//   }

//   // Hàm được gọi khi thả ngón tay
//   void _onPanEnd(DragEndDetails details) {
//     // Tạo animation để ảnh quay về vị trí ban đầu
//     _tiltAnimation = Tween<Offset>(begin: _currentPanOffset, end: Offset.zero).animate(_controller);
//     _controller.forward(from: 0.0).then((_) {
//       setState(() {
//         _currentPanOffset = Offset.zero; // Reset sau animation
//       });
//     });
//   }

// @override
// Widget build(BuildContext context) {
//   return LayoutBuilder(
//     builder: (context, constraints) {
//       return GestureDetector(
//         onPanUpdate: (details) => _onPanUpdate(details, constraints),
//         onPanEnd: _onPanEnd,
//         child: AnimatedBuilder(
//           animation: _tiltAnimation,
//           builder: (context, child) {
//             final effectiveOffset = _controller.isAnimating ? _tiltAnimation.value : _currentPanOffset;
//             final double rotateX = effectiveOffset.dy * widget.maxTiltAngle;
//             final double rotateY = effectiveOffset.dx * widget.maxTiltAngle;

//             return Transform(
//               alignment: FractionalOffset.center,
//               transform: Matrix4.identity()
//                 ..setEntry(3, 2, 0.001)
//                 ..rotateX(rotateX)
//                 ..rotateY(rotateY),
//               child: child, // << Trả về child được truyền vào
//             );
//           },
//           child: widget.child, // << Truyền child của InteractiveTiltImage vào AnimatedBuilder
//         ),
//       );
//     },
//   );
// }}