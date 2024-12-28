
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








// // import 'package:flutter/material.dart';
// // import 'package:syncfusion_flutter_gauges/gauges.dart' as cp1;
// // import 'blue_communication.dart'; // Import your Bluetooth communication file.
// // import 'package:indafit/exerciseStatus_1.dart';
// //
// // class RangeMotionPage extends StatefulWidget {
// //   RangeMotionPage({Key? key}) : super(key: key);
// //
// //   @override
// //   RangeMotionPageState createState() => RangeMotionPageState();
// // }
// //
// // class RangeMotionPageState extends State<RangeMotionPage> {
// //   double _currentValue = 0;
// //   int repCount = 1;
// //   bool firstEvent = true;
// //   List<double> startPositions = [];
// //   List<double> endPositions = [];
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     // Initialize Bluetooth or any necessary data.
// //   }
// //
// //   void onBluetoothValueReceived(double value) {
// //     setState(() {
// //       _currentValue = value; // Update gauge value dynamically.
// //     });
// //   }
// //
// //   void captureValue() {
// //     // Capture value based on current event (start or end position).
// //     setState(() {
// //       if (firstEvent) {
// //         startPositions.add(_currentValue);
// //       } else {
// //         endPositions.add(_currentValue);
// //       }
// //
// //       // Toggle event and update repetition count.
// //       firstEvent = !firstEvent;
// //       if (!firstEvent && startPositions.length == 3) {
// //         // Move to the next page when 3 repetitions are complete.
// //         Navigator.push(
// //           context,
// //           MaterialPageRoute(
// //               builder: (context) => ExerciseStatusPage()), // Navigate to next screen.
// //         );
// //       }
// //     });
// //   }
// //
// //   Widget _getRadialGauge() {
// //     return Container(
// //       child: cp1.SfRadialGauge(
// //         axes: <cp1.RadialAxis>[
// //           cp1.RadialAxis(
// //             minimum: 0,
// //             maximum: 100,
// //             showLabels: false,
// //             showTicks: false,
// //             radiusFactor: 0.6,
// //             axisLineStyle: cp1.AxisLineStyle(
// //               cornerStyle: cp1.CornerStyle.bothFlat,
// //               color: Colors.white60,
// //               thickness: 18,
// //             ),
// //             pointers: <cp1.GaugePointer>[
// //               cp1.RangePointer(
// //                 value: _currentValue,
// //                 cornerStyle: cp1.CornerStyle.bothCurve,
// //                 width: 18,
// //                 color: Colors.greenAccent,
// //               ),
// //             ],
// //             annotations: <cp1.GaugeAnnotation>[
// //               cp1.GaugeAnnotation(
// //                 angle: 90,
// //                 positionFactor: 0.1,
// //                 widget: Text(
// //                   _currentValue.toStringAsFixed(1),
// //                   style: TextStyle(
// //                     fontSize: 20,
// //                     fontWeight: FontWeight.bold,
// //                     color: Colors.orange,
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.black,
// //       body: SafeArea(
// //         child: Column(
// //           children: [
// //             _getRadialGauge(), // Display the radial gauge.
// //             Expanded(
// //               child: Container(
// //                 decoration: BoxDecoration(
// //                   gradient: LinearGradient(
// //                     colors: [Colors.lightGreenAccent, Colors.white60],
// //                   ),
// //                 ),
// //                 child: Column(
// //                   children: [
// //                     SizedBox(height: 10),
// //                     Text(
// //                       "Calibrate your Range of Motion",
// //                       style: TextStyle(color: Colors.black, fontSize: 18),
// //                     ),
// //                     Row(
// //                       mainAxisAlignment: MainAxisAlignment.center,
// //                       children: [
// //                         Text(
// //                           "$repCount",
// //                           style: TextStyle(
// //                             color: Colors.black,
// //                             fontSize: 30,
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                         ),
// //                         Text(
// //                           " of 3 Repetitions",
// //                           style: TextStyle(color: Colors.black, fontSize: 18),
// //                         ),
// //                       ],
// //                     ),
// //                     SizedBox(height: 60),
// //                     Column(
// //                       mainAxisAlignment: MainAxisAlignment.center,
// //                       children: [
// //                         Text(
// //                           firstEvent
// //                               ? "Move to Start Position"
// //                               : "Move to End Position",
// //                           style: TextStyle(
// //                             color: Colors.black,
// //                             fontSize: 30,
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                         ),
// //                         Text(
// //                           "[Hold for 3 seconds]",
// //                           style: TextStyle(color: Colors.black, fontSize: 18),
// //                         ),
// //                       ],
// //                     ),
// //                     SizedBox(height: 60),
// //                     ElevatedButton(
// //                       onPressed: captureValue,
// //                       child: Text("Capture"),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
//
//
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_gauges/gauges.dart' as cp1;
//
// import 'exerciseStatus_1.dart';
//
// class RangeMotionPage extends StatefulWidget {
//   RangeMotionPage({Key? key}) : super(key: key);
//
//   @override
//   RangeMotionPageState createState() => RangeMotionPageState();
// }
//
// class RangeMotionPageState extends State<RangeMotionPage> {
//   double _currentValue = -1;
//   int repCount = 1;
//   bool firstEvent = true;
//   List<double> startPositions = [];
//   List<double> endPositions = [];
//   Timer? _timer;
//
//   @override
//   void initState() {
//     super.initState();
//     startTimer();
//     captureValue();// Start the timer when the widget is initialized.
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel(); // Cancel the timer when the widget is disposed.
//     super.dispose();
//   }
//
//   void startTimer() {
//     _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
//       double simulatedValue = generateSimulatedValue(); // Generate a new value.
//       onBluetoothValueReceived(simulatedValue); // Update the gauge with the new value.
//     });
//   }
//
//   double generateSimulatedValue() {
//     if (!firstEvent){return -1000.0;}
//     else{
//       return -3000.0;
//     }
//   }
//
//
//   void onBluetoothValueReceived(double value) {
//     setState(() {
//       _currentValue = value; // Update gauge value dynamically.
//     });
//   }
//
//   void captureValue() {
//     // Capture value based on current event (start or end position).
//     setState(() {
//       if (firstEvent) {
//           startPositions.add(_currentValue);
//       } else {
//         endPositions.add(_currentValue);
//       }
//
//       // Toggle event and update repetition count.
//       firstEvent = !firstEvent;
//       if (!firstEvent && startPositions.length == 3) {
//         // Move to the next page when 3 repetitions are complete.
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => ExerciseStatusPage()), // Navigate to next screen.
//         );
//         // return;
//       }
//       // else{
//       //   captureValue();
//       // }
//     });
//   }
//
//   Widget _getRadialGauge() {
//     return Container(
//       child: cp1.SfRadialGauge(
//         axes: <cp1.RadialAxis>[
//           cp1.RadialAxis(
//             minimum: 0,
//             maximum: 100,
//             showLabels: false,
//             showTicks: false,
//             radiusFactor: 0.6,
//             axisLineStyle: cp1.AxisLineStyle(
//               cornerStyle: cp1.CornerStyle.bothFlat,
//               color: Colors.white60,
//               thickness: 18,
//             ),
//             pointers: <cp1.GaugePointer>[
//               cp1.RangePointer(
//                 value: _currentValue,
//                 cornerStyle: cp1.CornerStyle.bothCurve,
//                 width: 18,
//                 color: Colors.greenAccent,
//               ),
//             ],
//             annotations: <cp1.GaugeAnnotation>[
//               cp1.GaugeAnnotation(
//                 angle: 90,
//                 positionFactor: 0.1,
//                 widget: Text(
//                   _currentValue.toStringAsFixed(1),
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.orange,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Column(
//           children: [
//             _getRadialGauge(), // Display the radial gauge.
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.lightGreenAccent, Colors.white60],
//                   ),
//                 ),
//                 child: Column(
//                   children: [
//                     SizedBox(height: 10),
//                     Text(
//                       "Calibrate your Range of Motion",
//                       style: TextStyle(color: Colors.black, fontSize: 18),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "$repCount",
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 30,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           " of 3 Repetitions",
//                           style: TextStyle(color: Colors.black, fontSize: 18),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 60),
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           firstEvent
//                               ? "Move to Start Position"
//                               : "Move to End Position",
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 30,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           "[Hold for 3 seconds]",
//                           style: TextStyle(color: Colors.black, fontSize: 18),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 60),
//                     ElevatedButton(
//                       onPressed: captureValue,
//                       child: Text("Capture"),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

