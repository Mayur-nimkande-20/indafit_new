import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart' as cp1;
import 'package:syncfusion_flutter_charts/charts.dart' as cp2;
import 'package:indafit/main.dart';
import 'package:indafit/exerciseStatus_1.dart';
import 'package:indafit/login.dart';
import 'package:intl/intl.dart';
/*void main() async {
  // Fetch the available cameras before initializing the app.

  runApp(const GymApp());
}*/

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
      home: RangeMotionPage(),
    );
  }
}

*/



/// Represents MyHomePage class
class RangeMotionSummaryPage extends StatefulWidget {
  /// Creates the instance of MyHomePage
  RangeMotionSummaryPage({Key? key}) : super(key: key);

  @override
  RangeMotionSummaryPageState createState() => RangeMotionSummaryPageState();
}
double _volumeValue = 5;

void onVolumeChanged(double value) {
  //setState(() {
  _volumeValue = value;
  //});
}

class RangeMotionSummaryPageState extends State<RangeMotionSummaryPage> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  int repCount=1;
  bool firstEvent=true;
  //final jsonString =  '{\"privilege\":[{\"activity_id\":159,\"privilege_desc\":\"V4_MYPROFILE\",\"activity_desc\":\"V4_DASHBOARD\",\"privilege_id\":1185},{\"activity_id\":159,\"privilege_desc\":\"V4_MYTIMETABLE\",\"activity_desc\":\"V4_DASHBOARD\",\"privilege_id\":1186},{\"activity_id\":168,\"privilege_desc\":\"V4_LOGOUT\",\"activity_desc\":\"V4_LOGOUT\",\"privilege_id\":1210}],\"resultPrivilege\":\"0\",\"resultProfile\":\"0\"}';

  //final parsedJson = json.decode('{\"privilege\":[{\"activity_id\":159,\"privilege_desc\":\"V4_MYPROFILE\",\"activity_desc\":\"V4_DASHBOARD\",\"privilege_id\":1185},{\"activity_id\":159,\"privilege_desc\":\"V4_MYTIMETABLE\",\"activity_desc\":\"V4_DASHBOARD\",\"privilege_id\":1186},{\"activity_id\":168,\"privilege_desc\":\"V4_LOGOUT\",\"activity_desc\":\"V4_LOGOUT\",\"privilege_id\":1210}],\"resultPrivilege\":\"0\",\"resultProfile\":\"0\"}');
  /*var pageData={
    "exercise":"Just Lift",
    "mode":"Standard",
  };*/
  var pageData=json.decode('{\"exercise\":\"Just Lift\",'
      '\"mode\":\"Standard\",'
      '\"weight\":\"1000 KG\",'
      '\"activeTime\":\"2Min\",'
      '\"accuracy\":\"95%\",'
      '\"sessionTime\":\"20 Min\",'
      '\"power\":\"300 KW\",'
      '\"avgLoad\":\"20 KG\",'
      '\"maxLoad\":\"30 KG\",'
      '\"avgHeartRate\":\"120 BPM\",'
      '\"maxHeartRate\":\"160 BPM\",'
      '\"time\":\"2\",'
      '\"kcal\":\"500\",'
      '\"reps\":\"10\"}');

  Widget _getGauge({bool isRadialGauge = true}) {
    if (isRadialGauge) {
      return _getRadialGauge();
    } else {
      return _getLinearGauge();
    }
  }

  Widget _getRadialGauge() {
    return Container(
      //width: 230,
      child:
      cp1.SfRadialGauge(
          axes: <cp1.RadialAxis>[
            cp1.RadialAxis(minimum: 0,
                maximum: 100,
                //startAngle: 180,
                //endAngle: 0,
                showLabels: false,
                showTicks: false,
                radiusFactor: 0.6,
                axisLineStyle: cp1.AxisLineStyle(
                    cornerStyle: cp1.CornerStyle.bothFlat,
                    color: Colors.white60,
                    thickness: 18),
                pointers: <cp1.GaugePointer>[
                  cp1.RangePointer(
                      value: _volumeValue,
                      cornerStyle: cp1.CornerStyle.bothCurve,
                      width: 18,
                      sizeUnit: cp1.GaugeSizeUnit.logicalPixel,
                      color:  Colors.greenAccent,
                      gradient: const SweepGradient(
                          colors: <Color>[
                            Color(0XFFFFD180),
                            Color(0XFFFFAB40)
                          ],
                          stops: <double>[0.25, 0.75]
                      )),
                  cp1.MarkerPointer(
                    value: 50, // We declared this in state class.
                    color: Colors.blueAccent,
                    enableDragging: true,
                    borderColor: Colors.blueAccent,
                    markerHeight: 25,
                    borderWidth: 5,
                    markerWidth: 25,
                    markerType: cp1.MarkerType.circle,
                    //onValueChanged: _handleSecondPointerValueChanged,
                    //onValueChanging: _handleSecondPointerValueChanging,

                  ),
                ],
                annotations: <cp1.GaugeAnnotation>[
                  cp1.GaugeAnnotation(
                      angle: 90,
                      axisValue: 5,
                      positionFactor: 0.1,
                      widget: Text(_volumeValue.ceil()
                          .toString(),
                          style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight
                                  .bold,
                              color: Color(0XFFFFAB40)))
                  )
                ]
            )
          ]
      ),
    );
  }

  Widget _getLinearGauge() {
    return Container(
      child: cp1.SfLinearGauge(
          minimum: 0.0,
          maximum: 10.0,
          markerPointers: [cp1.LinearShapePointer(value: 5,color: Colors.deepOrange,markerAlignment: cp1.LinearMarkerAlignment.center,)],
          orientation: cp1.LinearGaugeOrientation.horizontal,
          //majorTickStyle: LinearTickStyle(length: 20),
          axisLabelStyle: TextStyle(fontSize: 12.0, color: Colors.white),
          axisTrackStyle: cp1.LinearAxisTrackStyle(
              color: Colors.cyan,
              edgeStyle: cp1.LinearEdgeStyle.bothCurve,
              thickness: 15.0,
              borderColor: Colors.grey)),
      margin: EdgeInsets.all(10),
    );
  }
  Widget circularGauge(){
    return Container(
      child: cp1.SfRadialGauge(
          axes: <cp1.RadialAxis>[
            cp1.RadialAxis(minimum: 0,
                maximum: 10,
                startAngle: 0,
                endAngle: 360,
                showLabels: false,
                showTicks: false,
                radiusFactor: 0.6,
                axisLineStyle: cp1.AxisLineStyle(
                    cornerStyle: cp1.CornerStyle.bothFlat,
                    color: Colors.grey,
                    thickness: 12),
                pointers: <cp1.GaugePointer>[
                  cp1.RangePointer(
                    value: _volumeValue,
                    cornerStyle: cp1.CornerStyle.bothFlat,
                    width: 12,
                    sizeUnit: cp1.GaugeSizeUnit.logicalPixel,
                    color:  Color(0xFFAD1457),
                  ),
                  cp1.MarkerPointer(
                      value: 50,
                      enableDragging: true,
                      onValueChanged: onVolumeChanged,
                      markerHeight: 20,
                      markerWidth: 20,
                      markerType: cp1.MarkerType.circle,
                      color: Color(0xFFF8BBD0),
                      borderWidth: 2,
                      borderColor: Colors.white54)
                ],
                annotations: <cp1.GaugeAnnotation>[
                  cp1.GaugeAnnotation(
                      angle: 90,
                      axisValue: 5,
                      positionFactor: 0.1,
                      widget: Text(_volumeValue.ceil()
                          .toString(),
                          style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight
                                  .bold,
                              color: Color(0XFFFFAB40)))
                  )
                ]
            )
          ]
      ),

    );
  }

  Widget _getLinearGaugeVertical() {
    return Container(
      height: 300,
      width: 60,
      child: cp1.SfLinearGauge(
          minimum: 0.0,
          maximum: 10.0,
          markerPointers: [cp1.LinearWidgetPointer(
            value: 5,
            child: Container(height: 14, width: 14, color: Colors.redAccent),
          ),],
          orientation: cp1.LinearGaugeOrientation.vertical,
          //majorTickStyle: LinearTickStyle(length: 20),
          axisLabelStyle: TextStyle(fontSize: 12.0, color: Colors.white),
          axisTrackStyle: cp1.LinearAxisTrackStyle(
              color: Colors.cyan,
              edgeStyle: cp1.LinearEdgeStyle.bothCurve,
              thickness: 15.0,
              borderColor: Colors.grey)),
      margin: EdgeInsets.all(10),
    );
  }

  final List<ChartData> chartData = [
    ChartData("Rip1", 23),
    ChartData("Rip2", 49),
    ChartData("Rip3", 12),
    ChartData("Rip4", 33),
    ChartData("Rip5", 30)
  ];

  Widget _getChart() {
    return Container(
      child: cp2.SfCartesianChart(
        series: <cp2.CartesianSeries<ChartData, String>>[
          cp2.ColumnSeries<ChartData, String>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              // Width of the columns
              width: 0.8,
              // Spacing between the columns
              spacing: 0.2
          )
        ],
        primaryXAxis:
        cp2.CategoryAxis(
            majorGridLines: const cp2.MajorGridLines(width: 0),
            labelPosition: cp2.ChartDataLabelPosition.inside,
            labelRotation: 270,
            labelStyle: TextStyle(
                fontSize: 18, // size in Pts.
                color: Colors.white),
            edgeLabelPlacement: cp2.EdgeLabelPlacement.shift
        ),
        primaryYAxis:
        cp2.CategoryAxis(
          majorGridLines: const cp2.MajorGridLines(width: 0),
          labelStyle: TextStyle(
              fontSize: 18, // size in Pts.
              color: Colors.white),
        ),

      ),
      margin: EdgeInsets.all(10),
      height: 200,
    );
  }
  @override
  void initState() {
    super.initState();
    _animController =
    AnimationController(vsync: this, duration: Duration(seconds: 1))
      ..repeat();
  }
  final f = new DateFormat('EEEE MMM yyyy');
  @override
  void dispose() {
    super.dispose();
    _animController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(child:
        Column(
          children: [
            Row(children: [
              Text("Summary",style: TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.bold),)
            ],),
            Row(children: [
              Text(DateFormat('EEEE, MMM yy').format(DateTime.now()),style: TextStyle(fontSize: 18,color: Colors.white),)
            ],),
            SizedBox(height: 20,),
            Row(children: [
              Text("Exercise",style: TextStyle(fontSize: 20,color: Colors.white),)
            ],),
            Row(children: [
              Text(pageData['exercise'],style: TextStyle(fontSize: 18,color: Colors.white),)
            ],),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              Column(children: [
                Text("Weight Mode",style: TextStyle(fontSize: 20,color: Colors.white),)
              ],),
              Column(children: [
                Text("Total Weight",style: TextStyle(fontSize: 20,color: Colors.white),)
              ],),
            ],),
            //SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(children: [
                  Text(pageData['mode'],style: TextStyle(fontSize: 18,color: Colors.white),)
                ],),
                Column(children: [
                  Text(pageData['weight'],style: TextStyle(fontSize: 18,color: Colors.white),)
                ],),
              ],),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(children: [
                  Text("Active Time",style: TextStyle(fontSize: 20,color: Colors.white),)
                ],),
                Column(children: [
                  Text("Movement Accuracy",style: TextStyle(fontSize: 20,color: Colors.white),)
                ],),
              ],),
            //SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(children: [
                  Text(pageData['activeTime'],style: TextStyle(fontSize: 18,color: Colors.white),)
                ],),
                Column(children: [
                  Text(pageData['accuracy'],style: TextStyle(fontSize: 18,color: Colors.white),)
                ],),
              ],),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(children: [
                  Text("Session Time",style: TextStyle(fontSize: 20,color: Colors.white),)
                ],),
                Column(children: [
                  Text("Power",style: TextStyle(fontSize: 20,color: Colors.white),)
                ],),
              ],),
            //SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(children: [
                  Text(pageData['sessionTime'],style: TextStyle(fontSize: 18,color: Colors.white),)
                ],),
                Column(children: [
                  Text(pageData['power'],style: TextStyle(fontSize: 18,color: Colors.white),)
                ],),
              ],),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(children: [
                  Text("Avg. Load",style: TextStyle(fontSize: 20,color: Colors.white),)
                ],),
                Column(children: [
                  Text("Max Load",style: TextStyle(fontSize: 20,color: Colors.white),)
                ],),
              ],),
            //SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(children: [
                  Text(pageData['avgLoad'],style: TextStyle(fontSize: 18,color: Colors.white),)
                ],),
                Column(children: [
                  Text(pageData['maxLoad'],style: TextStyle(fontSize: 18,color: Colors.white),)
                ],),
              ],),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(children: [
                  Text("Avg. Heart Rate",style: TextStyle(fontSize: 20,color: Colors.white),)
                ],),
                Column(children: [
                  Text("Max Heart Rate",style: TextStyle(fontSize: 20,color: Colors.white),)
                ],),
              ],),
            //SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(children: [
                  Text(pageData['avgHeartRate'],style: TextStyle(fontSize: 18,color: Colors.white),)
                ],),
                Column(children: [
                  Text(pageData['maxHeartRate'],style: TextStyle(fontSize: 18,color: Colors.white),)
                ],),
              ],),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                Column(children: [
                  Container(
                    width: 120,
                    height: 200,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(100)),gradient: LinearGradient(colors: [Colors.grey,Colors.white30])),
                    child:
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(width:50,child: Image.asset(
                              'assets/images/watch.png',
                              fit: BoxFit.cover,
                            ),),
                            Text("Minutes",style: TextStyle(fontSize: 30,color: Colors.black,fontWeight: FontWeight.bold),),
                            Text(pageData['time'],style: TextStyle(fontSize: 30,color: Colors.black,fontWeight: FontWeight.bold),),
                          ],
                        ),
                    /*child: Center(child:
                        Column(children: [
                          Row(children: [
                              Text("Minutes",style: TextStyle(fontSize: 30,color: Colors.red),),

                          ],),
                        ],),
                    ),*/
                  ),
                ],),
                Column(children: [
                  Container(
                    width: 120,
                    height: 200,
                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(100)),gradient: LinearGradient(colors: [Colors.grey,Colors.white30])),
                    child:                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(width:100,child: Image.asset(
                          'assets/images/kcal-1.png',
                          fit: BoxFit.cover,
                        ),),
                        Text("KCal",style: TextStyle(fontSize: 30,color: Colors.black,fontWeight: FontWeight.bold),),
                        Text(pageData['kcal'],style: TextStyle(fontSize: 30,color: Colors.black,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  )
                ],),
                Column(children: [
                  Container(
                    width: 120,
                    height: 200,
                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(100)),gradient: LinearGradient(colors: [Colors.grey,Colors.white30])),
                    child:                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(width:120,child: Image.asset(
                          'assets/images/dumbbell-1.png',
                          fit: BoxFit.cover,
                        ),),
                        Text("Reps",style: TextStyle(fontSize: 30,color: Colors.black,fontWeight: FontWeight.bold),),
                        Text(pageData['reps'],style: TextStyle(fontSize: 30,color: Colors.black,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  )
                ],)
              ],)

          ],
        ),
      ),
      ),
    );
  }
}
class ChartData {
  ChartData(this.x, this.y);

  final String x;
  final double y;
}