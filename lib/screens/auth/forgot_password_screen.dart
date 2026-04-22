// lib/screens/auth/forgot_password_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

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
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await _authService.resetPassword(_emailController.text.trim());
      if (!mounted) return;
      setState(() => _emailSent = true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text('Fehler: $e')),
            ],
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(16),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;

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
          // Subtle Glow
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
                      child: _emailSent
                          ? _buildSuccess(bg, surface, border, text, textMid,
                              textDim, isDark)
                          : _buildForm(bg, surface, border, text, textMid,
                              textDim, isDark),
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

  // ─── FORM ───────────────────────────────────────────
  Widget _buildForm(Color bg, Color surface, Color border, Color text,
      Color textMid, Color textDim, bool isDark) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Back Button
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back, color: textMid, size: 14),
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

          // Logo + Titel
          Center(
            child: Column(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.accent,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withOpacity(0.6),
                        blurRadius: 16,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Passwort vergessen?',
                  style: AppTextStyles.instrumentSerif(
                    size: 36,
                    color: text,
                    letterSpacing: -1.0,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Wir senden dir einen Reset-Link',
                  style: AppTextStyles.bodyMedium(textMid),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // Form Card
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
                // Info Box
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.accent.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.accent,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Gib deine E-Mail-Adresse ein und wir senden dir einen Link zum Zurücksetzen.',
                          style: AppTextStyles.bodySmall(
                            isDark ? AppColors.darkText : AppColors.lightText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Email Label
                Text('EMAIL', style: AppTextStyles.monoSmall(textDim)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
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
                      return 'Ungültige E-Mail-Adresse';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => _handleReset(),
                ),
                const SizedBox(height: 24),

                // Send Button
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleReset,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: text,
                      foregroundColor: bg,
                      disabledBackgroundColor: text.withOpacity(0.5),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
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
                            'Reset-Link senden  →',
                            style: AppTextStyles.labelLarge(bg),
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

  // ─── SUCCESS ───────────────────────────────────────
  Widget _buildSuccess(Color bg, Color surface, Color border, Color text,
      Color textMid, Color textDim, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 48),

        // Success Icon (Glow-Ring statt Material-Circle)
        Center(
          child: Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.success.withOpacity(0.1),
              border: Border.all(
                color: AppColors.success.withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.success.withOpacity(0.2),
                  blurRadius: 40,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const Icon(
              Icons.mark_email_read_rounded,
              size: 42,
              color: AppColors.success,
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Status Label
        Center(
          child: Text(
            'ERFOLGREICH GESENDET',
            style: AppTextStyles.monoLabel(AppColors.success),
          ),
        ),
        const SizedBox(height: 12),

        // Titel
        Center(
          child: Text(
            'Check deine Mails.',
            style: AppTextStyles.instrumentSerif(
              size: 36,
              color: text,
              letterSpacing: -1.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),

        // Beschreibung
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: AppTextStyles.bodyMedium(textMid),
                children: [
                  const TextSpan(text: 'Wir haben einen Reset-Link an\n'),
                  TextSpan(
                    text: _emailController.text,
                    style: AppTextStyles.bodyMedium(text).copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(text: '\ngesendet.'),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 40),

        // Hinweis-Box
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border),
          ),
          child: Row(
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                color: textMid,
                size: 18,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Keine Mail gekommen? Schau im Spam-Ordner nach oder warte 1–2 Minuten.',
                  style: AppTextStyles.bodySmall(textMid),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Back Button
        SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: text,
              foregroundColor: bg,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Zurück zum Login  →',
              style: AppTextStyles.labelLarge(bg),
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  InputDecoration _inputDeco({
    required String hint,
    required bool isDark,
  }) {
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;

    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.bodyMedium(textDim),
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