import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart' as cp1;
import 'package:syncfusion_flutter_charts/charts.dart' as cp2;
import 'package:indafit/login.dart';
import 'package:indafit/bluetoothCommunication.dart';
import 'package:provider/provider.dart';
import 'color_themes_file/theme_notifier.dart';
void main() async {
  // Fetch the available cameras before initializing the app.
  //runApp(MyApp());
  //runApp(const GymApp());
  runApp(ChangeNotifierProvider(
    create: (_) => ThemeNotifier(),
    child: GymApp(),
  ),
  );
}

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
      home: MyHomePage(),
    );
  }
}
 */
/// Represents MyHomePage class
class StatusPage extends StatefulWidget {
  /// Creates the instance of MyHomePage
  StatusPage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
double _volumeValue = 50;

void onVolumeChanged(double value) {
  //setState(() {
    _volumeValue = value;
  //});
}

class _MyHomePageState extends State<StatusPage> {
  Widget _getGauge({bool isRadialGauge = true}) {
    if (isRadialGauge) {
      return _getRadialGauge();
    } else {
      return _getLinearGauge();
    }
  }

  Widget _getRadialGauge() {
    return Container(
      width: 230,
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  Container(child: Text("Session Time"),),
                  Container(child: Text("Active Time"),),
                ],
              ),
              Row(
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
              ),
              Row(
                children: [
                  _getLinearGauge(),
                ],
              ),
              Row(
                children: [
                  _getLinearGauge(),
                ],
              ),
              Row(
                children: [
                  _getChart(),
                ],
              )
            ],
          )
          ,
        ),
    );
  }
}
class ChartData {
  ChartData(this.x, this.y);

  final String x;
  final double y;
}