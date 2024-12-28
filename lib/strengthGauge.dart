//import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:indafit/model/model.dart';
// import 'package:syncfusion_flutter_gauges/gauges.dart' as cp1;
// import 'package:syncfusion_flutter_charts/charts.dart' as cp2;
import 'package:indafit/login.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:indafit/rangeMotion.dart';
import 'package:indafit/sgWorkout.dart';
import 'package:provider/provider.dart';
import 'color_themes_file/theme_notifier.dart';
/*void main() async {
  // Fetch the available cameras before initializing the app.

  runApp(const GymApp());
}
*/

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
      home: StrengthGaugePage(),
    );
  }
}



/// Represents MyHomePage class
class StrengthGaugePage extends StatefulWidget {
  /// Creates the instance of MyHomePage
  StrengthGaugePage({Key? key}) : super(key: key);

  @override
  StrengthGaugePageState createState() => StrengthGaugePageState();
}
double _volumeValue = 50;

void onVolumeChanged(double value) {
  //setState(() {
  _volumeValue = value;
  //});
}

class StrengthGaugePageState extends State<StrengthGaugePage> {
  late final Box<ExerciseCategories> dataBox;
  bool dataReceived=false;
  var _currentIntValue=50;
  var progressionValue=1;
  var regressionValue=1;
  var filterData="";
  @override
  StrengthGaugePageState() {
    print("Getting Data");
    getData();

    //super.initState();
  }
  void dispose() async{
    super.dispose();
    print("Removing Database");
    if (dataBox.isOpen){
      await dataBox.close();
    }

  }

  /*void closeData() async{
    await dataBox.close();
  }*/
  void getData() async{
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter<ExerciseCategories>(ExerciseCategoriesAdapter());
      Hive.registerAdapter<MovementModel>(MovementModelAdapter());
      Hive.registerAdapter<ExerciseModel>(ExerciseModelAdapter());
    }
    if(!Hive.isBoxOpen('exercise_box')) {
      await Hive.openBox<ExerciseCategories>('exercise_box');
    }
    setState(() {
      dataBox = Hive.box<ExerciseCategories>('exercise_box');
      dataReceived=true;
    });
  }
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      //backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child:
                    Text("Discover",style: TextStyle(fontSize: 30),),
                  ),
              ]),
            HorizontalListView(),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child:
              Text("Strength Gauge",style: TextStyle(fontSize: 18),),
            ),
            Expanded(child:
                //VerticalListView(),
                //SubMenuListView(),
            Stack(children: [
              Positioned(
                  top: 0.0,
                  left: 0.0,
                  right: 0.0,
                  bottom: 0.0,
                  child: exerciseList(),
              ),
              Positioned(
                  left: MediaQuery.of(context).size.width-50,
                  top: MediaQuery.of(context).size.height/4,
                  right: 0.0,
                  bottom: 0.0,
                  child: subMenuList(),
              ),
            ],),
            ),
          ],
        ),
      ),
    );
  }

  Widget exerciseList() {
    if (!dataReceived) {
      return const Center(
        child: Text('Information Not Available'),
      );
    } else {
      return ValueListenableBuilder(
        valueListenable: dataBox.listenable(),
        builder: (context, value, child) {
          if (value.isEmpty) {
            return const Center(
              child: Text('Information Not Available'),
            );
          } else {
            return ListView.builder(
              itemCount: dataBox.length,
              itemBuilder: (context, index) {
                var box = value;
                var getData = box.getAt(index);
                if(filterData.length>0)
                  {
                    if(getData!.shortName==filterData){
                      return Column(children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: getData!.movements.length,
                          itemBuilder: (context, mIndex) {
                            //var box = value;
                            //var getData = box.getAt(index);

                            return GestureDetector(onTap: (){
                              Navigator.push(context,MaterialPageRoute(builder: (context) => SgWorkoutPage(exerciseDetails: getData.movements[mIndex],)));
                            },child:
                            ListTile(
                              title: Text(getData.name,style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                              subtitle: Text(getData.movements[mIndex].name,style: TextStyle(fontSize: 18),),
                            ),
                            ) ;
                          },
                        )
                      ],);
                    }
                    else{
                      return SizedBox();
                    }
                  }
                else{
                  return Column(children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: getData!.movements.length,
                      itemBuilder: (context, mIndex) {
                        //var box = value;
                        //var getData = box.getAt(index);

                        return GestureDetector(onTap: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context) => SgWorkoutPage(exerciseDetails: getData.movements[mIndex],)));
                        },child:
                        ListTile(
                          title: Text(getData.name,style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                          subtitle: Text(getData.movements[mIndex].name,style: TextStyle(fontSize: 18),),
                        ),
                        ) ;
                      },
                    )
                  ],);
                }
              },
            );
          }
        },
      );
    }
  }

  Widget subMenuList(){
    if (!dataReceived) {
      return const Center(
        child: Text('',style: TextStyle(color: Colors.white),),
      );
    } else {
      return Container(
        //margin: EdgeInsets.symmetric(vertical: 20.0),
        height: 40.0,
        width: 50,
        child:
        ListView.builder(
            itemCount: dataBox.length+1, // Number of items in your list
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              return (index!=dataBox.length)?
              GestureDetector(
                key: Key(index.toString()),
                onTap: () {
                  setState(() {
                    filterData=dataBox.getAt(index)!.shortName;
                  });
                  print("Clicked " + index.toString());
                },
                child: Container(width: 50, height: 40.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: (filterData==dataBox.getAt(index)!.shortName)?Colors.lightGreenAccent:ThemeData().colorScheme.primaryContainer,
                    //boxShadow: [BoxShadow(blurRadius: 5, color: Colors.white70, offset: Offset(2, 2))],
                  ),
                  child: Center(child:
                  Text((dataBox
                      .getAt(index)
                      ?.shortName == 'null') ? "" : dataBox.getAt(index)!
                      .shortName, style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold,color: ThemeData().colorScheme.primary)),
                  ),),
              ):
              GestureDetector(
              key: Key(index.toString()),
              onTap: () {
                setState(() {
                  filterData="";
                });
                print("Clicked " + index.toString());
              },
              child: Container(width: 50, height: 40.0,
              decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: (filterData.length==0)?Colors.lightGreenAccent:ThemeData().colorScheme.primaryContainer,
              //boxShadow: [BoxShadow(blurRadius: 5, color: Colors.white70, offset: Offset(2, 2))],
              ),
              child: Center(child:
              Text("ALL", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: ThemeData().colorScheme.primary)),
              ),),
              );
            }),
      );
    }
  }

}

class HorizontalListView extends StatelessWidget {
var menuArray=["Movement","Predefined","Tutorial","ABC","PQR"];
  @override

  Widget build(BuildContext context) {

    return Container(
      //margin: EdgeInsets.symmetric(vertical: 20.0),
      //color: Colors.lightBlue,
      height: 40.0,
      child:
    ListView.builder(

    itemCount: menuArray.length, // Number of items in your list

    scrollDirection: Axis.horizontal,

    itemBuilder: (BuildContext context, int index) {
      return GestureDetector(
              onTap: (){
                print("Clicked");
              },
              child: Container(width: 120.0, margin: EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(100.0),
                    gradient: LinearGradient(colors: [Colors.grey, Colors.white30]),
                    //boxShadow: [BoxShadow(blurRadius: 5, color: Colors.white70, offset: Offset(2, 2))],
                  ),
                  child: Center(
                    child: Text(menuArray[index],style: TextStyle(fontSize: 18),),
                ),),
            );
    }),
    );
  }
}
class VerticalListView extends StatelessWidget {
  late final Box<ExerciseCategories> dataBox;
  @override
  VerticalListView() {
    print("Getting Data");
    getData();

    //super.initState();
  }
  void dispose() async{
    print("Removing Database");
    await dataBox.close();
  }

  /*void closeData() async{
    await dataBox.close();
  }*/
  void getData() async{
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
    Hive.registerAdapter<ExerciseCategories>(ExerciseCategoriesAdapter());
    Hive.registerAdapter<MovementModel>(MovementModelAdapter());
    Hive.registerAdapter<ExerciseModel>(ExerciseModelAdapter());
    await Hive.openBox<ExerciseCategories>('exercise_box');
    dataBox = Hive.box<ExerciseCategories>('exercise_box');
  }
  var menuArray=[["Movement","Leg,Back"],["Movement","Leg,Back"],["Movement","Leg,Back"],["Movement","Leg,Back"],["Movement","Leg,Back"],["Movement","Leg,Back"],["Movement","Leg,Back"]];

  @override
  Widget build(BuildContext context) {
    if(dataBox.isEmpty){
      return const Center(
        child: Text('Information Not Available'),
      );
    }else{
      return ValueListenableBuilder(
        valueListenable: dataBox.listenable(),
        builder: (context, value, child) {
          if (value.isEmpty) {
            return const Center(
              child: Text('Information Not Available'),
            );
          } else {
            return ListView.builder(
              itemCount: dataBox.length,
              itemBuilder: (context, index) {
                var box = value;
                var getData = box.getAt(index);
                return Column(children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: getData!.movements.length,
                    itemBuilder: (context, mIndex) {
                      //var box = value;
                      //var getData = box.getAt(index);

                      return ListTile(
                        title: Text(getData!.name),
                        subtitle: Text(getData!.movements[mIndex].name),
                      );
                    },
                  )
                ],);
              },
            );
          }
        },
      );
    }

    /*return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0),
      height: 40.0,
      child:
      ListView.builder(
          itemCount: menuArray.length, // Number of items in your list
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
                      onTap: (){
                        print("Clicked");
                      },
                      child: Container(height: 80.0, margin: EdgeInsets.only(right: 5,bottom: 5),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0),
                        gradient: LinearGradient(colors: [Colors.grey, Colors.white30]),
                        //boxShadow: [BoxShadow(blurRadius: 5, color: Colors.white70, offset: Offset(2, 2))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                          Padding(padding: EdgeInsets.only(left: 10),child:
                            Text(menuArray[index][0],style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                          ),
                          Padding(padding: EdgeInsets.only(left: 10),child:
                            Text(menuArray[index][1],style: TextStyle(fontSize: 18),),
                          ),
                        ]
                      ),),
                  );
          }),
    );*/
  }
}

class SubMenuListView extends StatelessWidget {
  final menuArray=["CH","SH","BH","ARM","DM"];

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: EdgeInsets.symmetric(vertical: 20.0),
      height: 40.0,
      width: 50,
      child:
      ListView.builder(
          itemCount: menuArray.length, // Number of items in your list
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
                      key: Key(index.toString()),
                      onTap: (){
                        print("Clicked "+index.toString());
                      },
                      child: Container(width: 50, height: 40.0,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                          //boxShadow: [BoxShadow(blurRadius: 5, color: Colors.white70, offset: Offset(2, 2))],
                        ),
                        child: Center(child:
                              Text(menuArray[index],style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                        ),),
                  );
          }),
    );
  }
}
