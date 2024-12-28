import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleConnect extends StatefulWidget {
  const BleConnect({super.key});

  @override
  State<BleConnect> createState() => _BleConnectState();
}

class _BleConnectState extends State<BleConnect> {

 final List<int> dataToSend = [01, 03, 32, 167, 00, 04];

  BluetoothCharacteristic? _activeCharacteristic;
  late StreamSubscription<List<int>> _lastValueSubscription;
  BluetoothDevice? _connectedDevice;
  List<int> _value = [];
  bool _isDeviceConnected = false;
  Timer? timer;

  List<ScanResult> _scanResults = [];
  bool _isScanning = false;

  int? decodedValue1;
  int? decodedValue2;

  late BluetoothCharacteristic usefFulChar;

  late StreamSubscription<BluetoothConnectionState> _connectionStream;

  @override
  void initState() {
    super.initState();
    FlutterBluePlus.scanResults.listen((results) {
      setState(() => _scanResults = results);
    });

    FlutterBluePlus.isScanning.listen((state) {
      setState(() => _isScanning = state);
    });
  }

  @override
  void dispose() {
    _lastValueSubscription.cancel();
    timer?.cancel();
    super.dispose();
  }

  Future<void> onScanPressed() async {
    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
    } catch (e) {
      print("Error starting scan: $e");
      _showSnackBar("Error starting scan", isError: true);
    }
  }

  Future<void> onStopPressed() async {
    try {
      await FlutterBluePlus.stopScan();
    } catch (e) {
      print("Error stopping scan: $e");
      _showSnackBar("Error stopping scan", isError: true);
    }
  }

 void attemptReconnect(BluetoothDevice device) {
   int attempts = 0;
   const maxAttempts = 3;

   Timer.periodic(Duration(seconds: 5), (timer) async{
     if (attempts < maxAttempts) {
       await device.connect().then((_) {
         print("Reconnected successfully");
         timer.cancel();
       }).catchError((error) {
         print("Reconnection attempt failed");
         attempts++;
       });
     } else {
       timer.cancel();
       print("Max reconnection attempts reached. Please check the device or environment.");
     }
   });
 }

  Future<void> onConnectPressed(BluetoothDevice device) async {
    try {
       // attemptReconnect(device) ;
      await device.connect(timeout: Duration(seconds: 60));
      _connectedDevice = device;
      _isDeviceConnected = true;
      _showSnackBar("Connected to ${device.name}");
      await _discoverAndSubscribe(device);
    } catch (e) {
      print("Error connecting to device: $e");
      _showSnackBar("Connection error", isError: true);
    }
  }


  // Future<void> _discoverAndSubscribe(BluetoothDevice device) async {
  //   try {
  //     final services = await device.discoverServices();
  //     if (services.isNotEmpty) {
  //       final service = services.first; // Select the first service
  //       if (service.characteristics.isNotEmpty) {
  //         final characteristic = service.characteristics.first; // Select the first characteristic
  //         await characteristic.setNotifyValue(true);
  //         _activeCharacteristic = characteristic;
  //
  //         _lastValueSubscription = characteristic.onValueReceived.listen((value) {
  //           _processReceivedValue(value);
  //         });
  //
  //         // Example: Send data with checksum
  //         // final List<int> dataToSend = [0x01, 0x02, 0x03]; // Example data
  //         sendData(dataToSend, characteristic);
  //       } else {
  //         _showSnackBar("No characteristics found", isError: true);
  //       }
  //     } else {
  //       _showSnackBar("No services found", isError: true);
  //     }
  //   } catch (e) {
  //     print("Error discovering services: $e");
  //     _showSnackBar("Error discovering services", isError: true);
  //   }
  // }

  Future<void> _discoverAndSubscribe(BluetoothDevice device) async {
    try {
      final services = await device.discoverServices().then((services) async{
        final service = services.last; // Select the first service
        if (service.characteristics.isNotEmpty) {
          final characteristic = service.characteristics
              .first; // Select the first characteristic
          await characteristic.setNotifyValue(true);
          _activeCharacteristic = characteristic;

          setState(() {
            usefFulChar=characteristic;
          });

          _lastValueSubscription =
              await usefFulChar.onValueReceived.listen((value) {
            _processReceivedValue(value); // Handle received data
            _showSnackBar("Value recived ${value}", isError : false);

            _showSnackBar("Value recived ${_value}", isError : false);
          },onError :(error){
            _showSnackBar("saying error:  ${error}", isError: true);
              },onDone: (){
                _showSnackBar("code completion", isError: true);
              }
              );

          // Start continuous data transmission
          // startContinuousTransmission(characteristic);
          // sendData(dataToSend, characteristic);
        } else {
          _showSnackBar("No characteristics found", isError: true);
        }

      }).onError((error,msg){

      });
      // if (services.isNotEmpty) {
      // } else {
      //   _showSnackBar("No services found", isError: true);
      // }
    } catch (e) {
      print("Error discovering services: $e");
      _showSnackBar("Error discovering services", isError: true);
    }
  }

  void startContinuousTransmission(BluetoothCharacteristic characteristic) {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // final List<int> dataToSend = [0x01, 0x02, 0x03]; // Example data
      sendData(dataToSend, characteristic);
    });
  }


  void sendData(List<int> byte, BluetoothCharacteristic characteristic) async {
    try {
      List<int> local = List.from(byte);
      final checksum = crc16umts(local);
      local.add(checksum ); // Add lower byte of checksum
      local.add((checksum >> 8)); // Add higher byte of checksum

      if(_isDeviceConnected){
        await characteristic.write(local, withoutResponse: true).onError((e,s){
          _showSnackBar(" Error in transmission ${e}",isError: true);
          // attemptReconnect(_connectedDevice!);

          // return;
        });
      }
      else {
        onConnectPressed(_connectedDevice!);
        // attemptReconnect(_connectedDevice!);
        // sendData(byte, usefFulChar);
      }// Send data



      print("Data Transmitted: $local");
      print("Checksum: $checksum");
    } catch (e) {
      print("Error sending data: $e");
      _showSnackBar("Error sending data", isError: true);
    }
  }

  int? get_recieved_value(){
    return decodedValue1;
  }

  int crc16umts(List<int> bytes) {
    int crc = 0xFFFF;
    const int polynomial = 0xA001;
    for (final byte in bytes) {
      crc ^= byte;
      for (int i = 0; i < 8; i++) {
        if ((crc & 0x0001) != 0) {
          crc = (crc >> 1) ^ polynomial;
        } else {
          crc >>= 1;
        }
      }
    }
    return crc & 0xFFFF;
  }

  void _processReceivedValue(List<int> value) {
    print("Value Received: $value");
    int temp1 = 0;
    int temp2 = 0;

    if (value.length > 10) {
      temp1 = value[3];
      temp1 = (temp1 << 8) + value[4];
      temp1 = (temp1 << 8) + value[5];
      temp1 = (temp1 << 8) + value[6];

      temp2 = value[7];
      temp2 = (temp2 << 8) + value[8];
      temp2 = (temp2 << 8) + value[9];
      temp2 = (temp2 << 8) + value[10];
    }

    int value1 = 0;
    int value2 = 0;

    if ((temp1 & 0x10000000) == 0x10000000) {
      value1 = -(temp1 ^ 0xFFFFFFFF) + 0x01;
    } else {
      value1 = temp1;
    }

    if ((temp2 & 0x10000000) == 0x10000000) {
      value2 = -(temp2 ^ 0xFFFFFFFF) + 0x01;
    } else {
      value2 = temp2;
    }

    print("Decoded Values:");
    print("Temp1: $temp1");
    print("Temp2: $temp2");
    print("Value1: $value1");
    print("Value2: $value2");

    // setState(() {
    //   _value = value; // Update state with raw data or decoded values as needed
    // });
    print("Decoded Values:");
    print("Temp1: $temp1");
    print("Temp2: $temp2");
    print("Value1: $value1");
    print("Value2: $value2");

    // Update state variables
    setState(() {
      _value = value;
      decodedValue1 = value1;
      decodedValue2 = value2;
    });
  }


  // void _processValue(List<int> value) {
  //   if (value.isNotEmpty) {
  //     print("Received value: $value");
  //     setState(() {
  //       _value = value;
  //     });
  //   }
  // }

  void _showSnackBar(String message, {bool isError = false}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget buildScanButton() {
    return FloatingActionButton(
      child: Icon(_isScanning ? Icons.stop : Icons.search),
      onPressed: _isScanning ? onStopPressed : onScanPressed,
    );
  }

  Widget buildDeviceList() {
    return ListView.builder(
      itemCount: _scanResults.length,
      itemBuilder: (context, index) {
        final result = _scanResults[index];
        return ListTile(
          title: Text(result.device.name.isNotEmpty
              ? result.device.name
              : "Unknown Device"),
          subtitle: Text(result.device.id.toString()),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [

              ElevatedButton(
                onPressed: () => onConnectPressed(result.device),
                child: const Text("Connect"),
              ),

              TextButton(onPressed: ()=>sendData(dataToSend,usefFulChar), child: Text("send"))
            ],
          ),
        );
      },
    );
  }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("BLE Devices")),
//       body: _scanResults.isEmpty
//           ? const Center(child: Text("No devices found"))
//           : buildDeviceList(),
//       floatingActionButton: buildScanButton(),
//     );
//   }
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("BLE Devices")),
      body: Column(
        children: [
          Expanded(
            child: _scanResults.isEmpty
                ? const Center(child: Text("No devices found"))
                : buildDeviceList(),
          ),
          if (_value.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Received Values: ${_value.join(', ')}",
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
      floatingActionButton: buildScanButton(),
    );
  }
}