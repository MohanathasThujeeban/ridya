import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_theme.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _floatingButtonController;
  final TextEditingController _destinationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _floatingButtonController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatingButtonController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      body: Stack(
        children: [
          // Map background (simulated)
          _buildMapBackground(),

          // Top header with user profile and menu
          _buildTopHeader(),

          // Floating action buttons (right side)
          _buildFloatingActionButtons(),

          // Bottom draggable sheet
          _buildBottomSheet(),
        ],
      ),
    );
  }

  // Simulated map background with grid pattern like Uber
  Widget _buildMapBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1a1a1a), Color(0xFF0d0d0d)],
        ),
      ),
      child: Stack(
        children: [
          // Static grid pattern
          Container(
            width: double.infinity,
            height: double.infinity,
            child: CustomPaint(painter: SimpleMapGridPainter()),
          ),
          // Floating dots for map effect
          ...List.generate(15, (index) {
            return Positioned(
              left: (index * 50 + 25) % MediaQuery.of(context).size.width,
              top: (index * 70 + 50) % MediaQuery.of(context).size.height,
              child: Container(
                width: 3,
                height: 3,
                decoration: BoxDecoration(
                  color: AppTheme.primaryOrange.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // Top header like Uber with menu and profile
  Widget _buildTopHeader() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Menu button
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.primaryWhite,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.menu,
                    color: AppTheme.primaryBlack,
                    size: 20,
                  ),
                  onPressed: () {},
                ),
              ),
              // Profile button
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const ProfileScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
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
                      transitionDuration: const Duration(milliseconds: 300),
                    ),
                  );
                },
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryOrange.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.person,
                    color: AppTheme.primaryWhite,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Right side floating buttons like Uber
  Widget _buildFloatingActionButtons() {
    return Positioned(
      right: 16,
      top: MediaQuery.of(context).size.height * 0.35,
      child: Column(
        children: [
          _buildFloatingButton(Icons.my_location, () {}),
          const SizedBox(height: 12),
          _buildFloatingButton(Icons.layers, () {}),
        ],
      ),
    );
  }

  Widget _buildFloatingButton(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppTheme.primaryWhite,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: AppTheme.primaryBlack, size: 20),
        onPressed: onPressed,
      ),
    );
  }

  // Bottom sheet like Uber's
  Widget _buildBottomSheet() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child:
          Container(
            decoration: const BoxDecoration(
              color: AppTheme.primaryWhite,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 16,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                const SizedBox(height: 24),

                // Main destination input
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryOrange,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Where to?',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Service options (Uber-style)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _buildServiceOption(Icons.directions_car, 'Ride', true),
                      const SizedBox(width: 12),
                      _buildServiceOption(Icons.two_wheeler, 'Bike', false),
                      const SizedBox(width: 12),
                      _buildServiceOption(
                        Icons.delivery_dining,
                        'Delivery',
                        false,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Quick destinations
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _buildDestinationRow(
                        Icons.home_outlined,
                        'Home',
                        'Add home address',
                      ),
                      const SizedBox(height: 16),
                      _buildDestinationRow(
                        Icons.work_outline,
                        'Work',
                        'Add work address',
                      ),
                      const SizedBox(height: 16),
                      _buildDestinationRow(
                        Icons.schedule,
                        'Scheduled rides',
                        null,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ).animate().slideY(
            begin: 1.0,
            end: 0,
            duration: 800.ms,
            curve: Curves.easeOutCubic,
          ),
    );
  }

  Widget _buildServiceOption(IconData icon, String label, bool isSelected) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryOrange.withOpacity(0.1)
              : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryOrange
                : const Color(0xFFE0E0E0),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primaryOrange : Colors.grey[600],
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppTheme.primaryOrange : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDestinationRow(IconData icon, String title, String? subtitle) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, color: Colors.grey[600], size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// Simple custom painter for map grid effect
class SimpleMapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryOrange.withOpacity(0.08)
      ..strokeWidth = 0.5;

    const gridSize = 40.0;

    // Draw vertical lines
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
