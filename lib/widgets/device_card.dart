import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:torch_light/torch_light.dart';

class DeviceCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const DeviceCard({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {},
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}

class ToggleDeviceCard extends StatefulWidget {
  final String title;
  final IconData icon;

  const ToggleDeviceCard({super.key, required this.title, required this.icon});

  @override
  State<ToggleDeviceCard> createState() => _ToggleDeviceCardState();
}

class _ToggleDeviceCardState extends State<ToggleDeviceCard> {
  bool isOn = false;

  void togglePower() async {
    try {
      setState(() {
        isOn = !isOn;
      });

      if (isOn) {
        await TorchLight.enableTorch();
      } else {
        await TorchLight.disableTorch();
      }
    } on PlatformException catch (e) {
      // Handle errors, maybe show a message
      print('Torch error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isOn ? Colors.yellow[100] : null,
      child: InkWell(
        onTap: togglePower,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                size: 48,
                color: isOn ? Colors.yellow[800] : null,
              ),
              const SizedBox(height: 8),
              Text(widget.title, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text(
                isOn ? 'On' : 'Off',
                style: TextStyle(
                  color: isOn ? Colors.yellow[800] : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
