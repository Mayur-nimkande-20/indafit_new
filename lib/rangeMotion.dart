import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart' as cp1;
import 'package:syncfusion_flutter_charts/charts.dart' as cp2;
import 'exerciseStatus_1.dart';

class RangeMotionPage extends StatefulWidget {
  RangeMotionPage({Key? key}) : super(key: key);

  @override
  RangeMotionPageState createState() => RangeMotionPageState();
}

double _volumeValue = -1;

class RangeMotionDetector {
  final List<double> _values = [];
  final int _requiredStableCount;
  final double _tolerance;

  RangeMotionDetector({
    int requiredStableCount = 30,
    double tolerance = 2.0,
  })  : _requiredStableCount = requiredStableCount,
        _tolerance = tolerance;

  bool addValue(double value) {
    _values.add(value);
    if (_values.length > _requiredStableCount) {
      _values.removeAt(0);
    }

    if (_values.length == _requiredStableCount && _isStable()) {
      return true;
    }
    return false;
  }

  bool _isStable() {
    final double average =
        _values.reduce((a, b) => a + b) / _values.length;
    return _values.every((value) => (value - average).abs() <= _tolerance);
  }

  double get average => _values.reduce((a, b) => a + b) / _values.length;
}

class RangeMotionPageState extends State<RangeMotionPage> {
  Timer? _timer;
  int repCount = 1;
  bool firstEvent = true;
  final RangeMotionDetector startPositionDetector = RangeMotionDetector();
  final RangeMotionDetector endPositionDetector = RangeMotionDetector();
  double? startPosition;
  double? endPosition;

  void startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      double simulatedValue = firstEvent ? 1000 : 3000;
      onBluetoothValueReceived(simulatedValue);
    });
  }

  void onBluetoothValueReceived(double value) {
    setState(() {
      _volumeValue = value;

      if (firstEvent && startPosition == null) {
        if (startPositionDetector.addValue(value)) {
          startPosition = startPositionDetector.average;
          print("Start Position Detected: $startPosition");
        }
      } else if (!firstEvent && endPosition == null) {
        if (endPositionDetector.addValue(value)) {
          endPosition = endPositionDetector.average;
          print("End Position Detected: $endPosition");
        }
      }

      if (startPosition != null && endPosition != null) {
        if (firstEvent) {
          firstEvent = false;
        } else {
          firstEvent = true;
          repCount += 1;
          if (repCount == 4) {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ExerciseStatusPage()));
          }
          startPosition = null;
          endPosition = null;
        }
      }
    });
  }

  Widget circularGauge() {
    return Container(
      child: cp1.SfRadialGauge(
          axes: <cp1.RadialAxis>[
            cp1.RadialAxis(
              minimum: 0,
              maximum: 4000,
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
                  color: Color(0xFFAD1457),
                ),
                cp1.MarkerPointer(
                  value: _volumeValue,
                  enableDragging: true,
                  markerHeight: 20,
                  markerWidth: 20,
                  markerType: cp1.MarkerType.circle,
                  color: Color(0xFFF8BBD0),
                  borderWidth: 2,
                  borderColor: Colors.white54,
                ),
              ],
              annotations: <cp1.GaugeAnnotation>[
                cp1.GaugeAnnotation(
                  angle: 90,
                  axisValue: 5,
                  positionFactor: 0.1,
                  widget: Text(
                    _volumeValue.ceil().toString(),
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Color(0XFFFFAB40),
                    ),
                  ),
                )
              ],
            ),
          ]),
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            circularGauge(),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.lightGreenAccent, Colors.white60],
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Calibrate your Range of Motion",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          repCount.toString(),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "   of   ",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                        Text(
                          "3",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "    Repetitions",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ],
                    ),
                    SizedBox(height: 60),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (firstEvent) ...[
                          Text(
                            "Go to Start Position",
                            style:
                            TextStyle(color: Colors.black, fontSize: 30),
                          ),
                          Text(
                            "[hold for 3 sec]",
                            style:
                            TextStyle(color: Colors.black, fontSize: 30),
                          ),
                        ] else ...[
                          Text(
                            "Go to End Position",
                            style:
                            TextStyle(color: Colors.black, fontSize: 30),
                          ),
                          Text(
                            "[hold for 3 sec]",
                            style:
                            TextStyle(color: Colors.black, fontSize: 30),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 60),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 100),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (firstEvent) {
                                  firstEvent = false;
                                } else {
                                  firstEvent = true;
                                  repCount += 1;
                                  if (repCount == 4) {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ExerciseStatusPage(),
                                      ),
                                    );
                                  }
                                }
                              });
                            },
                            child: Text("Done"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




// import 'dart:async';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_gauges/gauges.dart' as cp1;
// import 'package:syncfusion_flutter_charts/charts.dart' as cp2;
// import 'package:indafit/main.dart';
// import 'package:indafit/exerciseStatus_1.dart';
// import 'package:indafit/login.dart';
//
// /*void main() async {
//   // Fetch the available cameras before initializing the app.
//
//   runApp(const GymApp());
// }*/
// /*
//
// void main() {
//   return runApp(GaugeApp());
// }
//
// /// Represents the GaugeApp class
// class GaugeApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Radial Gauge Demo',
//       theme: ThemeData(primarySwatch: Colors.blue,scaffoldBackgroundColor: const Color(0xFFEFEFEF)),
//       home: RangeMotionPage(),
//     );
//   }
// }
//
// */
//
// /// Represents MyHomePage class
// class RangeMotionPage extends StatefulWidget {
//   /// Creates the instance of MyHomePage
//   RangeMotionPage({Key? key}) : super(key: key);
//
//
//   @override
//   RangeMotionPageState createState() => RangeMotionPageState();
// }
// double _volumeValue = -1;
//
// double onVolumeChanged() {
//   // setState(() {
//   return _volumeValue;
//   // });
// }
//
//
// class RangeMotionPageState extends State<RangeMotionPage> with SingleTickerProviderStateMixin {
//   //late AnimationController _animController;
//   Timer? _timer;
//   int repCount=1;
//   bool firstEvent=true;
//   Widget _getGauge({bool isRadialGauge = true}) {
//     if (isRadialGauge) {
//       return _getRadialGauge();
//     } else {
//       return _getLinearGauge();
//     }
//   }
//
//
//   void startTimer() {
//     _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
//       // double simulatedValue = generateSimulatedValue(); // Generate a new value.
//       if (firstEvent){
//         onBluetoothValueReceived(1000); // Update the gauge with the new value.
//       }
//       else{
//         onBluetoothValueReceived(3000); // Update the gauge with the new value.
//       }
//     });
//   }
//
//
//   void onBluetoothValueReceived(double value) {
//     setState(() {
//       _volumeValue = value; // Update gauge value dynamically.
//     });
//   }
//
//
//
//   Widget _getRadialGauge() {
//     return Container(
//       //width: 230,
//       child:
//       cp1.SfRadialGauge(
//           axes: <cp1.RadialAxis>[
//             cp1.RadialAxis(minimum: 0,
//                 maximum: 100,
//                 //startAngle: 180,
//                 //endAngle: 0,
//                 showLabels: false,
//                 showTicks: false,
//                 radiusFactor: 0.6,
//                 axisLineStyle: cp1.AxisLineStyle(
//                     cornerStyle: cp1.CornerStyle.bothFlat,
//                     color: Colors.white60,
//                     thickness: 18),
//                 pointers: <cp1.GaugePointer>[
//                   cp1.RangePointer(
//                       value: _volumeValue,
//                       cornerStyle: cp1.CornerStyle.bothCurve,
//                       width: 18,
//                       sizeUnit: cp1.GaugeSizeUnit.logicalPixel,
//                       color:  Colors.greenAccent,
//                       gradient: const SweepGradient(
//                           colors: <Color>[
//                             Color(0XFFFFD180),
//                             Color(0XFFFFAB40)
//                           ],
//                           stops: <double>[0.25, 0.75]
//                       )),
//                   cp1.MarkerPointer(
//                     value: 50, // We declared this in state class.
//                     color: Colors.blueAccent,
//                     enableDragging: true,
//                     borderColor: Colors.blueAccent,
//                     markerHeight: 25,
//                     borderWidth: 5,
//                     markerWidth: 25,
//                     markerType: cp1.MarkerType.circle,
//                     //onValueChanged: _handleSecondPointerValueChanged,
//                     //onValueChanging: _handleSecondPointerValueChanging,
//
//                   ),
//                 ],
//                 annotations: <cp1.GaugeAnnotation>[
//                   cp1.GaugeAnnotation(
//                       angle: 90,
//                       axisValue: 5,
//                       positionFactor: 0.1,
//                       widget: Text(_volumeValue.ceil()
//                           .toString(),
//                           style: TextStyle(
//                               fontSize: 50,
//                               fontWeight: FontWeight
//                                   .bold,
//                               color: Color(0XFFFFAB40)))
//                   )
//                 ]
//             )
//           ]
//       ),
//     );
//   }
//
//   Widget _getLinearGauge() {
//     return Container(
//       child: cp1.SfLinearGauge(
//           minimum: 0.0,
//           maximum: 10.0,
//           markerPointers: [cp1.LinearShapePointer(value: 5,color: Colors.deepOrange,markerAlignment: cp1.LinearMarkerAlignment.center,)],
//           orientation: cp1.LinearGaugeOrientation.horizontal,
//           //majorTickStyle: LinearTickStyle(length: 20),
//           axisLabelStyle: TextStyle(fontSize: 12.0, color: Colors.white),
//           axisTrackStyle: cp1.LinearAxisTrackStyle(
//               color: Colors.cyan,
//               edgeStyle: cp1.LinearEdgeStyle.bothCurve,
//               thickness: 15.0,
//               borderColor: Colors.grey)),
//       margin: EdgeInsets.all(10),
//     );
//   }
//   Widget circularGauge(){
//     return Container(
//       child: cp1.SfRadialGauge(
//           axes: <cp1.RadialAxis>[
//             cp1.RadialAxis(minimum: 0,
//               maximum: 4000,
//               startAngle: 0,
//               endAngle: 360,
//               showLabels: false,
//               showTicks: false,
//               radiusFactor: 0.6,
//               axisLineStyle: cp1.AxisLineStyle(
//                   cornerStyle: cp1.CornerStyle.bothFlat,
//                   color: Colors.grey,
//                   thickness: 12),
//               pointers: <cp1.GaugePointer>[
//                 cp1.RangePointer(
//                   value: _volumeValue,
//                   onValueChanged: onBluetoothValueReceived,
//                   // onValueChanging:,
//                   // onValueChangeStart: ,
//                   // onValueChangeEnd: ,
//                   cornerStyle: cp1.CornerStyle.bothFlat,
//                   width: 12,
//                   sizeUnit: cp1.GaugeSizeUnit.logicalPixel,
//                   color:  Color(0xFFAD1457),
//                 ),
//                 cp1.MarkerPointer(
//                     value: _volumeValue,
//                     enableDragging: true,
//                     // onValueChanged: onVolumeChanged,
//                     onValueChanged: onBluetoothValueReceived,
//                     markerHeight: 20,
//                     markerWidth: 20,
//                     markerType: cp1.MarkerType.circle,
//                     color: Color(0xFFF8BBD0),
//                     borderWidth: 2,
//                     borderColor: Colors.white54)
//               ],
//                 annotations: <cp1.GaugeAnnotation>[
//                   cp1.GaugeAnnotation(
//                       angle: 90,
//                       axisValue: 5,
//                       positionFactor: 0.1,
//                       widget: Text(
//                           _volumeValue.ceil()
//                           .toString(),
//                           style: TextStyle(
//                               fontSize: 50,
//                               fontWeight: FontWeight
//                                   .bold,
//                               color: Color(0XFFFFAB40)))
//                   )
//                 ]
//             )
//           ]
//       ),
//
//     );
//   }
//
//   Widget _getLinearGaugeVertical() {
//     return Container(
//       height: 300,
//       width: 60,
//       child: cp1.SfLinearGauge(
//           minimum: 0.0,
//           maximum: 10.0,
//           markerPointers: [cp1.LinearWidgetPointer(
//             value: 5,
//             child: Container(height: 14, width: 14, color: Colors.redAccent),
//           ),],
//           orientation: cp1.LinearGaugeOrientation.vertical,
//           //majorTickStyle: LinearTickStyle(length: 20),
//           axisLabelStyle: TextStyle(fontSize: 12.0, color: Colors.white),
//           axisTrackStyle: cp1.LinearAxisTrackStyle(
//               color: Colors.cyan,
//               edgeStyle: cp1.LinearEdgeStyle.bothCurve,
//               thickness: 15.0,
//               borderColor: Colors.grey)),
//       margin: EdgeInsets.all(10),
//     );
//   }
//
//   final List<ChartData> chartData = [
//     ChartData("Rip1", 23),
//     ChartData("Rip2", 49),
//     ChartData("Rip3", 12),
//     ChartData("Rip4", 33),
//     ChartData("Rip5", 30)
//   ];
//
//   Widget _getChart() {
//     return Container(
//       child: cp2.SfCartesianChart(
//         series: <cp2.CartesianSeries<ChartData, String>>[
//           cp2.ColumnSeries<ChartData, String>(
//               dataSource: chartData,
//               xValueMapper: (ChartData data, _) => data.x,
//               yValueMapper: (ChartData data, _) => data.y,
//               // Width of the columns
//               width: 0.8,
//               // Spacing between the columns
//               spacing: 0.2
//           )
//         ],
//         primaryXAxis:
//         cp2.CategoryAxis(
//             majorGridLines: const cp2.MajorGridLines(width: 0),
//             labelPosition: cp2.ChartDataLabelPosition.inside,
//             labelRotation: 270,
//             labelStyle: TextStyle(
//                 fontSize: 18, // size in Pts.
//                 color: Colors.white),
//             edgeLabelPlacement: cp2.EdgeLabelPlacement.shift
//         ),
//         primaryYAxis:
//         cp2.CategoryAxis(
//           majorGridLines: const cp2.MajorGridLines(width: 0),
//           labelStyle: TextStyle(
//               fontSize: 18, // size in Pts.
//               color: Colors.white),
//         ),
//
//       ),
//       margin: EdgeInsets.all(10),
//       height: 200,
//     );
//   }
//   @override
//   void initState() {
//     super.initState();
//     startTimer();
//     //_animController =
//     //AnimationController(vsync: this, duration: Duration(seconds: 1))
//     //  ..repeat();
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//     //_animController.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Column(
//           children: [
//             circularGauge(),
//             Expanded(
//                 child: Container(
//                   decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.lightGreenAccent,Colors.white60])),
//                   child:
//             Column(children: [
//               SizedBox(height: 10,),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text("Calibrate you Range of Motion",style: TextStyle(color: Colors.black,fontSize: 18),),
//               ],),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text( repCount.toString() ,style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold),),
//                   Text( "   of   ",style: TextStyle(color: Colors.black,fontSize: 18),),
//                   Text( " 3",style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold),),
//                   Text( "    Repetations",style: TextStyle(color: Colors.black,fontSize: 18),),
//                 ],),
//               SizedBox(height: 60,),
//               //Center(child:Text("Go to Start Position[hold for 3 sec]",style: TextStyle(color: Colors.black,fontSize: 18),)),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                  /* FadeTransition(
//                     opacity: _animController,
//                     child: Text(
//                       'Blinking Text',
//                       style: TextStyle(fontSize: 30),
//                     ),
//                   ),*/
//                   if (firstEvent) ...[
//                     Text("Go to Start Position",style: TextStyle(color: Colors.black,fontSize: 30),),
//                     Text("[hold for 3 sec]",style: TextStyle(color: Colors.black,fontSize: 30),),
//                   ]
//                 else ...[
//                     Text("Go to End Position",style: TextStyle(color: Colors.black,fontSize: 30),),
//                     Text("[hold for 3 sec]",style: TextStyle(color: Colors.black,fontSize: 30),),
//                   ],
//                   ],),
//               SizedBox(height: 60,),
//               Row(children: [
//                 Padding(padding: EdgeInsets.only(left:100),child:
//                 ElevatedButton(onPressed: (){setState(() {
//                   if (firstEvent) {
//                     firstEvent=false;
//                   }
//                   else{
//                     firstEvent=true;
//                     repCount+=1;
//                     if(repCount==4){
//                       Navigator.pop(context);
//                       Navigator.push(context,MaterialPageRoute(builder: (context) => ExerciseStatusPage()));
//                     }
//                   }
//                   //print("Pressed");
//                 });}, child: Text("Done"))
//                 ),
//               ],)
//             ],),
//             ),
//             ),
//           ],
//         )
//         ,
//       ),
//     );
//   }
// }
// class ChartData {
//   ChartData(this.x, this.y);
//
//   final String x;
//   final double y;
// }