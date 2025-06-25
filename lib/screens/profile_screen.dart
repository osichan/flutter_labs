import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/shared_preferences_storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthService(SharedPreferencesStorage());
  Map<String, dynamic>? _userData;
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final email = await _authService.getCurrentUserEmail();
    if (email != null) {
      final user = await _authService.getUser(email);
      if (user != null && mounted) {
        setState(() {
          _userData = user;
          _nameController.text = user['name'] ?? '';
        });
      }
    }
  }

  Future<void> _updateUser() async {
    if (_userData != null) {
      final updatedData = {..._userData!, 'name': _nameController.text.trim()};
      await _authService.updateUser(_userData!['email'], updatedData);
      if (mounted) setState(() => _userData = updatedData);
    }
  }

  Future<void> _deleteUser() async {
    if (_userData != null) {
      await _authService.deleteUser(_userData!['email']);
      if (context.mounted) Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> _logout() async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      await _authService.logout();
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: _userData == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    child: Icon(Icons.person, size: 40),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Email: ${_userData!['email']}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _updateUser,
                    child: const Text('Update Name'),
                  ),
                  TextButton(
                    onPressed: _logout,
                    child: const Text("Logout"),
                  ),
                ],
              ),
      ),
    );
  }
}