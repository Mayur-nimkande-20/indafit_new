import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';


class Blecommunication extends StatefulWidget {
  const Blecommunication({super.key});

  @override
  State<Blecommunication> createState() => _BlecommunicationState();
}

class _BlecommunicationState extends State<Blecommunication> {
  List<ScanResult> _scanResults = [];
  bool _isScanning = false;


  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;

  @override
  void initState() {
    super.initState();

    // Listen for scan results
    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      _scanResults = results;
      if (mounted) {
        setState(() {});
      }
    }, onError: (e) {
      _showSnackBar("Scan Error: ${e.toString()}", isError: true);
    });

    // Listen for scanning state
    _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
      _isScanning = state;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _scanResultsSubscription.cancel();
    _isScanningSubscription.cancel();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : Colors.green,
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _subscribeToCharacteristic(
      BluetoothCharacteristic characteristic) async {
    try {
      await characteristic.setNotifyValue(true);
      characteristic.value.listen((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Notification value: ${value.toString()}"),
            backgroundColor: Colors.blue,
          ),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error subscribing to characteristic: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> onScanPressed() async {
    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    } catch (e) {
      _showSnackBar("Start Scan Error: ${e.toString()}", isError: true);
    }
  }

  Future<void> onStopPressed() async {
    try {
      FlutterBluePlus.stopScan();
    } catch (e) {
      _showSnackBar("Stop Scan Error: ${e.toString()}", isError: true);
    }
  }

  void onConnectPressed(BluetoothDevice device) async {
    try {
      await device.connect();
      _showSnackBar("Connected to ${device.name}", isError: false);
  
      // DeviceServices(device: device);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DeviceServices(device: device),
        ),
      );
    } catch (e) {
      _showSnackBar("Connect Error: ${e.toString()}", isError: true);
    }
  }

  Widget buildScanButton() {
    if (_isScanning) {
      return FloatingActionButton(
        child: const Icon(Icons.stop),
        onPressed: onStopPressed,
        backgroundColor: Colors.red,
      );
    } else {
      return FloatingActionButton(
        child: const Text("SCAN"),
        onPressed: onScanPressed,
      );
    }
  }

  Widget buildDeviceList() {
    if (_scanResults.isEmpty) {
      return const Center(
        child: Text(
          "No devices found. Start scanning to discover nearby devices.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: _scanResults.length,
      itemBuilder: (context, index) {
        final result = _scanResults[index];
        return ListTile(
          title: Text(result.device.name.isNotEmpty
              ? result.device.name
              : "Unknown Device"),
          subtitle: Text(result.device.id.toString()),
          trailing: ElevatedButton(
            onPressed: () => onConnectPressed(result.device),
            child: const Text("Connect"),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          title: const Text("Nearby Devices"),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            if (!_isScanning) {
              onScanPressed();
            }
            return Future.delayed(const Duration(milliseconds: 500));
          },
          child: buildDeviceList(),
        ),
        floatingActionButton: buildScanButton(),
      );
  }
}


class DeviceServices extends StatefulWidget {
  final BluetoothDevice device;

  const DeviceServices({Key? key, required this.device}) : super(key: key);

  @override
  State<DeviceServices> createState() => _DeviceServicesState();
}

class _DeviceServicesState extends State<DeviceServices>{

  List<BluetoothService>  _services =[];
  BluetoothService? _usefulService;
  bool _serviceactive = false;
  List<BluetoothCharacteristic> _characteristics=[];
  BluetoothCharacteristic? _usefulCharacteristic;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _discoverServices();
  }




  Future<void> _discoverServices() async {
    try {
      List<BluetoothService> services = await widget.device.discoverServices();
      setState(() {
        _services = services;
        _usefulService = services[services.length - 1];
        _characteristics = _usefulService!.characteristics;
        _usefulCharacteristic = _characteristics[0] ;
        _usefulCharacteristic?.setNotifyValue(true);
        print("Value of notify"+(_usefulCharacteristic?.value).toString());
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error discovering services: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(child: Text("Device : "+widget.device.name));
  }
}