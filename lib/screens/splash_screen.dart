import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_theme.dart';
import 'onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _startAnimation();
  }

  void _startAnimation() async {
    // Start glow animation
    _glowController.repeat(reverse: true);
    
    // Start rotation animation
    _rotationController.repeat();
    
    // Start scale animation with delay
    await Future.delayed(const Duration(milliseconds: 500));
    _scaleController.forward();

    // Navigate to onboarding after splash duration
    await Future.delayed(AppTheme.splashDuration);
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const OnboardingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 1.0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOutCubic,
                )),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.splashGradient,
        ),
        child: Stack(
          children: [
            // Animated background particles
            ...List.generate(20, (index) => _buildFloatingParticle(index)),
            
            // Main logo container
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 3D Logo Container
                  AnimatedBuilder(
                    animation: Listenable.merge([
                      _rotationController,
                      _scaleController,
                      _glowController,
                    ]),
                    builder: (context, child) {
                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001) // Perspective
                          ..rotateY(_rotationController.value * 2 * 3.14159)
                          ..scale(_scaleController.value),
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryOrange.withOpacity(
                                  0.3 + (_glowController.value * 0.4),
                                ),
                                blurRadius: 30 + (_glowController.value * 20),
                                spreadRadius: 5 + (_glowController.value * 10),
                              ),
                              ...AppTheme.floatingShadow,
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Container(
                              decoration: const BoxDecoration(
                                gradient: AppTheme.primaryGradient,
                              ),
                              child: Image.asset(
                                'assets/images/3dlogo.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // App Name with 3D effect
                  const Text(
                    'RIDYA',
                    style: AppTheme.heading1,
                  )
                      .animate()
                      .fadeIn(delay: 800.ms, duration: 800.ms)
                      .slideY(begin: 0.3, end: 0, curve: Curves.easeOutBack)
                      .then(delay: 200.ms)
                      .shimmer(
                        duration: 1500.ms,
                        color: AppTheme.primaryOrange,
                      ),
                  
                  const SizedBox(height: 16),
                  
                  // Tagline
                  const Text(
                    'Your 3D Ride Experience',
                    style: AppTheme.bodyMedium,
                  )
                      .animate()
                      .fadeIn(delay: 1200.ms, duration: 600.ms)
                      .slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 60),
                  
                  // Loading indicator
                  Container(
                    width: 60,
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: AppTheme.lightBlack,
                    ),
                    child: AnimatedBuilder(
                      animation: _scaleController,
                      builder: (context, child) {
                        return FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: _scaleController.value,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              gradient: AppTheme.primaryGradient,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 1600.ms, duration: 400.ms),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingParticle(int index) {
    final double size = 4 + (index % 3) * 2;
    final double initialX = (index * 47) % MediaQuery.of(context).size.width;
    final double initialY = (index * 73) % MediaQuery.of(context).size.height;
    
    return Positioned(
      left: initialX,
      top: initialY,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.primaryOrange.withOpacity(0.3),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryOrange.withOpacity(0.2),
              blurRadius: size * 2,
              spreadRadius: 1,
            ),
          ],
        ),
      )
          .animate(
            onComplete: (controller) => controller.repeat(),
          )
          .moveY(
            begin: 0,
            end: -50 - (index % 100),
            duration: Duration(milliseconds: 3000 + (index % 2000)),
            curve: Curves.easeInOut,
          )
          .fadeIn(duration: 1000.ms)
          .then()
          .fadeOut(duration: 1000.ms),
    );
  }
}