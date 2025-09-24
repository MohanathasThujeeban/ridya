import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_theme.dart';
import '../home/home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  late AnimationController _flipController;
  late AnimationController _floatingController;
  bool isLogin = true;
  bool isFlipping = false;

  final _loginFormKey = GlobalKey<FormState>();
  final _signupFormKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _flipController.dispose();
    _floatingController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _toggleAuthMode() async {
    if (isFlipping) return;

    setState(() {
      isFlipping = true;
    });

    if (isLogin) {
      await _flipController.forward();
    } else {
      await _flipController.reverse();
    }

    setState(() {
      isLogin = !isLogin;
      isFlipping = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.darkGradient),
        child: Stack(
          children: [
            // Floating background elements
            _buildFloatingElements(),

            // Main content
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo section
                      _buildLogoSection(),

                      const SizedBox(height: 60),

                      // 3D Flip Card
                      _build3DFlipCard(),

                      const SizedBox(height: 40),

                      // Toggle button
                      _buildToggleButton(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingElements() {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        return Stack(
          children: List.generate(12, (index) {
            final double animationOffset =
                (_floatingController.value * 2 * 3.14159) + (index * 0.5);
            return Positioned(
              left: 50 + (index * 30) % MediaQuery.of(context).size.width,
              top:
                  100 +
                  (index * 60) % (MediaQuery.of(context).size.height - 200),
              child: Transform.translate(
                offset: Offset(
                  15 * (sin(animationOffset) * 0.5),
                  10 * (cos(animationOffset) * 0.3),
                ),
                child: Container(
                  width: 8 + (index % 3) * 4,
                  height: 8 + (index % 3) * 4,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primaryOrange.withOpacity(
                      0.2 + (index % 3) * 0.1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryOrange.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppTheme.primaryGradient,
                boxShadow: AppTheme.floatingShadow,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.asset(
                  'assets/images/3dlogo.png',
                  fit: BoxFit.cover,
                ),
              ),
            )
            .animate()
            .scale(duration: 600.ms, curve: Curves.elasticOut)
            .rotate(duration: 800.ms),

        const SizedBox(height: 20),

        const Text('Welcome to', style: AppTheme.bodyMedium)
            .animate()
            .fadeIn(delay: 300.ms, duration: 400.ms)
            .slideY(begin: 0.3, end: 0),

        const SizedBox(height: 8),

        const Text('RIDYA', style: AppTheme.heading1)
            .animate()
            .fadeIn(delay: 500.ms, duration: 600.ms)
            .slideY(begin: 0.3, end: 0)
            .shimmer(delay: 1000.ms, duration: 1500.ms),
      ],
    );
  }

  Widget _build3DFlipCard() {
    return Container(
          height: 480,
          child: AnimatedBuilder(
            animation: _flipController,
            builder: (context, child) {
              final bool showFront = _flipController.value < 0.5;
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(_flipController.value * 3.14159),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: AppTheme.cardRadius,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppTheme.lightBlack, AppTheme.primaryBlack],
                    ),
                    boxShadow: AppTheme.floatingShadow,
                  ),
                  child: showFront ? _buildLoginForm() : _buildSignupForm(),
                ),
              );
            },
          ),
        )
        .animate()
        .fadeIn(delay: 800.ms, duration: 600.ms)
        .slideY(begin: 0.3, end: 0, curve: Curves.easeOutBack);
  }

  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Form(
        key: _loginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Sign In',
              style: AppTheme.heading2,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            _buildFloatingTextField(
              controller: _emailController,
              label: 'Email',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 20),

            _buildFloatingTextField(
              controller: _passwordController,
              label: 'Password',
              icon: Icons.lock_outline,
              obscureText: true,
            ),

            const SizedBox(height: 30),

            _build3DButton(text: 'Sign In', onPressed: _handleLogin),

            const SizedBox(height: 20),

            TextButton(
              onPressed: () {},
              child: const Text('Forgot Password?', style: AppTheme.bodySmall),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignupForm() {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(3.14159),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: _signupFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Sign Up',
                style: AppTheme.heading2,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              _buildFloatingTextField(
                controller: _nameController,
                label: 'Full Name',
                icon: Icons.person_outline,
              ),

              const SizedBox(height: 16),

              _buildFloatingTextField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 16),

              _buildFloatingTextField(
                controller: _phoneController,
                label: 'Phone Number',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 16),

              _buildFloatingTextField(
                controller: _passwordController,
                label: 'Password',
                icon: Icons.lock_outline,
                obscureText: true,
              ),

              const SizedBox(height: 30),

              _build3DButton(text: 'Sign Up', onPressed: _handleSignup),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
          decoration: BoxDecoration(
            borderRadius: AppTheme.inputRadius,
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryBlack.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: AppTheme.bodyMedium,
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: Icon(icon, color: AppTheme.primaryOrange),
              filled: true,
              fillColor: AppTheme.lightBlack,
              border: OutlineInputBorder(
                borderRadius: AppTheme.inputRadius,
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppTheme.inputRadius,
                borderSide: const BorderSide(
                  color: AppTheme.primaryOrange,
                  width: 2,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your $label';
              }
              return null;
            },
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideX(begin: 0.3, end: 0, curve: Curves.easeOutBack);
  }

  Widget _build3DButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return Container(
          height: 56,
          decoration: BoxDecoration(
            borderRadius: AppTheme.buttonRadius,
            gradient: AppTheme.primaryGradient,
            boxShadow: AppTheme.cardShadow,
          ),
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: AppTheme.buttonRadius,
              ),
            ),
            child: Text(text, style: AppTheme.bodyLarge),
          ),
        )
        .animate()
        .scale(duration: 200.ms, curve: Curves.easeInOut)
        .shimmer(delay: 500.ms, duration: 1000.ms);
  }

  Widget _buildToggleButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isLogin ? "Don't have an account? " : "Already have an account? ",
          style: AppTheme.bodySmall,
        ),
        TextButton(
          onPressed: _toggleAuthMode,
          child: Text(
            isLogin ? 'Sign Up' : 'Sign In',
            style: AppTheme.bodyMedium.copyWith(color: AppTheme.primaryOrange),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 1200.ms, duration: 400.ms);
  }

  void _handleLogin() {
    if (_loginFormKey.currentState!.validate()) {
      // TODO: Implement login logic
      _navigateToHome();
    }
  }

  void _handleSignup() {
    if (_signupFormKey.currentState!.validate()) {
      // TODO: Implement signup logic
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1.0).animate(
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
