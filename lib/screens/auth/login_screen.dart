import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import '../../widgets/navigation/nav_root.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _isLoading = false;
  bool _obscurePassword = true;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      await _authService.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const NavRoot()),
        (route) => false,
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      String errorMessage;
      switch (e.message.toLowerCase()) {
        case 'invalid login credentials':
          errorMessage = 'Ungültige E-Mail oder Passwort';
          break;
        case 'email not confirmed':
          errorMessage = 'Bitte E-Mail bestätigen';
          break;
        default:
          errorMessage = e.message;
      }
      _showError(errorMessage);
    } catch (e) {
      if (!mounted) return;
      _showError('Fehler: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 18),
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

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Bitte E-Mail eingeben';
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) return 'Ungültige E-Mail-Adresse';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Bitte Passwort eingeben';
    if (value.length < 6) return 'Mindestens 6 Zeichen erforderlich';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDark;

    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final borderStrong =
        isDark ? AppColors.darkBorderStrong : AppColors.lightBorderStrong;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;
    final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          // Subtle Radial Glow im Hintergrund
          Align(
            alignment: const Alignment(0, -0.7),
            child: Container(
              width: 500,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accent.withOpacity(0.1),
                    AppColors.accent.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),

          // Theme-Toggle oben rechts
          Positioned(
            top: 16,
            right: 16,
            child: SafeArea(
              child: IconButton(
                onPressed: () => themeProvider.toggleTheme(),
                icon: Icon(
                  isDark
                      ? Icons.wb_sunny_outlined
                      : Icons.nightlight_outlined,
                  color: textMid,
                  size: 20,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: border),
                  ),
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
                          horizontal: 28, vertical: 40),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // ─── Logo ─────────────────────────────
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
                                          color: AppColors.accent
                                              .withOpacity(0.6),
                                          blurRadius: 16,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  // "Lernarena" Instrument Serif
                                  Text(
                                    'Lernarena',
                                    style: AppTextStyles.instrumentSerif(
                                      size: 40,
                                      color: text,
                                      letterSpacing: -1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Willkommen zurück',
                                    style: AppTextStyles.bodyMedium(textMid),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 48),

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
                                  // E-Mail
                                  _buildLabel('EMAIL', textDim),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _emailController,
                                    focusNode: _emailFocusNode,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    autocorrect: false,
                                    style: AppTextStyles.bodyMedium(text),
                                    decoration: _inputDecoration(
                                      hint: 'deine@email.com',
                                      isDark: isDark,
                                    ),
                                    validator: _validateEmail,
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context)
                                          .requestFocus(_passwordFocusNode);
                                    },
                                  ),

                                  const SizedBox(height: 20),

                                  // Passwort + "Vergessen?" Row
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildLabel('PASSWORT', textDim),
                                      TextButton(
                                        onPressed: _isLoading
                                            ? null
                                            : () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        const ForgotPasswordScreen(),
                                                  ),
                                                ),
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          minimumSize: Size.zero,
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        child: Text(
                                          'Vergessen?',
                                          style: AppTextStyles.labelSmall(
                                              AppColors.accent),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _passwordController,
                                    focusNode: _passwordFocusNode,
                                    obscureText: _obscurePassword,
                                    textInputAction: TextInputAction.done,
                                    style: AppTextStyles.bodyMedium(text),
                                    decoration: _inputDecoration(
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
                                        onPressed: () => setState(
                                          () => _obscurePassword =
                                              !_obscurePassword,
                                        ),
                                      ),
                                    ),
                                    validator: _validatePassword,
                                    onFieldSubmitted: (_) => _handleLogin(),
                                  ),

                                  const SizedBox(height: 24),

                                  // Login Button (Primary)
                                  SizedBox(
                                    height: 48,
                                    child: ElevatedButton(
                                      onPressed: _isLoading ? null : _handleLogin,
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
                                              'Anmelden  →',
                                              style: AppTextStyles.labelLarge(bg),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // ─── Divider ──────────────────────────
                            Row(
                              children: [
                                Expanded(child: Divider(color: border)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Text(
                                    'ODER',
                                    style: AppTextStyles.monoSmall(textDim),
                                  ),
                                ),
                                Expanded(child: Divider(color: border)),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Registrieren (Secondary)
                            SizedBox(
                              height: 48,
                              child: OutlinedButton(
                                onPressed: _isLoading
                                    ? null
                                    : () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const RegisterScreen(),
                                          ),
                                        ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: text,
                                  side: BorderSide(color: borderStrong),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Neuen Account erstellen',
                                  style: AppTextStyles.labelLarge(text),
                                ),
                              ),
                            ),

                            const SizedBox(height: 48),

                            // Version
                            Center(
                              child: Text(
                                'v1.0.0 · BUILD 2026.04',
                                style: AppTextStyles.monoSmall(textDim),
                              ),
                            ),
                            const SizedBox(height: 16),
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
    return Text(
      text,
      style: AppTextStyles.monoSmall(color),
    );
  }

  InputDecoration _inputDecoration({
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