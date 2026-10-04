// Dart (Flutter)
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'profile_setup_page.dart';

class OnboardingWelcomePage extends StatefulWidget {
  const OnboardingWelcomePage({super.key});

  @override
  State<OnboardingWelcomePage> createState() => _OnboardingWelcomePageState();
}

class _OnboardingWelcomePageState extends State<OnboardingWelcomePage> {
  bool _isAgreed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(),
              const SizedBox(height: 16),
              Expanded(flex: 5, child: _buildHeroImage()),
              const SizedBox(height: 24),
              const Text(
                'BETTER ROADS. BETTER COMPANY.',
                style: TextStyle(
                  color: AppColors.primaryLime,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Ride together.\nGo somewhere new.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  height: 1.15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Find local riders, join group rides, and discover '
                'unforgettable places—one road at a time.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              _buildTermsCheckbox(),
              const SizedBox(height: 18),
              _buildSignUpButton(),
              const SizedBox(height: 12),
              const Center(
                child: Text.rich(
                  TextSpan(
                    style: TextStyle(color: Colors.white60, fontSize: 12),
                    children: [
                      TextSpan(text: 'Already riding with us? '),
                      TextSpan(
                        text: 'Log in',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              child: SizedBox(
                width: 28,
                height: 28,
                child: Icon(Icons.two_wheeler, color: Colors.white, size: 16),
              ),
            ),
            SizedBox(width: 8),
            Text(
              'ROAD BOND',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        Text(
          '01 / 04',
          style: TextStyle(
            color: Colors.white54,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'lib/assets/images/onboarding_hero.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const ColoredBox(
                color: Color(0xFF1E2124),
                child: Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.white70,
                    size: 36,
                  ),
                ),
              );
            },
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.65),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            bottom: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.people_outline, color: Colors.white, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'Meet your riding crew',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => setState(() => _isAgreed = !_isAgreed),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: _isAgreed ? AppColors.primaryLime : Colors.transparent,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: _isAgreed ? AppColors.primaryLime : Colors.white38,
                width: 1.5,
              ),
            ),
            child: _isAgreed
                ? const Icon(Icons.check, size: 15, color: Colors.black)
                : null,
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Text.rich(
            TextSpan(
              style: TextStyle(color: Colors.white70, fontSize: 12),
              children: [
                TextSpan(text: "I confirm that I'm "),
                TextSpan(
                  text: '18+ ',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: 'and agree to the '),
                TextSpan(
                  text: 'Terms',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _isAgreed
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileSetupPage()),
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLime,
          disabledBackgroundColor: AppColors.primaryLime.withValues(
            alpha: 0.35,
          ),
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sign up',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, size: 18),
          ],
        ),
      ),
    );
  }
}
