import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:card_swiper/card_swiper.dart';
import '../../constants/app_theme.dart';
import '../auth/auth_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late AnimationController _parallaxController;
  late AnimationController _floatingController;
  int currentIndex = 0;

  final List<OnboardingData> onboardingData = [
    OnboardingData(
      title: "3D Ride Experience",
      description:
          "Book your ride with stunning 3D visuals and immersive animations that bring your journey to life.",
      icon: Icons.threed_rotation,
      floatingElements: ["🚗", "📍", "✨"],
    ),
    OnboardingData(
      title: "Smart Navigation",
      description:
          "Experience intelligent route planning with 3D maps and real-time traffic updates for optimal travel.",
      icon: Icons.navigation,
      floatingElements: ["🗺️", "🧭", "⚡"],
    ),
    OnboardingData(
      title: "Premium Comfort",
      description:
          "Choose from our premium fleet with 3D vehicle preview and luxury comfort for every journey.",
      icon: Icons.car_rental,
      floatingElements: ["🏆", "💎", "🌟"],
    ),
    OnboardingData(
      title: "Safe & Secure",
      description:
          "Your safety is our priority with real-time tracking, emergency features, and verified drivers.",
      icon: Icons.security,
      floatingElements: ["🛡️", "🔒", "✅"],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _parallaxController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _floatingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _parallaxController.dispose();
    _floatingController.dispose();
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
            SafeArea(
              child: Column(
                children: [
                  // Skip button
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextButton(
                        onPressed: () => _navigateToAuth(),
                        child: const Text('Skip', style: AppTheme.bodyMedium),
                      ),
                    ),
                  ),

                  // 3D Card Swiper
                  Expanded(
                    child: Swiper(
                      itemBuilder: (context, index) {
                        return _build3DCard(onboardingData[index], index);
                      },
                      itemCount: onboardingData.length,
                      viewportFraction: 0.85,
                      scale: 0.9,
                      onIndexChanged: (index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      loop: false,
                    ),
                  ),

                  // Page indicator
                  _buildPageIndicator(),

                  // Next/Get Started button
                  _buildActionButton(),

                  const SizedBox(height: 40),
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
      animation: _parallaxController,
      builder: (context, child) {
        return Stack(
          children: [
            // Moving geometric shapes
            ...List.generate(15, (index) {
              final double offset =
                  (_parallaxController.value * 360) + (index * 24);
              return Positioned(
                left: (index * 50) % MediaQuery.of(context).size.width,
                top: (offset % MediaQuery.of(context).size.height) - 50,
                child: Transform.rotate(
                  angle: offset * 0.01,
                  child: Container(
                    width: 20 + (index % 4) * 5,
                    height: 20 + (index % 4) * 5,
                    decoration: BoxDecoration(
                      shape: index % 2 == 0
                          ? BoxShape.circle
                          : BoxShape.rectangle,
                      color: AppTheme.primaryOrange.withOpacity(
                        0.1 + (index % 3) * 0.1,
                      ),
                      borderRadius: index % 2 == 1
                          ? BorderRadius.circular(8)
                          : null,
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

  Widget _build3DCard(OnboardingData data, int index) {
    return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Stack(
            children: [
              // 3D Card container
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(0.1)
                  ..rotateY((currentIndex == index) ? 0.0 : 0.05),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: AppTheme.cardRadius,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.lightBlack,
                        AppTheme.primaryBlack,
                        AppTheme.lightBlack,
                      ],
                    ),
                    boxShadow: AppTheme.floatingShadow,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Floating elements
                      SizedBox(
                        height: 100,
                        child: Stack(
                          children: data.floatingElements.asMap().entries.map((
                            entry,
                          ) {
                            return AnimatedBuilder(
                              animation: _floatingController,
                              builder: (context, child) {
                                final double animationOffset =
                                    (_floatingController.value * 2 * 3.14159) +
                                    (entry.key * 2);
                                return Positioned(
                                  left:
                                      50 +
                                      (entry.key * 80) +
                                      (15 * sin(animationOffset)),
                                  top: 20 + (10 * cos(animationOffset)),
                                  child: Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.identity()
                                      ..setEntry(3, 2, 0.001)
                                      ..rotateZ(animationOffset * 0.5),
                                    child: Text(
                                      entry.value,
                                      style: const TextStyle(fontSize: 32),
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Main icon with 3D effect
                      Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppTheme.primaryGradient,
                              boxShadow: AppTheme.cardShadow,
                            ),
                            child: Icon(
                              data.icon,
                              size: 40,
                              color: AppTheme.primaryWhite,
                            ),
                          )
                          .animate()
                          .scale(
                            duration: AppTheme.mediumAnimation,
                            curve: Curves.elasticOut,
                          )
                          .rotate(duration: AppTheme.longAnimation),

                      const SizedBox(height: 40),

                      // Title
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          data.title,
                          style: AppTheme.heading2,
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Description
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          data.description,
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.darkGrey,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 600.ms)
        .slideX(begin: 0.3, end: 0, curve: Curves.easeOutCubic);
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        onboardingData.length,
        (index) => AnimatedContainer(
          duration: AppTheme.quickAnimation,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: currentIndex == index ? 32 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: currentIndex == index
                ? AppTheme.primaryOrange
                : AppTheme.darkGrey,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () {
            if (currentIndex == onboardingData.length - 1) {
              _navigateToAuth();
            } else {
              // Move to next page - this would need swiper controller
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryOrange,
            foregroundColor: AppTheme.primaryWhite,
            shape: RoundedRectangleBorder(borderRadius: AppTheme.buttonRadius),
            elevation: 8,
          ),
          child: Text(
            currentIndex == onboardingData.length - 1 ? 'Get Started' : 'Next',
            style: AppTheme.bodyLarge,
          ),
        ),
      ),
    ).animate().slideY(begin: 0.3, end: 0, curve: Curves.easeOutBack).fadeIn();
  }

  void _navigateToAuth() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AuthScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOutCubic,
                  ),
                ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;
  final List<String> floatingElements;

  OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
    required this.floatingElements,
  });
}
