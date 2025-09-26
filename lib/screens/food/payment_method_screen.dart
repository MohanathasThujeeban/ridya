import 'package:flutter/material.dart';
import '../../constants/app_theme.dart';
import 'order_confirmation_screen_debug.dart';

class PaymentMethodScreen extends StatefulWidget {
  final Map<String, dynamic> orderSummary;
  final Map<String, String> deliveryAddress;

  const PaymentMethodScreen({
    super.key,
    required this.orderSummary,
    required this.deliveryAddress,
  });

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String _selectedPaymentMethod = '';
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();

  void _placeOrder() {
    if (_selectedPaymentMethod.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a payment method'),
          backgroundColor: AppTheme.primaryOrange,
        ),
      );
      return;
    }

    if (_selectedPaymentMethod != 'cod') {
      if (_cardNumberController.text.isEmpty ||
          _expiryController.text.isEmpty ||
          _cvvController.text.isEmpty ||
          _cardHolderController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill in all card details'),
            backgroundColor: AppTheme.primaryOrange,
          ),
        );
        return;
      }
    }

    final paymentInfo = {
      'method': _selectedPaymentMethod,
      if (_selectedPaymentMethod != 'cod') ...{
        'cardNumber': _cardNumberController.text,
        'expiryDate': _expiryController.text,
        'cardHolder': _cardHolderController.text,
      },
    };

    final orderId = 'ORD${DateTime.now().millisecondsSinceEpoch}';

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            OrderConfirmationScreenDebug(
              orderId: orderId,
              orderSummary: widget.orderSummary,
              deliveryAddress: widget.deliveryAddress,
              paymentInfo: paymentInfo,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
          'Payment Method',
          style: TextStyle(
            color: AppTheme.primaryWhite,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Payment Methods
                  const Text(
                    'Select Payment Method',
                    style: TextStyle(
                      color: AppTheme.primaryWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Visa Option
                  GestureDetector(
                    onTap: () =>
                        setState(() => _selectedPaymentMethod = 'visa'),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.lightBlack,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _selectedPaymentMethod == 'visa'
                              ? AppTheme.primaryOrange
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1F71),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text('💳', style: TextStyle(fontSize: 24)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Visa Card',
                                  style: TextStyle(
                                    color: AppTheme.primaryWhite,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Pay securely with your Visa card',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_selectedPaymentMethod == 'visa')
                            const Icon(
                              Icons.check_circle,
                              color: AppTheme.primaryOrange,
                              size: 24,
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Mastercard Option
                  GestureDetector(
                    onTap: () =>
                        setState(() => _selectedPaymentMethod = 'mastercard'),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.lightBlack,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _selectedPaymentMethod == 'mastercard'
                              ? AppTheme.primaryOrange
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEB001B),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text('💳', style: TextStyle(fontSize: 24)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Mastercard',
                                  style: TextStyle(
                                    color: AppTheme.primaryWhite,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Pay securely with your Mastercard',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_selectedPaymentMethod == 'mastercard')
                            const Icon(
                              Icons.check_circle,
                              color: AppTheme.primaryOrange,
                              size: 24,
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Cash on Delivery Option
                  GestureDetector(
                    onTap: () => setState(() => _selectedPaymentMethod = 'cod'),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: AppTheme.lightBlack,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _selectedPaymentMethod == 'cod'
                              ? AppTheme.primaryOrange
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryOrange,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text('💵', style: TextStyle(fontSize: 24)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Cash on Delivery',
                                  style: TextStyle(
                                    color: AppTheme.primaryWhite,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Pay when your order arrives',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_selectedPaymentMethod == 'cod')
                            const Icon(
                              Icons.check_circle,
                              color: AppTheme.primaryOrange,
                              size: 24,
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Card Details Form (shown for Visa/Mastercard)
                  if (_selectedPaymentMethod == 'visa' ||
                      _selectedPaymentMethod == 'mastercard') ...[
                    const Text(
                      'Card Details',
                      style: TextStyle(
                        color: AppTheme.primaryWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Card Number
                    TextField(
                      controller: _cardNumberController,
                      style: const TextStyle(color: AppTheme.primaryWhite),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Card Number',
                        labelStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: AppTheme.lightBlack,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(
                          Icons.credit_card,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Cardholder Name
                    TextField(
                      controller: _cardHolderController,
                      style: const TextStyle(color: AppTheme.primaryWhite),
                      decoration: InputDecoration(
                        labelText: 'Cardholder Name',
                        labelStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: AppTheme.lightBlack,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Expiry and CVV Row
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _expiryController,
                            style: const TextStyle(
                              color: AppTheme.primaryWhite,
                            ),
                            decoration: InputDecoration(
                              labelText: 'MM/YY',
                              labelStyle: TextStyle(color: Colors.grey[400]),
                              filled: true,
                              fillColor: AppTheme.lightBlack,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: const Icon(
                                Icons.calendar_today,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _cvvController,
                            style: const TextStyle(
                              color: AppTheme.primaryWhite,
                            ),
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'CVV',
                              labelStyle: TextStyle(color: Colors.grey[400]),
                              filled: true,
                              fillColor: AppTheme.lightBlack,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Order Summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.lightBlack,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.primaryOrange.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Order Summary',
                          style: TextStyle(
                            color: AppTheme.primaryWhite,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Items: ${widget.orderSummary['items']?.values?.fold(0, (sum, count) => sum + count) ?? 0}',
                              style: TextStyle(
                                color: Colors.grey[300],
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '₹${widget.orderSummary['total'] ?? 0}',
                              style: const TextStyle(
                                color: AppTheme.primaryOrange,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Delivery to: ${widget.deliveryAddress['house'] ?? ''} ${widget.deliveryAddress['street'] ?? ''}',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.primaryBlack,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _placeOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryOrange,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Place Order',
              style: TextStyle(
                color: AppTheme.primaryWhite,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
