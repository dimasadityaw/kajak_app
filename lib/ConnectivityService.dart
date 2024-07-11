import 'dart:async';
import 'package:flutter/services.dart';

import 'database_helper/send_answer.dart';

class ConnectivityService {
  static const MethodChannel _channel = MethodChannel('com.kajak.app/connectivity');

  static Future<bool> checkConnectivity() async {
    final bool isConnected = await _channel.invokeMethod('checkConnectivity');
    return isConnected;
  }

  static StreamController<bool> _connectivityStreamController = StreamController<bool>.broadcast();

  static Stream<bool> get connectivityStream => _connectivityStreamController.stream;

  static void startMonitoring() {
    Timer.periodic(Duration(seconds: 1), (timer) async {
      bool isConnected = await checkConnectivity();
      if (isConnected) {
        SendAnswer().checkSendAnswer();
      }
      _connectivityStreamController.add(isConnected);
    });
  }
}