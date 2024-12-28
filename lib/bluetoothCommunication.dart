/*import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
//import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyBluetoothPage(), // BluetoothApp() would be defined later
    );
  }
}
class MyBluetoothPage extends StatefulWidget {
  const MyBluetoothPage({super.key});

  @override
  _MyBluetoothPageState createState() => _MyBluetoothPageState();
}

class _MyBluetoothPageState extends State<MyBluetoothPage> {
@override
late BluetoothConnection currentConnectedDevice;
void initState() {
super.initState();
_initBluetooth();
}

Future<void> _initBluetooth() async {
await FlutterBluetoothSerial.instance.requestEnable();
}
FlutterBluetoothSerial _bluetooth=FlutterBluetoothSerial.instance;
List<BluetoothDevice> _devices = [];

Future<void> _startScan() async {
  _devices.clear();
  /*_bluetooth.getBondedDevices().then((deviceList)=>{
    deviceList.forEach((device){
      setState(() {
        if(device.isConnected)
          {
            print("Connected Device:"+device.name.toString());
            //currentConnectedDevice=device.;
          }
        print(device.name);
        _devices.add(device);
      });
    }),
  });*/
  await Permission.location.request();
  await Permission.bluetooth.request();
  await Permission.bluetoothScan.request();
  await Permission.bluetoothConnect.request();

  await Permission.bluetoothAdvertise.request();
  print("Bluetooth Permission:");
  print(await Permission.bluetooth.isGranted);
  //if Permission.bluetooth.isGranted
  _bluetooth.startDiscovery().listen((device) {
    print("Discovered");
    print(device);
    setState(() {
      _devices.add(device.device);
    });
  });
}

/*onTap: () async {
try {
await _devices[index].connect();
print('Connected to ${_devices[index].name}');
} catch (e) {
print('Error connecting to ${_devices[index].name}: $e');
}
},*/

/*void _sendDataFromBluetooth(BluetoothDevice myDevice,
    String myData) async {
  myDevice.write(Uint8List.fromList(myData.codeUnits));
}*/
void _listenForData(BluetoothConnection connection) {
  connection.input?.listen((data) {
    String text = String.fromCharCodes(data);
    print('Received data: $text');
  }).onDone(() {
    print('Connection closed');
  });
}

int connectedIndex=-1;
String dataReceived="";
@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: Text('Bluetooth Flutter App'),
),
body: SafeArea(
  child: Column(children: [
    ElevatedButton(onPressed: (){_startScan();}, child: Text("Scan")),
    Expanded(child: ListView.builder(
        itemCount: _devices.length, // Number of items in your list
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            key: Key(index.toString()),
            onTap: () async{
              print("Clicked "+_devices[index].name.toString()+":"+_devices[index].address.toString());
              try {
                BluetoothConnection.toAddress(_devices[index].address).then((_connection) async{
                  currentConnectedDevice=_connection;
                  connectedIndex=index;
                  _connection.input?.listen((Uint8List data) {
                    setState(() {
                      dataReceived = ascii.decode(data);
                    });

                    print('Received data: $dataReceived');
                  }).onDone(() {
                    print('Connection closed');
                  });
                  /*_connection.output.add(ascii.encode("Hello"));
                  await _connection.output.allSent;
                  _connection.close();*/
                });
                //await _devices[index].connect();
                print('Connected to ${_devices[index].name}');
              } catch (e) {
                print('Error connecting to ${_devices[index].name}: $e');
              }
            },
            child: Container(width: 50, height: 40.0,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
                //boxShadow: [BoxShadow(blurRadius: 5, color: Colors.white70, offset: Offset(2, 2))],
              ),
              child: Center(child:
              Text(_devices[index].name.toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
              ),),
          );
        }),
    ),
    Container(
        height: 200,
        child: Column(children: [
      (connectedIndex>=0?
      Text(_devices[connectedIndex].name.toString()):Text("")),
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
          currentConnectedDevice.output.add(ascii.encode("Hello"));
          await currentConnectedDevice.output.allSent;
        },),
        ElevatedButton(child: Text("Close Connection"),onPressed: (){
          currentConnectedDevice.close();
        },),
      ],),
      Text(dataReceived),
    ],))
  ],)
)
);
}
}

// Some simplest connection :F
/*try {
BluetoothConnection connection = await BluetoothConnection.toAddress(address);
print('Connected to the device');
connection.input.listen((Uint8List data) {
print('Data incoming: ${ascii.decode(data)}');
connection.output.add(data); // Sending data

if (ascii.decode(data).contains('!')) {
connection.finish(); // Closing connection
print('Disconnecting by local host');
}
}).onDone(() {
print('Disconnected by remote request');
});
}
catch (exception) {
print('Cannot connect, exception occured');
}*/
*/
