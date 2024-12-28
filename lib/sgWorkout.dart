import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:indafit/model/model.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart' as cp1;
import 'package:syncfusion_flutter_charts/charts.dart' as cp2;
import 'package:indafit/login.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:indafit/rangeMotion.dart';
import 'package:animated_weight_picker/animated_weight_picker.dart';
/*void main() async {
  // Fetch the available cameras before initializing the app.

  runApp(const GymApp());
}
*/

/*void main() {
  return runApp(GaugeApp());
}

/// Represents the GaugeApp class
class GaugeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Radial Gauge Demo',
      theme: ThemeData(primarySwatch: Colors.blue,scaffoldBackgroundColor: const Color(0xFFEFEFEF)),
      home: SgWorkoutPage(),
    );
  }
}
*/


/// Represents MyHomePage class
class SgWorkoutPage extends StatefulWidget {
  /// Creates the instance of MyHomePage
  SgWorkoutPage({Key? key,required this.exerciseDetails}) : super(key: key);
  final MovementModel exerciseDetails;

  @override
  SgWorkoutPageState createState() => SgWorkoutPageState();
}
double _volumeValue = 50;

void onVolumeChanged(double value) {
  //setState(() {
  _volumeValue = value;
  //});
}

class SgWorkoutPageState extends State<SgWorkoutPage> {
  late final Box<ExerciseCategories> dataBox;
  bool dataReceived=false;
  var _currentIntValue=50;
  var progressionValue=1;
  var regressionValue=1;
  int repsCount=3;
  @override
  SgWorkoutPageState() {
    print("Getting Data");
    //getData();

    //super.initState();
  }
  void dispose() async{
    super.dispose();
    print("Removing Database");
    if (dataBox.isOpen){
      await dataBox.close();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Container(
                  padding: EdgeInsets.only(top: 10,bottom: 30),
                  decoration: BoxDecoration(border: Border.all(),borderRadius: BorderRadius.circular(10),color: Colors.black26),
                  child:
                    Text(widget.exerciseDetails.name,style: TextStyle(color: Colors.white,fontSize: 20),),
                    //Text(widget.exerciseDetails.sets[0].reps,style: TextStyle(color: Colors.white,fontSize: 20),),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    child: NumberPicker(
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
                      value: repsCount,
                      minValue: 1,
                      maxValue: 500,
                      step: 1,
                      haptics: true,
                      onChanged: (value) => setState(() => repsCount = value),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 10,right: 10),child:
                  Text("reps",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),)),
                ],
              ),
            ),
            SizedBox(height: 100,),
            Spacer(),
            Container(width: 100,height: 50,decoration: BoxDecoration(color: Colors.lightGreenAccent,borderRadius: BorderRadius.all(Radius.circular(50))),child: Center(child:Text("Next",style: TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.bold),)),)

            //widget.exerciseDetails.sets.length
          ],
        ),
      ),
    );
  }
}