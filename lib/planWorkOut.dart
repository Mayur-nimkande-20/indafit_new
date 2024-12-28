//import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart';

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
  //print(DateFormat('dd-MM-yyyy').format(DateTime.now()));
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
      home: PlanworkoutHome(),
    );
  }
}
*/
/// Represents MyHomePage class
class PlanworkoutHome extends StatefulWidget {
  /// Creates the instance of MyHomePage
  PlanworkoutHome({Key? key}) : super(key: key);

  @override
  PlanworkoutHomeState createState() => PlanworkoutHomeState();
}
double _volumeValue = 50;

void onVolumeChanged(double value) {
  //setState(() {
  _volumeValue = value;
  //});
}

class PlanworkoutHomeState extends State<PlanworkoutHome> {
List<ExerciseItem> workOutTypes=[ExerciseItem("Chest", 175, 120),ExerciseItem("Back", 175, 120),ExerciseItem("Shoulders", 175, 120),ExerciseItem("Abs", 175, 120),ExerciseItem("Hip", 175, 120),ExerciseItem("legs", 175, 120),ExerciseItem("Arms", 175, 120),ExerciseItem("Full Body", 175, 120),ExerciseItem("Warm Up", 175, 120),ExerciseItem("Body Weight", 175, 120),ExerciseItem("Rehab", 175, 120),ExerciseItem("Rowing", 175, 120),ExerciseItem("Skiing", 175, 120)];
List<List<String>> workOutSubTypes=[["Cable Chest Fly","Chest Press","Bench Press","Low High Fly","Incline press"],["Dual Handle Low","Arm Pull Down","Lat Pull Down"],["Front Raise","Reverse Cable Fly","Shoulder Press","Arnold Press"]];
List<bool> daysStatus=[false,false,false,false,false,false,false,false];
List<bool> workOutConfigured=[false,false,false,false,false,false,false,false];

double width=175.0;
double height=120.0;
//TextEditingController dateController = new TextEditingController(text: DateFormat('dd-MM-yyyy').format(DateTime.now()));
  TextEditingController dateController = new TextEditingController();
  var _currentIntValue=10;
  String selectedValue = '';

  Widget getSubItems(int row){
    final _formKey = GlobalKey<FormState>();
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState)
    {
      return Column(
          children: [
            Container(
              child: Center(child: Text(workOutTypes[row].name,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),)),
              padding: const EdgeInsets.all(12),
            ),
            Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for(int j = 0; j < workOutSubTypes[row].length; j++)
                        GestureDetector(
                          onTap: () async {
                            await showDialog<void>(
                                context: context,
                                builder: (context) => StatefulBuilder(builder: (context,setState)=>
                                    AlertDialog(
                                      content: /*Stack(
                                  clipBehavior: Clip.none,
                                  children: <Widget>[*/
                                      /*Positioned(
                                      right: -30,
                                      top: -30,
                                      child: InkResponse(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const CircleAvatar(
                                          backgroundColor: Colors.red,
                                          child: Icon(Icons.close),
                                        ),
                                      ),
                                    ),*/
                                      SingleChildScrollView(child:
                                      Form(
                                        key: _formKey,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Padding(
                                                padding: const EdgeInsets.all(
                                                    8),
                                                child: Text(
                                                  workOutSubTypes[row][j],
                                                  style: TextStyle(fontSize: 25,
                                                      fontWeight: FontWeight
                                                          .bold),)
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: TextFormField(
                                                decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                        borderRadius: BorderRadius
                                                            .circular(10.0)),
                                                    hintText: "Number of Sets",
                                                    labelText: "Number of Sets"),),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: TextFormField(
                                                decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                        borderRadius: BorderRadius
                                                            .circular(10.0)),
                                                    hintText: "Number of Repetations",
                                                    labelText: "Number of Repetations"),),
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.all(
                                                    8),
                                                child: Row(
                                                  //crossAxisAlignment: WrapCrossAlignment.center,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Row(children: [
                                                          Checkbox(
                                                              value: daysStatus[0],
                                                              onChanged: (
                                                                  bool? value) {
                                                                //print(value);
                                                                //print(daysStatus[0]);
                                                                setState(() {
                                                                  //print("State Change");
                                                                  daysStatus[0] =value!;
                                                                });
                                                              }),
                                                          Text("Monday"),
                                                        ],),
                                                        Row(children: [
                                                          Checkbox(
                                                              value: daysStatus[2],
                                                              onChanged: (
                                                                  bool? value) {
                                                                setState(() {
                                                                  daysStatus[2] =
                                                                  value!;
                                                                });
                                                              }),
                                                          Text("Wednesday"),
                                                        ],),
                                                        Row(children: [
                                                          Checkbox(
                                                              value: daysStatus[4],
                                                              onChanged: (
                                                                  bool? value) {
                                                                setState(() {
                                                                  daysStatus[4] =
                                                                  value!;
                                                                });
                                                              }),
                                                          Text("Friday"),
                                                        ],),
                                                        Row(children: [
                                                          Checkbox(
                                                              value: daysStatus[6],
                                                              onChanged: (
                                                                  bool? value) {
                                                                setState(() {
                                                                  daysStatus[6] =
                                                                  value!;
                                                                });
                                                              }),
                                                          Text("Sunday"),
                                                        ],),
                                                      ],),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Row(children: [
                                                          Checkbox(
                                                              value: daysStatus[1],
                                                              onChanged: (
                                                                  bool? value) {
                                                                setState(() {
                                                                  daysStatus[1] =
                                                                  value!;
                                                                });
                                                              }),
                                                          Text("Tuesday"),
                                                        ],),
                                                        Row(children: [
                                                          Checkbox(
                                                              value: daysStatus[3],
                                                              onChanged: (
                                                                  bool? value) {
                                                                setState(() {
                                                                  daysStatus[3] =
                                                                  value!;
                                                                });
                                                              }),
                                                          Text("Thursday"),
                                                        ],),
                                                        Row(children: [
                                                          Checkbox(
                                                              value: daysStatus[5],
                                                              onChanged: (
                                                                  bool? value) {
                                                                setState(() {
                                                                  daysStatus[5] =
                                                                  value!;
                                                                });
                                                              }),
                                                          Text("Saturday"),
                                                        ],),
                                                        Row(children: [
                                                          Checkbox(
                                                              value: daysStatus[7],
                                                              onChanged: (
                                                                  bool? value) {
                                                                setState(() {
                                                                  daysStatus[7] =
                                                                  value!;
                                                                  for (int i = 0; i <
                                                                      7; i++) {
                                                                    daysStatus[i] =
                                                                        value;
                                                                  }
                                                                });
                                                              }),
                                                          Text("ALL"),
                                                        ],),
                                                      ],),
                                                    Column(children: [
                                                    ],),
                                                  ],)
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: ElevatedButton(
                                                child: const Text('Submit'),
                                                onPressed: () {
                                                  setState((){
                                                    workOutConfigured[j]=true;
                                                  });
                                                  for(int i=0;i<daysStatus.length;i++){
                                                    daysStatus[i]=false;
                                                  }
                                                  Navigator.of(context).pop();
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    _formKey.currentState!
                                                        .save();
                                                  }
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                      /*],
                                ),*/
                                    )),
                            );
                          },
                          child:
                          Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width - 10,
                            margin: EdgeInsets.all(10),
                            //padding: EdgeInsets.all(5),
                            //width: MediaQuery.of(context).size.width-20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: workOutConfigured[j]?Colors.green:Colors.amber,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Container(
                              child: Center(child: Text(workOutSubTypes[row][j],
                                style: TextStyle(fontSize: 30,
                                    fontWeight: FontWeight.bold),)),
                              padding: const EdgeInsets.all(12),
                            ),
                          ),
                        ),
                    ],
                  ),
                )

            ),
          ]);
    });
  }


  @override
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
      appBar: AppBar(title: Text("Workout Planner"),backgroundColor:Colors.lightGreenAccent ,foregroundColor: Colors.red,
          /*actions: [IconButton(
            onPressed: (){
              Navigator.push(context,MaterialPageRoute(builder: (context) => const CameraExampleHome()),
              );}, icon: Icon(Icons.photo_camera,size: 35),padding: EdgeInsets.only(right: 20),)]*/),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Wrap(
          children: [
            for(int i=0;i<workOutTypes.length;i++)
              GestureDetector(
                onTap: (){
                  setState(() {
                    if(workOutTypes[i].width==width)
                      {
                        workOutTypes[i].width=MediaQuery.of(context).size.width-20;
                        workOutTypes[i].height=500;
                      }
                    else
                      {
                        workOutTypes[i].width=width;
                        workOutTypes[i].height=height;
                      }
                  });
                },
                child:
                AnimatedContainer(
                    width: workOutTypes[i].width,
                    height: workOutTypes[i].height,
                    duration: const Duration(seconds: 1),
                    curve: Curves.fastOutSlowIn,
                    margin: EdgeInsets.all(10),
                    //padding: EdgeInsets.all(5),
                    //width: MediaQuery.of(context).size.width-20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.lightGreen,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white60.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child:
                    (workOutTypes[i].width==width?
                    Container(
                      child: Center(child: Text(workOutTypes[i].name,style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),)),
                      padding: const EdgeInsets.all(12),
                    ):
                            getSubItems(i)
                        /*Column(
                          children: [
                            Container(
                              child: Center(child: Text(workOutTypes[i].name,style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),)),
                              padding: const EdgeInsets.all(12),
                            ),
                            Container(
                              child: getSubItems(i),
                            ),
                          ],
                        )*/

                    ),
                  /*Column(
                children: [
                  Container(
                    child: Icon(Icons.person, size: 24, color:Colors.blueAccent),
                    padding: const EdgeInsets.all(12),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(12), bottomLeft: Radius.circular(12))
                    ),
                    child: Text("Student"),
                    padding: const EdgeInsets.all(12),
                  )
                ],
              ),*/
                ),
              ),
          ],
        ),
      ),
      ),
    );
  }
}

class ExerciseItem{
  String name;
  double width;
  double height;
  ExerciseItem(this.name,this.width,this.height);

}