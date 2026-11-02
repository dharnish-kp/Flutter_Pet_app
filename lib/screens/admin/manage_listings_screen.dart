import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/pet_model.dart';
import '../../models/pet_repository.dart';
import 'add_product_screen.dart';

class ManageListingsScreen extends StatelessWidget {
  const ManageListingsScreen({super.key});

  void _confirmDelete(BuildContext context, PetItem item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.delete_forever_rounded, color: AppColors.error, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              'Delete "${item.name}"?',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textDark),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'This listing will be permanently removed from LUCKEY PETS store.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textMuted,
                      side: const BorderSide(color: AppColors.lightBorder),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.delete_rounded, size: 18),
                    label: const Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                    onPressed: () {
                      PetRepository().deleteItem(item.id, item.type);
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(Icons.check_circle_rounded, color: Colors.white),
                              const SizedBox(width: 8),
                              Text('"${item.name}" removed successfully'),
                            ],
                          ),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = PetRepository();
    final List<_CategoryTab> tabs = const [
      _CategoryTab(label: 'Puppies', icon: Icons.pets_rounded, type: 'puppy', color: AppColors.primary),
      _CategoryTab(label: 'Adoption', icon: Icons.favorite_rounded, type: 'adoption', color: Color(0xFFDC2626)),
      _CategoryTab(label: 'Accessories', icon: Icons.shopping_bag_rounded, type: 'accessory', color: Color(0xFF7C3AED)),
    ];

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Manage Inventory'),
          backgroundColor: Colors.white,
          foregroundColor: AppColors.textDark,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.add_rounded, color: AppColors.accent),
              tooltip: 'Add New',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddProductScreen()),
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(52),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: AppColors.lightBorder)),
              ),
              child: TabBar(
                indicatorColor: AppColors.accent,
                indicatorWeight: 3,
                labelColor: AppColors.accent,
                unselectedLabelColor: AppColors.textMuted,
                labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                tabs: tabs.map((t) => Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(t.icon, size: 17),
                      const SizedBox(width: 6),
                      Text(t.label),
                    ],
                  ),
                )).toList(),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildManageList(context, repo.puppiesNotifier, tabs[0]),
            _buildManageList(context, repo.adoptionsNotifier, tabs[1]),
            _buildManageList(context, repo.accessoriesNotifier, tabs[2]),
          ],
        ),
      ),
    );
  }

  Widget _buildManageList(BuildContext context, ValueNotifier<List<dynamic>> notifier, _CategoryTab tab) {
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (context, items, _) {
        if (items.isEmpty) {
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
                  child: Icon(tab.icon, size: 44, color: tab.color.withOpacity(0.5)),
                ),
                const SizedBox(height: 16),
                Text(
                  'No ${tab.label} listings',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark),
                ),
                const SizedBox(height: 6),
                const Text('Add a listing to get started', style: TextStyle(color: AppColors.textMuted)),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Add Listing'),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddProductScreen()),
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return _buildManageCard(context, item, tab);
          },
        );
      },
    );
  }

  Widget _buildManageCard(BuildContext context, dynamic item, _CategoryTab tab) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.lightBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: 76,
                height: 76,
                color: tab.color.withOpacity(0.1),
                child: Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Icon(tab.icon, color: tab.color.withOpacity(0.4), size: 32),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textDark),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${item.breedOrCategory} • ${item.ageOrWeight}',
                    style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: tab.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item.price,
                          style: TextStyle(color: tab.color, fontWeight: FontWeight.w800, fontSize: 13),
                        ),
                      ),
                      if (item.isVaccinated) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.verified_rounded, size: 10, color: Colors.green.shade700),
                              const SizedBox(width: 3),
                              Text('Vacc.', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.green.shade700)),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // Delete button
            GestureDetector(
              onTap: () => _confirmDelete(context, item),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.delete_rounded, color: AppColors.error, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryTab {
  final String label;
  final IconData icon;
  final String type;
  final Color color;
  const _CategoryTab({required this.label, required this.icon, required this.type, required this.color});
}