import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_theme.dart';
import '../onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _backgroundController;
  late Timer _navigationTimer;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      duration: const Duration(
        milliseconds: 2000,
      ), // Longer duration for smoother feel
      vsync: this,
    );

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    _startAnimationSequence();
  }

  void _startAnimationSequence() async {
    // Start background animation immediately
    _backgroundController.repeat();

    // Start logo animation
    await _logoController.forward();

    // Navigate after 3.5 seconds total (allowing for longer animation)
    _navigationTimer = Timer(const Duration(milliseconds: 3500), () {
      _navigateToOnboarding();
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _backgroundController.dispose();
    _navigationTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.darkGradient),
        child: Stack(
          children: [
            // Animated background
            _buildAnimatedBackground(),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo section
                  _buildLogoSection(),

                  const SizedBox(height: 60),

                  // Loading indicator
                  _buildLoadingIndicator(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;

        return Stack(
          children: [
            // Gradient Wave Background
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primaryOrange.withOpacity(
                        0.03 + 0.02 * _backgroundController.value,
                      ),
                      Colors.transparent,
                      AppTheme.primaryOrange.withOpacity(
                        0.05 + 0.03 * (1 - _backgroundController.value),
                      ),
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),

            // Rising Bubbles
            ...List.generate(8, (index) {
              final double startDelay = (index * 0.125) % 1.0;
              final double adjustedProgress =
                  (_backgroundController.value + startDelay) % 1.0;

              final double bubbleY =
                  screenHeight + 50 - (adjustedProgress * (screenHeight + 100));
              final double bubbleX =
                  (index * (screenWidth / 8)) +
                  (25 * adjustedProgress * (index.isEven ? 1 : -1));

              return Positioned(
                left: bubbleX % screenWidth,
                top: bubbleY,
                child: Container(
                  width: 12 + (index % 3) * 4,
                  height: 12 + (index % 3) * 4,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primaryOrange.withOpacity(
                      0.2 + (0.15 * (1 - adjustedProgress)),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryOrange.withOpacity(0.15),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              );
            }),

            // Orbiting particles around center
            ...List.generate(4, (index) {
              final double angle =
                  (_backgroundController.value * 2 * 3.14159) +
                  (index * 3.14159 / 2);
              final double radius = 150 + (index * 30);

              return Positioned(
                left:
                    (screenWidth / 2) +
                    (radius *
                            0.8 *
                            MediaQuery.of(
                              context,
                            ).devicePixelRatio.clamp(0.5, 1.0)) *
                        (1 / MediaQuery.of(context).devicePixelRatio) *
                        (screenWidth / 400) *
                        (0.8 + 0.2 * index / 4) *
                        (screenWidth > 400 ? 1.0 : screenWidth / 400) *
                        (MediaQuery.of(context).size.width /
                                    MediaQuery.of(context).size.height >
                                0.5
                            ? 1.0
                            : 0.8) *
                        (MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? 1.0
                            : 0.7) *
                        0.6 * // Base scale factor
                        (angle / (2 * 3.14159)).abs(),
                top:
                    (screenHeight / 2) +
                    (radius *
                            0.6 *
                            MediaQuery.of(
                              context,
                            ).devicePixelRatio.clamp(0.5, 1.0)) *
                        (1 / MediaQuery.of(context).devicePixelRatio) *
                        (screenHeight / 800) *
                        (0.8 + 0.2 * index / 4) *
                        (screenHeight > 600 ? 1.0 : screenHeight / 600) *
                        (MediaQuery.of(context).size.height /
                                    MediaQuery.of(context).size.width >
                                1.3
                            ? 1.0
                            : 0.8) *
                        (MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? 1.0
                            : 0.7) *
                        0.6 * // Base scale factor
                        (angle / (2 * 3.14159)).abs(),
                child: Transform.rotate(
                  angle: angle,
                  child: Container(
                    width: 8 + (index % 2) * 4,
                    height: 8 + (index % 2) * 4,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppTheme.primaryOrange.withOpacity(0.6),
                          AppTheme.primaryOrange.withOpacity(0.1),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryOrange.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildLogoSection() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        // Create smooth curves for different elements
        final scaleAnimation = CurvedAnimation(
          parent: _logoController,
          curve: Curves.elasticOut,
        );

        final fadeAnimation = CurvedAnimation(
          parent: _logoController,
          curve: Curves.easeInOutCubic,
        );

        final rotationAnimation = CurvedAnimation(
          parent: _logoController,
          curve: Curves.easeOutBack,
        );

        return Opacity(
          opacity: fadeAnimation.value,
          child: Transform.scale(
            scale: 0.1 + (0.9 * scaleAnimation.value),
            child: Transform.rotate(
              angle: (1 - rotationAnimation.value) * 0.8,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.primaryOrange.withOpacity(
                        0.15 * fadeAnimation.value,
                      ),
                      AppTheme.primaryOrange.withOpacity(
                        0.08 * fadeAnimation.value,
                      ),
                      AppTheme.primaryOrange.withOpacity(
                        0.02 * fadeAnimation.value,
                      ),
                      Colors.transparent,
                    ],
                    stops: [0.0, 0.4, 0.7, 1.0],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryOrange.withOpacity(
                        0.5 * fadeAnimation.value,
                      ),
                      blurRadius: 50 * fadeAnimation.value,
                      spreadRadius: 12 * fadeAnimation.value,
                    ),
                    BoxShadow(
                      color: AppTheme.primaryOrange.withOpacity(
                        0.3 * fadeAnimation.value,
                      ),
                      blurRadius: 100 * fadeAnimation.value,
                      spreadRadius: 20 * fadeAnimation.value,
                    ),
                    BoxShadow(
                      color: AppTheme.primaryOrange.withOpacity(
                        0.1 * fadeAnimation.value,
                      ),
                      blurRadius: 150 * fadeAnimation.value,
                      spreadRadius: 30 * fadeAnimation.value,
                    ),
                  ],
                ),
                child: Center(
                  child: Transform.scale(
                    scale:
                        0.8 +
                        (0.2 * scaleAnimation.value), // Subtle inner scaling
                    child: Image.asset(
                      'assets/images/3dlogo.png',
                      width: 220,
                      height: 220,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.primaryOrange.withOpacity(0.8),
            ),
            backgroundColor: AppTheme.primaryOrange.withOpacity(0.2),
          ),
        )
        .animate(onPlay: (controller) => controller.repeat())
        .rotate(duration: 1500.ms)
        .fadeIn(delay: 2000.ms, duration: 500.ms);
  }

  void _navigateToOnboarding() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const OnboardingScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOutCubic,
                ),
              ),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }
}
