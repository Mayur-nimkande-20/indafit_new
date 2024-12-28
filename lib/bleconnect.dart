// import 'dart:async';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
//
//
// class Bleconnect extends StatefulWidget {
//   const Bleconnect({super.key});
//
//   @override
//   State<Bleconnect> createState() => _BleconnectState();
// }
//
// class _BleconnectState extends State<Bleconnect> {
//
//   BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
//
//   late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;
//
//   @override
//   void initState() {
//     super.initState();
//     _adapterStateStateSubscription = FlutterBluePlus.adapterState.listen((state) {
//       _adapterState = state;
//       if (mounted) {
//         setState(() {});
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _adapterStateStateSubscription.cancel();
//     super.dispose();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     Widget screen = _adapterState == BluetoothAdapterState.on
//         // ? NearbyDevicesDialog()
//         ?ScanScreen()
//         : BluetoothOffDialog();
//
//     return MaterialApp(
//       color: Colors.lightBlue,
//       home: screen,
//       navigatorObservers: [BluetoothAdapterStateObserver()],
//     );
//   }
// }
//
// class ScanScreen extends StatefulWidget {
//   const ScanScreen({super.key});
//
//   @override
//   State<ScanScreen> createState() => _ScanScreenState();
// }
//
// class _ScanScreenState extends State<ScanScreen> {
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(child: Text("hi scanner")),
//     );
//   }
// }
//
// class BluetoothOffDialog extends StatefulWidget {
//   const BluetoothOffDialog({super.key});
//
//   @override
//   State<BluetoothOffDialog> createState() => _BluetoothOffDialogState();
// }
//
// class _BluetoothOffDialogState extends State<BluetoothOffDialog> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
//
//
//
//
//
//
//
//
//
// class BluetoothAdapterStateObserver extends NavigatorObserver {
//   StreamSubscription<BluetoothAdapterState>? _adapterStateSubscription;
//
//   @override
//   void didPush(Route route, Route? previousRoute) {
//     super.didPush(route, previousRoute);
//     if (route.settings.name == '/DeviceScreen') {
//       // Start listening to Bluetooth state changes when a new route is pushed
//       _adapterStateSubscription ??= FlutterBluePlus.adapterState.listen((state) {
//         if (state != BluetoothAdapterState.on) {
//           // Pop the current route if Bluetooth is off
//           navigator?.pop();
//         }
//       });
//     }
//   }
//
//   @override
//   void didPop(Route route, Route? previousRoute) {
//     super.didPop(route, previousRoute);
//     // Cancel the subscription when the route is popped
//     _adapterStateSubscription?.cancel();
//     _adapterStateSubscription = null;
//   }
// }


// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
//
// void main() {
//   FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);
//   runApp(const Bleconnect());
// }
//
// class Bleconnect extends StatefulWidget {
//   const Bleconnect({Key? key}) : super(key: key);
//
//   @override
//   State<Bleconnect> createState() => _BleconnectState();
// }
//
// class _BleconnectState extends State<Bleconnect> {
//   BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
//   late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;
//
//   @override
//   void initState() {
//     super.initState();
//     // Listen for changes in Bluetooth adapter state
//     _adapterStateStateSubscription = FlutterBluePlus.adapterState.listen((state) {
//       _adapterState = state;
//       if (mounted) {
//         setState(() {});
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _adapterStateStateSubscription.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Determine the screen based on Bluetooth adapter state
//     Widget screen = _adapterState == BluetoothAdapterState.on
//         ? const ScanScreen()
//         : BluetoothOffDialog(adapterState: _adapterState);
//
//     return MaterialApp(
//       color: Colors.lightBlue,
//       home: screen,
//       navigatorObservers: [BluetoothAdapterStateObserver()],
//     );
//   }
// }
//
// class ScanScreen extends StatelessWidget {
//   const ScanScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Scan Devices"),
//         backgroundColor: Colors.blue,
//       ),
//       body: const Center(
//         child: Text(
//           "Scanning for devices...",
//           style: TextStyle(fontSize: 18),
//         ),
//       ),
//     );
//   }
// }
//
// class BluetoothOffDialog extends StatelessWidget {
//   final BluetoothAdapterState adapterState;
//
//   const BluetoothOffDialog({Key? key, required this.adapterState}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Bluetooth Off"),
//         backgroundColor: Colors.red,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.bluetooth_disabled, size: 80, color: Colors.red),
//             const SizedBox(height: 20),
//             Text(
//               "Bluetooth is ${adapterState.toString().split('.').last}.",
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Open system Bluetooth settings
//                 // FlutterBluePlus.openBluetoothSettings();
//                 print("Error in settings");
//               },
//               child: const Text("Open Bluetooth Settings"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// class BluetoothAdapterStateObserver extends NavigatorObserver {
//   StreamSubscription<BluetoothAdapterState>? _adapterStateSubscription;
//
//   @override
//   void didPush(Route route, Route? previousRoute) {
//     super.didPush(route, previousRoute);
//     if (route.settings.name == '/DeviceScreen') {
//       // Start listening to Bluetooth state changes when a new route is pushed
//       _adapterStateSubscription ??= FlutterBluePlus.adapterState.listen((state) {
//         if (state != BluetoothAdapterState.on) {
//           // Pop the current route if Bluetooth is off
//           navigator?.pop();
//         }
//       });
//     }
//   }
//
//   @override
//   void didPop(Route route, Route? previousRoute) {
//     super.didPop(route, previousRoute);
//     // Cancel the subscription when the route is popped
//     _adapterStateSubscription?.cancel();
//     _adapterStateSubscription = null;
//   }
// }

// V33
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'device_screen.dart'; // Replace with your actual implementation if needed
//
// class BleConnect extends StatefulWidget {
//   const BleConnect({super.key});
//
//   @override
//   State<BleConnect> createState() => _BleConnectState();
// }
//
// class _BleConnectState extends State<BleConnect> {
//   List<ScanResult> _scanResults = [];
//   bool _isScanning = false;
//
//   late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
//   late StreamSubscription<bool> _isScanningSubscription;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Listen for scan results
//     _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
//       _scanResults = results;
//       if (mounted) {
//         setState(() {});
//       }
//     }, onError: (e) {
//       _showSnackBar("Scan Error: ${e.toString()}", isError: true);
//     });
//
//     // Listen for scanning state
//     _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
//       _isScanning = state;
//       if (mounted) {
//         setState(() {});
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _scanResultsSubscription.cancel();
//     _isScanningSubscription.cancel();
//     super.dispose();
//   }
//
//   void _showSnackBar(String message, {bool isError = false}) {
//     final snackBar = SnackBar(
//       content: Text(message),
//       backgroundColor: isError ? Colors.red : Colors.green,
//       duration: const Duration(seconds: 3),
//     );
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }
//
//   Future<void> onScanPressed() async {
//     try {
//       await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
//     } catch (e) {
//       _showSnackBar("Start Scan Error: ${e.toString()}", isError: true);
//     }
//   }
//
//   Future<void> onStopPressed() async {
//     try {
//       FlutterBluePlus.stopScan();
//     } catch (e) {
//       _showSnackBar("Stop Scan Error: ${e.toString()}", isError: true);
//     }
//   }
//
//   void onConnectPressed(BluetoothDevice device) async {
//     try {
//       await device.connect();
//       _showSnackBar("Connected to ${device.name}", isError: false);
//
//       Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (context) => DeviceScreen(device: device),
//         ),
//       );
//     } catch (e) {
//       _showSnackBar("Connect Error: ${e.toString()}", isError: true);
//     }
//   }
//
//   Widget buildScanButton() {
//     if (_isScanning) {
//       return FloatingActionButton(
//         child: const Icon(Icons.stop),
//         onPressed: onStopPressed,
//         backgroundColor: Colors.red,
//       );
//     } else {
//       return FloatingActionButton(
//         child: const Text("SCAN"),
//         onPressed: onScanPressed,
//       );
//     }
//   }
//
//   Widget buildDeviceList() {
//     if (_scanResults.isEmpty) {
//       return const Center(
//         child: Text(
//           "No devices found. Start scanning to discover nearby devices.",
//           style: TextStyle(fontSize: 16, color: Colors.grey),
//         ),
//       );
//     }
//
//     return ListView.builder(
//       itemCount: _scanResults.length,
//       itemBuilder: (context, index) {
//         final result = _scanResults[index];
//         return ListTile(
//           title: Text(result.device.name.isNotEmpty
//               ? result.device.name
//               : "Unknown Device"),
//           subtitle: Text(result.device.id.toString()),
//           trailing: ElevatedButton(
//             onPressed: () => onConnectPressed(result.device),
//             child: const Text("Connect"),
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Nearby Devices"),
//       ),
//       body: RefreshIndicator(
//         onRefresh: () async {
//           if (!_isScanning) {
//             onScanPressed();
//           }
//           return Future.delayed(const Duration(milliseconds: 500));
//         },
//         child: buildDeviceList(),
//       ),
//       floatingActionButton: buildScanButton(),
//     );
//   }
// }
//
//
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// // import 'device_screen.dart'; // For navigating to the DeviceScreen
// // import 'widgets/system_device_tile.dart'; // Custom widget for system devices
// // import 'widgets/scan_result_tile.dart'; // Custom widget for scan results
//
// class BleConnect extends StatefulWidget {
//   const BleConnect({super.key});
//
//   @override
//   State<BleConnect> createState() => _BleConnectState();
// }
//
// class _BleConnectState extends State<BleConnect> {
//   BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
//   List<BluetoothDevice> _systemDevices = [];
//   List<ScanResult> _scanResults = [];
//   bool _isScanning = false;
//
//   late StreamSubscription<BluetoothAdapterState> _adapterStateSubscription;
//   late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
//   late StreamSubscription<bool> _isScanningSubscription;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Listen for adapter state changes
//     _adapterStateSubscription = FlutterBluePlus.adapterState.listen((state) {
//       _adapterState = state;
//       if (mounted) {
//         setState(() {});
//       }
//     });
//
//     // Listen for scan results
//     _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
//       _scanResults = results;
//       if (mounted) {
//         setState(() {});
//       }
//     }, onError: (e) {
//       _showSnackBar("Scan Error: ${e.toString()}", isError: true);
//     });
//
//     // Listen for scanning state
//     _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
//       _isScanning = state;
//       if (mounted) {
//         setState(() {});
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _adapterStateSubscription.cancel();
//     _scanResultsSubscription.cancel();
//     _isScanningSubscription.cancel();
//     super.dispose();
//   }
//
//   void _showSnackBar(String message, {bool isError = false}) {
//     final snackBar = SnackBar(
//       content: Text(message),
//       backgroundColor: isError ? Colors.red : Colors.green,
//       duration: const Duration(seconds: 3),
//     );
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }
//
//   Future<void> onScanPressed() async {
//     try {
//       // `withServices` is required on iOS for privacy purposes, ignored on Android.
//       var withServices = [Guid("180f")]; // Battery Level Service
//       _systemDevices = await FlutterBluePlus.systemDevices(withServices);
//     } catch (e) {
//       _showSnackBar("System Devices Error: ${e.toString()}", isError: true);
//     }
//
//     try {
//       await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
//     } catch (e) {
//       _showSnackBar("Start Scan Error: ${e.toString()}", isError: true);
//     }
//
//     if (mounted) {
//       setState(() {});
//     }
//   }
//
//   Future<void> onStopPressed() async {
//     try {
//       FlutterBluePlus.stopScan();
//     } catch (e) {
//       _showSnackBar("Stop Scan Error: ${e.toString()}", isError: true);
//     }
//   }
//
//   void onConnectPressed(BluetoothDevice device) {
//     device.connectAndUpdateStream().catchError((e) {
//       _showSnackBar("Connect Error: ${e.toString()}", isError: true);
//     });
//
//     Navigator.of(context).push(MaterialPageRoute(
//       builder: (context) => DeviceScreen(device: device),
//       settings: const RouteSettings(name: '/DeviceScreen'),
//     ));
//   }
//
//   Future<void> onRefresh() async {
//     if (!_isScanning) {
//       FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
//     }
//
//     if (mounted) {
//       setState(() {});
//     }
//
//     return Future.delayed(const Duration(milliseconds: 500));
//   }
//
//   Widget buildScanButton() {
//     if (_isScanning) {
//       return FloatingActionButton(
//         child: const Icon(Icons.stop),
//         onPressed: onStopPressed,
//         backgroundColor: Colors.red,
//       );
//     } else {
//       return FloatingActionButton(
//         child: const Text("SCAN"),
//         onPressed: onScanPressed,
//       );
//     }
//   }
//
//   List<Widget> _buildSystemDeviceTiles() {
//     return _systemDevices
//         .map((device) => SystemDeviceTile(
//       device: device,
//       onOpen: () => Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (context) => DeviceScreen(device: device),
//           settings: const RouteSettings(name: '/DeviceScreen'),
//         ),
//       ),
//       onConnect: () => onConnectPressed(device),
//     ))
//         .toList();
//   }
//
//   List<Widget> _buildScanResultTiles() {
//     return _scanResults
//         .map((result) => ScanResultTile(
//       result: result,
//       onTap: () => onConnectPressed(result.device),
//     ))
//         .toList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Widget screen;
//
//     if (_adapterState == BluetoothAdapterState.on) {
//       // Bluetooth is ON: Show scanning UI
//       screen = Scaffold(
//         appBar: AppBar(
//           title: const Text("Find Devices"),
//         ),
//         body: RefreshIndicator(
//           onRefresh: onRefresh,
//           child: ListView(
//             children: [
//               ..._buildSystemDeviceTiles(),
//               ..._buildScanResultTiles(),
//             ],
//           ),
//         ),
//         floatingActionButton: buildScanButton(),
//       );
//     } else {
//       // Bluetooth is OFF: Show prompt to enable Bluetooth
//       screen = Center(
//         child: Text(
//           "Bluetooth is turned off. Please enable Bluetooth to continue.",
//           style: TextStyle(color: Colors.grey, fontSize: 18),
//           textAlign: TextAlign.center,
//         ),
//       );
//     }
//
//     return MaterialApp(
//       home: Scaffold(
//         body: screen,
//       ),
//     );
//   }
// }


// WORKING V4

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'device_screen.dart'; // Replace with your actual implementation if needed

class BleConnect extends StatefulWidget {
  const BleConnect({super.key});

  @override
  State<BleConnect> createState() => _BleConnectState();
}

class _BleConnectState extends State<BleConnect> {
  List<ScanResult> _scanResults = [];
  bool _isScanning = false;

  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
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

  late StreamSubscription<bool> _isScanningSubscription;

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

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DeviceServicesScreen(device: device),
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


class DeviceScreen extends StatelessWidget {
  final BluetoothDevice device;

  const DeviceScreen({Key? key, required this.device}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(device.name.isNotEmpty ? device.name : "Unknown Device"),
      ),
      body: Center(
        child: Text(
          "Connected to ${device.name.isNotEmpty ? device.name : "Unknown Device"}",
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}


// checking for services
class DeviceServicesScreen extends StatefulWidget {
  final BluetoothDevice device;

  const DeviceServicesScreen({Key? key, required this.device}) : super(key: key);

  @override
  State<DeviceServicesScreen> createState() => _DeviceServicesScreenState();
}

class _DeviceServicesScreenState extends State<DeviceServicesScreen> {
  List<BluetoothService> _services = [];

  @override
  void initState() {
    super.initState();
    _discoverServices();
  }

  Future<void> _discoverServices() async {
    try {
      List<BluetoothService> services = await widget.device.discoverServices();
      setState(() {
        _services = services;
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

  Widget _buildServiceTile(BluetoothService service) {
    return ExpansionTile(
      title: Text('Service: ${service.uuid.toString()}'),
      children: service.characteristics.map((characteristic) {
        return ListTile(
          title: Text('Characteristic: ${characteristic.uuid}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Properties: ${characteristic.properties.toString()}'),
              ElevatedButton(
                onPressed: () => _readCharacteristic(characteristic),
                child: const Text("Read"),
              ),
              ElevatedButton(
                onPressed: () => _writeCharacteristic(characteristic),
                child: const Text("Write"),
              ),
              ElevatedButton(
                onPressed: () => _subscribeToCharacteristic(characteristic),
                child: const Text("Notify"),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Future<void> _readCharacteristic(BluetoothCharacteristic characteristic) async {
    try {
      var value = await characteristic.read();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Read value: ${value.toString()}"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error reading characteristic: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _writeCharacteristic(BluetoothCharacteristic characteristic) async {
    try {
      await characteristic.write([0x12, 0x34]); // Example data
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Data written successfully"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error writing to characteristic: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _subscribeToCharacteristic(BluetoothCharacteristic characteristic) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.name.isNotEmpty ? widget.device.name : "Unknown Device"),
      ),
      body: _services.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        children: _services.map((service) => _buildServiceTile(service)).toList(),
      ),
    );
  }
}
