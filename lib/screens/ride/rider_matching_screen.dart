import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_theme.dart';
import 'ride_tracking_screen.dart';

class RiderMatchingScreen extends StatefulWidget {
  final Map<String, dynamic> selectedVehicle;
  final String pickupLocation;
  final String destination;

  const RiderMatchingScreen({
    super.key,
    required this.selectedVehicle,
    required this.pickupLocation,
    required this.destination,
  });

  @override
  State<RiderMatchingScreen> createState() => _RiderMatchingScreenState();
}

class _RiderMatchingScreenState extends State<RiderMatchingScreen>
    with TickerProviderStateMixin {
  late AnimationController _searchAnimationController;
  late AnimationController _pulseController;

  String _currentStatus = 'searching';
  Map<String, dynamic>? _matchedRider;
  int _searchProgress = 0;

  @override
  void initState() {
    super.initState();
    _searchAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _startRiderSearch();
  }

  @override
  void dispose() {
    _searchAnimationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  // Simulate rider search process
  void _startRiderSearch() {
    // Simulate searching progress
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _searchProgress = 25;
          _currentStatus = 'searching_nearby';
        });
      }
    });

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _searchProgress = 50;
          _currentStatus = 'found_riders';
        });
      }
    });

    Future.delayed(const Duration(seconds: 6), () {
      if (mounted) {
        setState(() {
          _searchProgress = 75;
          _currentStatus = 'connecting';
        });
      }
    });

    Future.delayed(const Duration(seconds: 8), () {
      if (mounted) {
        setState(() {
          _searchProgress = 100;
          _currentStatus = 'matched';
          _matchedRider = {
            'name': 'Rajesh Kumar',
            'rating': 4.8,
            'vehicle': '${widget.selectedVehicle['vehicleType']}',
            'plateNumber': 'DL 12 AB 3456',
            'phone': '+91 98765 43210',
            'estimatedArrival': '3 min',
            'profileImage': 'assets/images/driver_avatar.jpg',
            'totalTrips': 1247,
          };
        });
        _searchAnimationController.stop();
        _pulseController.stop();
      }
    });
  }

  // Cancel booking
  void _cancelBooking() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Booking'),
          content: const Text(
            'Are you sure you want to cancel this ride booking?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No, Continue'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text(
                'Yes, Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // Call rider
  void _callRider() {
    if (_matchedRider != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Calling ${_matchedRider!['name']}...'),
          backgroundColor: AppTheme.primaryOrange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Main content
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                decoration: const BoxDecoration(
                  color: AppTheme.primaryWhite,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: _currentStatus == 'matched'
                    ? _buildMatchedRiderContent()
                    : _buildSearchingContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Header with back button
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.primaryWhite,
              borderRadius: BorderRadius.circular(22),
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
          const SizedBox(width: 16),
          const Text(
            'Finding Your Ride',
            style: TextStyle(
              color: AppTheme.primaryWhite,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Searching content
  Widget _buildSearchingContent() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const SizedBox(height: 40),

          // Animated search indicator
          SizedBox(
            height: 200,
            width: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Pulse animation
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Container(
                      height: 160 + (_pulseController.value * 40),
                      width: 160 + (_pulseController.value * 40),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.primaryOrange.withOpacity(
                            0.3 - (_pulseController.value * 0.3),
                          ),
                          width: 2,
                        ),
                      ),
                    );
                  },
                ),

                // Center icon
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppTheme.primaryGradient,
                  ),
                  child: Icon(
                    widget.selectedVehicle['icon'] as IconData? ??
                        Icons.directions_car,
                    color: AppTheme.primaryWhite,
                    size: 60,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Status text
          Text(
            _getStatusText(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryBlack,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          Text(
            _getStatusSubtext(),
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 40),

          // Progress indicator
          Container(
            width: double.infinity,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: _searchProgress / 100,
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            '${_searchProgress}% Complete',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),

          const Spacer(),

          // Cancel button
          Container(
            width: double.infinity,
            height: 56,
            margin: const EdgeInsets.only(bottom: 20),
            child: OutlinedButton(
              onPressed: _cancelBooking,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.primaryOrange),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Cancel Booking',
                style: TextStyle(
                  color: AppTheme.primaryOrange,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Matched rider content
  Widget _buildMatchedRiderContent() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const SizedBox(height: 20),

          // Success animation
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 80,
          ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),

          const SizedBox(height: 24),

          const Text(
            'Rider Found!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryBlack,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Your ${widget.selectedVehicle['vehicleType']} is on the way',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // Rider info card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    // Rider avatar
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryOrange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: AppTheme.primaryOrange,
                        size: 30,
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Rider details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _matchedRider!['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryBlack,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 16,
                                color: Colors.amber[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${_matchedRider!['rating']}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '• ${_matchedRider!['totalTrips']} trips',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          Text(
                            _matchedRider!['plateNumber'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Call button
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: IconButton(
                        onPressed: _callRider,
                        icon: const Icon(
                          Icons.phone,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ETA info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.access_time,
                  color: AppTheme.primaryOrange,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Estimated Arrival',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primaryOrange,
                      ),
                    ),
                    Text(
                      _matchedRider!['estimatedArrival'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryBlack,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Spacer(),

          // Track ride button
          Container(
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
                // Navigate to ride tracking screen
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        RideTrackingScreen(
                          riderInfo: _matchedRider!,
                          vehicleInfo: widget.selectedVehicle,
                          pickupLocation: widget.pickupLocation,
                          destination: widget.destination,
                        ),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                          const begin = Offset(0.0, 1.0);
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
                    transitionDuration: const Duration(milliseconds: 400),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Track Your Ride',
                style: TextStyle(
                  color: AppTheme.primaryWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText() {
    switch (_currentStatus) {
      case 'searching':
        return 'Searching for riders...';
      case 'searching_nearby':
        return 'Finding nearby riders';
      case 'found_riders':
        return 'Riders found!';
      case 'connecting':
        return 'Connecting with rider...';
      default:
        return 'Rider matched!';
    }
  }

  String _getStatusSubtext() {
    switch (_currentStatus) {
      case 'searching':
        return 'Looking for available ${widget.selectedVehicle['vehicleType']} in your area';
      case 'searching_nearby':
        return 'Checking riders within 2 km radius';
      case 'found_riders':
        return 'Found 3 available riders nearby';
      case 'connecting':
        return 'Contacting the best match for you';
      default:
        return 'Your ride is confirmed and on the way!';
    }
  }
}
