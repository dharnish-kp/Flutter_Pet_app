import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/pet_model.dart';
import '../../models/pet_repository.dart';
import '../auth/login_screen.dart';
import 'pet_detail_screen.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen>
    with SingleTickerProviderStateMixin {
  int _currentTabIndex = 0;
  final PetRepository _repo = PetRepository();
  late AnimationController _fabAnimController;
  String _searchQuery = '';

  final List<_TabInfo> _tabs = const [
    _TabInfo(label: 'Puppies', icon: Icons.pets_rounded, emoji: '🐶', color: AppColors.primary),
    _TabInfo(label: 'Adoption', icon: Icons.favorite_rounded, emoji: '❤', color: Color(0xFFDC2626)),
    _TabInfo(label: 'Accessories', icon: Icons.shopping_bag_rounded, emoji: '🛍', color: Color(0xFF7C3AED)),
  ];

  @override
  void initState() {
    super.initState();
    _fabAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();
  }

  @override
  void dispose() {
    _fabAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildSliverAppBar(innerBoxIsScrolled),
        ],
        body: _buildBody(),
      ),
      floatingActionButton: ScaleTransition(
        scale: CurvedAnimation(parent: _fabAnimController, curve: Curves.elasticOut),
        child: FloatingActionButton.extended(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          elevation: 8,
          icon: const Icon(Icons.phone_rounded, size: 20),
          label: const Text('Call Store', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.phone, color: Colors.white),
                    SizedBox(width: 10),
                    Text('Calling LUCKEY PETS: +91 6374693453', style: TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
                backgroundColor: AppColors.accent,
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildSliverAppBar(bool innerBoxIsScrolled) {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      snap: false,
      backgroundColor: AppColors.primaryDark,
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
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
        titlePadding: const EdgeInsets.only(left: 16, bottom: 56),
        title: AnimatedOpacity(
          opacity: innerBoxIsScrolled ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: const Text('LUCKEY PETS', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1)),
        ),
        background: _buildHeroBanner(),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: _buildSearchBar(),
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.heroGradient),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1548681528-6a5c45b66b42?w=800&auto=format&fit=crop&q=80',
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.45),
              colorBlendMode: BlendMode.darken,
              errorBuilder: (context, e, s) => const SizedBox.shrink(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 70),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.pets, color: Colors.white, size: 16),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'LUCKEY PETS',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Eddapadi • Poolampatti',
                  style: TextStyle(color: Colors.white60, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 48,
      decoration: const BoxDecoration(
        color: AppColors.primaryDark,
      ),
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: TextField(
          onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: const InputDecoration(
            hintText: 'Search pets & accessories...',
            hintStyle: TextStyle(color: Colors.white54, fontSize: 13),
            prefixIcon: Icon(Icons.search_rounded, color: Colors.white54, size: 20),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            isDense: true,
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    final tabs = _tabs;
    return IndexedStack(
      index: _currentTabIndex,
      children: [
        _buildPetGrid(_repo.puppiesNotifier, tabs[0]),
        _buildPetGrid(_repo.adoptionsNotifier, tabs[1]),
        _buildPetGrid(_repo.accessoriesNotifier, tabs[2]),
      ],
    );
  }

  Widget _buildPetGrid(ValueNotifier<List<PetItem>> notifier, _TabInfo tab) {
    return ValueListenableBuilder<List<PetItem>>(
      valueListenable: notifier,
      builder: (context, items, _) {
        final filtered = _searchQuery.isEmpty
            ? items
            : items.where((p) =>
                p.name.toLowerCase().contains(_searchQuery) ||
                p.breedOrCategory.toLowerCase().contains(_searchQuery)).toList();

        if (filtered.isEmpty) {
          return _buildEmptyState(tab);
        }

        return CustomScrollView(
          slivers: [
            // Header banner
            SliverToBoxAdapter(
              child: _buildSectionHeader(tab, items.length),
            ),
            // Stats row
            SliverToBoxAdapter(
              child: _buildStatsRow(tab, items),
            ),
            // Grid
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _getCrossAxisCount(context),
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.75,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _PetCard(
                    item: filtered[index],
                    accentColor: tab.color,
                    onTap: () => _openDetail(filtered[index], tab.color),
                  ),
                  childCount: filtered.length,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 4;
    if (width > 800) return 3;
    if (width > 500) return 2;
    return 2;
  }

  Widget _buildSectionHeader(_TabInfo tab, int count) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [tab.color, tab.color.withOpacity(0.75)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: tab.color.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${tab.emoji} ${tab.label}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$count listing${count == 1 ? '' : 's'} available',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(_TabInfo tab, List<PetItem> items) {
    final vaccinated = items.where((p) => p.isVaccinated).length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: [
          _buildStatChip(Icons.verified_rounded, '$vaccinated Vaccinated', Colors.green),
          const SizedBox(width: 8),
          _buildStatChip(Icons.location_on_rounded, 'Eddapadi', AppColors.primary),
          const SizedBox(width: 8),
          _buildStatChip(Icons.star_rounded, 'Premium', AppColors.accent),
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }

  Widget _buildEmptyState(_TabInfo tab) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: tab.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(tab.icon, size: 48, color: tab.color.withOpacity(0.6)),
          ),
          const SizedBox(height: 16),
          Text(
            'No ${tab.label} listings yet',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark),
          ),
          const SizedBox(height: 6),
          const Text('Check back soon!', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
        ],
      ),
    );
  }

  void _openDetail(PetItem item, Color color) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => PetDetailScreen(item: item, accentColor: color),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(animation),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: NavigationBar(
        selectedIndex: _currentTabIndex,
        onDestinationSelected: (idx) => setState(() => _currentTabIndex = idx),
        backgroundColor: Colors.transparent,
        elevation: 0,
        indicatorColor: _tabs[_currentTabIndex].color.withOpacity(0.12),
        destinations: _tabs.map((tab) => NavigationDestination(
          icon: Icon(tab.icon, color: AppColors.textMuted),
          selectedIcon: Icon(tab.icon, color: tab.color),
          label: tab.label,
        )).toList(),
      ),
    );
  }
}

class _PetCard extends StatefulWidget {
  final PetItem item;
  final Color accentColor;
  final VoidCallback onTap;

  const _PetCard({required this.item, required this.accentColor, required this.onTap});

  @override
  State<_PetCard> createState() => _PetCardState();
}

class _PetCardState extends State<_PetCard> with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnim;
  late Animation<double> _elevAnim;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOut),
    );
    _elevAnim = Tween<double>(begin: 2, end: 12).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _hoverController.forward(),
      onExit: (_) => _hoverController.reverse(),
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnim.value,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: widget.accentColor.withOpacity(0.08 + _hoverController.value * 0.12),
                  blurRadius: _elevAnim.value,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: child,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  Expanded(
                    flex: 3,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            widget.item.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, e, s) => Container(
                              color: widget.accentColor.withOpacity(0.1),
                              child: Icon(Icons.pets, size: 40, color: widget.accentColor.withOpacity(0.4)),
                            ),
                          ),
                        ),
                        // Type badge
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: widget.accentColor.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.item.type.toUpperCase(),
                              style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                            ),
                          ),
                        ),
                        // Vaccinated badge
                        if (widget.item.isVaccinated)
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.green.shade600,
                                shape: BoxShape.circle,
                                boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.4), blurRadius: 6)],
                              ),
                              child: const Icon(Icons.verified_rounded, color: Colors.white, size: 14),
                            ),
                          ),
                        // Gradient overlay at bottom
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: 60,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                              ),
                            ),
                          ),
                        ),
                        // Price at bottom of image
                        Positioned(
                          bottom: 8,
                          left: 10,
                          child: Text(
                            widget.item.price,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                              shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Info
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.item.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            widget.item.breedOrCategory,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              const Icon(Icons.access_time_rounded, size: 12, color: AppColors.textMuted),
                              const SizedBox(width: 3),
                              Text(
                                widget.item.ageOrWeight,
                                style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: widget.accentColor.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(Icons.arrow_forward_ios_rounded, size: 10, color: widget.accentColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabInfo {
  final String label;
  final IconData icon;
  final String emoji;
  final Color color;
  const _TabInfo({required this.label, required this.icon, required this.emoji, required this.color});
}