import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetworkService {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  // Check if device is connected to the internet
  Future<bool> isConnected() async {
    final result = await _connectivity.checkConnectivity();
    return result.isNotEmpty && !result.contains(ConnectivityResult.none);
  }

  // Monitor connectivity changes and show a SnackBar when connection is lost
  void monitorConnectivity(BuildContext context, VoidCallback onConnectionLost) {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((result) {
      if (result.isEmpty || result.contains(ConnectivityResult.none)) {
        onConnectionLost();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No internet connection'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    });
  }

  // Dispose of the subscription
  void dispose() {
    _connectivitySubscription?.cancel();
  }
}