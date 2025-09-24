import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_theme.dart';
import '../auth/auth_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _floatingController;

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      body: Stack(
        children: [
          // Background with floating elements
          _buildFloatingBackground(),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Custom App Bar
                _buildCustomAppBar(),

                // Profile content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        _buildProfileHeader(),
                        const SizedBox(height: 40),
                        _buildProfileStats(),
                        const SizedBox(height: 30),
                        _buildProfileOptions(),
                        const SizedBox(height: 40),
                        _buildLogoutButton(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingBackground() {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        return Container(
          decoration: const BoxDecoration(gradient: AppTheme.darkGradient),
          child: Stack(
            children: List.generate(15, (index) {
              final double animationOffset =
                  (_floatingController.value * 2 * 3.14159) + (index * 0.4);
              return Positioned(
                left: (index * 50 + 25) % MediaQuery.of(context).size.width,
                top: (index * 70 + 50) % MediaQuery.of(context).size.height,
                child: Transform.translate(
                  offset: Offset(
                    10 * (animationOffset.sin),
                    8 * (animationOffset.cos),
                  ),
                  child: Container(
                    width: 4 + (index % 3) * 2,
                    height: 4 + (index % 3) * 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.primaryOrange.withOpacity(
                        0.15 + (index % 3) * 0.05,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildCustomAppBar() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.lightBlack,
              borderRadius: BorderRadius.circular(22),
              boxShadow: AppTheme.cardShadow,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppTheme.primaryOrange),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 16),
          Text('My Profile', style: AppTheme.heading2),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.3, end: 0);
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppTheme.primaryGradient,
            boxShadow: AppTheme.floatingShadow,
          ),
          child: const Icon(
            Icons.person,
            size: 60,
            color: AppTheme.primaryWhite,
          ),
        ).animate().scale(duration: 800.ms, curve: Curves.elasticOut),

        const SizedBox(height: 20),

        Text(
          'Rideya User',
          style: AppTheme.heading2,
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3, end: 0),

        const SizedBox(height: 8),

        Text(
          'rideya@example.com',
          style: AppTheme.bodyMedium.copyWith(color: AppTheme.darkGrey),
        ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.3, end: 0),

        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.primaryOrange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.primaryOrange.withOpacity(0.3)),
          ),
          child: Text(
            'Premium Member',
            style: AppTheme.bodySmall.copyWith(color: AppTheme.primaryOrange),
          ),
        ).animate().fadeIn(delay: 800.ms).scale(curve: Curves.elasticOut),
      ],
    );
  }

  Widget _buildProfileStats() {
    return Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppTheme.lightBlack, AppTheme.primaryBlack],
            ),
            boxShadow: AppTheme.floatingShadow,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('24', 'Trips'),
              _buildStatDivider(),
              _buildStatItem('4.8', 'Rating'),
              _buildStatDivider(),
              _buildStatItem('₹2,450', 'Saved'),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: 1000.ms)
        .slideY(begin: 0.5, end: 0, curve: Curves.easeOutBack);
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.heading3.copyWith(color: AppTheme.primaryOrange),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTheme.bodySmall.copyWith(color: AppTheme.darkGrey),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 40,
      color: AppTheme.darkGrey.withOpacity(0.3),
    );
  }

  Widget _buildProfileOptions() {
    final options = [
      {
        'icon': Icons.person_outline,
        'title': 'Edit Profile',
        'subtitle': 'Update your information',
      },
      {
        'icon': Icons.history,
        'title': 'Ride History',
        'subtitle': 'View past trips',
      },
      {
        'icon': Icons.payment,
        'title': 'Payment Methods',
        'subtitle': 'Manage cards & wallets',
      },
      {
        'icon': Icons.favorite_outline,
        'title': 'Saved Places',
        'subtitle': 'Home, work & favorites',
      },
      {
        'icon': Icons.notifications,
        'title': 'Notifications',
        'subtitle': 'Push notifications',
      },
      {
        'icon': Icons.help_outline,
        'title': 'Help & Support',
        'subtitle': 'Get help or contact us',
      },
      {
        'icon': Icons.privacy_tip,
        'title': 'Privacy Policy',
        'subtitle': 'Read our privacy policy',
      },
    ];

    return Column(
      children: options.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;

        return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppTheme.lightBlack,
                boxShadow: AppTheme.cardShadow,
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Icon(
                    option['icon'] as IconData,
                    color: AppTheme.primaryOrange,
                    size: 24,
                  ),
                ),
                title: Text(
                  option['title'] as String,
                  style: AppTheme.bodyLarge,
                ),
                subtitle: Text(
                  option['subtitle'] as String,
                  style: AppTheme.bodySmall.copyWith(color: AppTheme.darkGrey),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: AppTheme.darkGrey,
                  size: 16,
                ),
                onTap: () {
                  // Handle option tap
                },
              ),
            )
            .animate()
            .fadeIn(delay: Duration(milliseconds: 1200 + (index * 100)))
            .slideX(begin: 0.3, end: 0, curve: Curves.easeOutBack);
      }).toList(),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
          width: double.infinity,
          height: 56,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.red.withOpacity(0.8),
                Colors.red.withOpacity(0.9),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () => _handleLogout(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.logout, color: AppTheme.primaryWhite),
                const SizedBox(width: 12),
                Text(
                  'Logout',
                  style: AppTheme.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryWhite,
                  ),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(delay: 2000.ms)
        .scale(curve: Curves.elasticOut)
        .shimmer(delay: 2500.ms, duration: 1000.ms);
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.lightBlack,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text('Logout', style: AppTheme.heading3),
          content: Text(
            'Are you sure you want to logout?',
            style: AppTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: AppTheme.bodyMedium.copyWith(color: AppTheme.darkGrey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pushAndRemoveUntil(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const AuthScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: ScaleTransition(
                              scale: Tween<double>(begin: 0.8, end: 1.0)
                                  .animate(
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
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(color: AppTheme.primaryWhite),
              ),
            ),
          ],
        );
      },
    );
  }
}

extension DoubleExtension on double {
  double get sin => math.sin(this);
  double get cos => math.cos(this);
}
