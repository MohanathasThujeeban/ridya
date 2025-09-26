import 'package:flutter/material.dart';
import '../../constants/app_theme.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final String orderId;
  final Map<String, dynamic> orderSummary;
  final Map<String, String> deliveryAddress;
  final Map<String, dynamic> paymentInfo;

  const OrderConfirmationScreen({
    super.key,
    required this.orderId,
    required this.orderSummary,
    required this.deliveryAddress,
    required this.paymentInfo,
  });

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  String _orderStatus = 'Order Confirmed';
  String _estimatedTime = '25-30 mins';

  final List<Map<String, dynamic>> _orderSteps = [
    {
      'title': 'Order Confirmed',
      'subtitle': 'Your order has been placed',
      'icon': Icons.check_circle,
      'completed': true,
      'time': 'Just now',
    },
    {
      'title': 'Preparing Food',
      'subtitle': 'Restaurant is preparing your order',
      'icon': Icons.restaurant,
      'completed': false,
      'time': '5-10 mins',
    },
    {
      'title': 'Out for Delivery',
      'subtitle': 'Your order is on the way',
      'icon': Icons.delivery_dining,
      'completed': false,
      'time': '15-20 mins',
    },
    {
      'title': 'Delivered',
      'subtitle': 'Enjoy your meal!',
      'icon': Icons.home,
      'completed': false,
      'time': '25-30 mins',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    // Simulate order progress
    _simulateOrderProgress();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _simulateOrderProgress() {
    // Simulate restaurant accepting order
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _orderSteps[1] = {..._orderSteps[1], 'completed': true};
          _orderStatus = 'Preparing Food';
        });
      }
    });

    // Simulate order ready for delivery
    Future.delayed(const Duration(seconds: 8), () {
      if (mounted) {
        setState(() {
          _orderSteps[2] = {..._orderSteps[2], 'completed': true};
          _orderStatus = 'Out for Delivery';
          _estimatedTime = '10-15 mins';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSuccessCard(),
                  const SizedBox(height: 24),
                  _buildOrderTracker(),
                  const SizedBox(height: 24),
                  _buildOrderDetails(),
                  const SizedBox(height: 24),
                  _buildDeliveryInfo(),
                  const SizedBox(height: 24),
                  _buildPaymentInfo(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.darkGradient),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close, color: AppTheme.primaryWhite),
                onPressed: () {
                  // Navigate back to home screen
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
              const Expanded(
                child: Text(
                  'Order Confirmation',
                  style: TextStyle(
                    color: AppTheme.primaryWhite,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.help_outline,
                  color: AppTheme.primaryWhite,
                ),
                onPressed: () {
                  // Show help/support
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryOrange.withOpacity(0.9),
            AppTheme.darkOrange.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryOrange.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (_pulseController.value * 0.1),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryWhite.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    size: 50,
                    color: AppTheme.primaryWhite,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          const Text(
            '🎉 Order Confirmed!',
            style: TextStyle(
              color: AppTheme.primaryWhite,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Order ID: ${widget.orderId}',
            style: const TextStyle(
              color: AppTheme.primaryWhite,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Estimated delivery: $_estimatedTime',
            style: TextStyle(
              color: AppTheme.primaryWhite.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTracker() {
    return Container(
      padding: const EdgeInsets.all(20),
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
          const Text(
            'Track Your Order',
            style: TextStyle(
              color: AppTheme.primaryWhite,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          ..._orderSteps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            final isLast = index == _orderSteps.length - 1;

            return _buildOrderStep(step, isLast);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildOrderStep(Map<String, dynamic> step, bool isLast) {
    final isCompleted = step['completed'] as bool;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppTheme.primaryOrange
                    : AppTheme.darkGrey.withOpacity(0.3),
                shape: BoxShape.circle,
                boxShadow: isCompleted
                    ? [
                        BoxShadow(
                          color: AppTheme.primaryOrange.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                step['icon'],
                color: isCompleted ? AppTheme.primaryWhite : AppTheme.darkGrey,
                size: 20,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isCompleted
                    ? AppTheme.primaryOrange
                    : AppTheme.darkGrey.withOpacity(0.3),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step['title'],
                  style: TextStyle(
                    color: isCompleted
                        ? AppTheme.primaryWhite
                        : AppTheme.darkGrey,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  step['subtitle'],
                  style: TextStyle(color: AppTheme.darkGrey, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  step['time'],
                  style: TextStyle(
                    color: isCompleted
                        ? AppTheme.primaryOrange
                        : AppTheme.darkGrey,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightBlack,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.darkGrey.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Details',
            style: TextStyle(
              color: AppTheme.primaryWhite,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ...((widget.orderSummary['items'] as Map<String, int>).entries.map((
            entry,
          ) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${entry.key} x ${entry.value}',
                      style: TextStyle(color: AppTheme.darkGrey, fontSize: 14),
                    ),
                  ),
                ],
              ),
            );
          })),
          const Divider(color: AppTheme.darkGrey),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Total Amount',
                  style: TextStyle(
                    color: AppTheme.primaryWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '₹${widget.orderSummary['total']}',
                style: const TextStyle(
                  color: AppTheme.primaryOrange,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightBlack,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.darkGrey.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.location_on, color: AppTheme.primaryOrange, size: 20),
              SizedBox(width: 8),
              Text(
                'Delivery Address',
                style: TextStyle(
                  color: AppTheme.primaryWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${widget.deliveryAddress['house']}, ${widget.deliveryAddress['street']}',
            style: TextStyle(color: AppTheme.darkGrey, fontSize: 14),
          ),
          if (widget.deliveryAddress['landmark']!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'Near ${widget.deliveryAddress['landmark']}',
              style: TextStyle(
                color: AppTheme.darkGrey.withOpacity(0.8),
                fontSize: 13,
              ),
            ),
          ],
          const SizedBox(height: 4),
          Text(
            'PIN: ${widget.deliveryAddress['pincode']}',
            style: TextStyle(color: AppTheme.darkGrey, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightBlack,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.darkGrey.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.payment, color: AppTheme.primaryOrange, size: 20),
              SizedBox(width: 8),
              Text(
                'Payment Method',
                style: TextStyle(
                  color: AppTheme.primaryWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                widget.paymentInfo['method'] == 'cod'
                    ? 'Cash on Delivery'
                    : widget.paymentInfo['method'] == 'visa'
                    ? 'Visa Card'
                    : 'Mastercard',
                style: TextStyle(color: AppTheme.darkGrey, fontSize: 14),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.paymentInfo['method'] == 'cod'
                      ? 'Pay on Delivery'
                      : 'Paid',
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (widget.paymentInfo['method'] != 'cod') ...[
            const SizedBox(height: 8),
            Text(
              '**** **** **** ${widget.paymentInfo['cardNumber']?.substring(widget.paymentInfo['cardNumber'].length - 4) ?? '****'}',
              style: TextStyle(
                color: AppTheme.darkGrey.withOpacity(0.8),
                fontSize: 13,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightBlack,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // Share order details
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.primaryOrange),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Center(
                    child: Text(
                      'Share Order',
                      style: TextStyle(
                        color: AppTheme.primaryOrange,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Center(
                    child: Text(
                      'Back to Home',
                      style: TextStyle(
                        color: AppTheme.primaryWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
