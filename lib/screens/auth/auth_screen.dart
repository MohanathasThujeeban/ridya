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
      duration: const Duration(seconds: 6),
      vsync: this,
    );

    // Smooth linear animation
    _floatingController.repeat();
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

                      const SizedBox(height: 30),

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
                        0.02 + 0.01 * _floatingController.value,
                      ),
                      Colors.transparent,
                      AppTheme.primaryOrange.withOpacity(
                        0.03 + 0.02 * (1 - _floatingController.value),
                      ),
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),

            // Rising Bubbles
            ...List.generate(12, (index) {
              final double startDelay = (index * 0.1) % 1.0;
              final double adjustedProgress =
                  (_floatingController.value + startDelay) % 1.0;

              // Linear vertical movement from bottom to top
              final double bubbleY =
                  screenHeight + 50 - (adjustedProgress * (screenHeight + 100));
              final double bubbleX =
                  (index * (screenWidth / 12)) +
                  (20 * adjustedProgress * (index.isEven ? 1 : -1));

              return Positioned(
                left: bubbleX % screenWidth,
                top: bubbleY,
                child: Container(
                  width: 8 + (index % 4) * 4,
                  height: 8 + (index % 4) * 4,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primaryOrange.withOpacity(
                      0.15 +
                          (0.1 *
                              (1 - adjustedProgress)), // Fade out as it rises
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryOrange.withOpacity(0.1),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              );
            }),

            // Horizontal Drifting Particles
            ...List.generate(8, (index) {
              final double startDelay = (index * 0.15) % 1.0;
              final double adjustedProgress =
                  (_floatingController.value + startDelay) % 1.0;

              // Linear horizontal movement from left to right
              final double particleX =
                  -30 + (adjustedProgress * (screenWidth + 60));
              final double particleY =
                  (index * (screenHeight / 8)) +
                  (10 * adjustedProgress * (index.isEven ? 1 : -1));

              return Positioned(
                left: particleX,
                top: particleY % screenHeight,
                child: Container(
                  width: 6 + (index % 3) * 3,
                  height: 6 + (index % 3) * 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryOrange.withOpacity(0.2),
                        AppTheme.primaryOrange.withOpacity(0.05),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryOrange.withOpacity(0.08),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
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
    return Column(
      children: [
        Image.asset(
              'assets/images/3dlogo.png',
              width: 160,
              height: 160,
              fit: BoxFit.contain,
            )
            .animate()
            .scale(duration: 600.ms, curve: Curves.elasticOut)
            .rotate(duration: 800.ms),

        const SizedBox(height: 10),
      ],
    );
  }

  Widget _build3DFlipCard() {
    return Container(
          width: MediaQuery.of(context).size.width * 0.9,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.65,
            minHeight: 420,
          ),
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
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 28.0),
      child: SingleChildScrollView(
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

              const SizedBox(height: 32),

              _buildFloatingTextField(
                controller: _emailController,
                label: 'Username/Email',
                icon: Icons.person_outlined,
                keyboardType: TextInputType.text,
              ),

              const SizedBox(height: 18),

              _buildFloatingTextField(
                controller: _passwordController,
                label: 'Password',
                icon: Icons.lock_outline,
                obscureText: true,
              ),

              const SizedBox(height: 28),

              _build3DButton(text: 'Sign In', onPressed: _handleLogin),

              const SizedBox(height: 16),

              TextButton(
                onPressed: () {},
                child: const Text(
                  'Forgot Password?',
                  style: AppTheme.bodySmall,
                ),
              ),

              const SizedBox(height: 24),

              // Divider with "OR"
              _buildOrDivider(),

              const SizedBox(height: 24),

              // Social login buttons
              _buildSocialLoginButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignupForm() {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(3.14159),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        child: SingleChildScrollView(
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

                const SizedBox(height: 28),

                _buildFloatingTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  icon: Icons.person_outline,
                ),

                const SizedBox(height: 14),

                _buildFloatingTextField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 14),

                _buildFloatingTextField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: 14),

                _buildFloatingTextField(
                  controller: _passwordController,
                  label: 'Password',
                  icon: Icons.lock_outline,
                  obscureText: true,
                ),

                const SizedBox(height: 24),

                _build3DButton(text: 'Sign Up', onPressed: _handleSignup),

                const SizedBox(height: 20),

                // Divider with "OR"
                _buildOrDivider(),

                const SizedBox(height: 20),

                // Social login buttons
                _buildSocialLoginButtons(),
              ],
            ),
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

  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppTheme.primaryOrange.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'OR',
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.primaryOrange.withOpacity(0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppTheme.primaryOrange.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLoginButtons() {
    return Column(
      children: [
        // Google Sign In Button
        _buildSocialButton(
          text: isLogin ? 'Continue with Google' : 'Sign up with Google',
          icon: Icons.g_mobiledata, // Using a built-in icon as placeholder
          color: Colors.white,
          textColor: Colors.black87,
          onPressed: _handleGoogleAuth,
        ),
        const SizedBox(height: 12),
        // Facebook Sign In Button
        _buildSocialButton(
          text: isLogin ? 'Continue with Facebook' : 'Sign up with Facebook',
          icon: Icons.facebook,
          color: const Color(0xFF1877F2),
          textColor: Colors.white,
          onPressed: _handleFacebookAuth,
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required String text,
    required IconData icon,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: AppTheme.buttonRadius,
            color: color,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: AppTheme.buttonRadius,
              ),
            ),
            icon: Icon(icon, color: textColor, size: 24),
            label: Text(
              text,
              style: AppTheme.bodyMedium.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideX(begin: 0.3, end: 0, curve: Curves.easeOutBack);
  }

  void _handleGoogleAuth() {
    // TODO: Implement Google authentication
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Google authentication coming soon!'),
        backgroundColor: AppTheme.primaryOrange,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleFacebookAuth() {
    // TODO: Implement Facebook authentication
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Facebook authentication coming soon!'),
        backgroundColor: const Color(0xFF1877F2),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleLogin() {
    if (_loginFormKey.currentState!.validate()) {
      // Check for default credentials
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      if (email == 'Rideya' && password == 'Ride123') {
        _navigateToHome();
      } else {
        // Show error message for invalid credentials
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Invalid credentials. Use username: Rideya, password: Ride123',
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
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
