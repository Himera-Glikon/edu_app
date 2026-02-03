import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';

class StarFieldPage extends StatefulWidget {
  const StarFieldPage({super.key});

  @override
  State<StarFieldPage> createState() => _StarFieldPageState();
}

class _StarFieldPageState extends State<StarFieldPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Star> _stars = [];
  final Random _random = Random();
  Offset _mousePosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..repeat();

    // Создаем 200 звезд
    for (int i = 0; i < 200; i++) {
      _stars.add(Star.random(_random));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateMousePosition(Offset position) {
    setState(() {
      _mousePosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: MouseRegion(
        onHover: (event) => _updateMousePosition(event.position),
        child: GestureDetector(
          onPanUpdate: (details) => _updateMousePosition(details.globalPosition),
          child: CustomPaint(
            size: Size.infinite,
            painter: StarFieldPainter(stars: _stars, mousePosition: _mousePosition),
          ),
        ),
      ),
    );
  }
}

class Star {
  double x;
  double y;
  double size;
  double depth;
  double twinkleOffset;
  double twinkleSpeed;
  double baseOpacity;
  double opacity;

  Star({
    required this.x,
    required this.y,
    required this.size,
    required this.depth,
    required this.twinkleOffset,
    required this.twinkleSpeed,
    required this.baseOpacity,
    required this.opacity,
  });

  factory Star.random(Random random) {
    return Star(
      x: random.nextDouble(),
      y: random.nextDouble(),
      size: random.nextDouble() * 2 + 0.5,
      depth: random.nextDouble() * 1.5 + 0.5,
      twinkleOffset: random.nextDouble() * math.pi * 2,
      twinkleSpeed: random.nextDouble() * 0.05 + 0.01,
      baseOpacity: random.nextDouble() * 0.5 + 0.3,
      opacity: 0.5,
    );
  }

  void update(Size size, Offset mouseOffset, double deltaTime) {
    twinkleOffset += twinkleSpeed;
    opacity = baseOpacity + math.sin(twinkleOffset) * 0.2;

    final parallaxFactor = depth * 0.3;
    x += (mouseOffset.dx / size.width - 0.5) * parallaxFactor * 0.1;
    y += (mouseOffset.dy / size.height - 0.5) * parallaxFactor * 0.1;

    if (x < 0) x += 1;
    if (x > 1) x -= 1;
    if (y < 0) y += 1;
    if (y > 1) y -= 1;
  }
}

class StarFieldPainter extends CustomPainter {
  final List<Star> stars;
  final Offset mousePosition;

  StarFieldPainter({required this.stars, required this.mousePosition});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final star in stars) {
      star.update(size, mousePosition, 0.016);

      final effectiveOpacity = opacityClamp(star.opacity);
      final effectiveSize = star.size * (0.5 + star.depth * 0.5);

      // Создаем градиент для эффекта свечения
      final gradient = RadialGradient(
        center: Alignment.center,
        colors: [
          Color.fromRGBO(255, 255, 255, effectiveOpacity),
          Color.fromRGBO(200, 220, 255, effectiveOpacity * 0.5),
          Color.fromRGBO(150, 180, 255, 0),
        ],
        stops: [0.0, 0.4, 1.0],
      );

      final rect = Rect.fromCenter(
        center: Offset(star.x * size.width, star.y * size.height),
        width: effectiveSize * 4,
        height: effectiveSize * 4,
      );

      paint.shader = gradient.createShader(rect);
      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        effectiveSize * 2,
        paint,
      );
    }
  }

  double opacityClamp(double value) {
    if (value < 0) return 0;
    if (value > 1) return 1;
    return value;
  }

  @override
  bool shouldRepaint(covariant StarFieldPainter oldDelegate) => true;
}
