import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/parent_account.dart';
import '../services/auth_service.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

/// Gjendjet e mundshme të autentifikimit prindëror.
sealed class AuthState {
  const AuthState();
}

class AuthStateInitial extends AuthState {
  const AuthStateInitial();
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateAuthenticated extends AuthState {
  const AuthStateAuthenticated(this.account);
  final ParentAccount account;
}

class AuthStateUnauthenticated extends AuthState {
  const AuthStateUnauthenticated();
}

class AuthStateError extends AuthState {
  const AuthStateError(this.messageKey);
  final String messageKey; // çelës ARB
}

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthStateInitial()) {
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    final account = await AuthService.getCurrentAccount();
    if (account != null && AuthService.isSignedIn) {
      state = AuthStateAuthenticated(account);
    } else {
      state = const AuthStateUnauthenticated();
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    state = const AuthStateLoading();
    final result = await AuthService.signUp(email: email, password: password);
    state = switch (result) {
      AuthSuccess(:final account) => AuthStateAuthenticated(account),
      AuthFailure(:final messageKey) => AuthStateError(messageKey),
    };
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AuthStateLoading();
    final result = await AuthService.signIn(email: email, password: password);
    state = switch (result) {
      AuthSuccess(:final account) => AuthStateAuthenticated(account),
      AuthFailure(:final messageKey) => AuthStateError(messageKey),
    };
  }

  Future<void> signOut() async {
    await AuthService.signOut();
    state = const AuthStateUnauthenticated();
  }

  Future<bool> deleteAccount() async {
    final success = await AuthService.deleteAccount();
    if (success) {
      state = const AuthStateUnauthenticated();
    }
    return success;
  }

  /// Rivendos gabimin (pas shfaqjes së mesazhit në UI).
  void clearError() {
    if (state is AuthStateError) {
      state = const AuthStateUnauthenticated();
    }
  }

  /// B-02: Rilexo llogarinë nga Hive (pas updateLastSyncAt) për të reflektuar
  /// lastSyncAt të ri në UI pa ndryshuar gjendjen e autentifikimit.
  Future<void> refreshAccount() async {
    final account = await AuthService.getCurrentAccount();
    if (account != null && state is AuthStateAuthenticated) {
      state = AuthStateAuthenticated(account);
    }
  }
}

// ---------------------------------------------------------------------------
// Providers
// ---------------------------------------------------------------------------

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

/// Provider helper — a është prindi i autentifikuar?
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider) is AuthStateAuthenticated;
});

/// Provider helper — kthe llogarinë aktuale ose null.
final currentParentProvider = Provider<ParentAccount?>((ref) {
  final s = ref.watch(authProvider);
  return s is AuthStateAuthenticated ? s.account : null;
});
