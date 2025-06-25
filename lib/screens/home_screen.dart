import 'package:flutter/material.dart';
import '../widgets/device_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Devices'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          )
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        children: const [
          ToggleDeviceCard(title: 'Light', icon: Icons.lightbulb),
          DeviceCard(title: 'Thermostat', icon: Icons.thermostat),
          DeviceCard(title: 'Camera', icon: Icons.videocam),
          DeviceCard(title: 'Door Lock', icon: Icons.lock),
        ],
      ),
    );
  }
}
