import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../responsive.dart';
import '../../../shared/widgets/cosmic_button.dart';
import '../../../shared/widgets/cosmic_top_bar.dart';
import '../../../shared/widgets/glass_panel.dart';
import '../providers/auth_provider.dart';
import 'parent_signup_screen.dart';

/// Ekrani i hyrjes prindërore.
///
/// Aksesues vetëm nga SettingsScreen pas inicializimit të Firebase.
class ParentSignInScreen extends ConsumerStatefulWidget {
  const ParentSignInScreen({super.key});

  @override
  ConsumerState<ParentSignInScreen> createState() => _ParentSignInScreenState();
}

class _ParentSignInScreenState extends ConsumerState<ParentSignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSignIn() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref.read(authProvider.notifier).signIn(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
        );
  }

  Future<void> _onForgotPassword() async {
    final l10n = AppLocalizations.of(context);
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) {
      _showSnack(l10n.authResetEmailEnterFirst, isError: true);
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (!mounted) return;
      _showSnack(l10n.authResetEmailSent, isError: false);
    } catch (_) {
      _showSnack(l10n.authResetEmailError, isError: true);
    }
  }

  void _showSnack(String message, {required bool isError}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 80),
        backgroundColor:
            isError ? CosmicColors.error : CosmicColors.primaryContainer,
      ),
    );
  }

  String _localizeError(AppLocalizations l10n, String key) => switch (key) {
        'authErrorUserNotFound' => l10n.authErrorUserNotFound,
        'authErrorWrongPassword' => l10n.authErrorWrongPassword,
        'authErrorTooManyRequests' => l10n.authErrorTooManyRequests,
        'authErrorNetwork' => l10n.authErrorNetwork,
        'authErrorFirebaseNotReady' => l10n.authErrorFirebaseNotReady,
        'authErrorUserDisabled' => l10n.authErrorUserDisabled,
        'authErrorEmptyFields' => l10n.authErrorEmptyFields,
        _ => l10n.authErrorUnknown,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthStateLoading;

    ref.listen<AuthState>(authProvider, (_, next) {
      if (next is AuthStateAuthenticated && mounted) {
        Navigator.of(context).pop();
      } else if (next is AuthStateError && mounted) {
        _showSnack(_localizeError(l10n, next.messageKey), isError: true);
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
                l10n.authSignInTitle,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: CosmicColors.primaryContainer,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.authSignInSubtitle,
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
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? l10n.authErrorEmptyFields
                          : null,
                    ),
                    const SizedBox(height: 16),
                    // Fjalëkalimi
                    TextFormField(
                      controller: _passwordCtrl,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _onSignIn(),
                      style: const TextStyle(color: CosmicColors.onSurface),
                      decoration: _inputDecoration(
                        label: l10n.authPasswordLabel,
                        hint: '••••••••',
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
                      validator: (v) => (v == null || v.isEmpty)
                          ? l10n.authErrorEmptyFields
                          : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: isLoading ? null : _onForgotPassword,
                  child: Text(
                    l10n.authForgotPassword,
                    style: TextStyle(
                        color: CosmicColors.onSurfaceVariant, fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CosmicButton(
                label: isLoading ? l10n.authSigningIn : l10n.authSignInButton,
                icon: isLoading ? null : Icons.login_outlined,
                onPressed: isLoading ? null : _onSignIn,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: isLoading
                    ? null
                    : () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute<void>(
                            builder: (_) => const ParentSignUpScreen(),
                          ),
                        ),
                child: Text(
                  l10n.authNoAccount,
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

