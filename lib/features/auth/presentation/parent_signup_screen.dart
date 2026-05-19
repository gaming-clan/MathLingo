import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../responsive.dart';
import '../../../shared/widgets/cosmic_button.dart';
import '../../../shared/widgets/cosmic_top_bar.dart';
import '../../../shared/widgets/glass_panel.dart';
import '../providers/auth_provider.dart';
import 'parent_signin_screen.dart';

/// Ekrani i regjistrimit prindëror.
///
/// Aksesues vetëm nga SettingsScreen pas inicializimit të Firebase.
/// Fëmija nuk e sheh dhe nuk e akseson kurrë këtë ekran.
class ParentSignUpScreen extends ConsumerStatefulWidget {
  const ParentSignUpScreen({super.key});

  @override
  ConsumerState<ParentSignUpScreen> createState() => _ParentSignUpScreenState();
}

class _ParentSignUpScreenState extends ConsumerState<ParentSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSignUp() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_passwordCtrl.text != _confirmCtrl.text) {
      _showError('authErrorPasswordMismatch');
      return;
    }
    await ref.read(authProvider.notifier).signUp(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
        );
  }

  void _showError(String messageKey) {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_localizeError(l10n, messageKey)),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 80),
        backgroundColor: CosmicColors.error,
      ),
    );
  }

  String _localizeError(AppLocalizations l10n, String key) => switch (key) {
        'authErrorEmptyFields' => l10n.authErrorEmptyFields,
        'authErrorPasswordMismatch' => l10n.authErrorPasswordMismatch,
        'authErrorEmailInUse' => l10n.authErrorEmailInUse,
        'authErrorInvalidEmail' => l10n.authErrorInvalidEmail,
        'authErrorWeakPassword' => l10n.authErrorWeakPassword,
        'authErrorTooManyRequests' => l10n.authErrorTooManyRequests,
        'authErrorNetwork' => l10n.authErrorNetwork,
        'authErrorFirebaseNotReady' => l10n.authErrorFirebaseNotReady,
        _ => l10n.authErrorUnknown,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthStateLoading;

    // Navigo mbrapa nëse u autentifikua
    ref.listen<AuthState>(authProvider, (_, next) {
      if (next is AuthStateAuthenticated && mounted) {
        Navigator.of(context).pop();
      } else if (next is AuthStateError && mounted) {
        _showError(next.messageKey);
        ref.read(authProvider.notifier).clearError();
      }
    });

    return Scaffold(
      backgroundColor: CosmicColors.background,
      appBar: const CosmicTopBar(showBackButton: true),
      body: ResponsivePage(
        maxWidth: 480,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.authSignUpTitle,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: CosmicColors.primaryContainer,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.authSignUpSubtitle,
                style: TextStyle(
                  color: CosmicColors.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 28),
              GlassPanel(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Email
                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      style: const TextStyle(color: CosmicColors.onSurface),
                      decoration: _inputDecoration(
                        label: l10n.authEmailLabel,
                        hint: l10n.authEmailHint,
                        icon: Icons.email_outlined,
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return l10n.authErrorEmptyFields;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Fjalëkalimi
                    TextFormField(
                      controller: _passwordCtrl,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.next,
                      style: const TextStyle(color: CosmicColors.onSurface),
                      decoration: _inputDecoration(
                        label: l10n.authPasswordLabel,
                        hint: l10n.authPasswordHint,
                        icon: Icons.lock_outline,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: CosmicColors.onSurfaceVariant,
                            size: 20,
                          ),
                          onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return l10n.authErrorEmptyFields;
                        }
                        if (v.length < 8 ||
                            !v.contains(RegExp(r'\d'))) {
                          return l10n.authWeakPasswordHint;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Konfirmo fjalëkalimin
                    TextFormField(
                      controller: _confirmCtrl,
                      obscureText: _obscureConfirm,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _onSignUp(),
                      style: const TextStyle(color: CosmicColors.onSurface),
                      decoration: _inputDecoration(
                        label: l10n.authConfirmPasswordLabel,
                        hint: l10n.authConfirmPasswordHint,
                        icon: Icons.lock_outline,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: CosmicColors.onSurfaceVariant,
                            size: 20,
                          ),
                          onPressed: () => setState(
                              () => _obscureConfirm = !_obscureConfirm),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return l10n.authErrorEmptyFields;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Shënim privatësia
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  l10n.authPrivacyNote,
                  style: TextStyle(
                    color: CosmicColors.onSurfaceVariant,
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              CosmicButton(
                label: isLoading ? l10n.authSigningUp : l10n.authSignUpButton,
                icon: isLoading ? null : Icons.person_add_outlined,
                onPressed: isLoading ? null : _onSignUp,
              ),
              const SizedBox(height: 16),
              // Lidhja me sign-in
              TextButton(
                onPressed: isLoading
                    ? null
                    : () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute<void>(
                            builder: (_) => const ParentSignInScreen(),
                          ),
                        ),
                child: Text(
                  l10n.authHaveAccount,
                  style: TextStyle(color: CosmicColors.primaryContainer),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: CosmicColors.onSurfaceVariant, size: 20),
      suffixIcon: suffixIcon,
      labelStyle: const TextStyle(color: CosmicColors.onSurfaceVariant),
      hintStyle: const TextStyle(
          color: CosmicColors.onSurfaceVariant, fontSize: 13),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: CosmicColors.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            const BorderSide(color: CosmicColors.primaryContainer, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: CosmicColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: CosmicColors.error, width: 2),
      ),
      filled: true,
      fillColor: CosmicColors.surface.withValues(alpha: 0.5),
    );
  }
}
