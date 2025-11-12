import 'package:flutter/material.dart';

class InteractiveTiltImage extends StatefulWidget {
  final Widget child;
  final double maxTiltAngle; // Góc nghiêng tối đa
  final Duration animationDuration; // Thời gian ảnh trở về vị trí cũ
  final bool isHolo; // <<< THÊM CỜ "HOLO"
  final int? raraityId;

  const InteractiveTiltImage({
    super.key,
    required this.child,
    this.maxTiltAngle = 0.1, // Góc nghiêng tối đa theo radian (khoảng 5.7 độ)
    this.animationDuration = const Duration(milliseconds: 200), 
    this.isHolo = true, // Mặc định là có
    this.raraityId,
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
            animation: _controller,
            builder: (context, child) {
              final effectiveOffset = _controller.isAnimating ? _tiltAnimation.value : _currentPanOffset;   

              // Tính toán góc xoay dựa trên độ lệch và góc tối đa
              final double rotateX = effectiveOffset.dy * widget.maxTiltAngle * 2; // Vuốt lên/xuống -> xoay quanh trục X
              final double rotateY = -effectiveOffset.dx * widget.maxTiltAngle;   // Vuốt trái/phải -> xoay quanh trục Y

              // TẠO HOLO (BẰNG STACK)
              Widget holoChild = Stack(
                fit: StackFit.expand,
                
                children: [
                  // LỚP 1: ẢNH CARD (NỀN)
                  widget.child,

                  // LỚP 2: HOLO TEXTURE (NỔI LÊN)
                  if (widget.isHolo && widget.raraityId == 4 || widget.raraityId == 6)
                    // 3. BỌC BẰNG "Transform.translate"
                    Transform.translate(
                      // 4. "LÁI" (DRIVE) CÁI TRANSLATE NÀY
                      //    Nó sẽ di chuyển cái ảnh holo theo ngón tay
                      //    (M có thể nhân 10.0, 20.0, 30.0... để chỉnh "độ" parallax)
                      offset: Offset(
                        effectiveOffset.dx * 20.0, // Di chuyển ngang
                        effectiveOffset.dy * 20.0  // Di chuyển dọc
                      ),
                      child: Opacity(
                        // ... (opacity logic của m y chang cũ)
                        opacity: 0.5, 
                        
                        // 5. BỌC BẰNG "Transform.scale"
                        child: Transform.scale(
                          // 6. PHÓNG TO HOLO LÊN 1 CHÚT (ví dụ: 1.15 = 15%)
                          //    Cái này BẮT BUỘC, để khi m translate nó không bị hụt
                          scale: 1, 
                          child: Image.asset(
                            'assets/images/parallax_texture.png',
                            fit: BoxFit.fitWidth,
                            colorBlendMode: BlendMode.overlay,
                          ),
                        ),
                      ),
                    ),

                  if (widget.isHolo && widget.raraityId == 5)
                    Opacity(
                      opacity: (effectiveOffset.dy.abs() * 0.8 + 0.1).clamp(0.1, 0.5), // 0.1 -> 0.5
                      child: Image.asset(
                        'assets/images/holo_dots_texture.png',
                        fit: BoxFit.fitWidth,
                        colorBlendMode: BlendMode.screen, 
                      ),
                    ),

                  if (widget.isHolo && widget.raraityId == 6 || widget.raraityId == 3 || widget.raraityId == 2)
                    Opacity(
                      opacity: (effectiveOffset.dy.abs() * 0.8 + 0.1).clamp(0.1, 0.5), // 0.1 -> 0.5
                      child: Image.asset(
                        'assets/images/holo_texture.png',
                        fit: BoxFit.fitWidth,
                        colorBlendMode: BlendMode.colorDodge, 
                      ),
                    ),
                ],
              );

              return Transform(
                alignment: FractionalOffset.center, // Điểm xoay là giữa ảnh
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // Thêm hiệu ứng phối cảnh 3D nhẹ
                  ..rotateX(rotateX)
                  ..rotateY(rotateY),
                child: holoChild,
              );
            },
            child: widget.child,
          ),
        );
      },
    );
  }
}

// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'dart:ui' as ui; // <<< 1. THÊM IMPORT NÀY

// // 1. ĐỊNH NGHĨA CÁC KIỂU HOLO
// enum HoloEffectType {
//   linear, // 1 dải sáng
//   cross,  // 2 dải sáng đan chéo
//   circle, // 1 vầng sáng tròn
//   shatter, // 4 dải
//   randomStripe,
// }

// // 2. THÊM CLASS HELPER NÀY VÀO TRÊN CÙNG
// class _SlideGradientTransform extends GradientTransform {
//   final double percentX;
//   final double percentY;

//   // percentX/Y sẽ là offset từ -0.5 đến 0.5
//   const _SlideGradientTransform(this.percentX, this.percentY);

//   @override
//   Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
//     // Dịch (translate) gradient theo TỌA ĐỘ
//     // * 2.0 để nó trượt từ -1.0 đến 1.0 (trượt hết card)
//     final slideX = bounds.width * percentX * 2.0; 
//     final slideY = bounds.height * percentY * 2.0;
    
//     return Matrix4.translationValues(slideX, slideY, 0.0);
//   }
// }

// // 3. CLASS HELPER THỨ 2 (CHO DẢI SÁNG NGƯỢC LẠI)
// class _SlideGradientTransformCross extends GradientTransform {
//   final double percentX;
//   final double percentY;
//   const _SlideGradientTransformCross(this.percentX, this.percentY);

//   @override
//   Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
//     // Nó trượt ngược lại (TopRight -> BottomLeft)
//     final slideX = bounds.width * -percentX * 2.0; // << Đảo dấu X
//     final slideY = bounds.height * percentY * 2.0;
//     return Matrix4.translationValues(slideX, slideY, 0.0);
//   }
// }

// class InteractiveTiltImage extends StatefulWidget {
//   final Widget child;
//   final double maxTiltAngle; // Góc nghiêng tối đa
//   final Duration animationDuration; // Thời gian ảnh trở về vị trí cũ
//   // final bool isHolo; // <<< 3. THÊM PROP "isHolo"
//   final bool enableHolo; // << Đổi tên isHolo
//   final HoloEffectType holoType; // << PROP MỚI ĐỂ CHỌN HIỆU ỨNG

//   const InteractiveTiltImage({
//     super.key,
//     required this.child,
//     this.maxTiltAngle = 0.1, // Góc nghiêng tối đa theo radian (khoảng 5.7 độ)
//     this.animationDuration = const Duration(milliseconds: 200), 
//     // this.isHolo = true, // Mặc định là 'true'
//     this.enableHolo = true, // Mặc định là 'true'
//     this.holoType = HoloEffectType.linear, // Mặc định là dải sáng
//   });

//   @override
//   State<InteractiveTiltImage> createState() => _InteractiveTiltImageState();
// }

// class _InteractiveTiltImageState extends State<InteractiveTiltImage> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<Offset> _tiltAnimation;

//   // Lưu trữ độ lệch (từ 0 đến 1) của ngón tay trên ảnh
//   Offset _currentPanOffset = Offset.zero;

//   // <<< THÊM 2 BIẾN STATE MỚI ĐỂ GIỮ DẢI MÀU NGẪU NHIÊN >>>
//   List<Color> _randomColors = [];
//   List<double> _randomStops = [];

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(vsync: this, duration: widget.animationDuration);
//     // _tiltAnimation = Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(_controller);
//     // Sửa lại: Dùng Curve cho nó "mượt" khi thả tay
//     _tiltAnimation = Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeOut)
//     );

//     // 5. TẠO DẢI MÀU NGẪU NHIÊN (CHẠY 1 LẦN)
//     if (widget.enableHolo && widget.holoType == HoloEffectType.randomStripe) {
//       _generateRandomStripes();
//     }
//   }

//   // 6. THÊM HÀM TẠO DẢI MÀU
//   void _generateRandomStripes() {
//     final random = Random();
//     _randomColors.add(Colors.transparent);
//     _randomStops.add(0.0);

//     double currentStop = 0.0;
//     // Tạo khoảng 7-12 vệt sáng
//     int stripeCount = random.nextInt(6) + 7; 

//     for (int i = 0; i < stripeCount; i++) {
//       // 1. Khoảng cách (spacing) ngẫu nhiên
//       currentStop += random.nextDouble() * 0.15; // (0% -> 15% cách)
//       if (currentStop >= 1.0) break;
//       _randomColors.add(Colors.transparent);
//       _randomStops.add(currentStop);

//       // 2. Chiều rộng (width) ngẫu nhiên
//       final width = random.nextDouble() * 0.05; // (0% -> 5% rộng)
//       currentStop += width;
//       if (currentStop >= 1.0) break;

//       // 3. Màu (color) ngẫu nhiên (với opacity ngẫu nhiên)
//       final color = Colors.white.withOpacity(random.nextDouble() * 0.4 + 0.1); // Opacity 0.1 -> 0.5
//       _randomColors.add(color);
//       _randomStops.add(currentStop);
//     }

//     _randomColors.add(Colors.transparent);
//     _randomStops.add(1.0);
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
//     _controller.forward(from: 0.0)
//       .then((_) {
//         setState(() {
//           _currentPanOffset = Offset.zero; // Reset sau animation
//         });
//       }
//     );
//   }

//   //// CÁC HIỆU ỨNG HOLO KHÁC NHAU
//   // HIỆU ỨNG 1: LINEAR (CÁI CŨ)
//   Widget _buildLinearHolo(Offset offset, Widget child) {
//     final invertedOffset = -offset;

//     return ShaderMask(
//       blendMode: BlendMode.colorDodge,
//       shaderCallback: (Rect bounds) {
//         return LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             Colors.transparent, 
//             Colors.white.withOpacity(0.1),
//             Colors.white.withOpacity(0.4), 
//             Colors.white.withOpacity(0.1),
//             Colors.transparent,
//           ],
//           stops: const [ 0.0, 0.35, 0.5, 0.65, 1.0 ],
//           transform: _SlideGradientTransform(invertedOffset.dx, invertedOffset.dy),
//         ).createShader(bounds);
//       },
//       child: child,
//     );
//   }

//   // HIỆU ỨNG 2: CROSS (ĐAN CHÉO)
//   Widget _buildCrossHolo(Offset offset, Widget child) {
//     final invertedOffset = -offset;

//     // Dùng 2 ShaderMask lồng nhau
//     return ShaderMask(
//       blendMode: BlendMode.screen,
//       shaderCallback: (Rect bounds) {
//         return LinearGradient(
//           begin: Alignment.topLeft, end: Alignment.bottomRight,
//           colors: [
//             Colors.transparent, Colors.white.withOpacity(0.1),
//             Colors.white.withOpacity(0.3), Colors.white.withOpacity(0.1),
//             Colors.transparent,
//           ],
//           stops: const [ 0.0, 0.35, 0.5, 0.65, 1.0 ],
//           transform: _SlideGradientTransform(invertedOffset.dx, invertedOffset.dy),
//         ).createShader(bounds);
//       },
//       // Lồng mask 2 (chạy ngược lại)
//       child: ShaderMask(
//         blendMode: BlendMode.screen,
//         shaderCallback: (Rect bounds) {
//           return LinearGradient(
//             begin: Alignment.topRight, end: Alignment.bottomLeft, // << Ngược lại
//             colors: [
//               Colors.transparent, Colors.white.withOpacity(0.1),
//               Colors.white.withOpacity(0.3), Colors.white.withOpacity(0.1),
//               Colors.transparent,
//             ],
//             stops: const [ 0.0, 0.35, 0.5, 0.65, 1.0 ],
//             transform: _SlideGradientTransformCross(invertedOffset.dx, invertedOffset.dy), // << Dùng transform 2
//           ).createShader(bounds);
//         },
//         child: child,
//       ),
//     );
//   }

//   // HIỆU ỨNG 3: CIRCLE (VÒNG TRÒN)
//   Widget _buildCircleHolo(Offset offset, Widget child) {
//     final invertedOffset = -offset;

//     // Map offset (-0.5 -> 0.5) thành Alignment (-1.0 -> 1.0)
//     final alignX = invertedOffset.dx * 2.0;
//     final alignY = invertedOffset.dy * 2.0;

//     return ShaderMask(
//       blendMode: BlendMode.screen,
//       shaderCallback: (Rect bounds) {
//         return RadialGradient(
//           center: Alignment(alignX, alignY), // << Tâm vòng tròn di chuyển
//           radius: 0.7, // Bán kính
//           colors: [
//             Colors.white.withOpacity(0.5), // Lõi sáng
//             Colors.transparent,
//           ],
//           stops: const [0.0, 0.8], // Mờ dần ra
//         ).createShader(bounds);
//       },
//       child: child,
//     );
//   }

//   // 6. <<< THÊM HIỆU ỨNG MỚI: SHATTER (4 DẢI) >>>
//   Widget _buildShatterHolo(Offset offset, Widget child) {
//     final invertedOffset = -offset;

//     // Dải màu 1 (2 vệt sáng)
//     final gradient1 = LinearGradient(
//       begin: Alignment.topLeft,
//       end: Alignment.bottomRight,
//       colors: [
//         Colors.transparent,
//         Colors.white.withOpacity(0.2), // Vệt 1
//         Colors.transparent,
//         Colors.transparent, // Khoảng trống
//         Colors.white.withOpacity(0.3), // Vệt 2
//         Colors.transparent,
//       ],
//       stops: const [
//         0.0,    // Bắt đầu
//         0.1,    // Vệt 1
//         0.2,
//         0.6,    // Khoảng trống
//         0.7,    // Vệt 2
//         0.9,
//       ],
//       transform: _SlideGradientTransform(invertedOffset.dx, invertedOffset.dy),
//     );

//     // Dải màu 2 (2 vệt sáng, chạy ngược)
//     final gradient2 = LinearGradient(
//       begin: Alignment.topRight,
//       end: Alignment.bottomLeft,
//       colors: [
//         Colors.transparent,
//         Colors.white.withOpacity(0.2), // Vệt 3
//         Colors.transparent,
//         Colors.transparent, // Khoảng trống
//         Colors.white.withOpacity(0.3), // Vệt 4
//         Colors.transparent,
//       ],
//       stops: const [
//         0.1,    // Bắt đầu (hơi trễ 1 tí)
//         0.2,    // Vệt 3
//         0.3,
//         0.5,    // Khoảng trống
//         0.8,    // Vệt 4
//         1.0,
//       ],
//       transform: _SlideGradientTransformCross(invertedOffset.dx, invertedOffset.dy),
//     );

//     // Chồng 2 dải (mỗi dải 2 vệt)
//     return ShaderMask(
//       blendMode: BlendMode.screen,
//       shaderCallback: (Rect bounds) => gradient1.createShader(bounds),
//       child: ShaderMask(
//         blendMode: BlendMode.screen,
//         shaderCallback: (Rect bounds) => gradient2.createShader(bounds),
//         child: child,
//       ),
//     );
//   }

//   // 7. THÊM HÀM BUILD HIỆU ỨNG SỐ 5
//   Widget _buildRandomStripeHolo(Offset offset, Widget child) {
//     final invertedOffset = -offset;
    
//     return ShaderMask(
//       blendMode: BlendMode.screen,
//       shaderCallback: (Rect bounds) {
//         return LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           // 8. DÙNG 2 LIST NGẪU NHIÊN ĐÃ TẠO
//           colors: _randomColors,
//           stops: _randomStops,
//           // 9. VẪN LÁI BẰNG NGÓN TAY
//           transform: _SlideGradientTransform(invertedOffset.dx, invertedOffset.dy),
//         ).createShader(bounds);
//       },
//       child: child,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder( // Dùng LayoutBuilder để lấy kích thước của widget
//       builder: (context, constraints) {
//         return GestureDetector(
//           onPanUpdate: (details) => _onPanUpdate(details, constraints),
//           onPanEnd: _onPanEnd,
//           child: AnimatedBuilder( // Dùng AnimatedBuilder để lắng nghe animation
//             animation: _tiltAnimation, // Sửa: Nghe _controller (vì _tiltAnimation gán lại)
//             builder: (context, child) {
//               final effectiveOffset = _controller.isAnimating ? _tiltAnimation.value : _currentPanOffset;   

//               // Tính toán góc xoay dựa trên độ lệch và góc tối đa
//               final double rotateX = effectiveOffset.dy * widget.maxTiltAngle * 2; // Vuốt lên/xuống -> xoay quanh trục X
//               final double rotateY = -effectiveOffset.dx * widget.maxTiltAngle * 2;   // Vuốt trái/phải -> xoay quanh trục Y

//               // Widget holoChild = widget.enableHolo
//               //   ? ShaderMask(
//               //       blendMode: BlendMode.screen, // Hiệu ứng "overlay"
//               //       shaderCallback: (Rect bounds) {
//               //         return LinearGradient(
//               //           begin: Alignment.topLeft,
//               //           end: Alignment.bottomRight,
//               //           colors: [
//               //             Colors.transparent,
//               //             Colors.white.withOpacity(0.1),
//               //             Colors.white.withOpacity(0.4), // Lõi sáng
//               //             Colors.white.withOpacity(0.1),
//               //             Colors.transparent,
//               //           ],
//               //           stops: const [ 0.0, 0.35, 0.5, 0.65, 1.0 ],
//               //           // 3. LÁI GRADIENT BẰNG OFFSET TILT
//               //           transform: _SlideGradientTransform(
//               //             effectiveOffset.dx, // -0.5 đến 0.5
//               //             effectiveOffset.dy  // -0.5 đến 0.5
//               //           ),
//               //         ).createShader(bounds);
//               //       },
//               //       child: widget.child,
//               //     )
//               //   : widget.child; // Nếu không holo thì trả ảnh gốc

//               // 6. CHỌN HIỆU ỨNG HOLO
//               Widget holoChild;
//               if (!widget.enableHolo) {
//                 holoChild = widget.child;
//               } else {
//                 // "Render" hiệu ứng holo
//                 switch (widget.holoType) {
//                   case HoloEffectType.linear:
//                     holoChild = _buildLinearHolo(effectiveOffset, widget.child);
//                     break;
//                   case HoloEffectType.cross:
//                     holoChild = _buildCrossHolo(effectiveOffset, widget.child);
//                     break;
//                   case HoloEffectType.circle:
//                     holoChild = _buildCircleHolo(effectiveOffset, widget.child);
//                     break;
//                   case HoloEffectType.shatter:
//                     holoChild = _buildShatterHolo(effectiveOffset, widget.child);
//                     break;
//                   case HoloEffectType.randomStripe:
//                     holoChild = _buildRandomStripeHolo(effectiveOffset, widget.child);
//                     break;
//                 }
//               }

//               return Transform(
//                 alignment: FractionalOffset.center, // Điểm xoay là giữa ảnh
//                 transform: Matrix4.identity()
//                   ..setEntry(3, 2, 0.001) // Thêm hiệu ứng phối cảnh 3D nhẹ
//                   ..rotateX(rotateX)
//                   ..rotateY(rotateY),
//                 child: holoChild,
//               );
//             },
//             child: widget.child,
//           ),
//         );
//       },
//     );
//   }
// }