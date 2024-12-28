import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:animated_weight_picker/animated_weight_picker.dart';
import 'package:indafit/globals.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
void main() {
  //print(DateFormat('dd-MM-yyyy').format(DateTime.now()));
  return runApp(GaugeApp());
}


/*
class StateModel {
  const StateModel(this.name, this.code);
  final String code;
  final String name;

  @override
  String toString() => name;
}

 */

/// Represents the GaugeApp class
class GaugeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Radial Gauge Demo',
      theme: ThemeData(primarySwatch: Colors.blue,scaffoldBackgroundColor: const Color(0xFFEFEFEF)),
      home: TargetConfigurationPage(),
    );
  }
}



/// Represents MyHomePage class
class TargetConfigurationPage extends StatefulWidget {
  /// Creates the instance of MyHomePage
  TargetConfigurationPage({Key? key}) : super(key: key);

  @override
  TargetConfigurationPageState createState() => TargetConfigurationPageState();
}
double _volumeValue = 50;

void onVolumeChanged(double value) {
  //setState(() {
  _volumeValue = value;
  //});
}

class TargetConfigurationPageState extends State<TargetConfigurationPage> {
int targetVolume=1500;
int targetCalories=1500;
int targetDuration=45;
//TextEditingController dateController = new TextEditingController(text: DateFormat('dd-MM-yyyy').format(DateTime.now()));
  TextEditingController dateController = new TextEditingController();
  var _currentIntValue=10;
  String selectedValue = '';
  @override
  //var future1= showMaterialScrollPicker(context: context, items: usStates, selectedItem: selectedUsState), child: Text("Press ME")),
  Widget build(BuildContext context) {
    final List<ChartData> chartData = <ChartData>[
      ChartData('Low', 3500, const Color.fromRGBO(0, 128, 0, 1)),
      ChartData('Average', 4200, const Color.fromRGBO(0, 0, 128, 1)),
      ChartData('High', 5500, const Color.fromRGBO(255, 0, 0, 1)),
    ];
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: MyDrawer(),
      //appBar: AppBar(title: Text("About ME"),backgroundColor:Colors.lightGreenAccent ,foregroundColor: Colors.red,),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 60,
              padding: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(color:Colors.grey.withOpacity(0.3),borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                Text("Target - Volume",style: TextStyle(color: Colors.white,fontSize: 20),),
                Spacer(),
                    //Padding(padding: EdgeInsets.only(bottom: 11),child: Icon(Icons,color: Colors.white,weight: 10,)),
                  ElevatedButton(child: Text("-",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    backgroundColor: Colors.red,
                  ),onPressed: (){
                    setState(() {
                      if(targetVolume>0){
                        targetVolume-=1;
                      }
                    });
                  }),
                //SizedBox(width: 10,),
                Container(
                  child: Text(targetVolume.toString()+ " Kg",style: TextStyle(color: Colors.white,fontSize: 18)),
                ),
                //SizedBox(width: 10,),
                  //Padding(padding: EdgeInsets.only(bottom: 11),child: Icon(Icons,color: Colors.white,weight: 10,)),
                  ElevatedButton(child: Text("+",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    backgroundColor: Colors.red,
                  ),onPressed: (){
                    setState(() {
                      if(targetVolume>0){
                        targetVolume+=1;
                      }
                    });
                  }),
                SizedBox(width: 10,),
              ],),
            ),
            SizedBox(height: 15,),
            Container(
              height: 60,
              padding: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(color:Colors.grey.withOpacity(0.3),borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                Text("Target - Calories",style: TextStyle(color: Colors.white,fontSize: 20),),
                Spacer(),
                  //Padding(padding: EdgeInsets.only(bottom: 11),child: Icon(Icons,color: Colors.white,weight: 10,)),
                ElevatedButton(child: Text("-",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  backgroundColor: Colors.red,
                ),onPressed: (){
                  setState(() {
                    if(targetCalories>0){
                      targetCalories-=1;
                    }
                  });
                }),
                //SizedBox(width: 20,),
                Container(
                  child: Text(targetCalories.toString()+" Kcal",style: TextStyle(color: Colors.white,fontSize: 18)),
                ),
                //SizedBox(width: 20,),
                  //Padding(padding: EdgeInsets.only(bottom: 11),child: Icon(Icons,color: Colors.white,weight: 10,)),
                ElevatedButton(child: Text("+",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  backgroundColor: Colors.red,
                ),onPressed: (){
                  setState(() {
                    if(targetCalories>0){
                      targetCalories+=1;
                    }
                  });
                }),
                //SizedBox(width: 10,),
              ],),
            ),
            SizedBox(height: 15,),
            Container(
              height: 60,
              padding: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(color:Colors.grey.withOpacity(0.3),borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                Text("Target - Duration",style: TextStyle(color: Colors.white,fontSize: 20),),
                Spacer(),
                  //Padding(padding: EdgeInsets.only(bottom: 11),child: Icon(Icons,color: Colors.white,weight: 10,)),
                ElevatedButton(child: Text("-",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  backgroundColor: Colors.red,
                ),onPressed: (){
                  setState(() {
                    if(targetDuration>0){
                      targetDuration-=1;
                    }
                  });
                }),
                //SizedBox(width: 20,),
                Container(
                  child: Text(targetDuration.toString()+ " min",style: TextStyle(color: Colors.white,fontSize: 18)),
                ),
                //SizedBox(width: 20,),
                  //Padding(padding: EdgeInsets.only(bottom: 11),child: Icon(Icons,color: Colors.white,weight: 10,)),
                ElevatedButton(child: Text("+",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  backgroundColor: Colors.red,
                ),onPressed: (){
                  setState(() {
                    if(targetDuration>0){
                      targetDuration+=1;
                    }
                  });
                }),
                SizedBox(width: 10,),
              ],),
            ),
            SizedBox(height: 10,),
            Container(
              height: 100,
              child:DayScroll(),
            ),
            SizedBox(height: 20,),
            Expanded(child:
            Stack(children: [
              SfCircularChart(centerX: '25%',centerY: '30%',
                  series: <CircularSeries<ChartData, String>>[
                    RadialBarSeries<ChartData, String>(
                        maximumValue: 6000,
                        radius: '50%',
                        gap: '10%',
                        innerRadius: '30%',
                        dataSource: chartData,
                        cornerStyle: CornerStyle.bothCurve,
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y,
                        pointColorMapper: (ChartData data, _) => data.color)
                  ]),
              Positioned(left: 200,child: Column(children: [
                Text("VOLUME 95%",style: TextStyle(color: Colors.white,fontSize: 24),),
                Text("1250/1900 KG",style: TextStyle(color: Colors.white,fontSize: 24),),
                SizedBox(height: 20,),
                Text("CALORIES 95%",style: TextStyle(color: Colors.white,fontSize: 24),),
                Text("120/1200 KCal",style: TextStyle(color: Colors.white,fontSize: 24),),
                SizedBox(height: 20,),
                Text("DURATION 95%",style: TextStyle(color: Colors.white,fontSize: 24),),
                Text("120/100 Min",style: TextStyle(color: Colors.white,fontSize: 24),)
              ],),
              ),
            ],),
            ),
          ],
        ),
      ),
    );
  }

  Widget DayScroll(){
    ScrollController _scrollController = new ScrollController();
    var dayArray=[];
    DateTime today=DateTime.now();
    for(int i =1;i<=7;i++){
      var currentWeekInfo=[];
      print(DateFormat("EEE").format(today.subtract(Duration(days: today.weekday - 1))));
      currentWeekInfo.add(DateFormat("EEE").format(today.subtract(Duration(days: today.weekday - i))).toString());
      currentWeekInfo.add(DateFormat("dd").format(today.subtract(Duration(days: today.weekday - i))).toString());
      if(DateFormat("dd").format(today.subtract(Duration(days: today.weekday - i))).compareTo(DateFormat("dd").format(today))==0){
        //currentWeekInfo.add(Colors.lightGreenAccent.toString());
        currentWeekInfo.add('0xFF2BFF00');
      }
      else{
        //currentWeekInfo.add(Colors.lightGreenAccent.withOpacity(0.5).toString());
        currentWeekInfo.add('0xFF1A1F1F');
      }
      dayArray.add(currentWeekInfo);
    }
    //["Fri","Sat","Sun"].any(DateFormat("EEE").format(today).toString());
    if(DateFormat("EEE").format(today).contains("Sat") || DateFormat("EEE").format(today).contains("Sun")){
      Future.delayed(const Duration(seconds: 2)).then((val) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
      });
    }
    //var dayArray=[['Wed', '12', '0xFF1A1F1F'],['Thurs', '13', '0xFF1A1F1F'],['Fri', '14', '0xFF2BFF00'],['Sat', '15', '0xFF1A1F1F'],['Sun', '16', '0xFF1A1F1F'],['Mon', '17', '0xFF1A1F1F']];
    return Container(
      //margin: EdgeInsets.symmetric(vertical: 20.0),
      //color: Colors.lightBlue,
      height: 80.0,
      child:
      ListView.builder(
          controller: _scrollController,
          itemCount: dayArray.length, // Number of items in your list

          scrollDirection: Axis.horizontal,

          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: (){
                print("Clicked");
              },
              child: buildDayContainer(context, dayArray[index][0].toString(), dayArray[index][1].toString(), Color(int.parse(dayArray[index][2].toString())),
              ),
            );
          }),
    );
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildDayContainer(context, 'Wed', '12', Color(0xFF1A1F1F)),
        buildDayContainer(context, 'Thurs', '13', Color(0xFF1A1F1F)),
        buildDayContainer(context, 'Fri', '14', Color(0xFF2BFF00)),
        buildDayContainer(context, 'Sat', '15', Color(0xFF1A1F1F)),
        buildDayContainer(context, 'Sun', '16', Color(0xFF1A1F1F)),
        buildDayContainer(context, 'Mon', '17', Color(0xFF1A1F1F)),
      ],
    );
  }

  Widget buildDayContainer(BuildContext context, String day, String date, Color color) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 4.0, 0.0),
      child: Container(
        width: 70.0,
        height: 80.0,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 10.0),
              child: Text(
                day,
                style: TextStyle(
                  //fontFamily: 'Readex Pro',
                  color: color == Color(0xFF2BFF00)
                      ? Colors.black
                      : Colors.white70,
                  fontSize: 18.0,
                  letterSpacing: 0.0,
                ),
              ),
            ),
            Text(
              date,
              style: TextStyle(
                //fontFamily: 'Readex Pro',
                color: color == Color(0xFF2BFF00)
                    ? Colors.black
                    : Colors.white70,
                fontSize: 18.0,
                letterSpacing: 0.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color? color;
}