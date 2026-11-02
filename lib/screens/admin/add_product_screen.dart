import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/pet_repository.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  String _selectedType = 'puppy';
  bool _isLoading = false;

  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _breedController = TextEditingController();
  final _ageController = TextEditingController();
  final _stockController = TextEditingController();

  String _selectedGender = 'Male';
  bool _isVaccinated = true;
  String _accessoryCategory = 'Food & Treats';

  final List<String> _accessoryCategories = [
    'Food & Treats',
    'Toys',
    'Collars & Leashes',
    'Grooming',
    'Beds & Crates',
    'Health & Wellness',
  ];

  final List<_TypeOption> _typeOptions = const [
    _TypeOption(type: 'puppy', label: 'Puppy for Sale', icon: Icons.pets_rounded, color: AppColors.primary),
    _TypeOption(type: 'adoption', label: 'Adoption', icon: Icons.favorite_rounded, color: Color(0xFFDC2626)),
    _TypeOption(type: 'accessory', label: 'Accessory', icon: Icons.shopping_bag_rounded, color: Color(0xFF7C3AED)),
  ];

  Color get _activeColor {
    switch (_selectedType) {
      case 'adoption':
        return const Color(0xFFDC2626);
      case 'accessory':
        return const Color(0xFF7C3AED);
      default:
        return AppColors.primary;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final repo = PetRepository();

    String breedOrCat = _selectedType == 'accessory'
        ? _accessoryCategory
        : '${_breedController.text.trim()} ($_selectedGender)';

    String ageOrWeight = _selectedType == 'accessory'
        ? 'Stock: ${_stockController.text.trim()}'
        : _ageController.text.trim();

    String finalPrice = _selectedType == 'adoption'
        ? (_priceController.text.trim().isEmpty || _priceController.text.trim() == '0'
            ? 'Free Adoption'
            : '₹${_priceController.text.trim()}')
        : '₹${_priceController.text.trim()}';

    await repo.addItem(
      name: _nameController.text.trim(),
      breedOrCategory: breedOrCat,
      ageOrWeight: ageOrWeight,
      price: finalPrice,
      imageUrl: _imageUrlController.text.trim(),
      type: _selectedType,
      isVaccinated: _isVaccinated,
      description: _descController.text.trim(),
    );

    setState(() => _isLoading = false);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 10),
            Text('Successfully listed ${_nameController.text.trim()}!', style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        backgroundColor: Colors.green.shade700,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Add New Listing'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.lightBorder),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Type selector
            const Text(
              'Listing Type',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textDark),
            ),
            const SizedBox(height: 12),
            Row(
              children: _typeOptions.map((opt) {
                final isSelected = _selectedType == opt.type;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedType = opt.type),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: EdgeInsets.only(right: opt.type != 'accessory' ? 10 : 0),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(colors: [opt.color, opt.color.withOpacity(0.8)])
                            : null,
                        color: isSelected ? null : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? opt.color : AppColors.lightBorder,
                          width: isSelected ? 0 : 1,
                        ),
                        boxShadow: isSelected
                            ? [BoxShadow(color: opt.color.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 3))]
                            : null,
                      ),
                      child: Column(
                        children: [
                          Icon(opt.icon, color: isSelected ? Colors.white : opt.color, size: 22),
                          const SizedBox(height: 6),
                          Text(
                            opt.label,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? Colors.white : AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Image URL section
            _buildSectionTitle('Media', Icons.image_rounded),
            const SizedBox(height: 10),
            _buildField(
              controller: _imageUrlController,
              label: 'Image URL',
              hint: 'Paste a direct web image link (optional)',
              icon: Icons.link_rounded,
            ),
            if (_imageUrlController.text.isNotEmpty) ...[
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  _imageUrlController.text,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.lightBorder,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Center(child: Text('Invalid URL', style: TextStyle(color: AppColors.textMuted))),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),

            // Basic info
            _buildSectionTitle('Basic Information', Icons.info_outline_rounded),
            const SizedBox(height: 10),
            _buildField(
              controller: _nameController,
              label: _selectedType == 'accessory' ? 'Product Name' : 'Pet Name / Breed Name',
              hint: _selectedType == 'accessory' ? 'Royal Canin Puppy 3kg' : 'Golden Retriever Puppy',
              icon: Icons.title_rounded,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null,
            ),
            const SizedBox(height: 14),

            // Pet-specific fields
            if (_selectedType == 'puppy' || _selectedType == 'adoption') ...[
              Row(
                children: [
                  Expanded(
                    child: _buildField(
                      controller: _breedController,
                      label: 'Breed',
                      hint: 'Labrador, Beagle...',
                      icon: Icons.category_rounded,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter breed' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildField(
                      controller: _ageController,
                      label: 'Age',
                      hint: '50 Days, 2 Months...',
                      icon: Icons.calendar_today_rounded,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter age' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdownField(
                      label: 'Gender',
                      icon: Icons.transgender_rounded,
                      value: _selectedGender,
                      items: ['Male', 'Female'],
                      onChanged: (v) => setState(() => _selectedGender = v!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildToggleField(),
                  ),
                ],
              ),
              const SizedBox(height: 14),
            ],

            // Accessory-specific
            if (_selectedType == 'accessory') ...[
              _buildDropdownField(
                label: 'Category',
                icon: Icons.category_rounded,
                value: _accessoryCategory,
                items: _accessoryCategories,
                onChanged: (v) => setState(() => _accessoryCategory = v!),
              ),
              const SizedBox(height: 14),
              _buildField(
                controller: _stockController,
                label: 'Stock Quantity',
                hint: '20 pcs, 4 kg, etc.',
                icon: Icons.inventory_rounded,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter stock' : null,
              ),
              const SizedBox(height: 14),
            ],

            // Price
            _buildField(
              controller: _priceController,
              label: _selectedType == 'adoption' ? 'Adoption Fee ₹ (0 for Free)' : 'Price (₹)',
              hint: _selectedType == 'adoption' ? '0' : '15000',
              icon: Icons.currency_rupee_rounded,
              keyboardType: TextInputType.number,
              validator: (v) => (_selectedType != 'adoption' && (v == null || v.trim().isEmpty)) ? 'Enter price' : null,
            ),
            const SizedBox(height: 14),

            // Description
            _buildSectionTitle('Description & Details', Icons.notes_rounded),
            const SizedBox(height: 10),
            _buildField(
              controller: _descController,
              label: 'Description',
              hint: 'Describe health status, temperament, vaccination details...',
              icon: Icons.notes_rounded,
              maxLines: 4,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter description' : null,
            ),
            const SizedBox(height: 28),

            // Submit button
            Container(
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_activeColor, _activeColor.withOpacity(0.85)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _activeColor.withOpacity(0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _saveProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: EdgeInsets.zero,
                ),
                icon: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Icon(Icons.cloud_upload_rounded, size: 22),
                label: _isLoading
                    ? const Text('Publishing...')
                    : const Text('Publish to LUCKEY PETS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: _activeColor),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textDark)),
      ],
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      onChanged: icon == Icons.link_rounded ? (_) => setState(() {}) : null,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: _activeColor, size: 20),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: _activeColor, width: 2),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F6F2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: _activeColor),
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Outfit',
          ),
          items: items.map((item) => DropdownMenuItem(
            value: item,
            child: Text(item),
          )).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildToggleField() {
    return GestureDetector(
      onTap: () => setState(() => _isVaccinated = !_isVaccinated),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: _isVaccinated ? Colors.green.shade50 : const Color(0xFFF8F6F2),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _isVaccinated ? Colors.green.shade400 : AppColors.lightBorder,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: _isVaccinated ? Colors.green.shade600 : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isVaccinated ? Icons.check_rounded : Icons.close_rounded,
                color: Colors.white,
                size: 14,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Vaccinated', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  Text(
                    _isVaccinated ? 'Yes, confirmed' : 'Not vaccinated',
                    style: TextStyle(fontSize: 10, color: _isVaccinated ? Colors.green.shade700 : AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeOption {
  final String type;
  final String label;
  final IconData icon;
  final Color color;
  const _TypeOption({required this.type, required this.label, required this.icon, required this.color});
}