import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_theme.dart';
import 'rider_matching_screen.dart';

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
  bool _isSearchingRiders = false;
  bool _hasSelectedDestination = false;
  List<Map<String, dynamic>> _availableRiders = [];
  int _selectedRiderIndex = 0;

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

  // Fetch current location
  void _fetchCurrentLocation() {
    setState(() {
      _pickupController.text = "Fetching current location...";
    });

    // Simulate location fetching
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _pickupController.text = "123 Main Street, City Center, Your City";
      });
    });
  }

  // Search for available riders
  void _searchAvailableRiders() {
    if (_destinationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your destination'),
          backgroundColor: AppTheme.primaryOrange,
        ),
      );
      return;
    }

    setState(() {
      _isSearchingRiders = true;
      _hasSelectedDestination = true;
    });

    // Simulate searching for riders
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isSearchingRiders = false;
        _availableRiders = [
          {
            'vehicleType': '🏍️ RideyaBike',
            'subtitle': 'Motorbike • Quick & Easy',
            'icon': Icons.two_wheeler,
            'estimatedTime': '2 min',
            'price': 50,
            'distance': '1.8 km',
            'capacity': '1 person',
          },
          {
            'vehicleType': '🛺 RideyaAuto',
            'subtitle': 'Three Wheeler • Affordable rides',
            'icon': Icons.electric_rickshaw,
            'estimatedTime': '3 min',
            'price': 80,
            'distance': '2.1 km',
            'capacity': '3 persons',
          },
          {
            'vehicleType': '🚗 RideyaCar',
            'subtitle': 'Car • Comfortable rides',
            'icon': Icons.directions_car,
            'estimatedTime': '4 min',
            'price': 120,
            'distance': '2.5 km',
            'capacity': '4 persons',
          },
          {
            'vehicleType': '🚐 RideyaVan',
            'subtitle': 'Van • Group travels',
            'icon': Icons.airport_shuttle,
            'estimatedTime': '5 min',
            'price': 150,
            'distance': '2.8 km',
            'capacity': '7 persons',
          },
          {
            'vehicleType': '🚌 RideyaXL',
            'subtitle': 'XL Van • Large groups',
            'icon': Icons.rv_hookup,
            'estimatedTime': '7 min',
            'price': 200,
            'distance': '3.2 km',
            'capacity': '12 persons',
          },
        ];
      });
    });
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
          _buildFloatingButton(Icons.my_location, _fetchCurrentLocation),
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
                        showFetchButton: true,
                      ),

                      const SizedBox(height: 16),

                      // Destination
                      _buildLocationInput(
                        icon: Icons.location_on,
                        iconColor: Colors.red,
                        hintText: 'Where to?',
                        controller: _destinationController,
                        showFetchButton: false,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Search Riders or Available Riders
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!_hasSelectedDestination) ...[
                        const Text(
                          'Enter destination to search riders',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.primaryBlack,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: AppTheme.primaryGradient,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ElevatedButton(
                            onPressed: _searchAvailableRiders,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Search Available Riders',
                              style: TextStyle(
                                color: AppTheme.primaryWhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ] else if (_isSearchingRiders) ...[
                        const Center(
                          child: Column(
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.primaryOrange,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Searching for available riders...',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppTheme.primaryBlack,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else if (_availableRiders.isNotEmpty) ...[
                        const Text(
                          'Choose Your Ride',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryBlack,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            itemCount: _availableRiders.length,
                            itemBuilder: (context, index) {
                              final rider = _availableRiders[index];
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedRiderIndex = index;
                                  });
                                },
                                child: _buildRiderCard(
                                  rider,
                                  index == _selectedRiderIndex,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Confirm booking button (only show when riders are available)
                if (_availableRiders.isNotEmpty && !_isSearchingRiders)
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
                          _confirmBooking();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Confirm Booking',
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
    required bool showFetchButton,
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
          if (showFetchButton)
            Container(
              margin: const EdgeInsets.only(left: 8),
              child: TextButton(
                onPressed: _fetchCurrentLocation,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  backgroundColor: AppTheme.primaryOrange.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Fetch Location',
                  style: TextStyle(
                    color: AppTheme.primaryOrange,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Build rider card widget
  Widget _buildRiderCard(Map<String, dynamic> rider, bool isSelected) {
    // Extract values with proper null checks and defaults
    final String vehicleType =
        rider['vehicleType'] as String? ?? 'Unknown Vehicle';
    final String subtitle =
        rider['subtitle'] as String? ?? 'Vehicle Description';
    final IconData icon = rider['icon'] as IconData? ?? Icons.directions_car;
    final String capacity = rider['capacity'] as String? ?? '1 person';
    final String distance = rider['distance'] as String? ?? '0 km';
    final int price = rider['price'] as int? ?? 0;
    final String estimatedTime = rider['estimatedTime'] as String? ?? '0 min';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          // Vehicle icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppTheme.primaryOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(icon, color: AppTheme.primaryOrange, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vehicleType,
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
                Row(
                  children: [
                    Icon(Icons.people, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '$capacity • $distance away',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹$price',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryOrange,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.primaryOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'ETA: $estimatedTime',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.primaryOrange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Confirm booking method
  void _confirmBooking() {
    if (_availableRiders.isEmpty ||
        _selectedRiderIndex >= _availableRiders.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a valid ride option'),
          backgroundColor: AppTheme.primaryOrange,
        ),
      );
      return;
    }

    final selectedRider = _availableRiders[_selectedRiderIndex];
    final String vehicleType =
        selectedRider['vehicleType'] as String? ?? 'Unknown Vehicle';
    final String capacity = selectedRider['capacity'] as String? ?? '1 person';
    final int price = selectedRider['price'] as int? ?? 0;
    final String estimatedTime =
        selectedRider['estimatedTime'] as String? ?? '0 min';
    final String distance = selectedRider['distance'] as String? ?? '0 km';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.primaryWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Confirm Booking',
            style: TextStyle(
              color: AppTheme.primaryBlack,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.primaryOrange.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vehicle: $vehicleType',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryBlack,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Capacity: $capacity',
                      style: TextStyle(color: Colors.grey[700], fontSize: 14),
                    ),
                    Text(
                      'Price: ₹$price',
                      style: const TextStyle(
                        color: AppTheme.primaryOrange,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'ETA: $estimatedTime',
                      style: TextStyle(color: Colors.grey[700], fontSize: 14),
                    ),
                    Text(
                      'Distance: $distance',
                      style: TextStyle(color: Colors.grey[700], fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Are you sure you want to book this ride? A driver will be assigned and will arrive at your pickup location.',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryOrange.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _navigateToRiderMatching();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Confirm',
                  style: TextStyle(
                    color: AppTheme.primaryWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Navigate to rider matching screen
  void _navigateToRiderMatching() {
    final selectedRider = _availableRiders[_selectedRiderIndex];
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            RiderMatchingScreen(
              selectedVehicle: selectedRider,
              pickupLocation: _pickupController.text,
              destination: _destinationController.text,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
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
