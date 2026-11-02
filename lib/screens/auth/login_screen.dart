import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../admin/admin_dashboard_screen.dart';
import '../user/home_screen.dart';
import 'auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _bgAnimController;
  late AnimationController _cardAnimController;
  late Animation<double> _cardSlideAnim;
  late Animation<double> _cardFadeAnim;

  final _signInFormKey = GlobalKey<FormState>();
  final _signUpFormKey = GlobalKey<FormState>();

  bool _isAdmin = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  final _signInEmailController = TextEditingController();
  final _signInPasswordController = TextEditingController();
  final _adminKeyController = TextEditingController();
  final _signUpNameController = TextEditingController();
  final _signUpEmailController = TextEditingController();
  final _signUpPhoneController = TextEditingController();
  final _signUpPasswordController = TextEditingController();
  final _signUpConfirmPassController = TextEditingController();
  final _signUpAdminKeyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _bgAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _cardAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _cardSlideAnim = Tween<double>(begin: 60, end: 0).animate(
      CurvedAnimation(parent: _cardAnimController, curve: Curves.easeOutCubic),
    );
    _cardFadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _cardAnimController, curve: Curves.easeOut),
    );

    _cardAnimController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _bgAnimController.dispose();
    _cardAnimController.dispose();
    _signInEmailController.dispose();
    _signInPasswordController.dispose();
    _adminKeyController.dispose();
    _signUpNameController.dispose();
    _signUpEmailController.dispose();
    _signUpPhoneController.dispose();
    _signUpPasswordController.dispose();
    _signUpConfirmPassController.dispose();
    _signUpAdminKeyController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (!_signInFormKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final res = await AuthService.login(
      email: _signInEmailController.text.trim(),
      password: _signInPasswordController.text,
      isAdmin: _isAdmin,
      adminKey: _adminKeyController.text.trim(),
    );
    setState(() => _isLoading = false);
    if (!mounted) return;
    if (res['success'] == true) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              _isAdmin ? const AdminDashboardScreen() : const UserHomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.05),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    } else {
      _showErrorSnack(res['message'] ?? 'Authentication failed');
    }
  }

  Future<void> _handleSignUp() async {
    if (!_signUpFormKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final res = await AuthService.signUp(
      fullName: _signUpNameController.text.trim(),
      email: _signUpEmailController.text.trim(),
      phone: _signUpPhoneController.text.trim(),
      password: _signUpPasswordController.text,
      isAdmin: _isAdmin,
      adminKey: _signUpAdminKeyController.text.trim(),
    );
    setState(() => _isLoading = false);
    if (!mounted) return;
    if (res['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white),
              SizedBox(width: 10),
              Text('Account created! Please Sign In.', style: TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          backgroundColor: AppColors.primary,
        ),
      );
      _tabController.animateTo(0);
    } else {
      _showErrorSnack(res['message'] ?? 'Sign up failed');
    }
  }

  void _showErrorSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text(msg, style: const TextStyle(fontWeight: FontWeight.w600))),
          ],
        ),
        backgroundColor: AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;
    return Scaffold(
      body: Stack(
        children: [
          // Animated Gradient Background
          _buildAnimatedBackground(),

          // Main Content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: AnimatedBuilder(
                animation: _cardAnimController,
                builder: (context, child) => Transform.translate(
                  offset: Offset(0, _cardSlideAnim.value),
                  child: Opacity(
                    opacity: _cardFadeAnim.value,
                    child: child,
                  ),
                ),
                child: isWide ? _buildWideLayout() : _buildNarrowLayout(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _bgAnimController,
      builder: (context, child) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF041A0C),
                Color(0xFF0A3018),
                Color(0xFF062012),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Floating orbs
              Positioned(
                top: -100 + 80 * math.sin(_bgAnimController.value * 2 * math.pi),
                left: -80,
                child: _buildOrb(280, AppColors.primary.withOpacity(0.3)),
              ),
              Positioned(
                bottom: -80 + 60 * math.cos(_bgAnimController.value * 2 * math.pi),
                right: -60,
                child: _buildOrb(240, AppColors.accent.withOpacity(0.25)),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.4,
                left: MediaQuery.of(context).size.width * 0.3,
                child: _buildOrb(180, AppColors.primaryLight.withOpacity(0.15)),
              ),
              // Grid pattern overlay
              Opacity(
                opacity: 0.03,
                child: CustomPaint(
                  size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
                  painter: _GridPainter(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrb(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }

  Widget _buildWideLayout() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1000),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Hero Panel
          Expanded(
            flex: 5,
            child: _buildHeroPanel(),
          ),
          const SizedBox(width: 32),
          // Right Auth Card
          Expanded(
            flex: 4,
            child: _buildAuthCard(),
          ),
        ],
      ),
    );
  }

  Widget _buildNarrowLayout() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 480),
      child: Column(
        children: [
          _buildCompactLogo(),
          const SizedBox(height: 24),
          _buildAuthCard(),
          const SizedBox(height: 20),
          _buildContactFooter(),
        ],
      ),
    );
  }

  Widget _buildHeroPanel() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(Icons.pets, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 14),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LUCKEY PETS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  Text(
                    'Eddapadi • Poolampatti',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 48),
          const Text(
            'Your Trusted\nPet Paradise',
            style: TextStyle(
              color: Colors.white,
              fontSize: 44,
              fontWeight: FontWeight.w900,
              height: 1.1,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Bringing joy and love to every home through our carefully selected pets, premium accessories, and heartfelt adoption program.',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 15,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 40),
          // Feature Badges
          _buildFeatureBadge(Icons.pets_rounded, 'Pure Breed Puppies', 'KCI registered, fully vaccinated'),
          const SizedBox(height: 12),
          _buildFeatureBadge(Icons.favorite_rounded, 'Pet Adoption', 'Give a rescue a forever home'),
          const SizedBox(height: 12),
          _buildFeatureBadge(Icons.shopping_bag_rounded, 'Premium Accessories', 'Curated food, toys & grooming'),
          const SizedBox(height: 40),
          _buildContactFooter(),
        ],
      ),
    );
  }

  Widget _buildFeatureBadge(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
              Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactLogo() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.5),
                blurRadius: 24,
                spreadRadius: 4,
              ),
            ],
          ),
          child: const Icon(Icons.pets, color: Colors.white, size: 32),
        ),
        const SizedBox(height: 16),
        const Text(
          'LUCKEY PETS',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.5,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            gradient: AppColors.accentGradient,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            '🐾  Happy Pets, Healthy Lives  🐾',
            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  Widget _buildAuthCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 40,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          // Hero image banner
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
            child: Stack(
              children: [
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: AppColors.heroGradient,
                  ),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1548681528-6a5c45b66b42?w=800&auto=format&fit=crop&q=80',
                    fit: BoxFit.cover,
                    color: Colors.black.withOpacity(0.4),
                    colorBlendMode: BlendMode.darken,
                    errorBuilder: (context, e, s) => const SizedBox.shrink(),
                  ),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Category pills
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildPill('🐶 Puppies', AppColors.primaryLight),
                            const SizedBox(width: 8),
                            _buildPill('❤ Adoption', AppColors.accent),
                            const SizedBox(width: 8),
                            _buildPill('🛍 Shop', Colors.indigo),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Welcome Back!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const Text(
                          'Sign in to explore our pet universe',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Role toggle
                _buildRoleToggle(),
                const SizedBox(height: 20),

                // Tab bar
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: _isAdmin ? AppColors.accent : AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    unselectedLabelColor: AppColors.textMuted,
                    labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                    dividerColor: Colors.transparent,
                    padding: const EdgeInsets.all(4),
                    tabs: const [
                      Tab(text: 'Sign In'),
                      Tab(text: 'Create Account'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                AnimatedBuilder(
                  animation: _tabController,
                  builder: (context, _) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _tabController.index == 0
                          ? _buildSignInForm()
                          : _buildSignUpForm(),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }

  Widget _buildRoleToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Row(
        children: [
          _buildRoleOption(
            label: 'Customer',
            icon: Icons.person_rounded,
            isSelected: !_isAdmin,
            color: AppColors.primary,
            onTap: () => setState(() => _isAdmin = false),
          ),
          _buildRoleOption(
            label: 'Admin Portal',
            icon: Icons.admin_panel_settings_rounded,
            isSelected: _isAdmin,
            color: AppColors.accent,
            onTap: () => setState(() => _isAdmin = true),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleOption({
    required String label,
    required IconData icon,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: isSelected ? Colors.white : AppColors.textMuted),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: isSelected ? Colors.white : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignInForm() {
    final activeColor = _isAdmin ? AppColors.accent : AppColors.primary;
    return Form(
      key: _signInFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildInput(
            controller: _signInEmailController,
            label: _isAdmin ? 'Admin Email' : 'Email Address',
            hint: _isAdmin ? 'admin@pets.com' : 'you@example.com',
            icon: Icons.alternate_email_rounded,
            activeColor: activeColor,
            keyboardType: TextInputType.emailAddress,
            validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
          ),
          const SizedBox(height: 14),
          _buildInput(
            controller: _signInPasswordController,
            label: 'Password',
            hint: '••••••••',
            icon: Icons.lock_outline_rounded,
            activeColor: activeColor,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                color: AppColors.textMuted,
                size: 20,
              ),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
            validator: (v) => (v == null || v.length < 6) ? 'Min 6 characters' : null,
          ),
          if (_isAdmin) ...[
            const SizedBox(height: 14),
            _buildInput(
              controller: _adminKeyController,
              label: 'Admin Secret Key',
              hint: 'Enter master passkey',
              icon: Icons.vpn_key_rounded,
              activeColor: activeColor,
              obscureText: true,
              validator: (v) => _isAdmin && (v == null || v.isEmpty) ? 'Enter passkey' : null,
            ),
          ],
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: Text(
                'Forgot Password?',
                style: TextStyle(color: activeColor, fontWeight: FontWeight.w700, fontSize: 13),
              ),
            ),
          ),
          const SizedBox(height: 4),
          _buildSubmitButton(
            label: _isAdmin ? 'Access Admin Dashboard' : 'Sign In to Shop',
            icon: _isAdmin ? Icons.dashboard_rounded : Icons.storefront_rounded,
            color: activeColor,
            onPressed: _handleSignIn,
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpForm() {
    final activeColor = _isAdmin ? AppColors.accent : AppColors.primary;
    return Form(
      key: _signUpFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildInput(
            controller: _signUpNameController,
            label: 'Full Name',
            hint: 'Your full name',
            icon: Icons.person_outline_rounded,
            activeColor: activeColor,
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter your name' : null,
          ),
          const SizedBox(height: 12),
          _buildInput(
            controller: _signUpEmailController,
            label: 'Email Address',
            hint: 'name@example.com',
            icon: Icons.email_outlined,
            activeColor: activeColor,
            keyboardType: TextInputType.emailAddress,
            validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
          ),
          const SizedBox(height: 12),
          _buildInput(
            controller: _signUpPhoneController,
            label: 'Mobile Number',
            hint: '+91 9876543210',
            icon: Icons.phone_outlined,
            activeColor: activeColor,
            keyboardType: TextInputType.phone,
            validator: (v) => (v == null || v.trim().length < 10) ? 'Enter 10-digit number' : null,
          ),
          const SizedBox(height: 12),
          _buildInput(
            controller: _signUpPasswordController,
            label: 'Password',
            hint: 'Min 6 characters',
            icon: Icons.lock_outline_rounded,
            activeColor: activeColor,
            obscureText: _obscurePassword,
            validator: (v) => (v == null || v.length < 6) ? 'Min 6 characters' : null,
          ),
          const SizedBox(height: 12),
          _buildInput(
            controller: _signUpConfirmPassController,
            label: 'Confirm Password',
            hint: 'Re-enter password',
            icon: Icons.lock_clock_outlined,
            activeColor: activeColor,
            obscureText: _obscureConfirmPassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                color: AppColors.textMuted,
                size: 20,
              ),
              onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
            ),
            validator: (v) => v != _signUpPasswordController.text ? 'Passwords do not match' : null,
          ),
          if (_isAdmin) ...[
            const SizedBox(height: 12),
            _buildInput(
              controller: _signUpAdminKeyController,
              label: 'Master Admin Key',
              hint: 'PETSADMIN2026',
              icon: Icons.security_rounded,
              activeColor: activeColor,
              obscureText: true,
              validator: (v) => _isAdmin && (v == null || v.isEmpty) ? 'Admin key required' : null,
            ),
          ],
          const SizedBox(height: 20),
          _buildSubmitButton(
            label: _isAdmin ? 'Register Admin Account' : 'Create Free Account',
            icon: _isAdmin ? Icons.admin_panel_settings_rounded : Icons.how_to_reg_rounded,
            color: activeColor,
            onPressed: _handleSignUp,
          ),
        ],
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Color activeColor,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: activeColor, size: 20),
        suffixIcon: suffixIcon,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: activeColor, width: 2),
        ),
      ),
    );
  }

  Widget _buildSubmitButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 52,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.85)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: EdgeInsets.zero,
        ),
        icon: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : Icon(icon, size: 20),
        label: _isLoading ? const SizedBox.shrink() : Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
      ),
    );
  }

  Widget _buildContactFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on_rounded, size: 14, color: Colors.white60),
              const SizedBox(width: 4),
              const Text('Eddapadi, Poolampatti', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(width: 16),
              const Icon(Icons.phone_rounded, size: 14, color: Colors.white60),
              const SizedBox(width: 4),
              const Text('+91 6374693453', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Owner: VIJAYDHARNISH  •  luckeypets@gmail.com',
            style: TextStyle(color: Colors.white38, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 0.5;
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}