import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../home/presentation/main_shell.dart';
import 'login_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final SupabaseClient _supabase = Supabase.instance.client;

  StreamSubscription<AuthState>? _authSubscription;

  Session? _session;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();

    // Récupère immédiatement la session déjà enregistrée localement.
    _session = _supabase.auth.currentSession;
    _initialized = true;

    // Écoute les changements de session.
    _authSubscription = _supabase.auth.onAuthStateChange.listen(
      (authState) {
        if (!mounted) return;

        setState(() {
          _session = authState.session;
        });
      },
      onError: (error, stackTrace) {
        debugPrint('Erreur Auth hors ligne : $error');

        // Très important :
        // on ne remplace pas _session en cas d'erreur réseau.
        // L'application peut donc continuer avec la session locale.
      },
    );
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Session locale disponible.
    if (_session != null) {
      return const MainShell();
    }

    // Aucune session.
    return const LoginScreen();
  }
}