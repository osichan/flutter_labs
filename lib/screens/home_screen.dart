import 'package:flutter/material.dart';
import '../services/mqtt_service.dart';
import '../services/network_service.dart';
import '../widgets/device_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _mqttService = MqttService();
  final _networkService = NetworkService();
  String _temperature = 'Waiting for data...';
  bool _isConnectedToInternet = true;

  @override
  void initState() {
    super.initState();
    _initConnectivity();
    _initMqtt();
  }

  Future<void> _initConnectivity() async {
    _isConnectedToInternet = await _networkService.isConnected();
    if (!_isConnectedToInternet && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No internet connection. Limited functionality.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
    _networkService.monitorConnectivity(context, () {
      setState(() => _isConnectedToInternet = false);
    });
  }

  Future<void> _initMqtt() async {
    if (await _networkService.isConnected()) {
      await _mqttService.connect();
      _mqttService.temperatureStream.listen((temp) {
        if (mounted) {
          setState(() => _temperature = '$temp °C');
        }
      });
    }
  }

  @override
  void dispose() {
    _mqttService.disconnect();
    _networkService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Devices'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('Temperature Sensor', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(_temperature, style: const TextStyle(fontSize: 24)),
                    if (!_isConnectedToInternet || !_mqttService.isConnected)
                      const Text('Offline or MQTT disconnected', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16),
              children: const [
                ToggleDeviceCard(title: 'Light', icon: Icons.lightbulb),
                DeviceCard(title: 'Thermostat', icon: Icons.thermostat),
                DeviceCard(title: 'Camera', icon: Icons.videocam),
                DeviceCard(title: 'Door Lock', icon: Icons.lock),
              ],
            ),
          ),
        ],
      ),
    );
  }
}