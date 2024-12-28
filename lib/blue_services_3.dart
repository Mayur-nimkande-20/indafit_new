import 'dart:async';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleService {
  FlutterBluePlus flutterBlue = FlutterBluePlus();
  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? activeCharacteristic;

  StreamSubscription<BluetoothConnectionState>? _connectionStream;
  Timer? reconnectionTimer;
  bool isConnected = false;

  // Connect to a BLE device and listen to connection state updates
  Future<void> connectAndUpdateStream(BluetoothDevice device) async {
    try {
      print("Connecting to device: ${device.localName}");
      await device.connect(timeout: const Duration(seconds: 60));
      connectedDevice = device;
      isConnected = true;

      _connectionStream =
          device.connectionState.listen((BluetoothConnectionState state) {
            print("Connection state changed: $state");
            if (state == BluetoothConnectionState.disconnected) {
              isConnected = false;
              _attemptReconnect(device);
            } else if (state == BluetoothConnectionState.connected) {
              isConnected = true;
              reconnectionTimer?.cancel();
              print("Device connected successfully.");
            }
          });
    } catch (e) {
      print("Error during connection: $e");
    }
  }

  // Disconnect and clean up
  Future<void> disconnectAndUpdateStream() async {
    try {
      if (connectedDevice != null) {
        await connectedDevice!.disconnect();
        _connectionStream?.cancel();
        connectedDevice = null;
        isConnected = false;
        print("Device disconnected.");
      }
    } catch (e) {
      print("Error during disconnect: $e");
    }
  }

  // Attempt reconnection logic
  void _attemptReconnect(BluetoothDevice device) {
    int attempts = 0;
    const maxAttempts = 5;

    reconnectionTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (attempts < maxAttempts) {
        print("Reconnection attempt ${attempts + 1}...");
        try {
          await device.connect(timeout: const Duration(seconds: 30));
          connectedDevice = device;
          isConnected = true;
          timer.cancel();
          print("Reconnected successfully.");
        } catch (e) {
          print("Reconnection failed: $e");
          attempts++;
        }
      } else {
        timer.cancel();
        print("Max reconnection attempts reached.");
      }
    });
  }

  // Discover services and subscribe to a characteristic
  Future<void> discoverAndSubscribe() async {
    if (connectedDevice == null) {
      print("No device connected.");
      return;
    }

    try {
      final services = await connectedDevice!.discoverServices();
      if (services.isNotEmpty) {
        final service = services.last;
        if (service.characteristics.isNotEmpty) {
          final characteristic = service.characteristics.first;
          await characteristic.setNotifyValue(true);
          activeCharacteristic = characteristic;

          characteristic.onValueReceived.listen((value) {
            print("Received value: $value");
          });
        }
      } else {
        print("No services found.");
      }
    } catch (e) {
      print("Error discovering services: $e");
    }
  }

  // Send data to the BLE device
  Future<void> sendData(List<int> data) async {
    if (activeCharacteristic == null || !isConnected) {
      print("Cannot send data: No active connection or characteristic.");
      return;
    }
    try {
      await activeCharacteristic!.write(data, withoutResponse: true);
      print("Data sent: $data");
    } catch (e) {
      print("Error sending data: $e");
    }
  }
}
