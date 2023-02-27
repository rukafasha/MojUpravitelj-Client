import 'package:flutter/material.dart';

class BackgroundTop extends StatefulWidget {
  const BackgroundTop({super.key});

  @override
  _MyPainterState createState() => _MyPainterState();
}

class _MyPainterState extends State<BackgroundTop> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: CustomPaint(
        size: Size(size.width, size.height),
        painter: Curved(),
      ),
    );
  }
}

class Curved extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;
    // Path rectPathThree = Path();
    Paint paint = Paint();
    paint.shader = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: [.01, .25],
      colors: [
        Color(0xfff8a55f),
        Color(0xfff1665f),
      ],
    ).createShader(rect);

    Paint paint2 = Paint();
    paint2.shader = const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      stops: [.05, 1],
      colors: [
        Color(0xff0ce8f9),
        Color(0xff45b7fe),
      ],
    ).createShader(rect);

    var path = Path();

    path.lineTo(0, 0);
    path.lineTo(size.width, 0);
    path.quadraticBezierTo(
      size.width * 0.9,
      size.height * 0.07,
      size.width * 0.6,
      size.height * 0.07,
    );
    path.quadraticBezierTo(
      size.width * 0.2,
      size.height * 0.08,
      size.width * 0.1,
      size.height * 0.18,
    );
    path.quadraticBezierTo(
      size.width * 0.06,
      size.height * 0.21,
      size.width * 0,
      size.height * 0.26,
    );
    path.close();
    //
    canvas.drawPath(path, paint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}