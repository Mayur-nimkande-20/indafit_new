import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleConnect extends StatefulWidget {
  const BleConnect({super.key});

  @override
  State<BleConnect> createState() => _BleConnectState();
}

class _BleConnectState extends State<BleConnect> {
  int value1=0;
  int value2=0;
  Timer? timer;
  List<int> _value = [];
  // String inputts="";
  // var textedcontroller = new TextEditingController();
  // var statuss = new WidgetStatesController();
  late StreamSubscription<List<int>> _lastValueSubscription;


  BluetoothCharacteristic? _usefulchar;

  List<ScanResult> _scanResults = [];
  bool _isScanning = false;

  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;

  BluetoothDevice? _connectedDevice;
  bool _isDeviceConnected = false; // Global state for connection status

  List<int> bytes=[01,03,32,167,00,04];

  @override
  void initState() {
    super.initState();
    print("Initializing BLE Connect State...");
    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      print("Scan results received: ${results.length} devices found");
      _scanResults = results;
      if (mounted) {
        setState(() {});
      }
    }, onError: (e) {
      print("Error during scan: $e");
      _showSnackBar("Scan Error: ${e.toString()}", isError: true);
    });

    _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
      print("Scanning state updated: $state");
      _isScanning = state;
      if (mounted) {
        setState(() {});
      }
    });

    // _lastValueSubscription = _usefulchar!.onValueReceived.listen((value) {
    //   //_lastValueSubscription = widget.characteristic.lastValueStream.listen((value) {
    //   print("Value Received");
    //   print(value);
    //   int? temp1=0;
    //   int? temp2=0;
    //   if(value.length>10){
    //     temp1=value[3];
    //     temp1=(temp1!<<8);
    //     temp1=(temp1+value[4]) as int?;
    //     temp1=(temp1!<<8);
    //     temp1=(temp1+value[5]) as int?;
    //     temp1=(temp1!<<8);
    //     temp1=(temp1+value[6]) as int?;
    //
    //     temp2=value[7];
    //     temp2=(temp2!<<8);
    //     temp2=(temp2+(value[8])) as int?;
    //     temp2=temp2!<<8;
    //     temp2=(temp2+(value[9])) as int?;
    //     temp2=temp2!<<8;
    //     temp2=(temp2+(value[10])) as int?;
    //   }
    //   if((temp1! & 0x10000000)==268435456){
    //     value1=-(temp1^0xFFFFFFFF)+0x01;
    //   }
    //   else
    //   {
    //     value1=temp1;
    //   }
    //   if((temp2! & 0x10000000)==268435456){
    //     value2=-(temp2^0xFFFFFFFF)+0x01;
    //   }
    //   else
    //   {
    //     value2=temp2;
    //   }
    //
    //   _value = value;
    //   if (mounted) {
    //     setState(() {});
    //   }
    // });

  }

  @override
  void dispose() {
    print("Disposing BLE Connect State...");
    _scanResultsSubscription.cancel();
    _isScanningSubscription.cancel();
    _lastValueSubscription.cancel();
    timer!.cancel();
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
    print("Starting scan...");
    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    } catch (e) {
      print("Error starting scan: $e");
      _showSnackBar("Start Scan Error: ${e.toString()}", isError: true);
    }
  }

  Future<void> onStopPressed() async {
    print("Stopping scan...");
    try {
      await FlutterBluePlus.stopScan();
    } catch (e) {
      print("Error stopping scan: $e");
      _showSnackBar("Stop Scan Error: ${e.toString()}", isError: true);
    }
  }

  void onConnectPressed(BluetoothDevice device) async {
    print("Attempting to connect to device: ${device.name} (${device.id})");
    try {
      await device.connect();
      _connectedDevice = device;
      _isDeviceConnected = true;
      print("Connected to device: ${device.name}");

      _showSnackBar("Connected to ${device.name}", isError: false);

      // Automatically discover services and subscribe to the first characteristic
      await _discoverAndSubscribeToFirstCharacteristic(device);
    } catch (e) {
      print("Error connecting to device: $e");
      _showSnackBar("Connect Error: ${e.toString()}", isError: true);
    }
  }

  Future<void> _discoverAndSubscribeToFirstCharacteristic(BluetoothDevice device) async {
    print("Discovering services for device: ${device.name}");
    try {
      List<BluetoothService> services = await device.discoverServices();
      print("Discovered ${services.length} services");

      if (services.isNotEmpty) {
        BluetoothService service = services.last; // Select the last service
        print("Selected service: ${service.uuid}");

        if (service.characteristics.isNotEmpty) {
          // _showSnackBar("Char list :  ${service.characteristics.toString()}", isError: true );

          BluetoothCharacteristic characteristic = service.characteristics[0]; // Select the first characteristic
          print("Selected characteristic: ${characteristic.uuid}");

          await characteristic.setNotifyValue(true);
          print("Subscribed to characteristic: ${characteristic.uuid}");

          // characteristic.value.listen((value) {
          //   print("Notification received from ${characteristic.uuid}: $value");
          // });

          // setState(() {
          //   _usefulchar = characteristic;
          // });

          _lastValueSubscription = characteristic.onValueReceived.listen((value) {
            //_lastValueSubscription = widget.characteristic.lastValueStream.listen((value) {
            print("Value Received");
            print(value);
            int? temp1=0;
            int? temp2=0;
            if(value.length>10){
              temp1=value[3];
              temp1=(temp1!<<8);
              temp1=(temp1+value[4]) as int?;
              temp1=(temp1!<<8);
              temp1=(temp1+value[5]) as int?;
              temp1=(temp1!<<8);
              temp1=(temp1+value[6]) as int?;

              temp2=value[7];
              temp2=(temp2!<<8);
              temp2=(temp2+(value[8])) as int?;
              temp2=temp2!<<8;
              temp2=(temp2+(value[9])) as int?;
              temp2=temp2!<<8;
              temp2=(temp2+(value[10])) as int?;
            }
            if((temp1! & 0x10000000)==268435456){
              value1=-(temp1^0xFFFFFFFF)+0x01;
            }
            else
            {
              value1=temp1;
            }
            if((temp2! & 0x10000000)==268435456){
              value2=-(temp2^0xFFFFFFFF)+0x01;
            }
            else
            {
              value2=temp2;
            }

            _value = value;
            print(_value);
            if (mounted) {
              setState(() {});
            }
          });

          await sendData(bytes, characteristic);
        } else {
          print("No characteristics found in the service: ${service.uuid}");
          _showSnackBar("No characteristics found in the service", isError: true);
        }
      } else {
        print("No services found on the device: ${device.name}");
        _showSnackBar("No services found on the device", isError: true);
      }
    } catch (e) {
      print("Error during service discovery: $e");
      _showSnackBar("Error discovering services: ${e.toString()}", isError: true);
    }
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

        /*if ((crc & 0x8000) != 0) {
        crc = (crc << 1) ^ polynomial;
      } else {
        crc <<= 1;
      }*/
      }
    }
    return crc & 0xFFFF;
  }
  //
  // Future<void> read_value(List<int> b,BluetoothCharacteristic c)async {
  //             StreamSubscription<List<int>> ans = c.value.listen(b);
  //   print("Value Received");
  //   print(value);
  //   int? temp1=0;
  //   int? temp2=0;
  //   if(value.length>10){
  //     temp1=value[3];
  //     temp1=(temp1!<<8);
  //     temp1=(temp1+value[4]) as int?;
  //     temp1=(temp1!<<8);
  //     temp1=(temp1+value[5]) as int?;
  //     temp1=(temp1!<<8);
  //     temp1=(temp1+value[6]) as int?;
  //
  //     temp2=value[7];
  //     temp2=(temp2!<<8);
  //     temp2=(temp2+(value[8])) as int?;
  //     temp2=temp2!<<8;
  //     temp2=(temp2+(value[9])) as int?;
  //     temp2=temp2!<<8;
  //     temp2=(temp2+(value[10])) as int?;
  //   }
  //   if((temp1! & 0x10000000)==268435456){
  //     value1=-(temp1^0xFFFFFFFF)+0x01;
  //   }
  //   else
  //   {
  //     value1=temp1;
  //   }
  //   if((temp2! & 0x10000000)==268435456){
  //     value2=-(temp2^0xFFFFFFFF)+0x01;
  //   }
  //   else
  //   {
  //     value2=temp2;
  //   }
  // }

  Future<dynamic> sendData(List<int> bytes, BluetoothCharacteristic characteristic) async {
    print("Attempting to send data: $bytes");
    if (_connectedDevice == null) {
      print("No connected device to send data");
      _showSnackBar("No connected device", isError: true);
      return;
    }

    try {

      final checksum = crc16umts(bytes);
      bytes.add(checksum);
      bytes.add(checksum>>8);
      print("Data Transmitted");
      print(checksum);
      print(bytes);
      // timer = Timer.periodic(const Duration(milliseconds: 2000), ((timer) async {
        await characteristic.write(bytes, withoutResponse: characteristic.properties.writeWithoutResponse);
        // await read_value(bytes,characteristic)
      // print(_value)
        // await receiveData(characteristic);
      // }));

      // if (characteristic.properties.read) {
      //   // _value = await characteristic.read();
      //   print("Reading properties");
      //   List<int> dataReceived= await characteristic.read();
      //   //_value=dataReceived[0];
      //   print("Data Received:");
      //   print(dataReceived);
      //   print("End of Data");
      //   print(dataReceived[0]);
      //
      //   if (mounted) {
      //     setState(() {});
      //   }
      // }



      // await characteristic.write(bytes);
      // print("Data sent successfully: $data");
      // _showSnackBar("sent value : ${by.toString()}",isError: true );
    } catch (e) {
      print("Error sending data: $e");
      _showSnackBar("Error sending data: ${e.toString()}", isError: true);
    }
  }

  // Future<List<int>> receiveData(BluetoothCharacteristic characteristic,) async {
  //   print("Attempting to receive data...");
  //   if (_connectedDevice == null) {
  //     print("No connected device to receive data");
  //     _showSnackBar("No connected device", isError: true);
  //     return [];
  //   }
  //
  //   try {
  //     // List<BluetoothService> services = await _connectedDevice!.discoverServices();
  //     // BluetoothService service = services.last; // Use last service
  //     // BluetoothCharacteristic characteristic = service.characteristics.first; // Use first characteristic
  //     // List<int> value = (await characteristic.value.listen()) as List<int>;
  //     print("Data received: $characteristic");
  //     //
  //     // int temp1=0;
  //     // int temp2=0;
  //     // if(value.length>10){
  //     //   temp1=value[3];
  //     //   temp1=temp1<<8;
  //     //   temp1=temp1+value[4];
  //     //   temp1=temp1<<8;
  //     //   temp1=temp1+value[5];
  //     //   temp1=temp1<<8;
  //     //   temp1=temp1+value[6];
  //     //
  //     //   temp2=value[7];
  //     //   temp2=temp2<<8;
  //     //   temp2=temp2+(value[8]);
  //     //   temp2=temp2<<8;
  //     //   temp2=temp2+(value[9]);
  //     //   temp2=temp2<<8;
  //     //   temp2=temp2+(value[10]);
  //     // }
  //     // if((temp1 & 0x10000000)==268435456){
  //     //   value1=-(temp1^0xFFFFFFFF)+0x01;
  //     // }
  //     // else
  //     // {
  //     //   value1=temp1;
  //     // }
  //     // if((temp2 & 0x10000000)==268435456){
  //     //   value2=-(temp2^0xFFFFFFFF)+0x01;
  //     // }
  //     // else
  //     // {
  //     //   value2=temp2;
  //     // }
  //     //
  //     // print("End of Value");
  //     // print(temp1);
  //     // print(temp2);
  //     // print(value2);
  //     // print(temp2 & 0x10000000);
  //     //
  //     //
  //     // // return value;
  //     // _value = value;
  //     // print("Its the ans"+_value.toString());
  //     //
  //     // _showSnackBar("recived value : ${value.toString()}",isError: true );
  //     // return value;
  //
  //
  //
  //   } catch (e) {
  //     print("Error receiving data: $e");
  //     _showSnackBar("Error receiving data: ${e.toString()}", isError: true);
  //     return [];
  //   }
  // }

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
            minTileHeight: 40,
          // minLeadingWidth: ,

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
              // ElevatedButton(onPressed: sendData(bytes,_usefulchar!), child: Text("write")),
              // ElevatedButton(onPressed: receiveData(_usefulchar), child: Text("read"))
              // TextButton(onPressed: () async { await sendData(bytes,_usefulchar!);}  , child: Text("Write")),
              // TextButton(onPressed: () async { await receiveData(_usefulchar!);}  , child: Text("Read"))

            ]

          ),



        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
