// lib/screens/auth/change_password_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _success = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleChange() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await _authService.updatePassword(_newPasswordController.text);
      if (!mounted) return;
      setState(() => _success = true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler: $e'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
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
    final borderStrong = isDark
        ? AppColors.darkBorderStrong
        : AppColors.lightBorderStrong;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;
    final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // ─── APPBAR ───────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back_rounded, color: text, size: 22),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Passwort ändern',
                    style: AppTextStyles.instrumentSerif(
                      size: 24,
                      color: text,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),

            // ─── CONTENT ──────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                child: _success
                    ? _buildSuccess(text, textMid, textDim, bg)
                    : _buildForm(
                        surface,
                        border,
                        borderStrong,
                        text,
                        textMid,
                        textDim,
                        bg,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── SUCCESS STATE ───────────────────────
  Widget _buildSuccess(Color text, Color textMid, Color textDim, Color bg) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
        Row(
          children: [
            Container(width: 16, height: 1, color: AppColors.success),
            const SizedBox(width: 10),
            Text(
              'ERFOLGREICH',
              style: AppTextStyles.monoLabel(AppColors.success),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Passwort geändert.',
          style: AppTextStyles.instrumentSerif(
            size: 34,
            color: text,
            letterSpacing: -1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Dein neues Passwort ist aktiv. Du kannst dich ab sofort damit einloggen.',
          style: AppTextStyles.bodyMedium(textMid),
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded, size: 18),
            label: const Text('Zurück'),
            style: ElevatedButton.styleFrom(
              backgroundColor: text,
              foregroundColor: bg,
              elevation: 0,
              textStyle: AppTextStyles.labelLarge(bg),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─── FORM ────────────────────────────────
  Widget _buildForm(
    Color surface,
    Color border,
    Color borderStrong,
    Color text,
    Color textMid,
    Color textDim,
    Color bg,
  ) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Intro
          Row(
            children: [
              Container(width: 16, height: 1, color: AppColors.accent),
              const SizedBox(width: 10),
              Text(
                'SICHERHEIT',
                style: AppTextStyles.monoLabel(AppColors.accent),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Neues Passwort\nfestlegen.',
            style: AppTextStyles.instrumentSerif(
              size: 34,
              color: text,
              letterSpacing: -1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Mindestens 8 Zeichen — am besten mit Sonderzeichen.',
            style: AppTextStyles.bodyMedium(textMid),
          ),

          const SizedBox(height: 36),

          // Neues Passwort
          Text('NEUES PASSWORT', style: AppTextStyles.monoSmall(textDim)),
          const SizedBox(height: 8),
          TextFormField(
            controller: _newPasswordController,
            obscureText: _obscureNew,
            style: AppTextStyles.bodyMedium(text),
            decoration: InputDecoration(
              hintText: '••••••••',
              hintStyle: AppTextStyles.bodyMedium(textDim),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureNew
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: textMid,
                  size: 18,
                ),
                onPressed: () => setState(() => _obscureNew = !_obscureNew),
              ),
              filled: true,
              fillColor: surface,
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
                borderSide: BorderSide(color: AppColors.accent),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.error),
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Passwort eingeben';
              if (v.length < 8) return 'Mindestens 8 Zeichen';
              return null;
            },
          ),

          const SizedBox(height: 20),

          // Passwort bestätigen
          Text('PASSWORT BESTÄTIGEN', style: AppTextStyles.monoSmall(textDim)),
          const SizedBox(height: 8),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirm,
            style: AppTextStyles.bodyMedium(text),
            decoration: InputDecoration(
              hintText: '••••••••',
              hintStyle: AppTextStyles.bodyMedium(textDim),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirm
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: textMid,
                  size: 18,
                ),
                onPressed: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
              ),
              filled: true,
              fillColor: surface,
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
                borderSide: BorderSide(color: AppColors.accent),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.error),
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Passwort bestätigen';
              if (v != _newPasswordController.text)
                return 'Passwörter stimmen nicht überein';
              return null;
            },
          ),

          const SizedBox(height: 36),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleChange,
              style: ElevatedButton.styleFrom(
                backgroundColor: text,
                foregroundColor: bg,
                disabledBackgroundColor: border,
                disabledForegroundColor: textDim,
                elevation: 0,
                textStyle: AppTextStyles.labelLarge(bg),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: _isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(bg),
                      ),
                    )
                  : const Text('Passwort ändern'),
            ),
          ),
        ],
      ),
    );
  }
}
