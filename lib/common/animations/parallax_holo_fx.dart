import 'dart:math';
import 'package:flutter/material.dart';

class ParallaxHoloCard extends StatefulWidget {
  final Widget child; // your card image widget
  final double width;
  final double height;

  const ParallaxHoloCard({
    super.key,
    required this.child,
    required this.width,
    required this.height,
  });

  @override
  State<ParallaxHoloCard> createState() => _ParallaxHoloCardState();
}

class _ParallaxHoloCardState extends State<ParallaxHoloCard> {
  Offset _pointer = Offset.zero; // normalized (-0.5..0.5)

  void _onPanUpdate(DragUpdateDetails d) {
    final local = d.localPosition;
    final nx = (local.dx / widget.width) - 0.5;
    final ny = (local.dy / widget.height) - 0.5;
    setState(() => _pointer = Offset(nx.clamp(-0.5, 0.5), ny.clamp(-0.5, 0.5)));
  }

  void _onPanEnd(DragEndDetails d) {
    setState(() => _pointer = Offset.zero);
  }

  @override
  Widget build(BuildContext context) {
    // multipliers — tune these
    final bandMult = Offset(_pointer.dx * 40, _pointer.dy * 12); // vệt sáng di chuyển nhiều theo X
    final rainbowMult = Offset(_pointer.dx * 12, _pointer.dy * 6); // rainbow nhẹ
    final noiseMult = Offset(_pointer.dx * 6, _pointer.dy * 3); // noise subtle

    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // base card
            widget.child,
            // wide soft rainbow overlay (low opacity)
            Transform.translate(
              offset: Offset(rainbowMult.dx, rainbowMult.dy),
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.25,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(-1.0, -0.3),
                        end: Alignment(1.0, 0.3),
                        colors: [
                          Colors.pink.withOpacity(0.0),
                          Colors.purple.withOpacity(0.2),
                          Colors.cyan.withOpacity(0.12),
                          Colors.yellow.withOpacity(0.08),
                          Colors.transparent,
                        ],
                        stops: [0.0, 0.35, 0.6, 0.85, 1.0],
                      ),
                      // use blend mode by wrapping with ColorFiltered if desired
                    ),
                  ),
                ),
              ),
            ),
            // bright narrow band (shimmer)
            Transform.translate(
              offset: Offset(bandMult.dx, bandMult.dy),
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.95,
                  child: Align(
                    alignment: Alignment.center,
                    child: FractionallySizedBox(
                      widthFactor: 0.9,
                      heightFactor: 0.2,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.transparent,
                              Colors.white.withOpacity(0.8),
                              Colors.white.withOpacity(0.0),
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                        // Use blend by wrapping with BackdropFilter/ColorFiltered if needed
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // subtle noise: can replace with Image.asset('assets/noise.png') for better result
            Transform.translate(
              offset: Offset(noiseMult.dx, noiseMult.dy),
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.12,
                  child: Container(
                    decoration: BoxDecoration(
                      // you can use an Image as noise; here we use radial noise-ish via gradient
                      gradient: RadialGradient(
                        center: const Alignment(-0.2, -0.2),
                        radius: 1.0,
                        colors: [Colors.white.withOpacity(0.02), Colors.transparent],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // optional: vignette or border highlight
            IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.02),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
