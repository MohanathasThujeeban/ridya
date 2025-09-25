import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_theme.dart';

class RideBookingScreen extends StatefulWidget {
  const RideBookingScreen({super.key});

  @override
  State<RideBookingScreen> createState() => _RideBookingScreenState();
}

class _RideBookingScreenState extends State<RideBookingScreen>
    with TickerProviderStateMixin {
  late AnimationController _floatingButtonController;
  final TextEditingController _pickupController = TextEditingController();
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
    _pickupController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      body: Stack(
        children: [
          // Map background with grid pattern
          _buildMapBackground(),

          // Top header with back button and menu
          _buildTopHeader(),

          // Floating action buttons (right side)
          _buildFloatingActionButtons(),

          // Bottom sheet for ride booking
          _buildRideBookingSheet(),
        ],
      ),
    );
  }

  // Map background placeholder
  Widget _buildMapBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.primaryBlack,
            AppTheme.primaryBlack.withOpacity(0.8),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.location_on,
          size: 100,
          color: AppTheme.primaryOrange.withOpacity(0.3),
        ),
      ),
    );
  }

  // Top header with back button
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
              // Back button
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
                    Icons.arrow_back,
                    color: AppTheme.primaryBlack,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
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
            ],
          ),
        ),
      ),
    );
  }

  // Right side floating buttons
  Widget _buildFloatingActionButtons() {
    return Positioned(
      right: 16,
      top: MediaQuery.of(context).size.height * 0.35,
      child: Column(
        children: [
          _buildFloatingButton(Icons.my_location, () {
            // Location button action placeholder
          }),
          const SizedBox(height: 12),
          _buildFloatingButton(Icons.layers, () {
            // Toggle map type or show layer options
          }),
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

  // Ride booking bottom sheet
  Widget _buildRideBookingSheet() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child:
          Container(
            decoration: const BoxDecoration(
              color: AppTheme.primaryWhite,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
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
                  margin: const EdgeInsets.only(top: 12),
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                const SizedBox(height: 24),

                // Location inputs
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Pickup location
                      _buildLocationInput(
                        icon: Icons.radio_button_checked,
                        iconColor: AppTheme.primaryOrange,
                        hintText: 'Pickup location',
                        controller: _pickupController,
                      ),

                      const SizedBox(height: 16),

                      // Destination
                      _buildLocationInput(
                        icon: Icons.location_on,
                        iconColor: Colors.red,
                        hintText: 'Where to?',
                        controller: _destinationController,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Ride options
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Choose a ride',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryBlack,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildRideOption(
                        title: 'RidyaGo',
                        subtitle: 'Affordable, everyday rides',
                        price: '₹120',
                        time: '2 min',
                        icon: Icons.directions_car,
                        isSelected: true,
                      ),
                      const SizedBox(height: 12),
                      _buildRideOption(
                        title: 'RidyaXL',
                        subtitle: '6 seats',
                        price: '₹150',
                        time: '3 min',
                        icon: Icons.airport_shuttle,
                        isSelected: false,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Book ride button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryOrange.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle ride booking
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Book Ride',
                        style: TextStyle(
                          color: AppTheme.primaryWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
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

  Widget _buildLocationInput({
    required IconData icon,
    required Color iconColor,
    required String hintText,
    required TextEditingController controller,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE9ECEF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white,
                hintStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRideOption({
    required String title,
    required String subtitle,
    required String price,
    required String time,
    required IconData icon,
    required bool isSelected,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected
            ? AppTheme.primaryOrange.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppTheme.primaryOrange : const Color(0xFFE9ECEF),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primaryOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: AppTheme.primaryOrange, size: 24),
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
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryBlack,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryBlack,
                ),
              ),
              Text(
                time,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Custom painter for map grid effect
class MapGridPainter extends CustomPainter {
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
