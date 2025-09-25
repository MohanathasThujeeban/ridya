import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_theme.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
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
          'Notifications',
          style: TextStyle(
            color: AppTheme.primaryWhite,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.mark_email_read_outlined,
              color: AppTheme.primaryOrange,
            ),
            onPressed: () {
              // Mark all as read
            },
          ),
        ],
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
            Tab(text: 'All'),
            Tab(text: 'Rides'),
            Tab(text: 'Promotions'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildAllTab(), _buildRidesTab(), _buildPromotionsTab()],
      ),
    );
  }

  Widget _buildAllTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildNotificationCard(
          icon: Icons.directions_car,
          iconColor: AppTheme.primaryOrange,
          title: 'Driver Found!',
          subtitle: 'Sarah is on her way to pick you up',
          description: 'Honda Civic • ABC-789 • ETA: 3 minutes',
          time: '2 minutes ago',
          isUnread: true,
          actionText: 'View Details',
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _buildNotificationCard(
          icon: Icons.local_offer,
          iconColor: Colors.green,
          title: '50% Off Your Next Ride!',
          subtitle: 'Limited time offer for premium users',
          description:
              'Use code SAVE50 to get 50% discount on your next ride. Valid until Dec 31st.',
          time: '1 hour ago',
          isUnread: true,
          actionText: 'Use Coupon',
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _buildNotificationCard(
          icon: Icons.check_circle,
          iconColor: Colors.green,
          title: 'Trip Completed Successfully',
          subtitle: 'Your ride to City Mall has been completed',
          description: 'Total fare: \$12.50 • Please rate your driver',
          time: '3 hours ago',
          isUnread: false,
          actionText: 'Rate Driver',
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _buildNotificationCard(
          icon: Icons.account_balance_wallet,
          iconColor: Colors.blue,
          title: 'Payment Successful',
          subtitle: 'Payment of \$12.50 processed successfully',
          description: 'Payment method: Credit Card ending in 1234',
          time: '3 hours ago',
          isUnread: false,
          actionText: 'View Receipt',
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _buildNotificationCard(
          icon: Icons.security,
          iconColor: Colors.orange,
          title: 'Security Update',
          subtitle: 'Enhanced safety features now available',
          description:
              'We\'ve updated our safety protocols to ensure better ride experiences.',
          time: '1 day ago',
          isUnread: false,
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _buildNotificationCard(
          icon: Icons.star,
          iconColor: Colors.amber,
          title: 'Driver Rated You 5 Stars!',
          subtitle: 'Great passenger experience',
          description:
              'Thank you for being a courteous passenger. Keep up the good work!',
          time: '2 days ago',
          isUnread: false,
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _buildNotificationCard(
          icon: Icons.card_giftcard,
          iconColor: Colors.purple,
          title: 'Referral Reward Earned',
          subtitle: 'You earned \$5 credit for referring a friend',
          description:
              'Your friend John completed their first ride. Enjoy your reward!',
          time: '3 days ago',
          isUnread: false,
          actionText: 'View Wallet',
          onTap: () {},
        ),
      ],
    ).animate().fadeIn(duration: 600.ms);
  }

  Widget _buildRidesTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildNotificationCard(
          icon: Icons.directions_car,
          iconColor: AppTheme.primaryOrange,
          title: 'Driver Found!',
          subtitle: 'Sarah is on her way to pick you up',
          description: 'Honda Civic • ABC-789 • ETA: 3 minutes',
          time: '2 minutes ago',
          isUnread: true,
          actionText: 'View Details',
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _buildNotificationCard(
          icon: Icons.check_circle,
          iconColor: Colors.green,
          title: 'Trip Completed Successfully',
          subtitle: 'Your ride to City Mall has been completed',
          description: 'Total fare: \$12.50 • Please rate your driver',
          time: '3 hours ago',
          isUnread: false,
          actionText: 'Rate Driver',
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _buildNotificationCard(
          icon: Icons.cancel,
          iconColor: Colors.red,
          title: 'Trip Cancelled',
          subtitle: 'Driver had to cancel due to emergency',
          description:
              'We\'re finding you another driver. Refund will be processed automatically.',
          time: '1 day ago',
          isUnread: false,
          actionText: 'Book Again',
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _buildNotificationCard(
          icon: Icons.location_on,
          iconColor: Colors.blue,
          title: 'Driver Arrived',
          subtitle: 'Your driver Mike has reached the pickup location',
          description:
              'Toyota Camry • XYZ-456 is waiting at the designated pickup point.',
          time: '2 days ago',
          isUnread: false,
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _buildNotificationCard(
          icon: Icons.schedule,
          iconColor: Colors.orange,
          title: 'Scheduled Ride Reminder',
          subtitle: 'Your ride to airport is scheduled in 30 minutes',
          description: 'Pickup time: 6:00 AM • Don\'t forget to be ready!',
          time: '3 days ago',
          isUnread: false,
          actionText: 'View Details',
          onTap: () {},
        ),
      ],
    ).animate().fadeIn(duration: 600.ms, delay: 100.ms);
  }

  Widget _buildPromotionsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildNotificationCard(
          icon: Icons.local_offer,
          iconColor: Colors.green,
          title: '50% Off Your Next Ride!',
          subtitle: 'Limited time offer for premium users',
          description:
              'Use code SAVE50 to get 50% discount on your next ride. Valid until Dec 31st.',
          time: '1 hour ago',
          isUnread: true,
          actionText: 'Use Coupon',
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _buildNotificationCard(
          icon: Icons.flash_on,
          iconColor: AppTheme.primaryOrange,
          title: 'Flash Sale - Free Rides!',
          subtitle: 'Get your first 3 rides absolutely free',
          description:
              'New to Ridya? Enjoy 3 free rides up to \$10 each. Limited time offer!',
          time: '6 hours ago',
          isUnread: false,
          actionText: 'Claim Now',
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _buildNotificationCard(
          icon: Icons.weekend,
          iconColor: Colors.purple,
          title: 'Weekend Special',
          subtitle: '25% off on weekend rides',
          description:
              'Every Saturday and Sunday, enjoy 25% discount on all your rides.',
          time: '1 day ago',
          isUnread: false,
          actionText: 'Learn More',
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _buildNotificationCard(
          icon: Icons.group,
          iconColor: Colors.blue,
          title: 'Refer Friends & Earn',
          subtitle: 'Earn \$5 for every friend you refer',
          description:
              'Share your referral code and earn rewards when your friends take their first ride.',
          time: '2 days ago',
          isUnread: false,
          actionText: 'Share Code',
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _buildNotificationCard(
          icon: Icons.loyalty,
          iconColor: Colors.amber,
          title: 'Loyalty Program Launch',
          subtitle: 'Introducing Ridya Rewards',
          description:
              'Earn points on every ride and redeem them for free trips and exclusive benefits.',
          time: '1 week ago',
          isUnread: false,
          actionText: 'Join Now',
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _buildNotificationCard(
          icon: Icons.restaurant,
          iconColor: Colors.red,
          title: 'Food Delivery Launch',
          subtitle: 'Order food from your favorite restaurants',
          description:
              'Ridya Food is now live! Get free delivery on your first order with code FOOD20.',
          time: '2 weeks ago',
          isUnread: false,
          actionText: 'Order Now',
          onTap: () {},
        ),
      ],
    ).animate().fadeIn(duration: 600.ms, delay: 200.ms);
  }

  Widget _buildNotificationCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String description,
    required String time,
    required bool isUnread,
    String? actionText,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.lightBlack,
          borderRadius: BorderRadius.circular(16),
          border: isUnread
              ? Border.all(
                  color: AppTheme.primaryOrange.withOpacity(0.3),
                  width: 1,
                )
              : null,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                color: AppTheme.primaryWhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (isUnread)
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(top: 4, left: 8),
                              decoration: const BoxDecoration(
                                color: AppTheme.primaryOrange,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: AppTheme.darkGrey,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: TextStyle(
                          color: AppTheme.darkGrey,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    color: AppTheme.darkGrey.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
                if (actionText != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryOrange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.primaryOrange.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      actionText,
                      style: const TextStyle(
                        color: AppTheme.primaryOrange,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
