import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/shared_preferences_storage.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _nameController = TextEditingController();
  String? _error;
  final _authService = AuthService(SharedPreferencesStorage());

  void _register() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirm = _confirmController.text.trim();
    final name = _nameController.text.trim();

    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(email)) {
      setState(() => _error = 'Please enter a valid email address');
      return;
    }
    if (password.length < 6) {
      setState(() => _error = 'Password must be at least 6 characters');
      return;
    }
    if (password != confirm) {
      setState(() => _error = 'Passwords do not match');
      return;
    }
    if (name.isEmpty) {
      setState(() => _error = 'Please enter your name');
      return;
    }

    final success = await _authService.register(email, password, name);
    if (success && context.mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() => _error = 'User already exists');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Register", style: TextStyle(fontSize: 32)),
            const SizedBox(height: 24),
            CustomTextField(controller: _emailController, label: 'Email'),
            CustomTextField(controller: _nameController, label: 'Name'),
            CustomTextField(
              controller: _passwordController,
              label: 'Password',
              obscure: true,
            ),
            CustomTextField(
              controller: _confirmController,
              label: 'Confirm Password',
              obscure: true,
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 16),
            PrimaryButton(text: "Sign Up", onPressed: _register),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Already have an account? Login"),
            ),
          ],
        ),
      ),
    );
  }
}
