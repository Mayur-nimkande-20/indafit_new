import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart' as cp1;
import 'package:syncfusion_flutter_charts/charts.dart' as cp2;
import 'package:indafit/login.dart';
import 'package:numberpicker/numberpicker.dart';
// import 'package:indafit/rangeMotion.dart';
import 'package:indafit/rangeMotion2.dart';

/*void main() async {
  // Fetch the available cameras before initializing the app.

  runApp(const GymApp());
}
*/
/*
void main() {
  return runApp(GaugeApp());
}

/// Represents the GaugeApp class
class GaugeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Radial Gauge Demo',
      theme: ThemeData(primarySwatch: Colors.blue,scaffoldBackgroundColor: const Color(0xFFEFEFEF)),
      home: StatusPage(),
    );
  }
}
*/


/// Represents MyHomePage class
class JustLiftPage extends StatefulWidget {
  /// Creates the instance of MyHomePage
  JustLiftPage({Key? key}) : super(key: key);

  @override
  JustLiftPageState createState() => JustLiftPageState();
}
double _volumeValue = 50;

void onVolumeChanged(double value) {
  //setState(() {
  _volumeValue = value;
  //});
}

class JustLiftPageState extends State<JustLiftPage> {
  var _currentIntValue=50;
  var progressionValue=1;
  var regressionValue=1;
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              child:
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10,right: 30),
                    child:
                    Text("Set Weight",style: TextStyle(color: Colors.white,fontSize: 30),),
                  ),
                  NumberPicker(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 1.0, color: Colors.lightBlue.shade600),
                        bottom: BorderSide(width: 1.0, color: Colors.lightBlue.shade900),
                      ),
                      //color: Colors.deepOrangeAccent,
                      //borderRadius: BorderRadius.circular(30),
                    ),
                    textStyle: TextStyle(color: Colors.amber),
                    selectedTextStyle: TextStyle(color: Colors.lightGreenAccent,fontSize: 30,fontWeight: FontWeight.bold),
                    value: _currentIntValue,
                    minValue: 10,
                    maxValue: 500,
                    step: 5,
                    haptics: true,
                    onChanged: (value) => setState(() => _currentIntValue = value),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child:
                    Text("KG",style: TextStyle(color: Colors.white,fontSize: 20),),
                  ),

                ],
              ),
            ),
            Row(children: [
              Padding(
                padding: EdgeInsets.only(left: 10,right: 30),
                child:
                Text("Weight Mode",style: TextStyle(color: Colors.white,fontSize: 20),),
              ),
              Container(
                width: 80,
                margin: EdgeInsets.only(right: 80),
                child:
                Padding(padding: EdgeInsets.only(top: 10),
                  child:
                  DropdownMenu<String>(
                    textStyle: TextStyle(color: Colors.lightGreenAccent),
                    initialSelection: 'STANDARD',
                    dropdownMenuEntries: <String>['STANDARD', 'ECCENTRIC','CONCENTRIC','ELASTIC'].map((String value) {
                      return DropdownMenuEntry<String>(
                        value: value,
                        label: value,
                      );
                    }).toList(),
                    onSelected: (value) {print(value);},
                  ),
                ),
              ),
            ],),
            SizedBox(height: 20,),
            Row(children: [
              Padding(
                padding: EdgeInsets.only(left: 10,right: 30,top: 10),
                child:
                Text("Progression",style: TextStyle(color: Colors.white,fontSize: 20),),
              ),
              Container(
                //margin: EdgeInsets.only(right: 80),
                child:
                Padding(padding: EdgeInsets.only(top: 10),
                  child:
                  ElevatedButton(child: Text("-",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    backgroundColor: Colors.red,
                  ),onPressed: (){setState(() {
                    if(progressionValue>0){
                      progressionValue-=1;
                    }
                  });;}),
                ),
              ),
              Container(
                //margin: EdgeInsets.only(right: 80),
                child:
                Padding(padding: EdgeInsets.only(top: 10,left: 20,right: 20),
                  child:  Text(progressionValue.toString(),style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),)),
              ),

              Container(
                //margin: EdgeInsets.only(right: 80),
                child:
                Padding(padding: EdgeInsets.only(top: 10),
                  child:
                  ElevatedButton(child: Text("+",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    backgroundColor: Colors.green,
                  ),onPressed: (){setState(() {
                    progressionValue+=1;
                  });;}),
                ),
              ),
            ],),
            SizedBox(height: 20,),
            Expanded(child:
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Padding(
                padding: EdgeInsets.only(left: 10,right: 30,top: 20),
                child:
                Text("Regression",style: TextStyle(color: Colors.white,fontSize: 20),),
              ),
              Container(
                //margin: EdgeInsets.only(right: 80),
                child:
                Padding(padding: EdgeInsets.only(top: 10),
                  child:
                  ElevatedButton(child: Text("-",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    backgroundColor: Colors.red,
                  ),onPressed: (){setState(() {
                    if(regressionValue>0){
                      regressionValue-=1;
                    }
                  });;}),
                ),
              ),
              Container(
                //margin: EdgeInsets.only(right: 80),
                child:
                Padding(padding: EdgeInsets.only(top: 10,left: 20,right: 20),
                    child:  Text(regressionValue.toString(),style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),)),
              ),

              Container(
                //margin: EdgeInsets.only(right: 80),
                child:
                Padding(padding: EdgeInsets.only(top: 10),
                  child:
                  ElevatedButton(child: Text("+",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    backgroundColor: Colors.green,
                  ),onPressed: (){setState(() {
                    regressionValue+=1;
                  });;}),
                ),
              ),
            ],),
            ),
            Row(
              children: [
                Container(
                  //margin: EdgeInsets.only(right: 80),
                  child:
                  Padding(padding: EdgeInsets.only(top: 10),
                    child:
                    IconButton.filledTonal(icon: const Icon(Icons.arrow_back),onPressed: (){print("Its pressed");},),
                  ),
                ),
                Expanded(
                  //margin: EdgeInsets.only(right: 80),
                  child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 115,
                              decoration: BoxDecoration(color: Colors.lightGreenAccent,borderRadius: BorderRadius.circular(70)),
                              child:
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.pop(context);
                                      Navigator.push(context,MaterialPageRoute(builder: (context) => RangeMotionPage()));

                                    },
                                    child:
                              Row(children: [
                                Padding(padding: EdgeInsets.only(left: 10),child:Text("START",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),), ),
                                //SizedBox(width: 3,),
                                Icon(Icons.arrow_right,color: Colors.black,size: 40)
                              ],),
                                  ),
                              /*ElevatedButton(child:
    //Text("START",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.black,backgroundColor: Colors.yellow),),
                                Row(children: [
                                    Text("START",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.black,backgroundColor: Colors.yellow),),
                                    //SizedBox(width: 3,),
                                    Icon(Icons.arrow_right,color: Colors.black,size: 40)
                                ],),
                                  style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(70)
                                ),
                                backgroundColor: Colors.green,
                              ),onPressed: (){setState(() {
                                regressionValue+=1;
                              });;}),*/
                            ),

                        ],)

                ),

              ],),

          ],
        ),
      ),
    );
  }
}
