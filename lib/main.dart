import 'package:apptik1/inscription.dart';
import 'package:apptik1/login.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart'; // Ce fichier est généré par la commande `flutterfire configure`
import 'package:firebase_core/firebase_core.dart';
// ...existing code...

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ApptikApp());
}



class ApptikApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'APPTIK',
      home: WelcomeScreen(),
    );
  }
}

const Color kPrimaryColor = Color(0xFF355E4B);
const Color kTextFieldColor = Color(0xFF4F7F68);
const Color kButtonColor = Colors.black;

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Bienvenue", style: TextStyle(fontSize: 40, fontStyle: FontStyle.italic, color: Colors.white)),
            Text("sur", style: TextStyle(fontSize: 30, fontStyle: FontStyle.italic, color: Colors.white)),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: 'APP', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
                  TextSpan(text: 'TIK', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black)),
                ],
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  child: Text("S'inscrire"),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kButtonColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text("Se connecter"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}