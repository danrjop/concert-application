import 'package:flutter/material.dart';

/// Custom widget for Google logo to avoid needing an image asset
class GoogleLogo extends StatelessWidget {
  final double size;

  const GoogleLogo({super.key, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _GoogleLogoPainter(),
      ),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Draw G logo with colors
    final Path path = Path();
    path.moveTo(width * 0.5, height * 0.5);
    // Create a simple circle for the G shape
    path.addOval(Rect.fromCircle(
      center: Offset(width / 2, height / 2),
      radius: width / 2,
    ));

    // Draw a simplified Google logo with colors
    // Red part
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(
      Rect.fromLTWH(0, 0, width, height),
      0,
      3.14 / 2,
      true,
      paint,
    );

    // Green part
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(
      Rect.fromLTWH(0, 0, width, height),
      3.14 / 2,
      3.14 / 2,
      true,
      paint,
    );

    // Yellow part
    paint.color = const Color(0xFFFFBB0A);
    canvas.drawArc(
      Rect.fromLTWH(0, 0, width, height),
      3.14,
      3.14 / 2,
      true,
      paint,
    );

    // Blue part
    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(
      Rect.fromLTWH(0, 0, width, height),
      3.14 * 1.5,
      3.14 / 2,
      true,
      paint,
    );

    // White center to create the G shape
    paint.color = Colors.white;
    canvas.drawCircle(
      Offset(width / 2, height / 2),
      width / 3,
      paint,
    );

    // Cut out part of the circle to create G shape
    paint.color = const Color(0xFF4285F4);
    canvas.drawRect(
      Rect.fromLTWH(width * 0.6, height * 0.4, width * 0.4, height * 0.2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
