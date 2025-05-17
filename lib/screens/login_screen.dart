import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/network_service.dart';
import '../services/shared_preferences_storage.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _error;
  final _authService = AuthService(SharedPreferencesStorage());
  final _networkService = NetworkService();

  Future<void> _login() async {
    final isConnected = await _networkService.isConnected();
    if (!isConnected) {
      setState(() => _error = 'No internet connection');
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final success = await _authService.login(email, password);
    if (success && context.mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() => _error = 'Invalid credentials');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
            const Text("Login", style: TextStyle(fontSize: 32)),
            const SizedBox(height: 24),
            CustomTextField(controller: _emailController, label: 'Email'),
            CustomTextField(controller: _passwordController, label: 'Password', obscure: true),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 16),
            PrimaryButton(text: "Login", onPressed: _login),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: const Text("Don't have an account? Register"),
            ),
          ],
        ),
      ),
    );
  }
}