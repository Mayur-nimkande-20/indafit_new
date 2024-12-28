import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:animated_weight_picker/animated_weight_picker.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:indafit/exerciseStatus.dart';
import 'package:indafit/aboutME.dart';
import 'package:indafit/main.dart';
import 'package:indafit/globals.dart';
/*
void main() {
  print(DateFormat('dd-MM-yyyy').format(DateTime.now()));
  return runApp(GaugeApp());
}

 */
class StateModel {
  const StateModel(this.name, this.code);
  final String code;
  final String name;

  @override
  String toString() => name;
}
/*
/// Represents the GaugeApp class
class GaugeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Radial Gauge Demo',
      theme: ThemeData(primarySwatch: Colors.blue,scaffoldBackgroundColor: const Color(0xFFEFEFEF)),
      home: MyHomePage(),
    );
  }
}
*/
/// Represents MyHomePage class
class MyHomePage extends StatefulWidget {
  /// Creates the instance of MyHomePage
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
double _volumeValue = 50;

void onVolumeChanged(double value) {
  //setState(() {
  _volumeValue = value;
  //});
}

class _MyHomePageState extends State<MyHomePage> {

//TextEditingController dateController = new TextEditingController(text: DateFormat('dd-MM-yyyy').format(DateTime.now()));
  TextEditingController dateController = new TextEditingController();
  var _currentIntValue=10;
  String selectedValue = '';
  @override
  //var future1= showMaterialScrollPicker(context: context, items: usStates, selectedItem: selectedUsState), child: Text("Press ME")),
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: MyDrawer(),
      /*drawer: Drawer(child:
      ListView(children: [
        ListTile(title: Text("Home Page"), onTap: (){
          Navigator.pop(context);
          Navigator.push(context,MaterialPageRoute(builder: (context) => MyHomePage()));
        },
        ),
        ListTile(title: Text("About ME"), onTap: (){
          Navigator.pop(context);
          Navigator.push(context,MaterialPageRoute(builder: (context) => AboutMePage()));
        },
        ),
        ListTile(title: Text("Setup Goal")),
        ListTile(title: Text("Setup Activity Level")),
        ListTile(title: Text("Configure Workout")),
        ListTile(title: Text("Show Status"), onTap: (){
          Navigator.pop(context);
          Navigator.push(context,MaterialPageRoute(builder: (context) => StatusPage()));
        },
        ),
      ],)
      ),*/
      appBar: AppBar(title: Text("Todays Tasks"),backgroundColor:Colors.lightGreenAccent ,foregroundColor: Colors.red,
          actions: [IconButton(
                    onPressed: (){
                      Navigator.push(context,MaterialPageRoute(builder: (context) => const CameraExampleHome()),
      );}, icon: Icon(Icons.photo_camera,size: 35),padding: EdgeInsets.only(right: 20),)]),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 30,),
            Text("Biseps",style: TextStyle(fontSize: 30,color: Colors.white),),
            SizedBox(height: 30,),
            Text("Pushups",style: TextStyle(fontSize: 30,color: Colors.white)),
          ],
        )
        ,
      ),
    );
  }
}