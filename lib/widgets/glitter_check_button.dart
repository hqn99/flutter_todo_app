import 'package:flutter/material.dart';

class GlitterCheckButton extends StatefulWidget {
  final bool isCompleted;
  final VoidCallback? onToggle;

  const GlitterCheckButton({
    super.key,
    required this.isCompleted,
    this.onToggle,
  });

  @override
  GlitterCheckButtonState createState() => GlitterCheckButtonState();
}

class GlitterCheckButtonState extends State<GlitterCheckButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _opacityAnim = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 50),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPressed() {
    _controller.forward(from: 0.0);
    if (widget.onToggle != null) {
      widget.onToggle!();
    }
  }

  Widget glitterDot(double x, double y, double size, double delay) {
    return Positioned(
      left: x + 24, // アイコン中心基準で調整（32/2=16くらいなので少しずらす）
      top: y + 24,
      child: FadeTransition(
        opacity: _opacityAnim,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.yellowAccent.withValues(
              alpha: (0.8 * 255).round().toDouble(),
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.yellowAccent.withValues(
                  alpha: (0.9 * 255).round().toDouble(),
                ),
                blurRadius: size / 2,
                spreadRadius: size / 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 56,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          IconButton(
            iconSize: 32,
            icon: Icon(
              widget.isCompleted
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: Colors.white,
            ),
            onPressed: _onPressed,
          ),
          glitterDot(-8, 0, 12, 0.3),
          glitterDot(0, 28, 8, 1.5),
          glitterDot(10, -10, 10, 0.7),
          glitterDot(-10, 18, 7, 2.0),
        ],
      ),
    );
  }
}
