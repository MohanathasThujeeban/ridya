import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_theme.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBlack,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Activities',
          style: TextStyle(
            color: AppTheme.primaryWhite,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primaryOrange,
          labelColor: AppTheme.primaryOrange,
          unselectedLabelColor: AppTheme.darkGrey,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          tabs: const [
            Tab(text: 'Recent'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRecentTab(),
          _buildCompletedTab(),
          _buildCancelledTab(),
        ],
      ),
    );
  }

  Widget _buildRecentTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Currently booking section
        _buildSectionTitle('Currently Booking'),
        const SizedBox(height: 12),
        _buildCurrentBookingCard(),
        const SizedBox(height: 24),

        // Recent rides section
        _buildSectionTitle('Recent Rides'),
        const SizedBox(height: 12),
        _buildRideCard(
          status: 'Completed',
          statusColor: Colors.green,
          fromLocation: 'Home',
          fromAddress: '123 Main Street, Downtown',
          toLocation: 'Office',
          toAddress: '456 Business Ave, City Center',
          date: 'Today',
          time: '8:30 AM',
          fare: '\$12.50',
          driverName: 'John Smith',
          rating: 4.8,
          vehicleInfo: 'Toyota Camry • ABC-123',
        ),
        const SizedBox(height: 12),
        _buildRideCard(
          status: 'Completed',
          statusColor: Colors.green,
          fromLocation: 'Shopping Mall',
          fromAddress: '789 Mall Road, Westside',
          toLocation: 'Home',
          toAddress: '123 Main Street, Downtown',
          date: 'Yesterday',
          time: '6:15 PM',
          fare: '\$8.75',
          driverName: 'Sarah Johnson',
          rating: 5.0,
          vehicleInfo: 'Honda Civic • XYZ-789',
        ),
        const SizedBox(height: 12),
        _buildRideCard(
          status: 'Completed',
          statusColor: Colors.green,
          fromLocation: 'Airport',
          fromAddress: 'International Airport Terminal 1',
          toLocation: 'Hotel',
          toAddress: '321 Hotel Plaza, Central District',
          date: 'Dec 23',
          time: '2:45 PM',
          fare: '\$35.20',
          driverName: 'Mike Wilson',
          rating: 4.5,
          vehicleInfo: 'Hyundai Sonata • DEF-456',
        ),
      ],
    ).animate().fadeIn(duration: 600.ms);
  }

  Widget _buildCompletedTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionTitle('This Week'),
        const SizedBox(height: 12),
        _buildRideCard(
          status: 'Completed',
          statusColor: Colors.green,
          fromLocation: 'Home',
          fromAddress: '123 Main Street, Downtown',
          toLocation: 'Gym',
          toAddress: '789 Fitness Center, North Side',
          date: 'Dec 22',
          time: '7:00 AM',
          fare: '\$6.30',
          driverName: 'Emily Davis',
          rating: 4.9,
          vehicleInfo: 'Nissan Altima • GHI-789',
        ),
        const SizedBox(height: 12),
        _buildRideCard(
          status: 'Completed',
          statusColor: Colors.green,
          fromLocation: 'Restaurant',
          fromAddress: '456 Food Street, Downtown',
          toLocation: 'Friend\'s House',
          toAddress: '654 Residential Ave, Suburbs',
          date: 'Dec 21',
          time: '9:30 PM',
          fare: '\$14.80',
          driverName: 'Alex Chen',
          rating: 4.7,
          vehicleInfo: 'Ford Focus • JKL-012',
        ),
        const SizedBox(height: 24),
        _buildSectionTitle('Earlier This Month'),
        const SizedBox(height: 12),
        _buildRideCard(
          status: 'Completed',
          statusColor: Colors.green,
          fromLocation: 'Doctor\'s Office',
          fromAddress: '987 Medical Center, Health District',
          toLocation: 'Pharmacy',
          toAddress: '321 Medicine Street, Near Hospital',
          date: 'Dec 18',
          time: '3:15 PM',
          fare: '\$4.50',
          driverName: 'Lisa Brown',
          rating: 5.0,
          vehicleInfo: 'Chevrolet Malibu • MNO-345',
        ),
      ],
    ).animate().fadeIn(duration: 600.ms, delay: 100.ms);
  }

  Widget _buildCancelledTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildRideCard(
          status: 'Cancelled',
          statusColor: Colors.red,
          fromLocation: 'Home',
          fromAddress: '123 Main Street, Downtown',
          toLocation: 'Meeting Venue',
          toAddress: '789 Conference Center, Business Park',
          date: 'Dec 20',
          time: '10:00 AM',
          fare: 'Refunded',
          cancelReason: 'Driver unavailable',
          showCancelReason: true,
        ),
        const SizedBox(height: 12),
        _buildRideCard(
          status: 'Cancelled',
          statusColor: Colors.red,
          fromLocation: 'Airport',
          fromAddress: 'International Airport Terminal 2',
          toLocation: 'Home',
          toAddress: '123 Main Street, Downtown',
          date: 'Dec 15',
          time: '11:45 PM',
          fare: 'Refunded',
          cancelReason: 'Flight delayed - cancelled by user',
          showCancelReason: true,
        ),
      ],
    ).animate().fadeIn(duration: 600.ms, delay: 200.ms);
  }

  Widget _buildCurrentBookingCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryOrange.withOpacity(0.2),
            AppTheme.primaryOrange.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryOrange.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryOrange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Active',
                  style: TextStyle(
                    color: AppTheme.primaryWhite,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              const Text(
                'Looking for driver...',
                style: TextStyle(
                  color: AppTheme.primaryOrange,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(width: 2, height: 30, color: AppTheme.darkGrey),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryOrange,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Location',
                      style: TextStyle(
                        color: AppTheme.primaryWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '123 Main Street, Downtown',
                      style: TextStyle(color: AppTheme.darkGrey, fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'City Mall',
                      style: TextStyle(
                        color: AppTheme.primaryWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '789 Shopping Center, West District',
                      style: TextStyle(color: AppTheme.darkGrey, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Estimated fare: \$9.50',
                style: TextStyle(color: AppTheme.darkGrey, fontSize: 14),
              ),
              TextButton(
                onPressed: () {
                  // Cancel booking
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRideCard({
    required String status,
    required Color statusColor,
    required String fromLocation,
    required String fromAddress,
    required String toLocation,
    required String toAddress,
    required String date,
    required String time,
    required String fare,
    String? driverName,
    double? rating,
    String? vehicleInfo,
    bool showCancelReason = false,
    String? cancelReason,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightBlack,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: statusColor.withOpacity(0.3)),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    date,
                    style: TextStyle(color: AppTheme.darkGrey, fontSize: 12),
                  ),
                  Text(
                    time,
                    style: TextStyle(color: AppTheme.darkGrey, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(width: 2, height: 30, color: AppTheme.darkGrey),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryOrange,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fromLocation,
                      style: const TextStyle(
                        color: AppTheme.primaryWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      fromAddress,
                      style: TextStyle(color: AppTheme.darkGrey, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      toLocation,
                      style: const TextStyle(
                        color: AppTheme.primaryWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      toAddress,
                      style: TextStyle(color: AppTheme.darkGrey, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (showCancelReason && cancelReason != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.red, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      cancelReason,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (driverName != null) ...[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        driverName,
                        style: const TextStyle(
                          color: AppTheme.primaryWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (vehicleInfo != null)
                        Text(
                          vehicleInfo,
                          style: TextStyle(
                            color: AppTheme.darkGrey,
                            fontSize: 12,
                          ),
                        ),
                      if (rating != null)
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              rating.toStringAsFixed(1),
                              style: TextStyle(
                                color: AppTheme.darkGrey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
              Text(
                fare,
                style: const TextStyle(
                  color: AppTheme.primaryOrange,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppTheme.primaryWhite,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
