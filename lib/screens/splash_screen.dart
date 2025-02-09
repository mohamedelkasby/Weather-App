import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/screens/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInCubic),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF89CFF0),
              Color(0xFF0066B2),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scaleAnimation,
                child: Image.asset(
                  "assets/images/116.png",
                  width: 200,
                  height: 200,
                  color: Colors.white.withAlpha((0.9 * 255).toInt()),
                ),
              ),
              const SizedBox(height: 30),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Weather',
                        style: GoogleFonts.poppins(
                          fontSize: 42,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 10,
                              color:
                                  Colors.black.withAlpha((0.2 * 255).toInt()),
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                      TextSpan(
                        text: ' App',
                        style: GoogleFonts.poppins(
                          fontSize: 42,
                          fontWeight: FontWeight.w300,
                          color: const Color(0xFFE0F7FA),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const CustomWaveProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomWaveProgressIndicator extends StatefulWidget {
  const CustomWaveProgressIndicator({super.key});

  @override
  State<CustomWaveProgressIndicator> createState() =>
      _CustomWaveProgressIndicatorState();
}

class _CustomWaveProgressIndicatorState
    extends State<CustomWaveProgressIndicator> with TickerProviderStateMixin {
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(50, 50),
          painter: WavePainter(_waveController.value),
        );
      },
    );
  }
}

class WavePainter extends CustomPainter {
  final double progress;

  WavePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final y = size.height * (1 - progress);
    path.moveTo(0, y);
    path.quadraticBezierTo(
      size.width * 0.25,
      y + size.height * 0.2,
      size.width * 0.5,
      y,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      y - size.height * 0.2,
      size.width,
      y,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
