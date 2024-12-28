import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BleScanner(),
    );
  }
}

class BleScanner extends StatefulWidget {
  @override
  _BleScannerState createState() => _BleScannerState();
}

class _BleScannerState extends State<BleScanner> {
  FlutterBluePlus myFlutterBlue=FlutterBluePlus();
  List<BluetoothDevice> devices = [];
  int connectedIndex=-1;
  String dataReceived="";
  //late BluetoothConnection currentConnectedDevice;
  @override
  void initState() {
    super.initState();
    //startScanning();
  }

  void scanBluetoothDevices() async{
    await Permission.location.request();
    await Permission.bluetooth.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    FlutterBluePlus.turnOn();
    var subscription = FlutterBluePlus.onScanResults.listen((results) {
      if (results.isNotEmpty) {
        ScanResult r = results.last; // the most recently found device
        print('${r.device.remoteId}: "${r.advertisementData.advName}" found!');
      }
    },
      onError: (e) => print(e),
    );

// cleanup: cancel subscription when scanning stops
    FlutterBluePlus.cancelWhenScanComplete(subscription);

// Wait for Bluetooth enabled & permission granted
// In your real app you should use `FlutterBluePlus.adapterState.listen` to handle all states
    await FlutterBluePlus.adapterState.where((val) => val == BluetoothAdapterState.on).first;

// Start scanning w/ timeout
// Optional: use `stopScan()` as an alternative to timeout
    await FlutterBluePlus.startScan();

// wait for scanning to stop
    await FlutterBluePlus.isScanning.where((val) => val == false).first;
    print("Scanning Done");
  }

  void startScanning() async {
    //FlutterBluePlus.s
    print("Scanning");
    //await FlutterBluePlus.startScan();
    await Permission.location.request();
    await Permission.bluetooth.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    await Permission.bluetoothAdvertise.request();
    //await FlutterBluePlus.startScan(timeout: const Duration(milliseconds: 100));
    //print("Stopping scan");
    //await FlutterBluePlus.stopScan();
    //await Future.delayed(const Duration(milliseconds: 100));
    //print("Rescanning");
    //await FlutterBluePlus.startScan(timeout: const Duration(seconds: 1));
    await FlutterBluePlus.turnOn();
    await FlutterBluePlus.getPhySupport();
    //print("adapter State");
    //print(await FlutterBluePlus.adapterState);
    FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) async{
      print(state);
      if (state == BluetoothAdapterState.on) {
        await FlutterBluePlus.startScan(timeout: Duration(seconds: 60));
        print("Rescanning done");
        await FlutterBluePlus.stopScan();
        await FlutterBluePlus.scanResults.listen((results) {
          print("Scan Result : "+results.length.toString());
          for (ScanResult result in results) {
            print("Device Found:"+result.device.platformName+":"+result.device.advName);
            if (!devices.contains(result.device)) {
              setState(() {
                devices.add(result.device);
              });
            }
          }
        });

      } else {
        print("Bluetooth Adapter Error");
        // show an error to the user, etc
      }
    });

    /*List<BluetoothDevice> bondedList= await FlutterBluePlus.bondedDevices;
    print(bondedList.length);
    bondedList.forEach((device){
      print(device.advName);
      setState(() {
        devices.add(device);
      });
    });*/
    /*List<BluetoothDevice> conList= FlutterBluePlus.connectedDevices;
    conList.forEach((device){
      print(device.advName);
        setState(() {
        devices.add(device);
        });
    });*/
    /*var subscription = FlutterBluePlus.scanResults.listen((results) {
      print('scanResults: ${results}');
      // do something with scan results
      for (ScanResult r in results) {
        devices.add(r.device);
        print('${r.device.name} found! rssi: ${r.rssi}');
      }
    });
    setState(() {
    });
    print('subscription: $subscription');*/
    //FlutterBluePlus.scan();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BLE Scanner'),
      ),
      body: SafeArea(
          child: Column(children: [
            ElevatedButton(onPressed: (){startScanning();}, child: Text("Scan")),
            Expanded(child: ListView.builder(
                itemCount: devices.length, // Number of items in your list
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    key: Key(index.toString()),
                    onTap: () async{
                      print("Clicked "+devices[index].platformName.toString()+":"+devices[index].remoteId.toString());
                      try {
                        connectedIndex=index;

                        /*var subscription = devices[index].connectionState.listen((BluetoothConnectionState state) async {
                          if (state == BluetoothConnectionState.disconnected) {
                            // 1. typically, start a periodic timer that tries to
                            //    reconnect, or just call connect() again right now
                            // 2. you must always re-discover services after disconnection!
                            print("${devices[index].disconnectReason?.code} ${devices[index].disconnectReason?.description}");
                          }
                        });


                        devices[index].cancelWhenDisconnected(subscription, delayed:true, next:true);
*/
                        await Permission.bluetoothConnect.request();
                        try {
                          await FlutterBluePlus.turnOn();
                          await FlutterBluePlus.stopScan();
                          devices[index].clearGattCache();
                          devices[index].removeBond();
                          //devices[index].createBond();
                          await devices[index].connect(
                              mtu: 512, autoConnect: false).then((status) {
                            print("Connected:");
                            devices[index].discoverServices().then((value) {
                              value.forEach((service) {
                                //services are here
                                service.characteristics.forEach((
                                    characteristic) {
                                  print(characteristic.characteristicUuid);
                                  //characteristics
                                });
                              });
                            });
                            //print(status);
                          });
                        }catch(e){
                          print("Error");
                          print(e);
                          devices[index].disconnect();
                        }
                        print("Connection Status:"+devices[index].isConnected.toString());
                        //FlutterBluePlus.adapterState.listen(onData)
                        devices[index].connectionState.listen((state) async{
                          if(state==BluetoothConnectionState.connected){
                            devices[index].discoverServices().then((services){
                                services.forEach((service){
                                  print(service.uuid);
                                });
                            });
                          }
                            print("Connected Now Listening");
                        });
                        /*FlutterBluePlus.toAddress(_devices[index].address).then((_connection) async{
                          currentConnectedDevice=_connection;

                          _connection.input?.listen((Uint8List data) {
                            setState(() {
                              connectedIndex=index;
                              dataReceived = ascii.decode(data);
                            });

                            print('Received data: $dataReceived');
                          }).onDone(() {
                            print('Connection closed');
                          });*/
                          /*_connection.output.add(ascii.encode("Hello"));
                  await _connection.output.allSent;
                  _connection.close();*/
                        //});
                        //await _devices[index].connect();
                        print('Connected to ${devices[index].platformName}');
                      } catch (e) {
                        print('Error connecting to ${devices[index].platformName}: $e');
                      }
                    },
                    child: Container(width: 50, height: 40.0,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                        //boxShadow: [BoxShadow(blurRadius: 5, color: Colors.white70, offset: Offset(2, 2))],
                      ),
                      child: Center(child:
                      Text(devices[index].platformName.toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                      ),),
                  );
                }),
            ),
            Container(
                height: 200,
                child: Column(children: [
                  (connectedIndex>=0?
                  Text(devices[connectedIndex].platformName.toString()):Text("")),
                  Padding(padding: EdgeInsets.only(left:5,right: 5),child:
                  TextField(decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(color: Colors.black, width: 2),
                    ),
                  ),),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(child: Text("Send"),onPressed: () async{
                        List<int> data=[10,20,30];
                        List<BluetoothService> services = await devices[connectedIndex].discoverServices();
                        for (BluetoothService service in services) {
                          for (BluetoothCharacteristic characteristic in service.characteristics) {
                            print(characteristic.uuid);
                            print(characteristic.remoteId);
                            //await characteristic.write(data);
                            /*if (characteristic.uuid == characteristicId) {
                              await characteristic.write(data);
                              print('Data written successfully.');
                            }*/
                          }
                        }
                      },),
                      ElevatedButton(child: Text("Receive"),onPressed: () async{
                        List<int> data=[10,20,30];
                        List<BluetoothService> services = await devices[connectedIndex].discoverServices();
                        for (BluetoothService service in services) {
                          for (BluetoothCharacteristic characteristic in service.characteristics) {
                            print(characteristic.uuid);
                            print(characteristic.remoteId);
                            List<int> value =await characteristic.read();
                            print(value);
                            /*if (characteristic.uuid == characteristicId) {
                              await characteristic.write(data);
                              print('Data written successfully.');
                            }*/
                          }
                        }
                      },),
                      ElevatedButton(child: Text("Close Connection"),onPressed: (){
                        devices[connectedIndex].disconnect();
                      },),
                    ],),
                  Text(dataReceived),
                ],))
          ],)
      )
      /*body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(devices[index].name),
            subtitle: Text(devices[index].id.toString()),
          );
        },
      ),*/
    );
  }

  @override
  void dispose() {
    FlutterBluePlus.stopScan();
    if(connectedIndex>=0){
      devices[connectedIndex].disconnect();
    }
    super.dispose();
  }
}