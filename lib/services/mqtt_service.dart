import 'dart:async';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  final MqttServerClient _client =
      MqttServerClient('broker.hivemq.com', 'flutter_client_${DateTime.now().millisecondsSinceEpoch}');
  final StreamController<String> _temperatureStreamController = StreamController<String>.broadcast();
  bool _isConnected = false;

  Stream<String> get temperatureStream => _temperatureStreamController.stream;

  Future<void> connect() async {
    _client.port = 1883;
    _client.logging(on: false);
    _client.keepAlivePeriod = 20;
    _client.onDisconnected = _onDisconnected;
    _client.onConnected = _onConnected;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier('flutter_client_${DateTime.now().millisecondsSinceEpoch}')
        .startClean()
        .withWillQos(MqttQos.atMostOnce);
    _client.connectionMessage = connMessage;

    try {
      await _client.connect();
    } catch (e) {
      print('MQTT Connection failed: $e');
      _client.disconnect();
    }

    if (_client.connectionStatus?.state == MqttConnectionState.connected) {
      _isConnected = true;
      _client.subscribe('sensor/temperature', MqttQos.atMostOnce);
      _client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
        final recMess = messages[0].payload as MqttPublishMessage;
        final payload = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        _temperatureStreamController.add(payload);
      });
    }
  }

  void _onConnected() {
    print('Connected to MQTT broker');
    _isConnected = true;
  }

  void _onDisconnected() {
    print('Disconnected from MQTT broker');
    _isConnected = false;
  }

  bool get isConnected => _isConnected;

  void disconnect() {
    _client.disconnect();
    _temperatureStreamController.close();
  }
}