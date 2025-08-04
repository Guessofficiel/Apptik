import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:apptik1/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _authService = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String selectedRole = 'Apprenant';
  bool isLoading = false;
  String? errorMessage;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final user = await _authService.signUp(
        nameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
        phoneController.text.trim(),
        selectedRole,
      );

      // ...dans _register()
if (user != null && mounted) {
  if (selectedRole == 'Apprenant') {
    print('Redirection vers /apprenant');
    context.go('/apprenant');
  } else if (selectedRole == 'Formateur') {
    print('Redirection vers /formateur');
    context.go('/formateur');
  } else if (selectedRole == 'Administrateur') {
    print('Redirection vers /admin');
    context.go('/admin');
  }
}
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color kButtonColor = Colors.black;

    return Scaffold(
      appBar: AppBar(title: const Text('Inscription')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Nom complet"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Champ requis" : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Champ requis" : null,
              ),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Mot de passe"),
                validator: (value) => value == null || value.length < 6
                    ? "6 caractères minimum"
                    : null,
              ),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Téléphone"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Champ requis" : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedRole,
                items: ['Apprenant', 'Formateur', 'Administrateur']
                    .map(
                      (role) => DropdownMenuItem(
                        value: role,
                        child: Text(role),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedRole = value!;
                  });
                },
                decoration: const InputDecoration(labelText: "Rôle"),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: kButtonColor),
                onPressed: isLoading ? null : _register,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "S'inscrire",
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}