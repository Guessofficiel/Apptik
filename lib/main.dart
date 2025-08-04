import 'package:apptik1/screens/welcomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:apptik1/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

// Import de tes écrans
import 'package:apptik1/screens/auth/inscription.dart';
import 'package:apptik1/screens/auth/login.dart';
import 'package:apptik1/screens/apprenant/apprenant_page.dart';
import 'package:apptik1/screens/formateur/profil_formateur_page.dart';
import 'package:apptik1/screens/admin/admin_page.dart';
// import 'package:apptik1/screens/auth/welcome.dart'; // ✅ Remplace ça si WelcomeScreen est ailleurs

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ApptikApp());
}

class ApptikApp extends StatelessWidget {
  const ApptikApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'APPTIK',
      routerConfig: _appRouter,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: kPrimaryColor,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: kPrimaryColor,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData(brightness: Brightness.dark).textTheme,
        ),
      ),
      themeMode: ThemeMode.system,
    );
  }
}

// Couleurs globales
const Color kPrimaryColor = Color(0xFF355E4B);
const Color kTextFieldColor = Color(0xFF4F7F68);
const Color kButtonColor = Colors.black;

// Router GoRouter
final GoRouter _appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // ✅ Route d’accueil
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
      path: '/apprenant',
      builder: (context, state) => const AccueilPage(),
    ),
    GoRoute(
      path: '/formateur',
      builder: (context, state) => const ProfilFormateurPage(),
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => AccueilAdministrateurPage(),
    ),
  ],
);
