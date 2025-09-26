import 'package:flutter/material.dart';
import '../../constants/app_theme.dart';
import 'payment_method_screen.dart';

class DeliveryAddressScreen extends StatefulWidget {
  final Map<String, dynamic> orderSummary;

  const DeliveryAddressScreen({super.key, required this.orderSummary});

  @override
  State<DeliveryAddressScreen> createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen> {
  final TextEditingController _houseController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String _selectedAddressType = 'Home';
  bool _isLoadingLocation = false;
  String _currentLocation = '';

  final List<Map<String, dynamic>> _savedAddresses = [
    {
      'type': 'Home',
      'address': '123 Main Street, Apartment 4B',
      'landmark': 'Near Central Mall',
      'pincode': '560001',
    },
    {
      'type': 'Work',
      'address': '456 Business Plaza, Floor 8',
      'landmark': 'Tech Park',
      'pincode': '560037',
    },
  ];

  Future<void> _fetchCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      // Simulate location fetching
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _currentLocation = '123 Current Street, Near Mall, City - 560001';
        _houseController.text = '123';
        _streetController.text = 'Current Street';
        _landmarkController.text = 'Near Mall';
        _pincodeController.text = '560001';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location fetched successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to fetch location. Please enter manually.'),
            backgroundColor: AppTheme.primaryOrange,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  void _selectSavedAddress(Map<String, dynamic> address) {
    setState(() {
      _selectedAddressType = address['type'];
      _houseController.text = address['address'].split(',')[0];
      _streetController.text = address['address'].split(',')[1].trim();
      _landmarkController.text = address['landmark'] ?? '';
      _pincodeController.text = address['pincode'] ?? '';
    });
  }

  void _proceedToPayment() {
    if (_houseController.text.isEmpty || _streetController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in the required address fields'),
          backgroundColor: AppTheme.primaryOrange,
        ),
      );
      return;
    }

    final deliveryAddress = {
      'house': _houseController.text,
      'street': _streetController.text,
      'landmark': _landmarkController.text,
      'pincode': _pincodeController.text,
      'type': _selectedAddressType,
      'note': _noteController.text,
    };

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            PaymentMethodScreen(
              orderSummary: widget.orderSummary,
              deliveryAddress: deliveryAddress,
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
          'Delivery Address',
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
          // Fetch Location Button
          Container(
            margin: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: _isLoadingLocation ? null : _fetchCurrentLocation,
              icon: _isLoadingLocation
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppTheme.primaryWhite,
                      ),
                    )
                  : const Icon(Icons.my_location, color: AppTheme.primaryWhite),
              label: Text(
                _isLoadingLocation
                    ? 'Fetching Location...'
                    : 'Use Current Location',
                style: const TextStyle(color: AppTheme.primaryWhite),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryOrange,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          // Saved Addresses
          if (_savedAddresses.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Saved Addresses',
                  style: TextStyle(
                    color: AppTheme.primaryWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _savedAddresses.length,
                itemBuilder: (context, index) {
                  final address = _savedAddresses[index];
                  final isSelected = _selectedAddressType == address['type'];
                  return GestureDetector(
                    onTap: () => _selectSavedAddress(address),
                    child: Container(
                      width: 200,
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.lightBlack,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primaryOrange
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Icon(
                                address['type'] == 'Home'
                                    ? Icons.home
                                    : Icons.work,
                                color: AppTheme.primaryOrange,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                address['type'],
                                style: const TextStyle(
                                  color: AppTheme.primaryWhite,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Expanded(
                            child: Text(
                              address['address'],
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 10,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Address Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Address Details',
                    style: TextStyle(
                      color: AppTheme.primaryWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // House Number
                  TextField(
                    controller: _houseController,
                    style: const TextStyle(color: AppTheme.primaryWhite),
                    decoration: InputDecoration(
                      labelText: 'House Number *',
                      labelStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: AppTheme.lightBlack,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Street Address
                  TextField(
                    controller: _streetController,
                    style: const TextStyle(color: AppTheme.primaryWhite),
                    decoration: InputDecoration(
                      labelText: 'Street Address *',
                      labelStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: AppTheme.lightBlack,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Landmark
                  TextField(
                    controller: _landmarkController,
                    style: const TextStyle(color: AppTheme.primaryWhite),
                    decoration: InputDecoration(
                      labelText: 'Landmark (Optional)',
                      labelStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: AppTheme.lightBlack,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Pincode
                  TextField(
                    controller: _pincodeController,
                    style: const TextStyle(color: AppTheme.primaryWhite),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Pincode (Optional)',
                      labelStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: AppTheme.lightBlack,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Address Type
                  const Text(
                    'Address Type',
                    style: TextStyle(
                      color: AppTheme.primaryWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: ['Home', 'Work', 'Other'].map((type) {
                      return Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _selectedAddressType = type),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: _selectedAddressType == type
                                  ? AppTheme.primaryOrange
                                  : AppTheme.lightBlack,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: Text(
                                type,
                                style: const TextStyle(
                                  color: AppTheme.primaryWhite,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Notes
                  TextField(
                    controller: _noteController,
                    style: const TextStyle(color: AppTheme.primaryWhite),
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: 'Delivery Notes (Optional)',
                      labelStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: AppTheme.lightBlack,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Order Summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Order Summary',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Items: ${widget.orderSummary['items']?.values?.fold(0, (sum, count) => sum + count) ?? 0}',
                          style: const TextStyle(
                            color: AppTheme.primaryWhite,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          'Total: ₹${widget.orderSummary['total'] ?? 0}',
                          style: const TextStyle(
                            color: AppTheme.primaryWhite,
                            fontSize: 12,
                          ),
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
            onPressed: _proceedToPayment,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryOrange,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Proceed to Payment',
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
