import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/pet_repository.dart';
import '../../models/pet_model.dart';
import '../auth/login_screen.dart';
import 'add_product_screen.dart';
import 'manage_listings_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  final PetRepository _repo = PetRepository();
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Sliver App Bar
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.primaryDark,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_rounded, color: Colors.white70),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.logout_rounded, color: Colors.white70),
                tooltip: 'Sign Out',
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeroHeader(),
            ),
          ),

          // FAB Row
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      icon: Icons.add_photo_alternate_rounded,
                      label: 'Add Listing',
                      subtitle: 'New pet or product',
                      color: AppColors.primary,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddProductScreen()),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionCard(
                      icon: Icons.inventory_2_rounded,
                      label: 'Manage Stock',
                      subtitle: 'Edit & delete items',
                      color: AppColors.accent,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ManageListingsScreen()),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Stats Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Live Inventory Stats',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textDark),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildStatCard(_repo.puppiesNotifier, 'Puppies', Icons.pets_rounded, AppColors.primary),
                      const SizedBox(width: 10),
                      _buildStatCard(_repo.adoptionsNotifier, 'Adoptions', Icons.favorite_rounded, const Color(0xFFDC2626)),
                      const SizedBox(width: 10),
                      _buildStatCard(_repo.accessoriesNotifier, 'Accessories', Icons.shopping_bag_rounded, const Color(0xFF7C3AED)),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Recent Listings
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Listings',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textDark),
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ManageListingsScreen()),
                    ),
                    child: const Text('View All', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
          ),

          // Puppies live feed
          _buildLiveSectionSliver(_repo.puppiesNotifier, 'Puppies', AppColors.primary),
          _buildLiveSectionSliver(_repo.adoptionsNotifier, 'Adoption', const Color(0xFFDC2626)),
          _buildLiveSectionSliver(_repo.accessoriesNotifier, 'Accessories', const Color(0xFF7C3AED)),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        elevation: 8,
        child: const Icon(Icons.add_rounded, size: 28),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddProductScreen()),
        ),
      ),
    );
  }

  Widget _buildHeroHeader() {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.heroGradient),
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.07,
              child: Image.network(
                'https://images.unsplash.com/photo-1548681528-6a5c45b66b42?w=800',
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => const SizedBox.shrink(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 70, 20, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.accent.withOpacity(0.4)),
                  ),
                  child: const Text(
                    '🔐  ADMIN PORTAL',
                    style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'LUCKEY PETS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
                const Text(
                  'Owner: Vijay Dharnish  •  Eddapadi / Poolampatti',
                  style: TextStyle(color: Colors.white60, fontSize: 12),
                ),
                const SizedBox(height: 16),
                // Total count row
                ValueListenableBuilder<List<PetItem>>(
                  valueListenable: _repo.puppiesNotifier,
                  builder: (context, puppies, _) => ValueListenableBuilder<List<PetItem>>(
                    valueListenable: _repo.adoptionsNotifier,
                    builder: (context, adoptions, _) => ValueListenableBuilder<List<PetItem>>(
                      valueListenable: _repo.accessoriesNotifier,
                      builder: (context, accessories, _) {
                        final total = puppies.length + adoptions.length + accessories.length;
                        return Row(
                          children: [
                            _headerStat('$total', 'Total Listings'),
                            const SizedBox(width: 24),
                            _headerStat('${puppies.length}', 'Puppies'),
                            const SizedBox(width: 24),
                            _headerStat('${adoptions.length}', 'Adoptions'),
                            const SizedBox(width: 24),
                            _headerStat('${accessories.length}', 'Shop Items'),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerStat(String count, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(count, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10)),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
            Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    ValueNotifier<List<PetItem>> notifier,
    String label,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: ValueListenableBuilder<List<PetItem>>(
        valueListenable: notifier,
        builder: (context, items, _) {
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.15)),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  '${items.length}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
                Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.w600)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLiveSectionSliver(
    ValueNotifier<List<PetItem>> notifier,
    String category,
    Color color,
  ) {
    return SliverToBoxAdapter(
      child: ValueListenableBuilder<List<PetItem>>(
        valueListenable: notifier,
        builder: (context, items, _) {
          if (items.isEmpty) return const SizedBox.shrink();
          final displayItems = items.take(3).toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 16,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      category,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: color),
                    ),
                  ],
                ),
              ),
              ...displayItems.map((item) => _buildAdminListItem(item, color)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAdminListItem(PetItem item, Color color) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 60,
              height: 60,
              color: color.withOpacity(0.1),
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Icon(Icons.pets, color: color.withOpacity(0.4), size: 28),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textDark)),
                Text(
                  '${item.breedOrCategory} • ${item.ageOrWeight}',
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              item.price,
              style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}