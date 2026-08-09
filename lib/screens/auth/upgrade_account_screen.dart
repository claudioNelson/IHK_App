// lib/screens/auth/upgrade_account_screen.dart
//
// Gast → Account-Umwandlung.
// Der anonyme User bekommt E-Mail, Passwort und Username — die User-ID
// bleibt gleich, der komplette Lernfortschritt bleibt erhalten.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';

class UpgradeAccountScreen extends StatefulWidget {
  const UpgradeAccountScreen({super.key});

  @override
  State<UpgradeAccountScreen> createState() => _UpgradeAccountScreenState();
}

class _UpgradeAccountScreenState extends State<UpgradeAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _authService = AuthService();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _loading = false;
  bool _done = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleUpgrade() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      await _authService.convertGuestToAccount(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        username: _usernameController.text.trim(),
      );
      if (!mounted) return;
      setState(() {
        _loading = false;
        _done = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);

      final msg = e.toString().toLowerCase();
      String fehler = 'Umwandlung fehlgeschlagen. Bitte später erneut versuchen.';
      if (msg.contains('already') && msg.contains('registered') ||
          msg.contains('already been registered') ||
          msg.contains('email_exists')) {
        fehler =
            'Diese E-Mail wird bereits verwendet. Bitte eine andere Adresse nutzen oder dich mit dem bestehenden Konto einloggen.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(fehler), backgroundColor: AppColors.error),
      );
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
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: text),
          onPressed: () => Navigator.pop(context, _done),
        ),
        title: Text('Account erstellen', style: AppTextStyles.h2(text)),
      ),
      body: SafeArea(
        child: _done
            ? _buildDone(surface, border, text, textMid)
            : _buildForm(isDark, surface, border, text, textMid, textDim),
      ),
    );
  }

  // ─── FORMULAR ───────────────────────────────────────────────
  Widget _buildForm(
    bool isDark,
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Sichere deinen Fortschritt.',
              style: AppTextStyles.displaySmall(text),
            ),
            const SizedBox(height: 8),
            Text(
              'Dein kompletter Lernfortschritt bleibt erhalten — er wird '
              'einfach mit deinem neuen Account verknüpft. Danach kannst du '
              'dich auf jedem Gerät einloggen.',
              style: AppTextStyles.bodyMedium(textMid),
            ),
            const SizedBox(height: 24),
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
                  Text('BENUTZERNAME', style: AppTextStyles.monoSmall(textDim)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _usernameController,
                    textInputAction: TextInputAction.next,
                    style: AppTextStyles.bodyMedium(text),
                    decoration: _inputDeco(hint: 'dein_name', isDark: isDark),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Bitte Benutzername eingeben';
                      }
                      if (v.trim().length < 3) return 'Mindestens 3 Zeichen';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Text('EMAIL', style: AppTextStyles.monoSmall(textDim)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autocorrect: false,
                    style: AppTextStyles.bodyMedium(text),
                    decoration:
                        _inputDeco(hint: 'deine@email.com', isDark: isDark),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Bitte E-Mail eingeben';
                      }
                      if (!v.contains('@')) return 'Ungültige E-Mail';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Text('PASSWORT', style: AppTextStyles.monoSmall(textDim)),
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
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Bitte Passwort eingeben';
                      }
                      if (v.length < 6) return 'Mindestens 6 Zeichen';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'PASSWORT BESTÄTIGEN',
                    style: AppTextStyles.monoSmall(textDim),
                  ),
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
                        onPressed: () => setState(
                          () => _obscureConfirmPassword =
                              !_obscureConfirmPassword,
                        ),
                      ),
                    ),
                    validator: (v) {
                      if (v != _passwordController.text) {
                        return 'Passwörter stimmen nicht überein';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _handleUpgrade(),
                  ),
                  const SizedBox(height: 28),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _loading ? null : _handleUpgrade,
                    child: _loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Account erstellen & Fortschritt sichern',
                            style: AppTextStyles.labelLarge(Colors.white),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── ERFOLG ─────────────────────────────────────────────────
  Widget _buildDone(Color surface, Color border, Color text, Color textMid) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.success.withOpacity(0.4)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.mark_email_read_outlined,
                color: AppColors.success,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                'Fast geschafft!',
                style: AppTextStyles.h1(text),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Wir haben dir eine Bestätigungsmail an '
                '${_emailController.text.trim()} geschickt. '
                'Tippe auf den Link in der Mail, um deinen Account zu '
                'aktivieren. Dein Fortschritt ist bereits gesichert.',
                style: AppTextStyles.bodyMedium(textMid),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  'Alles klar',
                  style: AppTextStyles.labelLarge(Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }
}
