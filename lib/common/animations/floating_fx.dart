import 'package:flutter/material.dart';

class FloatingWidget extends StatefulWidget {
  final Widget child; // Widget m muốn cho nó "nổi"
  final Duration duration; // Thời gian cho 1 chu kỳ lên-xuống
  final double verticalOffset; // Biên độ nhấp nhô (cao bao nhiêu px)

  const FloatingWidget({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 2), // Mặc định 2 giây
    this.verticalOffset = 10.0, // Mặc định nhấp nhô 10px
  });

  @override
  State<FloatingWidget> createState() => _FloatingWidgetState();
}

class _FloatingWidgetState extends State<FloatingWidget>
    with SingleTickerProviderStateMixin { // Cần cái này cho AnimationController
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // Tạo Tween để di chuyển widget lên/xuống theo trục Y
    _animation = Tween<Offset>(
      begin: Offset(0.0, -widget.verticalOffset / widget.duration.inMilliseconds), // Bắt đầu ở trên 1 chút
      end: Offset(0.0, widget.verticalOffset / widget.duration.inMilliseconds),   // Kết thúc ở dưới 1 chút
    ).animate(
      // Dùng CurvedAnimation để chuyển động mượt hơn (ví dụ: easeInOut)
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Bắt đầu animation và cho nó lặp lại, đảo chiều (reverse: true)
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose(); // Nhớ dispose controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Dùng SlideTransition để áp dụng animation offset
    return SlideTransition(
      position: _animation,
      child: widget.child,
    );
  }
}