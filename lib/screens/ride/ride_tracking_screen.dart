import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_theme.dart';

class RideTrackingScreen extends StatefulWidget {
  final Map<String, dynamic> riderInfo;
  final Map<String, dynamic> vehicleInfo;
  final String pickupLocation;
  final String destination;

  const RideTrackingScreen({
    super.key,
    required this.riderInfo,
    required this.vehicleInfo,
    required this.pickupLocation,
    required this.destination,
  });

  @override
  State<RideTrackingScreen> createState() => _RideTrackingScreenState();
}

class _RideTrackingScreenState extends State<RideTrackingScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _riderMoveController;

  String _currentStatus = 'on_the_way';
  double _riderLatOffset = 0.3; // Simulated rider position
  double _riderLngOffset = 0.2;
  int _estimatedTime = 3; // minutes

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _riderMoveController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );

    _startRideTracking();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _riderMoveController.dispose();
    super.dispose();
  }

  void _startRideTracking() {
    // Simulate rider movement towards pickup location
    _riderMoveController.addListener(() {
      setState(() {
        _riderLatOffset = 0.3 * (1 - _riderMoveController.value);
        _riderLngOffset = 0.2 * (1 - _riderMoveController.value);
        _estimatedTime = (3 * (1 - _riderMoveController.value)).round();
        if (_estimatedTime < 1) _estimatedTime = 1;
      });
    });

    _riderMoveController.forward();

    // Simulate status updates
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _currentStatus = 'nearby';
        });
      }
    });

    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          _currentStatus = 'arrived';
          _estimatedTime = 0;
        });
      }
    });
  }

  void _callRider() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Calling ${widget.riderInfo['name']}...'),
        backgroundColor: AppTheme.primaryOrange,
      ),
    );
  }

  void _cancelRide() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.primaryWhite,
          title: const Text(
            'Cancel Ride',
            style: TextStyle(
              color: AppTheme.primaryBlack,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Text(
            'Are you sure you want to cancel this ride? You may be charged a cancellation fee.',
            style: TextStyle(color: AppTheme.primaryBlack),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Keep Ride',
                style: TextStyle(color: AppTheme.primaryOrange),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text(
                'Cancel Ride',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show confirmation dialog when trying to go back during active ride
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('End Ride'),
            content: const Text(
              'Are you sure you want to end this ride and go back?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Stay'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('End Ride'),
              ),
            ],
          ),
        );
        return shouldPop ?? false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Map background
            _buildMapView(),

            // Top overlay with rider info
            _buildTopOverlay(),

            // Bottom sheet with ride details
            _buildBottomSheet(),

            // Floating action buttons
            _buildFloatingButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildMapView() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue.shade50, Colors.grey.shade100],
        ),
      ),
      child: Stack(
        children: [
          // Grid pattern to simulate map
          CustomPaint(painter: MapGridPainter(), size: Size.infinite),

          // Road lines
          CustomPaint(painter: RoadPainter(), size: Size.infinite),

          // Customer location (center)
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 30,
            top: MediaQuery.of(context).size.height / 2 - 30,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Pulse circle
                    Container(
                      width: 40 + (_pulseController.value * 20),
                      height: 40 + (_pulseController.value * 20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue.withOpacity(
                          0.3 - (_pulseController.value * 0.2),
                        ),
                      ),
                    ),
                    // Customer marker
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Rider location (moving)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            left:
                MediaQuery.of(context).size.width / 2 -
                30 +
                (_riderLngOffset * 200),
            top:
                MediaQuery.of(context).size.height / 2 -
                30 +
                (_riderLatOffset * 150),
            child:
                Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryOrange,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        widget.vehicleInfo['icon'] as IconData? ??
                            Icons.directions_car,
                        color: Colors.white,
                        size: 24,
                      ),
                    )
                    .animate(onPlay: (controller) => controller.repeat())
                    .shimmer(
                      duration: 2000.ms,
                      color: Colors.white.withOpacity(0.3),
                    ),
          ),

          // Route line (dotted)
          CustomPaint(
            painter: RoutePainter(
              startX: MediaQuery.of(context).size.width / 2,
              startY: MediaQuery.of(context).size.height / 2,
              endX:
                  MediaQuery.of(context).size.width / 2 +
                  (_riderLngOffset * 200),
              endY:
                  MediaQuery.of(context).size.height / 2 +
                  (_riderLatOffset * 150),
            ),
            size: Size.infinite,
          ),
        ],
      ),
    );
  }

  Widget _buildTopOverlay() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.primaryWhite,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Back button
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              const SizedBox(width: 16),

              // Status info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getStatusText(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryBlack,
                      ),
                    ),
                    if (_estimatedTime > 0)
                      Text(
                        '$_estimatedTime min away',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                  ],
                ),
              ),

              // Status indicator
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _getStatusColor(),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _currentStatus == 'arrived' ? 'Arrived' : 'En Route',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: _getStatusColor(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: const BoxDecoration(
          color: AppTheme.primaryWhite,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
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
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Rider info card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        // Rider avatar
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryOrange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: AppTheme.primaryOrange,
                            size: 24,
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Rider details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.riderInfo['name'],
                                style: const TextStyle(
                                  fontSize: 16,
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
                                    '${widget.riderInfo['rating']}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '• ${widget.riderInfo['plateNumber']}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Call button
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: IconButton(
                            onPressed: _callRider,
                            icon: const Icon(
                              Icons.phone,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Trip details
                  Row(
                    children: [
                      // Pickup info
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.radio_button_checked,
                                color: Colors.blue,
                                size: 24,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Pickup',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.pickupLocation,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.primaryBlack,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Destination info
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryOrange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: AppTheme.primaryOrange,
                                size: 24,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Destination',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.primaryOrange,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.destination,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.primaryBlack,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _cancelRide,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Cancel Ride',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Sending message to rider...'),
                                backgroundColor: AppTheme.primaryOrange,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryOrange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Message',
                            style: TextStyle(
                              color: AppTheme.primaryWhite,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingButtons() {
    return Positioned(
      right: 16,
      top: MediaQuery.of(context).size.height * 0.4,
      child: Column(
        children: [
          _buildFloatingButton(Icons.my_location, () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Centering on your location...'),
                backgroundColor: AppTheme.primaryOrange,
              ),
            );
          }),
          const SizedBox(height: 12),
          _buildFloatingButton(Icons.zoom_in, () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Zooming in...'),
                backgroundColor: AppTheme.primaryOrange,
              ),
            );
          }),
          const SizedBox(height: 12),
          _buildFloatingButton(Icons.zoom_out, () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Zooming out...'),
                backgroundColor: AppTheme.primaryOrange,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFloatingButton(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppTheme.primaryWhite,
        borderRadius: BorderRadius.circular(24),
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

  String _getStatusText() {
    switch (_currentStatus) {
      case 'on_the_way':
        return '${widget.riderInfo['name']} is on the way';
      case 'nearby':
        return 'Rider is nearby';
      case 'arrived':
        return 'Rider has arrived!';
      default:
        return 'Tracking your ride';
    }
  }

  Color _getStatusColor() {
    switch (_currentStatus) {
      case 'on_the_way':
        return AppTheme.primaryOrange;
      case 'nearby':
        return Colors.amber;
      case 'arrived':
        return Colors.green;
      default:
        return AppTheme.primaryOrange;
    }
  }
}

// Custom painter for map grid
class MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 0.5;

    const gridSize = 30.0;

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

// Custom painter for roads
class RoadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 4;

    // Draw some road lines
    canvas.drawLine(
      Offset(0, size.height * 0.3),
      Offset(size.width, size.height * 0.3),
      paint,
    );

    canvas.drawLine(
      Offset(size.width * 0.6, 0),
      Offset(size.width * 0.6, size.height),
      paint,
    );

    canvas.drawLine(
      Offset(0, size.height * 0.7),
      Offset(size.width, size.height * 0.7),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom painter for route line
class RoutePainter extends CustomPainter {
  final double startX, startY, endX, endY;

  const RoutePainter({
    required this.startX,
    required this.startY,
    required this.endX,
    required this.endY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryOrange
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(startX, startY);

    // Create a curved path
    final controlX = (startX + endX) / 2;
    final controlY = (startY + endY) / 2 - 50;

    path.quadraticBezierTo(controlX, controlY, endX, endY);

    // Draw dashed line
    const dashWidth = 8.0;
    const dashSpace = 4.0;

    final pathMetrics = path.computeMetrics();
    for (final pathMetric in pathMetrics) {
      double distance = 0.0;
      bool draw = true;

      while (distance < pathMetric.length) {
        final length = draw ? dashWidth : dashSpace;
        final end = distance + length;

        if (draw) {
          final extractPath = pathMetric.extractPath(distance, end);
          canvas.drawPath(extractPath, paint);
        }

        distance = end;
        draw = !draw;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
