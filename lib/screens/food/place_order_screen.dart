import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_theme.dart';
import 'delivery_address_screen.dart';

class PlaceOrderScreen extends StatefulWidget {
  final Map<String, dynamic> restaurant;

  const PlaceOrderScreen({super.key, required this.restaurant});

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final Map<String, int> _cartItems = {};
  double _totalAmount = 0.0;

  // Sample menu data
  final Map<String, List<Map<String, dynamic>>> _menuCategories = {
    'Popular': [
      {
        'name': 'Signature Burger',
        'description': 'Juicy beef patty with special sauce, lettuce, tomato',
        'price': 299.0,
        'image': '🍔',
        'rating': 4.5,
        'veg': false,
      },
      {
        'name': 'Margherita Pizza',
        'description': 'Fresh mozzarella, tomato sauce, basil leaves',
        'price': 399.0,
        'image': '🍕',
        'rating': 4.6,
        'veg': true,
      },
      {
        'name': 'Chicken Wings',
        'description': 'Crispy wings with BBQ sauce (6 pieces)',
        'price': 249.0,
        'image': '🍗',
        'rating': 4.3,
        'veg': false,
      },
    ],
    'Mains': [
      {
        'name': 'Grilled Chicken',
        'description': 'Tender grilled chicken with herbs and spices',
        'price': 349.0,
        'image': '🍖',
        'rating': 4.4,
        'veg': false,
      },
      {
        'name': 'Vegetable Biryani',
        'description': 'Aromatic basmati rice with mixed vegetables',
        'price': 279.0,
        'image': '🍛',
        'rating': 4.2,
        'veg': true,
      },
      {
        'name': 'Fish Curry',
        'description': 'Fresh fish in coconut curry sauce',
        'price': 389.0,
        'image': '🐟',
        'rating': 4.5,
        'veg': false,
      },
    ],
    'Beverages': [
      {
        'name': 'Fresh Lime Soda',
        'description': 'Refreshing lime with soda water',
        'price': 79.0,
        'image': '🥤',
        'rating': 4.1,
        'veg': true,
      },
      {
        'name': 'Mango Lassi',
        'description': 'Creamy yogurt drink with mango pulp',
        'price': 99.0,
        'image': '🥛',
        'rating': 4.4,
        'veg': true,
      },
      {
        'name': 'Iced Coffee',
        'description': 'Chilled coffee with ice and cream',
        'price': 129.0,
        'image': '☕',
        'rating': 4.2,
        'veg': true,
      },
    ],
    'Desserts': [
      {
        'name': 'Chocolate Cake',
        'description': 'Rich chocolate cake with chocolate frosting',
        'price': 199.0,
        'image': '🍰',
        'rating': 4.7,
        'veg': true,
      },
      {
        'name': 'Ice Cream Sundae',
        'description': 'Vanilla ice cream with chocolate sauce and nuts',
        'price': 149.0,
        'image': '🍨',
        'rating': 4.3,
        'veg': true,
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _menuCategories.keys.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _addToCart(String itemName, double price) {
    setState(() {
      _cartItems[itemName] = (_cartItems[itemName] ?? 0) + 1;
      _totalAmount += price;
    });
  }

  void _removeFromCart(String itemName, double price) {
    setState(() {
      if (_cartItems[itemName] != null && _cartItems[itemName]! > 0) {
        _cartItems[itemName] = _cartItems[itemName]! - 1;
        _totalAmount -= price;
        if (_cartItems[itemName] == 0) {
          _cartItems.remove(itemName);
        }
      }
    });
  }

  int _getItemCount(String itemName) {
    return _cartItems[itemName] ?? 0;
  }

  void _proceedToCheckout() {
    if (_cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add items to cart before proceeding'),
          backgroundColor: AppTheme.primaryOrange,
        ),
      );
      return;
    }

    final orderSummary = {
      'items': Map<String, int>.from(_cartItems),
      'total': _totalAmount.toInt(),
      'restaurant': widget.restaurant,
    };

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            DeliveryAddressScreen(orderSummary: orderSummary),
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
      body: Column(
        children: [
          _buildHeader(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _menuCategories.entries.map((entry) {
                return _buildMenuCategory(entry.key, entry.value);
              }).toList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _cartItems.isNotEmpty ? _buildCartSummary() : null,
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.darkGradient),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppTheme.primaryWhite,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: AppTheme.primaryWhite,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.favorite_outline,
                      color: AppTheme.primaryWhite,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        widget.restaurant['image'],
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.restaurant['name'],
                          style: const TextStyle(
                            color: AppTheme.primaryWhite,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.restaurant['cuisine'],
                          style: TextStyle(
                            color: AppTheme.darkGrey,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: AppTheme.primaryOrange,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.restaurant['rating'].toString(),
                              style: const TextStyle(
                                color: AppTheme.primaryWhite,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Icon(
                              Icons.access_time,
                              color: AppTheme.primaryOrange,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.restaurant['deliveryTime']} min',
                              style: const TextStyle(
                                color: AppTheme.primaryWhite,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppTheme.lightBlack,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: AppTheme.primaryOrange,
        indicatorWeight: 3,
        labelColor: AppTheme.primaryOrange,
        unselectedLabelColor: AppTheme.darkGrey,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        tabs: _menuCategories.keys.map((category) {
          return Tab(text: category);
        }).toList(),
      ),
    );
  }

  Widget _buildMenuCategory(String category, List<Map<String, dynamic>> items) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildMenuItem(item, index);
      },
    );
  }

  Widget _buildMenuItem(Map<String, dynamic> item, int index) {
    final itemCount = _getItemCount(item['name']);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: item['veg'] ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Icon(
                        item['veg'] ? Icons.circle : Icons.circle,
                        size: 12,
                        color: AppTheme.primaryWhite,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item['name'],
                        style: const TextStyle(
                          color: AppTheme.primaryWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item['description'],
                  style: TextStyle(color: AppTheme.darkGrey, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: AppTheme.primaryOrange,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item['rating'].toString(),
                      style: const TextStyle(
                        color: AppTheme.primaryWhite,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '₹${item['price'].toInt()}',
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
          ),
          const SizedBox(width: 16),
          Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    item['image'],
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              if (itemCount == 0)
                GestureDetector(
                  onTap: () => _addToCart(item['name'], item['price']),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'ADD',
                      style: TextStyle(
                        color: AppTheme.primaryWhite,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              else
                Container(
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () =>
                            _removeFromCart(item['name'], item['price']),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.remove,
                            color: AppTheme.primaryWhite,
                            size: 16,
                          ),
                        ),
                      ),
                      Text(
                        itemCount.toString(),
                        style: const TextStyle(
                          color: AppTheme.primaryWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _addToCart(item['name'], item['price']),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.add,
                            color: AppTheme.primaryWhite,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCartSummary() {
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_cartItems.values.fold(0, (sum, count) => sum + count)} items',
                    style: const TextStyle(
                      color: AppTheme.primaryWhite,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '₹${_totalAmount.toInt()}',
                    style: const TextStyle(
                      color: AppTheme.primaryOrange,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: _proceedToCheckout,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Proceed to Checkout',
                      style: TextStyle(
                        color: AppTheme.primaryWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward,
                      color: AppTheme.primaryWhite,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
