// Dart (Flutter)
import 'package:flutter/material.dart';

import '../auth/onboarding_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _bikePosition;
  late final Animation<double> _bikeOpacity;
  late final Animation<double> _loadingOpacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );

    // Bike travels from left, pauses near center, then rides off right
    _bikePosition = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: -1.35, end: 0).chain(
          CurveTween(curve: Curves.easeOutCubic),
        ),
        weight: 45,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: 1.35).chain(
          CurveTween(curve: Curves.easeInCubic),
        ),
        weight: 55,
      ),
    ]).animate(_controller);

    _bikeOpacity = TweenSequence<double>([
      TweenSequenceItem(
        tween: ConstantTween<double>(1),
        weight: 85,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1, end: 0),
        weight: 15,
      ),
    ]).animate(_controller);

    _loadingOpacity = TweenSequence<double>([
      TweenSequenceItem(
        tween: ConstantTween<double>(0),
        weight: 22,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: 1),
        weight: 14,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1),
        weight: 46,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1, end: 0),
        weight: 18,
      ),
    ]).animate(_controller);

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        Navigator.of(context).pushReplacement(_onboardingRoute());
      }
    });
  }

  PageRoute<void> _onboardingRoute() {
    return PageRouteBuilder<void>(
      pageBuilder: (context, animation, secondaryAnimation) {
        return const OnboardingPage();
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 450),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, bikeWidget) {
            return Stack(
              children: [
                // Animated Bike directly on white canvas (no card, no box)
                Align(
                  alignment: Alignment(_bikePosition.value, -0.08),
                  child: Opacity(
                    opacity: _bikeOpacity.value,
                    child: bikeWidget,
                  ),
                ),

                // Text and Lime line
                Align(
                  alignment: const Alignment(0, 0.44),
                  child: Opacity(
                    opacity: _loadingOpacity.value,
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _LimeAccentLine(),
                        SizedBox(height: 14),
                        Text(
                          'PREPARING YOUR NEXT RIDE...',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF141416),
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
          // Direct image asset seamlessly on pure white
          child: Image.asset(
            'lib/assets/images/loading_screen.png',
            width: 280,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.two_wheeler,
                color: Color(0xFF141416),
                size: 98,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _LimeAccentLine extends StatelessWidget {
  const _LimeAccentLine();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 4,
      decoration: BoxDecoration(
        color: const Color(0xFFD4FF32),
        borderRadius: BorderRadius.circular(99),
      ),
    );
  }
}
