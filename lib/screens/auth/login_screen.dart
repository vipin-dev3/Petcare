import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/animated_paw.dart';

class LoginScreen extends StatefulWidget {
  final AuthService authService;

  const LoginScreen({super.key, required this.authService});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _autofillDemo() {
    setState(() {
      _usernameController.text = 'admin';
      _passwordController.text = '1234';
      _errorMessage = null;
    });
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await Future.delayed(const Duration(milliseconds: 600)); // Smooth UX transition

    final success = await widget.authService.login(
      _usernameController.text,
      _passwordController.text,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (!success) {
      setState(() {
        _errorMessage = 'Invalid username or password. (Hint: admin / 1234)';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient & Animated Paws
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [const Color(0xFF0B1120), const Color(0xFF131D31), const Color(0xFF1E293B)]
                      : [const Color(0xFFF0FDF4), const Color(0xFFE0F2FE), const Color(0xFFFEF3C7)],
                ),
              ),
            ),
          ),
          const FloatingPawBackground(),

          // Centered Login Card
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Animated Mascot Icon
                        const AnimatedPawBadge(size: 64, color: AppColors.primary),

                        const SizedBox(height: 18),

                        // Title
                        Text(
                          'PetCare Pro',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Sign in to manage veterinary and pet records',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 24),

                        // Quick demo pill
                        InkWell(
                          onTap: _autofillDemo,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color: AppColors.primarySubtle,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.primaryLight.withValues(alpha: 0.5)),
                            ),
                            child: const Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              alignment: WrapAlignment.center,
                              children: [
                                Icon(Icons.flash_on_rounded, size: 14, color: AppColors.primaryDark),
                                SizedBox(width: 6),
                                Text(
                                  'Autofill Demo (admin / 1234)',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Error Banner if login fails
                        if (_errorMessage != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.errorSubtle,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline, color: AppColors.error, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _errorMessage!,
                                    style: const TextStyle(color: AppColors.error, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Username Field
                        TextFormField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            hintText: 'Enter admin or your username',
                            prefixIcon: Icon(Icons.person_outline_rounded),
                          ),
                          validator: (v) => v == null || v.trim().isEmpty ? 'Please enter username' : null,
                        ),

                        const SizedBox(height: 16),

                        // Password Field
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter password (e.g. 1234)',
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                size: 20,
                              ),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                          validator: (v) => v == null || v.trim().isEmpty ? 'Please enter password' : null,
                          onFieldSubmitted: (_) => _handleLogin(),
                        ),

                        const SizedBox(height: 24),

                        // Sign In Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              elevation: 2,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                  )
                                : const Text(
                                    'Sign In to Dashboard',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Friendly footer note
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.shield_outlined, size: 14, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Text(
                              'Secure Clinic Management Portal',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
