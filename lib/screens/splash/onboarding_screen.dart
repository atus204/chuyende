import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_strings.dart';
import '../../widgets/custom_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardPage> _pages = const [
    _OnboardPage(
      emoji: '🍽',
      title: AppStrings.onboard1Title,
      description: AppStrings.onboard1Desc,
      color1: Color(0xFFFF6B35),
      color2: Color(0xFFFF9A5C),
    ),
    _OnboardPage(
      emoji: '⚡',
      title: AppStrings.onboard2Title,
      description: AppStrings.onboard2Desc,
      color1: Color(0xFF1A1A2E),
      color2: Color(0xFF16213E),
    ),
    _OnboardPage(
      emoji: '🛵',
      title: AppStrings.onboard3Title,
      description: AppStrings.onboard3Desc,
      color1: Color(0xFF0F3460),
      color2: Color(0xFF533483),
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _goToLogin();
    }
  }

  void _goToLogin() {
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Page view
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (_, i) => _pages[i].build(context),
          ),

          // Controls overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 48),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _pages.length,
                    effect: const WormEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      activeDotColor: Colors.white,
                      dotColor: Colors.white38,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      if (_currentPage < _pages.length - 1)
                        Expanded(
                          child: TextButton(
                            onPressed: _goToLogin,
                            child: const Text(
                              AppStrings.skip,
                              style: TextStyle(color: Colors.white70, fontSize: 15),
                            ),
                          ),
                        ),
                      Expanded(
                        flex: _currentPage < _pages.length - 1 ? 2 : 1,
                        child: CustomButton(
                          text: _currentPage < _pages.length - 1
                              ? AppStrings.next
                              : AppStrings.getStarted,
                          onPressed: _nextPage,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardPage {
  final String emoji;
  final String title;
  final String description;
  final Color color1;
  final Color color2;

  const _OnboardPage({
    required this.emoji,
    required this.title,
    required this.description,
    required this.color1,
    required this.color2,
  });

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color1, color2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              // Illustration
              Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 100)),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.85),
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
