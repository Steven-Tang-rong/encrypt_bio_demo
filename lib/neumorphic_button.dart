import 'package:flutter/material.dart';

class NeumorphicButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final double width;
  final double height;

  const NeumorphicButton({
    Key? key,
    this.onPressed,
    required this.child,
    this.width = 180,
    this.height = 50,
  }) : super(key: key);

  @override
  State<NeumorphicButton> createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton> {
  bool _isPressed = false;
  final backgroundColor = const Color(0xFFE7ECF2);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => setState(() => _isPressed = true),
      onTapUp: (details) {
        setState(() => _isPressed = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: CustomPaint(
          painter: _NeumorphicPainter(
            isPressed: _isPressed,
            backgroundColor: backgroundColor,
          ),
          child: Center(child: widget.child),
        ),
      ),
    );
  }
}

class _NeumorphicPainter extends CustomPainter {
  final bool isPressed;
  final Color backgroundColor;

  _NeumorphicPainter({
    required this.isPressed,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(
      rect,
      const Radius.circular(25),
    );

    // Base color
    final paint = Paint()..color = backgroundColor;
    canvas.drawRRect(rrect, paint);

    if (isPressed) {
      // Inner shadow when pressed
      final innerShadowPath = Path()
        ..addRRect(rrect)
        ..close();

      canvas.save();
      canvas.clipRRect(rrect);

      // Soft dark shadow
      paint.color = Colors.black.withOpacity(0.07);
      canvas.drawShadow(
        innerShadowPath.shift(const Offset(2, 2)),
        Colors.black.withOpacity(0.07),
        3,
        true,
      );

      // Soft light shadow
      paint.color = Colors.white.withOpacity(0.7);
      canvas.drawShadow(
        innerShadowPath.shift(const Offset(-2, -2)),
        Colors.white.withOpacity(0.7),
        3,
        true,
      );

      canvas.restore();
    } else {
      // Outer shadow for normal state
      final shadowPath = Path()
        ..addRRect(rrect)
        ..close();

      // Very soft dark shadow
      canvas.drawShadow(
        shadowPath,
        Colors.black.withOpacity(0.06),
        6,
        true,
      );

      // Soft light shadow
      paint.color = Colors.white.withOpacity(0.8);
      final lightPath = Path()
        ..addRRect(rrect.shift(const Offset(-2, -2)))
        ..close();
      canvas.drawPath(lightPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Example usage
class ExampleScreen extends StatelessWidget {
  const ExampleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7ECF2),
      body: Center(
        child: NeumorphicButton(
          onPressed: () {
            print('Button pressed!');
          },
          child: const Text(
            'Space',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF566074),
              fontWeight: FontWeight.w400,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ),
    );
  }
}