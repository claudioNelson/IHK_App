import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _slideAnim = Tween<Offset>(
            begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await _authService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        username: _usernameController.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Expanded(
                child: Text('Registrierung erfolgreich! Bitte E-Mail bestätigen.'),
              ),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(16),
        ),
      );
      Navigator.pop(context);
    } on AuthException catch (e) {
      if (!mounted) return;
      _showError(e.message);
    } catch (e) {
      if (!mounted) return;
      _showError('Fehler: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline_rounded,
                color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDark;

    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;
    final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          // Subtle Radial Glow
          Align(
            alignment: const Alignment(0, -0.7),
            child: Container(
              width: 500,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accent.withOpacity(0.08),
                    AppColors.accent.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // ─── Back Button ──────────────────────
                            Align(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: surface,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: border),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.arrow_back,
                                          color: textMid, size: 14),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Zurück',
                                        style: AppTextStyles.labelSmall(textMid),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),

                            // ─── Logo & Titel ─────────────────────
                            Center(
                              child: Column(
                                children: [
                                  // Logo-Dot
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.accent,
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              AppColors.accent.withOpacity(0.6),
                                          blurRadius: 16,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    'Account erstellen',
                                    style: AppTextStyles.instrumentSerif(
                                      size: 36,
                                      color: text,
                                      letterSpacing: -1.0,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Starte deine Lernreise',
                                    style: AppTextStyles.bodyMedium(textMid),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 40),

                            // ─── Form Card ────────────────────────
                            Container(
                              padding: const EdgeInsets.all(28),
                              decoration: BoxDecoration(
                                color: surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: border),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _buildLabel('BENUTZERNAME', textDim),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _usernameController,
                                    textInputAction: TextInputAction.next,
                                    style: AppTextStyles.bodyMedium(text),
                                    decoration: _inputDeco(
                                      hint: 'dein_name',
                                      isDark: isDark,
                                    ),
                                    validator: (v) {
                                      if (v == null || v.isEmpty) {
                                        return 'Bitte Benutzername eingeben';
                                      }
                                      if (v.length < 3) {
                                        return 'Mindestens 3 Zeichen';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),

                                  _buildLabel('EMAIL', textDim),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    autocorrect: false,
                                    style: AppTextStyles.bodyMedium(text),
                                    decoration: _inputDeco(
                                      hint: 'deine@email.com',
                                      isDark: isDark,
                                    ),
                                    validator: (v) {
                                      if (v == null || v.isEmpty) {
                                        return 'Bitte E-Mail eingeben';
                                      }
                                      if (!v.contains('@')) {
                                        return 'Ungültige E-Mail';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),

                                  _buildLabel('PASSWORT', textDim),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: _obscurePassword,
                                    textInputAction: TextInputAction.next,
                                    style: AppTextStyles.bodyMedium(text),
                                    decoration: _inputDeco(
                                      hint: '••••••••',
                                      isDark: isDark,
                                      suffix: IconButton(
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          color: textDim,
                                          size: 18,
                                        ),
                                        onPressed: () => setState(() =>
                                            _obscurePassword =
                                                !_obscurePassword),
                                      ),
                                    ),
                                    validator: (v) {
                                      if (v == null || v.isEmpty) {
                                        return 'Bitte Passwort eingeben';
                                      }
                                      if (v.length < 6) {
                                        return 'Mindestens 6 Zeichen';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),

                                  _buildLabel('PASSWORT BESTÄTIGEN', textDim),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _confirmPasswordController,
                                    obscureText: _obscureConfirmPassword,
                                    textInputAction: TextInputAction.done,
                                    style: AppTextStyles.bodyMedium(text),
                                    decoration: _inputDeco(
                                      hint: '••••••••',
                                      isDark: isDark,
                                      suffix: IconButton(
                                        icon: Icon(
                                          _obscureConfirmPassword
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          color: textDim,
                                          size: 18,
                                        ),
                                        onPressed: () => setState(() =>
                                            _obscureConfirmPassword =
                                                !_obscureConfirmPassword),
                                      ),
                                    ),
                                    validator: (v) {
                                      if (v != _passwordController.text) {
                                        return 'Passwörter stimmen nicht überein';
                                      }
                                      return null;
                                    },
                                    onFieldSubmitted: (_) => _handleRegister(),
                                  ),
                                  const SizedBox(height: 28),

                                  SizedBox(
                                    height: 48,
                                    child: ElevatedButton(
                                      onPressed:
                                          _isLoading ? null : _handleRegister,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: text,
                                        foregroundColor: bg,
                                        disabledBackgroundColor:
                                            text.withOpacity(0.5),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: _isLoading
                                          ? SizedBox(
                                              height: 18,
                                              width: 18,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: bg,
                                              ),
                                            )
                                          : Text(
                                              'Account erstellen  →',
                                              style:
                                                  AppTextStyles.labelLarge(bg),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // ─── Back to Login ────────────────────
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Bereits ein Account?',
                                  style: AppTextStyles.bodySmall(textMid),
                                ),
                                const SizedBox(width: 6),
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Text(
                                    'Anmelden →',
                                    style: AppTextStyles.labelMedium(
                                        AppColors.accent),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
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

  Widget _buildLabel(String text, Color color) {
    return Text(text, style: AppTextStyles.monoSmall(color));
  }

  InputDecoration _inputDeco({
    required String hint,
    required bool isDark,
    Widget? suffix,
  }) {
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;

    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.bodyMedium(textDim),
      suffixIcon: suffix,
      filled: true,
      fillColor: bg,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      errorStyle: const TextStyle(color: AppColors.error, fontSize: 12),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }
}