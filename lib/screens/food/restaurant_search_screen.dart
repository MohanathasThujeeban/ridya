import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_theme.dart';
import 'place_order_screen.dart';

class RestaurantSearchScreen extends StatefulWidget {
  const RestaurantSearchScreen({super.key});

  @override
  State<RestaurantSearchScreen> createState() => _RestaurantSearchScreenState();
}

class _RestaurantSearchScreenState extends State<RestaurantSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _categories = [
    'All',
    'Fast Food',
    'Pizza',
    'Chinese',
    'Indian',
    'Desserts',
    'Coffee',
    'Healthy',
  ];
  String _selectedCategory = 'All';

  // Sample restaurant data
  final List<Map<String, dynamic>> _restaurants = [
    {
      'name': 'Pizza Palace',
      'cuisine': 'Italian',
      'rating': 4.5,
      'deliveryTime': '25-30',
      'deliveryFee': 2.99,
      'image': '🍕',
      'category': 'Pizza',
      'distance': '1.2 km',
      'offers': ['20% OFF', 'Free Delivery'],
    },
    {
      'name': 'Burger Haven',
      'cuisine': 'American',
      'rating': 4.2,
      'deliveryTime': '20-25',
      'deliveryFee': 1.99,
      'image': '🍔',
      'category': 'Fast Food',
      'distance': '0.8 km',
      'offers': ['Buy 1 Get 1'],
    },
    {
      'name': 'Golden Dragon',
      'cuisine': 'Chinese',
      'rating': 4.6,
      'deliveryTime': '30-35',
      'deliveryFee': 3.49,
      'image': '🥡',
      'category': 'Chinese',
      'distance': '2.1 km',
      'offers': ['15% OFF'],
    },
    {
      'name': 'Spice Route',
      'cuisine': 'Indian',
      'rating': 4.4,
      'deliveryTime': '35-40',
      'deliveryFee': 2.49,
      'image': '🍛',
      'category': 'Indian',
      'distance': '1.5 km',
      'offers': ['Free Delivery on ₹500+'],
    },
    {
      'name': 'Sweet Dreams',
      'cuisine': 'Desserts',
      'rating': 4.7,
      'deliveryTime': '15-20',
      'deliveryFee': 1.49,
      'image': '🍰',
      'category': 'Desserts',
      'distance': '0.6 km',
      'offers': ['25% OFF on Cakes'],
    },
    {
      'name': 'Coffee Corner',
      'cuisine': 'Beverages',
      'rating': 4.3,
      'deliveryTime': '10-15',
      'deliveryFee': 0.99,
      'image': '☕',
      'category': 'Coffee',
      'distance': '0.4 km',
      'offers': ['Buy 2 Get 1 Free'],
    },
  ];

  List<Map<String, dynamic>> get _filteredRestaurants {
    if (_selectedCategory == 'All') return _restaurants;
    return _restaurants
        .where((restaurant) => restaurant['category'] == _selectedCategory)
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildSearchBar(),
                _buildCategoryTabs(),
                _buildPromoBanner(),
              ],
            ),
          ),
          _buildRestaurantList(),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: AppTheme.primaryBlack,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppTheme.primaryWhite),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Restaurants & Food',
          style: TextStyle(
            color: AppTheme.primaryWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(gradient: AppTheme.darkGradient),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightBlack,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: AppTheme.primaryWhite),
        decoration: InputDecoration(
          hintText: 'Search for restaurants or food...',
          hintStyle: TextStyle(color: AppTheme.darkGrey),
          prefixIcon: const Icon(Icons.search, color: AppTheme.primaryOrange),
          suffixIcon: IconButton(
            icon: const Icon(Icons.tune, color: AppTheme.primaryOrange),
            onPressed: () {
              // Handle filter action
            },
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    ).animate().slideX(begin: -0.5, duration: 500.ms);
  }

  Widget _buildCategoryTabs() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: isSelected ? AppTheme.primaryGradient : null,
                color: isSelected ? null : AppTheme.lightBlack,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.primaryOrange
                      : AppTheme.darkGrey.withOpacity(0.3),
                ),
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected ? AppTheme.primaryWhite : AppTheme.darkGrey,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          );
        },
      ),
    ).animate().slideX(begin: 0.5, duration: 600.ms);
  }

  Widget _buildPromoBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryOrange.withOpacity(0.8),
            AppTheme.darkOrange.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryOrange.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Special Offer!',
                  style: TextStyle(
                    color: AppTheme.primaryWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Free delivery on orders above ₹299',
                  style: TextStyle(color: AppTheme.primaryWhite, fontSize: 14),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.primaryWhite,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Order Now',
              style: TextStyle(
                color: AppTheme.primaryOrange,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ).animate().scale(begin: const Offset(0.8, 0.8), duration: 700.ms);
  }

  Widget _buildRestaurantList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final restaurant = _filteredRestaurants[index];
        return _buildRestaurantCard(restaurant, index);
      }, childCount: _filteredRestaurants.length),
    );
  }

  Widget _buildRestaurantCard(Map<String, dynamic> restaurant, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    PlaceOrderScreen(restaurant: restaurant),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
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
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Restaurant image placeholder
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          restaurant['image'],
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
                            restaurant['name'],
                            style: const TextStyle(
                              color: AppTheme.primaryWhite,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            restaurant['cuisine'],
                            style: TextStyle(
                              color: AppTheme.darkGrey,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: AppTheme.primaryOrange,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                restaurant['rating'].toString(),
                                style: const TextStyle(
                                  color: AppTheme.primaryWhite,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                restaurant['distance'],
                                style: TextStyle(
                                  color: AppTheme.darkGrey,
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
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            color: AppTheme.primaryOrange,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${restaurant['deliveryTime']} min',
                            style: const TextStyle(
                              color: AppTheme.primaryWhite,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Icon(
                            Icons.delivery_dining,
                            color: AppTheme.primaryOrange,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '₹${restaurant['deliveryFee']}',
                            style: const TextStyle(
                              color: AppTheme.primaryWhite,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (restaurant['offers'].isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: restaurant['offers'].map<Widget>((offer) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryOrange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.primaryOrange.withOpacity(0.5),
                          ),
                        ),
                        child: Text(
                          offer,
                          style: const TextStyle(
                            color: AppTheme.primaryOrange,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
