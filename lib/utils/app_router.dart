import 'package:apptik1/screens/admin/gerer_utilisateur.dart';
import 'package:apptik1/screens/admin/rapport.dart';
import 'package:apptik1/screens/admin/statistique.dart';
import 'package:apptik1/screens/apprenant/apprenant_page.dart';
import 'package:apptik1/screens/formateur/formateur_page.dart'; // <-- à ajouter
import 'package:apptik1/screens/welcomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:apptik1/screens/auth/login.dart';
import 'package:apptik1/screens/auth/inscription.dart';
import 'package:apptik1/screens/admin/admin_page.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => AccueilAdministrateurPage(),
    ),
    GoRoute(
      path: '/apprenant',
      builder: (context, state) => const AccueilPage(),
    ),
    GoRoute(
      path: '/formateur',
      builder: (context, state) => const AccueilFormateurPage(),
    ),
    GoRoute(
      path: '/admin/users',
      builder: (context, state) => GererUtilisateursPage(),
    ),
    GoRoute(
      path: '/admin/stats',
      builder: (context, state) => StatistiquesPage(),
    ),
    GoRoute(
      path: '/admin/reports',
      builder: (context, state) => GenererRapportPage(),
    ),
  ],
);