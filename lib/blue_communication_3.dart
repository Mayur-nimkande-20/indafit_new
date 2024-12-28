import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'blue_services_3.dart';

class BleConnectPage extends StatefulWidget {
  const BleConnectPage({Key? key}) : super(key: key);

  @override
  State<BleConnectPage> createState() => _BleConnectPageState();
}

class _BleConnectPageState extends State<BleConnectPage> {
  final BleService _bleService = BleService();
  List<ScanResult> _scanResults = [];
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  // Start BLE Scan
  void _startScan() async {
    setState(() {
      _isScanning = true;
      _scanResults = [];
    });

    FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

    FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        _scanResults = results;
      });
    });

    FlutterBluePlus.isScanning.listen((isScanning) {
      setState(() {
        _isScanning = isScanning;
      });
    });
  }

  // Stop BLE Scan
  void _stopScan() {
    FlutterBluePlus.stopScan();
    setState(() {
      _isScanning = false;
    });
  }

  // Connect to Selected Device
  void _connectToDevice(BluetoothDevice device) async {
    _stopScan();
    await _bleService.connectAndUpdateStream(device);
    await _bleService.discoverAndSubscribe();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Connected to ${device.localName}')),
    );
  }

  // Disconnect from Device
  void _disconnect() async {
    await _bleService.disconnectAndUpdateStream();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Device disconnected.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLE Connect'),
        actions: [
          _isScanning
              ? IconButton(
            icon: const Icon(Icons.stop),
            onPressed: _stopScan,
          )
              : IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _startScan,
          ),
        ],
      ),
      body: _scanResults.isEmpty
          ? const Center(child: Text("No devices found."))
          : ListView.builder(
        itemCount: _scanResults.length,
        itemBuilder: (context, index) {
          final device = _scanResults[index].device;
          return ListTile(
            title: Text(device.localName.isNotEmpty
                ? device.localName
                : 'Unnamed Device'),
            subtitle: Text(device.remoteId.toString()),
            trailing: ElevatedButton(
              onPressed: () => _connectToDevice(device),
              child: const Text('Connect'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _disconnect,
        label: const Text('Disconnect'),
        icon: const Icon(Icons.bluetooth_disabled),
      ),
    );
  }
}
