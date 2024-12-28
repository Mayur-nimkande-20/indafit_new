// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive/hive.dart';
import 'package:video_player/video_player.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart' as cp1;
import 'package:syncfusion_flutter_charts/charts.dart' as cp2;
import 'package:indafit/rangeMotionSummary.dart';
/// Camera example home widget.
class ExerciseStatusPage extends StatefulWidget {
  /// Default Constructor
  const ExerciseStatusPage({super.key});

  @override
  State<ExerciseStatusPage> createState() {
    return ExerciseStatusPageState();
  }
}
double _volumeValue = 50;

void onVolumeChanged(double value) {
  //setState(() {
  _volumeValue = value;
  //});
}
/// Returns a suitable camera icon for [direction].
IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
  }
  // This enum is from a different package, so a new value could be added at
  // any time. The example should keep working if that happens.
  // ignore: dead_code
  return Icons.camera;
}

void _logError(String code, String? message) {
  // ignore: avoid_print
  print('Error: $code${message == null ? '' : '\nError Message: $message'}');
}

class ExerciseStatusPageState extends State<ExerciseStatusPage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  CameraController? controller;
  XFile? imageFile;
  XFile? videoFile;
  VideoPlayerController? videoController;
  VoidCallback? videoPlayerListener;
  bool enableAudio = true;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _currentExposureOffset = 0.0;
  late AnimationController _flashModeControlRowAnimationController;
  late Animation<double> _flashModeControlRowAnimation;
  late AnimationController _exposureModeControlRowAnimationController;
  late Animation<double> _exposureModeControlRowAnimation;
  late AnimationController _focusModeControlRowAnimationController;
  late Animation<double> _focusModeControlRowAnimation;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _currentScale = 1.0;
  double _baseScale = 1.0;

  // Counting pointers (number of user fingers on screen)
  int _pointers = 0;

  @override
  void initState()  {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _flashModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _flashModeControlRowAnimation = CurvedAnimation(
      parent: _flashModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );
    _exposureModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _exposureModeControlRowAnimation = CurvedAnimation(
      parent: _exposureModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );
    _focusModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _focusModeControlRowAnimation = CurvedAnimation(
      parent: _focusModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );
  getCameraDetails();

  }
  void getCameraDetails () async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      _cameras = await availableCameras();
      if (_cameras.length>0) {
        onNewCameraSelected(_cameras[1]);
        //return;
      }

    } on CameraException catch (e) {
      _logError(e.code, e.description);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _flashModeControlRowAnimationController.dispose();
    _exposureModeControlRowAnimationController.dispose();
    super.dispose();
  }

  // #docregion AppLifecycle
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCameraController(cameraController.description);
    }
  }
  // #enddocregion AppLifecycle
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
  bool startCamera=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      /*appBar: AppBar(title: Text("Workout"),backgroundColor:Colors.lightGreenAccent ,foregroundColor: Colors.red,
          actions: [IconButton(
            onPressed: (){
              setState(() {
                startCamera=!startCamera;
              });
              }, icon: Icon(Icons.photo_camera,size: 35),padding: EdgeInsets.only(right: 20),),
            IconButton(
              onPressed: (){
                Navigator.pop(context);
                Navigator.push(context,MaterialPageRoute(builder: (context) => RangeMotionPage()));

              }, icon: Icon(Icons.power_settings_new,size: 35),padding: EdgeInsets.only(right: 20),)
          ]),

       */
      body: SafeArea(child:
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: (){
                  setState(() {
                    startCamera=!startCamera;
                  });
                }, icon: Icon(Icons.photo_camera,size: 35,color: Colors.white,),padding: EdgeInsets.only(right: 20),),
              IconButton(
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.push(context,MaterialPageRoute(builder: (context) => RangeMotionSummaryPage()));

                }, icon: Icon(Icons.power_settings_new,size: 35,color: Colors.white,),padding: EdgeInsets.only(right: 20),)
          ],),
          (startCamera?
          Container(
            height:400,
            child: _cameraPreviewWidget(),
          )
          :
              SizedBox()
          ),
          Expanded(
              child:
                  SingleChildScrollView(
                    child:
                      Column(
                        children: [
                          Row(
                            children: [
                              Column(children: [
                                Container(padding: EdgeInsets.only(left:10,right: 10,top: 5,bottom: 5),margin: EdgeInsets.all(5),decoration: BoxDecoration(color: Colors.grey,border: Border.all(color: Colors.white),borderRadius: BorderRadius.all(Radius.circular(20))) ,child: Text("Session Time",style: TextStyle(color: Colors.white),),),
                                Container(padding: EdgeInsets.only(left:10,right: 10,bottom: 5) ,child: Text("00:00:00",style: TextStyle(color: Colors.white,fontSize: 20),),),
                              ],),
                              Spacer(),
                              Column(children: [
                                Container(padding: EdgeInsets.only(left:10,right: 10,top: 5,bottom: 5),margin: EdgeInsets.all(5),decoration: BoxDecoration(color: Colors.grey,border: Border.all(color: Colors.white),borderRadius: BorderRadius.all(Radius.circular(20))) ,child: Text("Active Time",style: TextStyle(color: Colors.white)),),
                                Container(padding: EdgeInsets.only(left:10,right: 10,bottom: 5),child: Text("00:00:00",style: TextStyle(color: Colors.white,fontSize: 20)),),
                              ],)
                            ],
                          ),
                          /*Row(
                            children: [
                              Column(
                                children: [
                                  _getLinearGaugeVertical(),
                                ],
                              ),
                              Column(
                                children: [
                                  _getGauge(),
                                ],
                              ),
                              Column(
                                children: [
                                  _getLinearGaugeVertical()
                                ],
                              )
                            ],
                          ),*/
                          Stack(children: [
                            _getGauge(),
                            Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 15,
                                  height: 300,
                                  decoration: BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.circular(10)),
                                  child: Column(children: [
                                    Spacer(),
                                    Container(width: 14,height: 200,decoration: BoxDecoration(color: Colors.green,borderRadius: BorderRadius.circular(10)),),
                                  ],),
                            )),
                            Positioned(
                                left: MediaQuery.sizeOf(context).width-15,
                                top: 0,
                                child: Container(
                                  width: 15,
                                  height: 300,
                                  decoration: BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.circular(10)),
                                  child: Column(children: [
                                    Spacer(),
                                    Container(width: 14,height: 200,decoration: BoxDecoration(color: Colors.green,borderRadius: BorderRadius.circular(10)),),
                                  ],),
                                ))
                          ],),
                          Row(children: [
                            Column(children: [
                              Container(
                                width: 150,
                                height: 15,
                                decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),
                                child: Row(children: [
                                  Container(width: 50,height: 29,decoration: BoxDecoration(color: Colors.orange,borderRadius: BorderRadius.circular(10)),),
                                  Spacer(),
                                ],),
                              ),
                              Padding(padding: EdgeInsets.only(top: 5),child:
                                Text("Set 1 of 3",style: TextStyle(fontSize: 18,color: Colors.white),)
                              ),
                            ],),
                            Spacer(),
                            Column(children: [
                              Container(
                                width: 150,
                                height: 15,
                                decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),
                                child: Row(children: [
                                  Container(width: 50,height: 29,decoration: BoxDecoration(color: Colors.lightGreenAccent,borderRadius: BorderRadius.circular(10)),),
                                  Spacer(),
                                ],),
                              ),
                              Padding(padding: EdgeInsets.only(top: 5),child:
                              Text("Reps 1 of 10",style: TextStyle(fontSize: 18,color: Colors.white),)
                              ),
                            ],),
                          ],),
                          SizedBox(height: 10,),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              //Row(children: [
                                Expanded(
                                  //color: Colors.yellow,
                                  child:SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child:
                                    Column(children: [
                                      Container(child:
                                        Row(children: [
                                          Column(children: [
                                            Container(
                                          width: 15,
                                          height: 150,
                                          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1)),
                                          child: Column(children: [
                                            Spacer(),
                                            Container(width: 14,height: 100,decoration: BoxDecoration(color: Colors.green),),
                                            Text("1",style: TextStyle(color: Colors.white),)
                                          ],),
                                        )
                                      ],),
                                      Padding(padding: EdgeInsets.only(left:5),child:
                                      Column(children: [
                                        Container(
                                          width: 15,
                                          height: 150,
                                          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1),),
                                          child: Column(children: [
                                            Spacer(),
                                            Container(width: 14,height: 130,decoration: BoxDecoration(color: Colors.green),),
                                            Text("2",style: TextStyle(color: Colors.white),)
                                          ],),
                                        )
                                      ],)
                                      ),
                                      Padding(padding: EdgeInsets.only(left:5),child:
                                      Column(children: [
                                        Container(
                                          width: 15,
                                          height: 150,
                                          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1),),
                                          child: Column(children: [
                                            Spacer(),
                                            Container(width: 14,height: 90,decoration: BoxDecoration(color: Colors.green),),
                                            Text("3",style: TextStyle(color: Colors.white),)
                                          ],),
                                        )
                                      ],)
                                      ),
                                      Padding(padding: EdgeInsets.only(left:5),child:
                                      Column(children: [
                                        Container(
                                          width: 15,
                                          height: 150,
                                          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1),),
                                          child: Column(children: [
                                            Spacer(),
                                            Container(width: 14,height: 130,decoration: BoxDecoration(color: Colors.green),),
                                            Text("4",style: TextStyle(color: Colors.white),)
                                          ],),
                                        )
                                      ],)
                                      ),
                                      Padding(padding: EdgeInsets.only(left:5),child:
                                      Column(children: [
                                        Container(
                                          width: 15,
                                          height: 150,
                                          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1),),
                                          child: Column(children: [
                                            Spacer(),
                                            Container(width: 14,height: 80,decoration: BoxDecoration(color: Colors.green),),
                                            Text("5",style: TextStyle(color: Colors.white),)
                                          ],),
                                        )
                                      ],)
                                      ),
                                      Padding(padding: EdgeInsets.only(left:5),child:
                                      Column(children: [
                                        Container(
                                          width: 15,
                                          height: 150,
                                          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1),),
                                          child: Column(children: [
                                            Spacer(),
                                            Container(width: 14,height: 130,decoration: BoxDecoration(color: Colors.green),),
                                            Text("6",style: TextStyle(color: Colors.white),)
                                          ],),
                                        )
                                      ],)
                                      ),
                                      Padding(padding: EdgeInsets.only(left:5),child:
                                      Column(children: [
                                        Container(
                                          width: 15,
                                          height: 150,
                                          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1),),
                                          child: Column(children: [
                                            Spacer(),
                                            Container(width: 14,height: 70,decoration: BoxDecoration(color: Colors.green),),
                                            Text("7",style: TextStyle(color: Colors.white),)
                                          ],),
                                        )
                                      ],)
                                      ),
                                      Padding(padding: EdgeInsets.only(left:5),child:
                                      Column(children: [
                                        Container(
                                          width: 15,
                                          height: 150,
                                          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1),),
                                          child: Column(children: [
                                            Spacer(),
                                            Container(width: 14,height: 40,decoration: BoxDecoration(color: Colors.green),),
                                            Text("8",style: TextStyle(color: Colors.white),)
                                          ],),
                                        )
                                      ],)
                                      ),
                                      Padding(padding: EdgeInsets.only(left:5),child:
                                      Column(children: [
                                        Container(
                                          width: 15,
                                          height: 150,
                                          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1),),
                                          child: Column(children: [
                                            Spacer(),
                                            Container(width: 14,height: 40,decoration: BoxDecoration(color: Colors.green),),
                                            Text("9",style: TextStyle(color: Colors.white),)
                                          ],),
                                        )
                                      ],)
                                      ),
                                      Padding(padding: EdgeInsets.only(left:5),child:
                                      Column(children: [
                                        Container(
                                          width: 15,
                                          height: 150,
                                          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1),),
                                          child: Column(children: [
                                            Spacer(),
                                            Container(width: 14,height: 40,decoration: BoxDecoration(color: Colors.green),),
                                            Text("0",style: TextStyle(color: Colors.white),)
                                          ],),
                                        )
                                      ],)
                                      ),
                                          Padding(padding: EdgeInsets.only(left:5),child:
                                          Column(children: [
                                            Container(
                                              width: 15,
                                              height: 150,
                                              decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1),),
                                              child: Column(children: [
                                                Spacer(),
                                                Container(width: 14,height: 40,decoration: BoxDecoration(color: Colors.green),),
                                                Text("0",style: TextStyle(color: Colors.white),)
                                              ],),
                                            )
                                          ],)
                                          ),
                                          Padding(padding: EdgeInsets.only(left:5),child:
                                          Column(children: [
                                            Container(
                                              width: 15,
                                              height: 150,
                                              decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1),),
                                              child: Column(children: [
                                                Spacer(),
                                                Container(width: 14,height: 40,decoration: BoxDecoration(color: Colors.green),),
                                                Text("0",style: TextStyle(color: Colors.white),)
                                              ],),
                                            )
                                          ],)
                                          ),
                                        ],),
                                      ),
                                      Container(child:
                                      Text("Reps",style: TextStyle(color: Colors.white),),
                                      ),

                                    ],),
                                  ),
                              ),
                                /*Row(children: [
                                  Text("Reps",style: TextStyle(color: Colors.white),),

                                ],),*/
                              //],),
                              SizedBox(width: 5,),

                              //Column(children: [

                                Container(width: 90,height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                                        gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              (Colors.grey[200])!,
                                              (Colors.grey[300])!,
                                              (Colors.grey[600])!,
                                              (Colors.grey[600])!,
                                            ],
                                            stops: const [
                                              0.1,
                                              0.3,
                                              0.9,
                                              1.0
                                            ])),
                                    child: Center(child: Text("80 reps/s",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),)
                                ),
                                SizedBox(width: 5,),
                                Container(width: 70,height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                                        gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              (Colors.grey[200])!,
                                              (Colors.grey[300])!,
                                              (Colors.grey[600])!,
                                              (Colors.grey[600])!,
                                            ],
                                            stops: const [
                                              0.1,
                                              0.3,
                                              0.9,
                                              1.0
                                            ])),
                                    child: Center(child: Text("300 sec",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),)
                                )

                            //],)
                          ],),
                          /*Row(
                            children: [
                              _getChart(),
                            ],
                          )*/
                        ],
                      )
                  ),
          ),
            ],
          ),
    ),

    );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return const Text(
        'Tap a camera',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return Listener(
        onPointerDown: (_) => _pointers++,
        onPointerUp: (_) => _pointers--,
        child: CameraPreview(
          controller!,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onScaleStart: _handleScaleStart,
                  onScaleUpdate: _handleScaleUpdate,
                  onTapDown: (TapDownDetails details) =>
                      onViewFinderTap(details, constraints),
                );
              }),
        ),
      );
    }
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    // When there are not exactly two fingers on screen don't scale
    if (controller == null || _pointers != 2) {
      return;
    }

    _currentScale = (_baseScale * details.scale)
        .clamp(_minAvailableZoom, _maxAvailableZoom);

    await controller!.setZoomLevel(_currentScale);
  }

  /// Display the thumbnail of the captured image or video.
  Widget _thumbnailWidget() {
    final VideoPlayerController? localVideoController = videoController;

    return Expanded(
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (localVideoController == null && imageFile == null)
              Container()
            else
              SizedBox(
                width: 64.0,
                height: 64.0,
                child: (localVideoController == null)
                    ? (
                    // The captured image on the web contains a network-accessible URL
                    // pointing to a location within the browser. It may be displayed
                    // either with Image.network or Image.memory after loading the image
                    // bytes to memory.
                    kIsWeb
                        ? Image.network(imageFile!.path)
                        : Image.file(File(imageFile!.path)))
                    : Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.pink)),
                  child: Center(
                    child: AspectRatio(
                        aspectRatio:
                        localVideoController.value.aspectRatio,
                        child: VideoPlayer(localVideoController)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Display a bar with buttons to change the flash and exposure modes
  Widget _modeControlRowWidget() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.flash_on),
              color: Colors.blue,
              onPressed: controller != null ? onFlashModeButtonPressed : null,
            ),
            // The exposure and focus mode are currently not supported on the web.
            ...!kIsWeb
                ? <Widget>[
              IconButton(
                icon: const Icon(Icons.exposure),
                color: Colors.blue,
                onPressed: controller != null
                    ? onExposureModeButtonPressed
                    : null,
              ),
              IconButton(
                icon: const Icon(Icons.filter_center_focus),
                color: Colors.blue,
                onPressed:
                controller != null ? onFocusModeButtonPressed : null,
              )
            ]
                : <Widget>[],
            IconButton(
              icon: Icon(enableAudio ? Icons.volume_up : Icons.volume_mute),
              color: Colors.blue,
              onPressed: controller != null ? onAudioModeButtonPressed : null,
            ),
            IconButton(
              icon: Icon(controller?.value.isCaptureOrientationLocked ?? false
                  ? Icons.screen_lock_rotation
                  : Icons.screen_rotation),
              color: Colors.blue,
              onPressed: controller != null
                  ? onCaptureOrientationLockButtonPressed
                  : null,
            ),
          ],
        ),
        _flashModeControlRowWidget(),
        _exposureModeControlRowWidget(),
        _focusModeControlRowWidget(),
      ],
    );
  }

  Widget _flashModeControlRowWidget() {
    return SizeTransition(
      sizeFactor: _flashModeControlRowAnimation,
      child: ClipRect(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.flash_off),
              color: controller?.value.flashMode == FlashMode.off
                  ? Colors.orange
                  : Colors.blue,
              onPressed: controller != null
                  ? () => onSetFlashModeButtonPressed(FlashMode.off)
                  : null,
            ),
            IconButton(
              icon: const Icon(Icons.flash_auto),
              color: controller?.value.flashMode == FlashMode.auto
                  ? Colors.orange
                  : Colors.blue,
              onPressed: controller != null
                  ? () => onSetFlashModeButtonPressed(FlashMode.auto)
                  : null,
            ),
            IconButton(
              icon: const Icon(Icons.flash_on),
              color: controller?.value.flashMode == FlashMode.always
                  ? Colors.orange
                  : Colors.blue,
              onPressed: controller != null
                  ? () => onSetFlashModeButtonPressed(FlashMode.always)
                  : null,
            ),
            IconButton(
              icon: const Icon(Icons.highlight),
              color: controller?.value.flashMode == FlashMode.torch
                  ? Colors.orange
                  : Colors.blue,
              onPressed: controller != null
                  ? () => onSetFlashModeButtonPressed(FlashMode.torch)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _exposureModeControlRowWidget() {
    final ButtonStyle styleAuto = TextButton.styleFrom(
      foregroundColor: controller?.value.exposureMode == ExposureMode.auto
          ? Colors.orange
          : Colors.blue,
    );
    final ButtonStyle styleLocked = TextButton.styleFrom(
      foregroundColor: controller?.value.exposureMode == ExposureMode.locked
          ? Colors.orange
          : Colors.blue,
    );

    return SizeTransition(
      sizeFactor: _exposureModeControlRowAnimation,
      child: ClipRect(
        child: ColoredBox(
          color: Colors.grey.shade50,
          child: Column(
            children: <Widget>[
              const Center(
                child: Text('Exposure Mode'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextButton(
                    style: styleAuto,
                    onPressed: controller != null
                        ? () =>
                        onSetExposureModeButtonPressed(ExposureMode.auto)
                        : null,
                    onLongPress: () {
                      if (controller != null) {
                        controller!.setExposurePoint(null);
                        showInSnackBar('Resetting exposure point');
                      }
                    },
                    child: const Text('AUTO'),
                  ),
                  TextButton(
                    style: styleLocked,
                    onPressed: controller != null
                        ? () =>
                        onSetExposureModeButtonPressed(ExposureMode.locked)
                        : null,
                    child: const Text('LOCKED'),
                  ),
                  TextButton(
                    style: styleLocked,
                    onPressed: controller != null
                        ? () => controller!.setExposureOffset(0.0)
                        : null,
                    child: const Text('RESET OFFSET'),
                  ),
                ],
              ),
              const Center(
                child: Text('Exposure Offset'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(_minAvailableExposureOffset.toString()),
                  Slider(
                    value: _currentExposureOffset,
                    min: _minAvailableExposureOffset,
                    max: _maxAvailableExposureOffset,
                    label: _currentExposureOffset.toString(),
                    onChanged: _minAvailableExposureOffset ==
                        _maxAvailableExposureOffset
                        ? null
                        : setExposureOffset,
                  ),
                  Text(_maxAvailableExposureOffset.toString()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _focusModeControlRowWidget() {
    final ButtonStyle styleAuto = TextButton.styleFrom(
      foregroundColor: controller?.value.focusMode == FocusMode.auto
          ? Colors.orange
          : Colors.blue,
    );
    final ButtonStyle styleLocked = TextButton.styleFrom(
      foregroundColor: controller?.value.focusMode == FocusMode.locked
          ? Colors.orange
          : Colors.blue,
    );

    return SizeTransition(
      sizeFactor: _focusModeControlRowAnimation,
      child: ClipRect(
        child: ColoredBox(
          color: Colors.grey.shade50,
          child: Column(
            children: <Widget>[
              const Center(
                child: Text('Focus Mode'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextButton(
                    style: styleAuto,
                    onPressed: controller != null
                        ? () => onSetFocusModeButtonPressed(FocusMode.auto)
                        : null,
                    onLongPress: () {
                      if (controller != null) {
                        controller!.setFocusPoint(null);
                      }
                      showInSnackBar('Resetting focus point');
                    },
                    child: const Text('AUTO'),
                  ),
                  TextButton(
                    style: styleLocked,
                    onPressed: controller != null
                        ? () => onSetFocusModeButtonPressed(FocusMode.locked)
                        : null,
                    child: const Text('LOCKED'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Display the control bar with buttons to take pictures and record videos.
  Widget _captureControlRowWidget() {
    final CameraController? cameraController = controller;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.camera_alt),
          color: Colors.blue,
          onPressed: cameraController != null &&
              cameraController.value.isInitialized &&
              !cameraController.value.isRecordingVideo
              ? onTakePictureButtonPressed
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.videocam),
          color: Colors.blue,
          onPressed: cameraController != null &&
              cameraController.value.isInitialized &&
              !cameraController.value.isRecordingVideo
              ? onVideoRecordButtonPressed
              : null,
        ),
        IconButton(
          icon: cameraController != null &&
              cameraController.value.isRecordingPaused
              ? const Icon(Icons.play_arrow)
              : const Icon(Icons.pause),
          color: Colors.blue,
          onPressed: cameraController != null &&
              cameraController.value.isInitialized &&
              cameraController.value.isRecordingVideo
              ? (cameraController.value.isRecordingPaused)
              ? onResumeButtonPressed
              : onPauseButtonPressed
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.stop),
          color: Colors.red,
          onPressed: cameraController != null &&
              cameraController.value.isInitialized &&
              cameraController.value.isRecordingVideo
              ? onStopButtonPressed
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.pause_presentation),
          color:
          cameraController != null && cameraController.value.isPreviewPaused
              ? Colors.red
              : Colors.blue,
          onPressed:
          cameraController == null ? null : onPausePreviewButtonPressed,
        ),
      ],
    );
  }

  /// Display a row of toggle to select the camera (or a message if no camera is available).
  Widget _cameraTogglesRowWidget() {
    final List<Widget> toggles = <Widget>[];

    void onChanged(CameraDescription? description) {
      if (description == null) {
        return;
      }

      onNewCameraSelected(description);
    }

    if (_cameras.isEmpty) {
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        showInSnackBar('No camera found.');
      });
      return const Text('None');
    } else {
      for (final CameraDescription cameraDescription in _cameras) {
        toggles.add(
          SizedBox(
            width: 90.0,
            child: RadioListTile<CameraDescription>(
              title: Icon(getCameraLensIcon(cameraDescription.lensDirection)),
              groupValue: controller?.description,
              value: cameraDescription,
              onChanged: onChanged,
            ),
          ),
        );
      }
    }

    return Row(children: toggles);
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (controller == null) {
      return;
    }

    final CameraController cameraController = controller!;

    final Offset offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    cameraController.setExposurePoint(offset);
    cameraController.setFocusPoint(offset);
  }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      return controller!.setDescription(cameraDescription);
    } else {
      return _initializeCameraController(cameraDescription);
    }
  }

  Future<void> _initializeCameraController(
      CameraDescription cameraDescription) async {
    final CameraController cameraController = CameraController(
      cameraDescription,
      kIsWeb ? ResolutionPreset.max : ResolutionPreset.medium,
      enableAudio: enableAudio,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    controller = cameraController;

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (cameraController.value.hasError) {
        showInSnackBar(
            'Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
      await Future.wait(<Future<Object?>>[
        // The exposure mode is currently not supported on the web.
        ...!kIsWeb
            ? <Future<Object?>>[
          cameraController.getMinExposureOffset().then(
                  (double value) => _minAvailableExposureOffset = value),
          cameraController
              .getMaxExposureOffset()
              .then((double value) => _maxAvailableExposureOffset = value)
        ]
            : <Future<Object?>>[],
        cameraController
            .getMaxZoomLevel()
            .then((double value) => _maxAvailableZoom = value),
        cameraController
            .getMinZoomLevel()
            .then((double value) => _minAvailableZoom = value),
      ]);
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          showInSnackBar('You have denied camera access.');
        case 'CameraAccessDeniedWithoutPrompt':
        // iOS only
          showInSnackBar('Please go to Settings app to enable camera access.');
        case 'CameraAccessRestricted':
        // iOS only
          showInSnackBar('Camera access is restricted.');
        case 'AudioAccessDenied':
          showInSnackBar('You have denied audio access.');
        case 'AudioAccessDeniedWithoutPrompt':
        // iOS only
          showInSnackBar('Please go to Settings app to enable audio access.');
        case 'AudioAccessRestricted':
        // iOS only
          showInSnackBar('Audio access is restricted.');
        default:
          _showCameraException(e);
          break;
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onTakePictureButtonPressed() {
    takePicture().then((XFile? file) {
      if (mounted) {
        setState(() {
          imageFile = file;
          videoController?.dispose();
          videoController = null;
        });
        if (file != null) {
          showInSnackBar('Picture saved to ${file.path}');
        }
      }
    });
  }

  void onFlashModeButtonPressed() {
    if (_flashModeControlRowAnimationController.value == 1) {
      _flashModeControlRowAnimationController.reverse();
    } else {
      _flashModeControlRowAnimationController.forward();
      _exposureModeControlRowAnimationController.reverse();
      _focusModeControlRowAnimationController.reverse();
    }
  }

  void onExposureModeButtonPressed() {
    if (_exposureModeControlRowAnimationController.value == 1) {
      _exposureModeControlRowAnimationController.reverse();
    } else {
      _exposureModeControlRowAnimationController.forward();
      _flashModeControlRowAnimationController.reverse();
      _focusModeControlRowAnimationController.reverse();
    }
  }

  void onFocusModeButtonPressed() {
    if (_focusModeControlRowAnimationController.value == 1) {
      _focusModeControlRowAnimationController.reverse();
    } else {
      _focusModeControlRowAnimationController.forward();
      _flashModeControlRowAnimationController.reverse();
      _exposureModeControlRowAnimationController.reverse();
    }
  }

  void onAudioModeButtonPressed() {
    enableAudio = !enableAudio;
    if (controller != null) {
      onNewCameraSelected(controller!.description);
    }
  }

  Future<void> onCaptureOrientationLockButtonPressed() async {
    try {
      if (controller != null) {
        final CameraController cameraController = controller!;
        if (cameraController.value.isCaptureOrientationLocked) {
          await cameraController.unlockCaptureOrientation();
          showInSnackBar('Capture orientation unlocked');
        } else {
          await cameraController.lockCaptureOrientation();
          showInSnackBar(
              'Capture orientation locked to ${cameraController.value.lockedCaptureOrientation.toString().split('.').last}');
        }
      }
    } on CameraException catch (e) {
      _showCameraException(e);
    }
  }

  void onSetFlashModeButtonPressed(FlashMode mode) {
    setFlashMode(mode).then((_) {
      if (mounted) {
        setState(() {});
      }
      showInSnackBar('Flash mode set to ${mode.toString().split('.').last}');
    });
  }

  void onSetExposureModeButtonPressed(ExposureMode mode) {
    setExposureMode(mode).then((_) {
      if (mounted) {
        setState(() {});
      }
      showInSnackBar('Exposure mode set to ${mode.toString().split('.').last}');
    });
  }

  void onSetFocusModeButtonPressed(FocusMode mode) {
    setFocusMode(mode).then((_) {
      if (mounted) {
        setState(() {});
      }
      showInSnackBar('Focus mode set to ${mode.toString().split('.').last}');
    });
  }

  void onVideoRecordButtonPressed() {
    startVideoRecording().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void onStopButtonPressed() {
    stopVideoRecording().then((XFile? file) {
      if (mounted) {
        setState(() {});
      }
      if (file != null) {
        showInSnackBar('Video recorded to ${file.path}');
        videoFile = file;
        _startVideoPlayer();
      }
    });
  }

  Future<void> onPausePreviewButtonPressed() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return;
    }

    if (cameraController.value.isPreviewPaused) {
      await cameraController.resumePreview();
    } else {
      await cameraController.pausePreview();
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onPauseButtonPressed() {
    pauseVideoRecording().then((_) {
      if (mounted) {
        setState(() {});
      }
      showInSnackBar('Video recording paused');
    });
  }

  void onResumeButtonPressed() {
    resumeVideoRecording().then((_) {
      if (mounted) {
        setState(() {});
      }
      showInSnackBar('Video recording resumed');
    });
  }

  Future<void> startVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return;
    }

    if (cameraController.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return;
    }

    try {
      await cameraController.startVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return;
    }
  }

  Future<XFile?> stopVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return null;
    }

    try {
      return cameraController.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  Future<void> pauseVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return;
    }

    try {
      await cameraController.pauseVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> resumeVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return;
    }

    try {
      await cameraController.resumeVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setFlashMode(FlashMode mode) async {
    if (controller == null) {
      return;
    }

    try {
      await controller!.setFlashMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setExposureMode(ExposureMode mode) async {
    if (controller == null) {
      return;
    }

    try {
      await controller!.setExposureMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setExposureOffset(double offset) async {
    if (controller == null) {
      return;
    }

    setState(() {
      _currentExposureOffset = offset;
    });
    try {
      offset = await controller!.setExposureOffset(offset);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setFocusMode(FocusMode mode) async {
    if (controller == null) {
      return;
    }

    try {
      await controller!.setFocusMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> _startVideoPlayer() async {
    if (videoFile == null) {
      return;
    }

    final VideoPlayerController vController = kIsWeb
        ? VideoPlayerController.networkUrl(Uri.parse(videoFile!.path))
        : VideoPlayerController.file(File(videoFile!.path));

    videoPlayerListener = () {
      if (videoController != null) {
        // Refreshing the state to update video player with the correct ratio.
        if (mounted) {
          setState(() {});
        }
        videoController!.removeListener(videoPlayerListener!);
      }
    };
    vController.addListener(videoPlayerListener!);
    await vController.setLooping(true);
    await vController.initialize();
    await videoController?.dispose();
    if (mounted) {
      setState(() {
        imageFile = null;
        videoController = vController;
      });
    }
    await vController.play();
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      final XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  void _showCameraException(CameraException e) {
    _logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }
}
List<CameraDescription> _cameras = <CameraDescription>[];

/// CameraApp is the Main Application.
class CameraApp extends StatelessWidget {
  /// Default Constructor
  const CameraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ExerciseStatusPage(),
    );
  }
}





Future<void> main() async {
  // Fetch the available cameras before initializing the app.
  try {
    WidgetsFlutterBinding.ensureInitialized();
    //_cameras = await availableCameras();
  } on CameraException catch (e) {
    _logError(e.code, e.description);
  }
  runApp(const CameraApp());
}

class ChartData {
  ChartData(this.x, this.y);

  final String x;
  final double y;
}

