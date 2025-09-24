import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _floatingButtonController;

  @override
  void initState() {
    super.initState();
    _floatingButtonController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatingButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      body: Stack(
        children: [
          // Map placeholder (will be replaced with Google Maps)
          Container(
            decoration: const BoxDecoration(gradient: AppTheme.darkGradient),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 100, color: AppTheme.primaryOrange),
                  SizedBox(height: 20),
                  Text('Map Integration Coming Soon', style: AppTheme.heading2),
                  SizedBox(height: 10),
                  Text(
                    'Google Maps will be integrated here',
                    style: AppTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),

          // 3D Floating Action Buttons
          Positioned(
            right: 20,
            top: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              children: [
                _build3DFloatingButton(
                  icon: Icons.my_location,
                  onPressed: () {},
                  delay: 0,
                ),
                const SizedBox(height: 16),
                _build3DFloatingButton(
                  icon: Icons.directions_car,
                  onPressed: () {},
                  delay: 200,
                ),
                const SizedBox(height: 16),
                _build3DFloatingButton(
                  icon: Icons.favorite,
                  onPressed: () {},
                  delay: 400,
                ),
              ],
            ),
          ),

          // Bottom Sheet Preview
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _build3DBottomSheet(),
          ),
        ],
      ),
    );
  }

  Widget _build3DFloatingButton({
    required IconData icon,
    required VoidCallback onPressed,
    required int delay,
  }) {
    return AnimatedBuilder(
          animation: _floatingButtonController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _floatingButtonController.value * 4),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppTheme.primaryGradient,
                  boxShadow: AppTheme.floatingShadow,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(28),
                    onTap: onPressed,
                    child: Icon(icon, color: AppTheme.primaryWhite, size: 24),
                  ),
                ),
              ),
            );
          },
        )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: delay),
          duration: 400.ms,
        )
        .slideX(begin: 1.0, end: 0, curve: Curves.easeOutBack);
  }

  Widget _build3DBottomSheet() {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppTheme.lightBlack, AppTheme.primaryBlack],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: AppTheme.darkGrey,
            ),
          ),

          const SizedBox(height: 20),

          const Text('Where to?', style: AppTheme.heading3),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: AppTheme.inputRadius,
                color: AppTheme.greyBlack,
                boxShadow: AppTheme.cardShadow,
              ),
              child: const TextField(
                style: AppTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Enter destination',
                  hintStyle: AppTheme.bodySmall,
                  prefixIcon: Icon(Icons.search, color: AppTheme.primaryOrange),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Quick action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickActionButton(Icons.home, 'Home'),
              _buildQuickActionButton(Icons.work, 'Work'),
              _buildQuickActionButton(Icons.history, 'Recent'),
              _buildQuickActionButton(Icons.star, 'Saved'),
            ],
          ),
        ],
      ),
    ).animate().slideY(
      begin: 1.0,
      end: 0,
      duration: 600.ms,
      curve: Curves.easeOutBack,
    );
  }

  Widget _buildQuickActionButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.greyBlack,
            boxShadow: AppTheme.cardShadow,
          ),
          child: Icon(icon, color: AppTheme.primaryOrange, size: 20),
        ),
        const SizedBox(height: 8),
        Text(label, style: AppTheme.caption),
      ],
    );
  }
}
