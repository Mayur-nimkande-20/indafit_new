import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:indafit/bbleconnect.dart';
import 'package:intl/intl.dart';
import 'package:indafit/strengthGauge.dart';
import 'package:indafit/justLift.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:indafit/targetConfiguration.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:indafit/model/model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math';
import 'package:indafit/settings_screen.dart';

// import 'bleconnect.dart';4
import 'blue_communication_2.dart';
//import 'package:flutterflow_ui/flutterflow_ui.dart';
/*
void main(){
  runApp(HomePageAPP());

}
DateTime findFirstDateOfTheWeek(DateTime dateTime) {
  return dateTime.subtract(Duration(days: dateTime.weekday - 1));
}
DateTime findLastDateOfTheWeek(DateTime dateTime) {
  return dateTime
      .add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
}
class HomePageAPP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePageWidget(userName:"Shailesh"),
    );
  }
}
*/

class HomePageWidget extends StatefulWidget {
  //const HomePageWidget({super.key});
  const HomePageWidget({super.key, required this.userName});
  final String userName;

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  //late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  String greeting = "";
  @override
  void initState() {
    super.initState();

    int hours=DateTime.now().hour;

    if(hours>=1 && hours<=12){
      greeting = "Good Morning";
    } else if(hours>=12 && hours<=16){
      greeting = "Good Afternoon";
    } else if(hours>=16 && hours<=21){
      greeting = "Good Evening";
    } else if(hours>=21 && hours<=24){
      greeting = "Good Night";
    }

    //print(widget.userName);
    //_model = createModel(context, () => HomePageModel());
    //_model.unfocusNode = FocusNode();
    //_model.unfocusNode!.addListener(() => setState(() {}));
    getHiveDetails();
  }

  void getHiveDetails() async{
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter<ExerciseCategories>(
          ExerciseCategoriesAdapter());
      Hive.registerAdapter<MovementModel>(MovementModelAdapter());
      Hive.registerAdapter<ExerciseModel>(ExerciseModelAdapter());
    }
    setState(() {

    });

  }
  @override
  void dispose() {
    //_model.unfocusNode?.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () { print("Pressed");      },
      child: Scaffold(
        key: scaffoldKey,
        //backgroundColor: const Color(0xFF020224),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
              Container(
              width: double.infinity,
              height: 100.0,
              decoration: const BoxDecoration(),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            10.0, 0.0, 0.0, 0.0),
                        child: Text(
                          greeting,
                          style: TextStyle(
                            //fontFamily: 'Readex Pro',
                            //color: Colors.white,
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.local_fire_department_sharp,
                        color: Color(0xFFF13820),
                        size: 24.0,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),

                            child: Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(

                                //color: Theme.of(context).colorScheme.secondary,
                                image: const DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage('assets/images/fit3.jpg'),

                                    /*NetworkImage(

                                      'https://images.unsplash.com/photo-1506863530036-1efeddceb993?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwxNnx8cHJvZmlsZXxlbnwwfHx8fDE3MjE3MTQ0MjJ8MA&ixlib=rb-4.0.3&q=80&w=1080',
                                    )*/
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Padding(

                            padding: const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),

                            child: Text(
                              widget.userName,
                              style: TextStyle(
                                //fontFamily: 'Readex Pro',
                                //color: Colors.white,
                                fontSize: 25.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Spacer(),
                          Container(
                              width: 70.0,
                              height: 75.0,
                              decoration: BoxDecoration(
                                //color: Colors.black54,
                                borderRadius: BorderRadius.circular(12.0),
                                shape: BoxShape.rectangle,
                              ),
                              child: GestureDetector(onTap: (){
                                print("Connect Clicked");

                                showDialog(
                                  context: context, // Make sure you are passing a valid context
                                  builder: (BuildContext context) {
                                    // return Blecommunication(); // Replace this with your BLE dialog widget
                                    return BleConnect();
                                  },
                                );

                              },child:
                              Column(
                                //mainAxisAlignment: MainAxisAlignment.center,
                                //crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                Row(children: [
                                  const Icon(
                                    Icons.qr_code_scanner_outlined,
                                    //color: Colors.white,
                                    size: 40.0,
                                  ),
                                ],),
                                Row(children: [
                                  Text(
                                    'CONNECT',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      //fontFamily: 'Readex Pro',
                                      //color: Colors.white,
                                      fontSize: 15.0,
                                      letterSpacing: 0.0,
                                    ),
                                  ),
                                ],)
                              ],),
                          ),
                            ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),

                            child:                           Container(
                              width: 70.0,
                              height: 75.0,
                              decoration: BoxDecoration(
                                //color: Colors.black54,
                                borderRadius: BorderRadius.circular(12.0),
                                shape: BoxShape.rectangle,
                              ),
                              child: GestureDetector(onTap: (){
                                Navigator.push(context,MaterialPageRoute(builder: (context) => TargetConfigurationPage()));
                              },child:
                              Column(
                                //mainAxisAlignment: MainAxisAlignment.center,
                                //crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(children: [
                                    ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.asset(
                                      'assets/images/images.png',
                                      width: 40.0,
                                      height: 40.0,
                                      fit: BoxFit.cover,
                                    ),
                                    ),
                                  ],),
                                  Row(children: [
                                    Text(
                                      'TARGET',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        //fontFamily: 'Readex Pro',
                                        //color: Colors.white,
                                        fontSize: 15.0,
                                        letterSpacing: 0.0,
                                      ),
                                    ),
                                  ],)
                                ],),
                            ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            /*Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
              child: TextFormField(
                controller: TextEditingController(),

                autofocus: false,
                textCapitalization: TextCapitalization.sentences,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Search',
                  labelStyle: TextStyle(

                    fontFamily: 'Outfit',
                    color: Color(0xFF606A85),
                    fontSize: 18.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                  ),
                  hintStyle: TextStyle(

                    fontFamily: 'Outfit',
                    color: Color(0xFF606A85),
                    fontSize: 14.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                  ),
                  errorStyle: TextStyle(

                    fontFamily: 'Figtree',
                    color: Color(0xFFFF5963),
                    fontSize: 12.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFE5E7EB),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF6F61EF),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFFF5963),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFFF5963),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,

                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Theme.of(context).iconTheme.color,

                    size: 24.0,
                  ),
                ),
                style: TextStyle(

                  fontFamily: 'Figtree',
                  color: Color(0xFF15161E),
                  fontSize: 14.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
                cursorColor: Color(0xFF6F61EF),

              ),
            ),*/
            DayScroll(),
            /*SingleChildScrollView(child:
              Row(
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
              ),
            ),*/


        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(
                    20.0, 0.0, 0.0, 10.0),
                child: Text(
                  'Popular Workouts',
                  style: TextStyle(

                    //fontFamily: 'Readex Pro',

                    //color: Theme.of(context).colorScheme.primary,
                    fontSize: 20.0,
                    letterSpacing: 0.0,
                  ),
                ),
              ),

            ],
          ),
        ),

        Container(
          width: double.infinity,
          height: 200.0,
          decoration: BoxDecoration(),
          child: ListView(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            children: [
              Container(
                width: 280.0,
                height: 76.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(24.0),
                                  child: Image.asset(
                                    'assets/images/fit3.jpg',
                                    width: double.infinity,
                                    height: 180.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsetsDirectional
                                              .fromSTEB(
                                              20.0, 20.0, 0.0, 0.0),
                                          child: Text(
                                            'Lower Body\nTraining',
                                            style: TextStyle(
                                              fontSize: 25.0,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,

                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsetsDirectional
                                              .fromSTEB(
                                              20.0, 10.0, 0.0, 0.0),
                                          child: Container(
                                            width: 100.0,
                                            height: 35.0,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,

                                              borderRadius:
                                              BorderRadius.circular(
                                                  12.0),
                                              shape: BoxShape.rectangle,
                                            ),
                                            child: Row(
                                              mainAxisSize:
                                              MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding:
                                                  EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      5.0,
                                                      0.0,
                                                      0.0,
                                                      0.0),
                                                  child: Icon(
                                                    Icons
                                                        .local_fire_department_outlined,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSecondary,

                                                    size: 24.0,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      1.0,
                                                      0.0,
                                                      0.0,
                                                      0.0),
                                                  child: Text(
                                                    '500 Kcal',
                                                    style: TextStyle(
                                                      fontSize: 15.0,

                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsetsDirectional
                                              .fromSTEB(
                                              20.0, 10.0, 0.0, 0.0),
                                          child: Container(
                                            width: 90.0,
                                            height: 35.0,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).colorScheme
                                                  .secondary,
                                              borderRadius:
                                              BorderRadius.circular(
                                                  12.0),
                                              shape: BoxShape.rectangle,
                                            ),
                                            child: Row(
                                              mainAxisSize:
                                              MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding:
                                                  EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      5.0,
                                                      0.0,
                                                      0.0,
                                                      0.0),
                                                  child: Icon(
                                                    Icons
                                                        .timer_outlined,
                                                    color: Theme.of(context).colorScheme
                                                        .secondary,
                                                    size: 24.0,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      5.0,
                                                      0.0,
                                                      0.0,
                                                      0.0),
                                                  child: Text(
                                                    '50 Min',
                                                    style: TextStyle(
                                                      fontFamily:
                                                      'Readex Pro',
                                                      fontSize:
                                                      15.0,
                                                      letterSpacing:
                                                      0.0,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional
                                          .fromSTEB(
                                          40.0, 30.0, 0.0, 0.0),
                                      child: Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                          color: Color(0xFF2BFF00),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.play_arrow,
                                          color: Theme.of(context).colorScheme.primary,
                                          size: 24.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ]
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: 280.0,
                height: 76.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(24.0),
                                  child: Image.asset(
                                    'assets/images/fit3.jpg',
                                    width: double.infinity,
                                    height: 180.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsetsDirectional
                                              .fromSTEB(
                                              20.0, 20.0, 0.0, 0.0),
                                          child: Text(
                                            'Lower Body\nTraining',
                                            style: TextStyle(
                                              fontFamily:
                                              'Readex Pro',
                                              color: Theme.of(context).colorScheme
                                                  .secondary,
                                              fontSize: 25.0,
                                              letterSpacing: 0.0,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsetsDirectional
                                              .fromSTEB(
                                              20.0, 10.0, 0.0, 0.0),
                                          child: Container(
                                            width: 100.0,
                                            height: 35.0,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).colorScheme
                                                  .secondary,
                                              borderRadius:
                                              BorderRadius.circular(
                                                  12.0),
                                              shape: BoxShape.rectangle,
                                            ),
                                            child: Row(
                                              mainAxisSize:
                                              MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding:
                                                  EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      5.0,
                                                      0.0,
                                                      0.0,
                                                      0.0),
                                                  child: Icon(
                                                    Icons
                                                        .local_fire_department_outlined,
                                                    color: Theme.of(context).colorScheme
                                                        .secondary,
                                                    size: 24.0,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      1.0,
                                                      0.0,
                                                      0.0,
                                                      0.0),
                                                  child: Text(
                                                    '500 Kcal',
                                                    style: TextStyle(
                                                      fontFamily:
                                                      'Readex Pro',
                                                      fontSize:
                                                      15.0,
                                                      letterSpacing:
                                                      0.0,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsetsDirectional
                                              .fromSTEB(
                                              20.0, 10.0, 0.0, 0.0),
                                          child: Container(
                                            width: 90.0,
                                            height: 35.0,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).colorScheme
                                                  .secondary,
                                              borderRadius:
                                              BorderRadius.circular(
                                                  12.0),
                                              shape: BoxShape.rectangle,
                                            ),
                                            child: Row(
                                              mainAxisSize:
                                              MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding:
                                                  EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      5.0,
                                                      0.0,
                                                      0.0,
                                                      0.0),
                                                  child: Icon(
                                                    Icons
                                                        .timer_outlined,
                                                    color: Theme.of(context).colorScheme
                                                        .secondary,
                                                    size: 24.0,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      5.0,
                                                      0.0,
                                                      0.0,
                                                      0.0),
                                                  child: Text(
                                                    '50 Min',
                                                    style: TextStyle(
                                                      fontFamily:
                                                      'Readex Pro',
                                                      fontSize:
                                                      15.0,
                                                      letterSpacing:
                                                      0.0,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional
                                          .fromSTEB(
                                          40.0, 30.0, 0.0, 0.0),
                                      child: Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                          color: Color(0xFF2BFF00),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.play_arrow,
                                          color: Theme.of(context).colorScheme
                                              .secondary,
                                          size: 24.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ]
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: 280.0,
                height: 76.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(24.0),
                                  child: Image.asset(
                                    'assets/images/fit3.jpg',
                                    width: double.infinity,
                                    height: 180.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsetsDirectional
                                              .fromSTEB(
                                              20.0, 20.0, 0.0, 0.0),
                                          child: Text(
                                            'Lower Body\nTraining',
                                            style: TextStyle(
                                              fontFamily:
                                              'Readex Pro',
                                              color: Theme.of(context).colorScheme
                                                  .secondary,
                                              fontSize: 25.0,
                                              letterSpacing: 0.0,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsetsDirectional
                                              .fromSTEB(
                                              20.0, 10.0, 0.0, 0.0),
                                          child: Container(
                                            width: 100.0,
                                            height: 35.0,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).colorScheme
                                                  .secondary,
                                              borderRadius:
                                              BorderRadius.circular(
                                                  12.0),
                                              shape: BoxShape.rectangle,
                                            ),
                                            child: Row(
                                              mainAxisSize:
                                              MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding:
                                                  EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      5.0,
                                                      0.0,
                                                      0.0,
                                                      0.0),
                                                  child: Icon(
                                                    Icons
                                                        .local_fire_department_outlined,
                                                    color: Theme.of(context).colorScheme
                                                        .secondary,
                                                    size: 24.0,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      1.0,
                                                      0.0,
                                                      0.0,
                                                      0.0),
                                                  child: Text(
                                                    '500 Kcal',
                                                    style: TextStyle(
                                                      fontFamily:
                                                      'Readex Pro',
                                                      fontSize:
                                                      15.0,
                                                      letterSpacing:
                                                      0.0,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsetsDirectional
                                              .fromSTEB(
                                              20.0, 10.0, 0.0, 0.0),
                                          child: Container(
                                            width: 90.0,
                                            height: 35.0,
                                            decoration: BoxDecoration(
                                              //color: Theme.of(context).colorScheme
                                              //    .secondary,
                                              borderRadius:
                                              BorderRadius.circular(
                                                  12.0),
                                              shape: BoxShape.rectangle,
                                            ),
                                            child: Row(
                                              mainAxisSize:
                                              MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding:
                                                  EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      5.0,
                                                      0.0,
                                                      0.0,
                                                      0.0),
                                                  child: Icon(
                                                    Icons
                                                        .timer_outlined,
                                                    color: Theme.of(context).colorScheme
                                                        .secondary,
                                                    size: 24.0,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      5.0,
                                                      0.0,
                                                      0.0,
                                                      0.0),
                                                  child: Text(
                                                    '50 Min',
                                                    style: TextStyle(
                                                      fontFamily:
                                                      'Readex Pro',
                                                      fontSize:
                                                      15.0,
                                                      letterSpacing:
                                                      0.0,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional
                                          .fromSTEB(
                                          40.0, 30.0, 0.0, 0.0),
                                      child: Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                          color: Color(0xFF2BFF00),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.play_arrow,
                                          color: Theme.of(context).colorScheme
                                              .secondary,
                                          size: 24.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ]
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ]
          ),
        ),
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child:
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                      20.0, 0.0, 0.0, 0.0),
                  child: Text(
                    'Activity',
                    style: TextStyle(
                      //fontFamily: 'Readex Pro',
                      //color: Theme.of(context).colorScheme
                      //    .secondary,
                      fontSize: 20.0,
                      letterSpacing: 0.0,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                      10.0, 0.0, 0.0, 0.0),
                  child: Container(
                    width: 120.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color:
                        Theme.of(context).colorScheme
                            .secondary,
                        width: 2.0,
                      ),
                    ),
                    child:  Center(child: Text(
                      'Today',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        //fontFamily: 'Readex Pro',
                        color: Colors.white,
                        fontSize: 18.0,
                        letterSpacing: 0.0,
                      ),
                    ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                      10.0, 0.0, 0.0, 0.0),
                  child: Container(
                    width: 120.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: Color(0x4C7567E1),
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color:
                        Theme.of(context).colorScheme
                            .secondary,
                        width: 2.0,
                      ),
                    ),
                    child: Center(child: Text(
                      'Week',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        //fontFamily: 'Readex Pro',
                        color: Colors.white,
                        fontSize: 18.0,
                        letterSpacing: 0.0,
                      ),
                    ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                      10.0, 0.0, 0.0, 0.0),
                  child: Container(
                    width: 120.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: Color(0x4C7567E1),
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color:
                        Theme.of(context).colorScheme
                            .secondary,
                        width: 2.0,
                      ),
                    ),
                    child: Center(child: Text(
                      'Month',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        //fontFamily: 'Readex Pro',
                        color: Colors.white,
                        fontSize: 18.0,
                        letterSpacing: 0.0,
                      ),
                    ),
                    ),
                  ),
                ),
              ],
            ),
            activityGraph(),

          ],
        ),
        ),

        Padding(
          padding:
          EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 0.0),
          child: Container(
            width: double.infinity,
            height: 320.0,

            decoration: BoxDecoration(
              //color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    'assets/images/Screenshot_2024-07-24_114955.png',
                    width: 300.0,
                    height: 292.0,
                    fit: BoxFit.cover,
                  ),
                ),

          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            0.0, 0.0, 5.0, 0.0),
                        child: Container(
                          width: 20.0,
                          height: 20.0,
                          decoration: BoxDecoration(
                            color: Color(0xFFFF007C),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'NOT RECOVERED',
                    style: TextStyle(
                      //fontFamily: 'Readex Pro',
                      //color: Theme.of(context).colorScheme
                      //    .secondary,
                      letterSpacing: 0.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 0.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 5.0, 0.0),
                          child: Container(
                            width: 20.0,
                            height: 20.0,
                            decoration: BoxDecoration(
                              color: Color(0xFF2BFF00),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      ' RECOVERED',
                      style: TextStyle(
                        //fontFamily: 'Readex Pro',
                        //color: Theme.of(context).colorScheme
                        //    .secondary,
                        letterSpacing: 0.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding:
          EdgeInsetsDirectional.fromSTEB(5.0, 10.0, 5.0, 0.0),
          child: Container(
            width: double.infinity,
            height: 530.0,
            decoration: BoxDecoration(
              //color: Colors.black54,
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: AlignmentDirectional(-1.0, 0.0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        20.0, 10.0, 0.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'STATISTICS',
                          style: TextStyle(
                            //fontFamily: 'Readex Pro',
                            //color: Colors.white,
                            fontSize: 20.0,
                            letterSpacing: 0.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                      10.0, 10.0, 0.0, 0.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              5.0, 0.0, 10.0, 0.0),
                          child:Container(
                            width: 100.0,
                            height: 37.0,
                            decoration: BoxDecoration(
                              color: Color(0xFF00492B),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Center(
                              child: Text(
                                'Today',
                                style: TextStyle(
                                  fontFamily: 'Readex Pro',
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              10.0, 0.0, 10.0, 0.0),
                          child: Opacity(
                          opacity: 0.3,
                          child: Container(
                              width: 100.0,
                              height: 37.0,
                              decoration: BoxDecoration(
                                color: Color(0xFF3A4243),
                                borderRadius:
                                BorderRadius.circular(12.0),
                                border: Border.all(
                                  color: Theme.of(context).colorScheme
                                      .secondary,
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Week',
                                  style: TextStyle(
                                    fontFamily: 'Readex Pro',
                                    color:Colors.white70,
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              10.0, 0.0, 10.0, 0.0),
                          child:Opacity(
                          opacity: 0.3,
                          child: Container(
                            width: 100.0,
                            height: 37.0,
                            decoration: BoxDecoration(
                              color: Color(0xFF3A4243),
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: Theme.of(context).colorScheme
                                    .secondary,
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Month',
                                style: TextStyle(
                                  fontFamily: 'Readex Pro',
                                  color:Colors.white70,
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                      5.0, 20.0, 0.0, 0.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 3.0, 0.0),
                            child:Container(
                              width: 120,
                              height: 200,
                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(100)),gradient: LinearGradient(colors: [Colors.grey,Colors.white30])),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(width:100,height:90,child: Image.asset(
                                    'assets/images/clock.png',
                                    fit: BoxFit.cover,
                                  ),),
                                  Text("Total Active",style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold),),
                                  Text("2000",style: TextStyle(fontSize: 30,color: Colors.black,fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              3.0, 0.0, 3.0, 0.0),
                          child:Container(
                            width: 120,
                            height: 200,
                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(100)),gradient: LinearGradient(colors: [Colors.grey,Colors.white30])),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(width:100,height:80,child: Image.asset(
                                  'assets/images/hand.png',
                                  fit: BoxFit.cover,
                                ),),
                                Text("Total MOVE",style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold),),
                                Text("52",style: TextStyle(fontSize: 30,color: Colors.black,fontWeight: FontWeight.bold),),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              3.0, 0.0, 3.0, 0.0),
                          child:Container(
                            width: 120,
                            height: 200,
                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(100)),gradient: LinearGradient(colors: [Colors.grey,Colors.white30])),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(width:100,height:90,child: Image.asset(
                                  'assets/images/hand.png',
                                  fit: BoxFit.cover,
                                ),),
                                Text("Total SETS",style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold),),
                                Text("500",style: TextStyle(fontSize: 30,color: Colors.black,fontWeight: FontWeight.bold),),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                      5.0, 20.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            5.0, 0.0, 20.0, 0.0),
                        child:Container(
                          width: 120,
                          height: 200,
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(100)),gradient: LinearGradient(colors: [Colors.grey,Colors.white30])),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(width:90,height:90,child: Image.asset(
                                'assets/images/fireclock.png',
                                fit: BoxFit.cover,
                              ),),
                              Text("Total Kcal",style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold),),
                              Text("500",style: TextStyle(fontSize: 30,color: Colors.black,fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            5.0, 0.0, 20.0, 0.0),
                        child:Container(
                          width: 120,
                          height: 200,
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(100)),gradient: LinearGradient(colors: [Colors.grey,Colors.white30])),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(width:90,height:90,child: Image.asset(
                                'assets/images/fireclock.png',
                                fit: BoxFit.cover,
                              ),),
                              Text("Total Volume",style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold),),
                              Text("5000",style: TextStyle(fontSize: 30,color: Colors.black,fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding:
          EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 0.0),
          child: Container(
            width: double.infinity,
            height: 350.0,
            decoration: BoxDecoration(
              //color: Colors.black54,
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: AlignmentDirectional(-1.0, 0.0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        20.0, 10.0, 0.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'TRAINING DONE',
                          style: TextStyle(
                            //fontFamily: 'Readex Pro',
                            //color: Colors.white,
                            fontSize: 20.0,
                            letterSpacing: 0.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                      10.0, 10.0, 0.0, 0.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              5.0, 0.0, 10.0, 0.0),
                          child:Container(
                            width: 100.0,
                            height: 37.0,
                            decoration: BoxDecoration(
                              color: Color(0xFF00492B),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Center(
                              child: Text(
                                'Today',
                                style: TextStyle(
                                  fontFamily: 'Readex Pro',
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              10.0, 0.0, 10.0, 0.0),
                          child: Opacity(
                            opacity: 0.3,
                            child: Container(
                              width: 100.0,
                              height: 37.0,
                              decoration: BoxDecoration(
                                color: Color(0xFF3A4243),
                                borderRadius:
                                BorderRadius.circular(12.0),
                                border: Border.all(
                                  color: Theme.of(context).colorScheme
                                      .secondary,
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Week',
                                  style: TextStyle(
                                    fontFamily: 'Readex Pro',
                                    color:Colors.white70,
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              10.0, 0.0, 10.0, 0.0),
                          child:Opacity(
                            opacity: 0.3,
                            child: Container(
                              width: 100.0,
                              height: 37.0,
                              decoration: BoxDecoration(
                                color: Color(0xFF3A4243),
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                  color: Theme.of(context).colorScheme
                                      .secondary,
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Month',
                                  style: TextStyle(
                                    fontFamily: 'Readex Pro',
                                    color:Colors.white70,
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                      0.0, 10.0, 0.0, 0.0),
                  child: Container(
                    width: 229.0,
                    height: 243.0,
                    child: pieChart()
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    ),
    ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
              backgroundColor: Colors.black,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_sharp),
              label: 'Business',
    //backgroundColor: Colors.green,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'School',
              //backgroundColor: Colors.purple,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
              //backgroundColor: Colors.pink,
            ),
          ],
          currentIndex: 0,
          selectedItemColor: Colors.lightGreenAccent,
          onTap: (int x) async{
              print(x);
              final appDocumentDirectory = await getApplicationDocumentsDirectory();
              Hive.init(appDocumentDirectory.path);
              if (!Hive.isAdapterRegistered(1)) {
                Hive.registerAdapter<ExerciseCategories>(
                    ExerciseCategoriesAdapter());
                Hive.registerAdapter<MovementModel>(MovementModelAdapter());
                Hive.registerAdapter<ExerciseModel>(ExerciseModelAdapter());
              }
              print(Hive.isBoxOpen('exercise_box'));
              if(!Hive.isBoxOpen('exercise_box')){
                await Hive.openBox<ExerciseCategories>('exercise_box');
              }
              if(x==1){
                  Hive.deleteBoxFromDisk('exercise_box');
                  Fluttertoast.showToast(
                      msg: "Deleted All Data",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
              }
              else if(x==2){
                //await Hive.openBox<ExerciseCategories>('exercise_box');
                //Hive.deleteBoxFromDisk('exercise_box');
                Box<ExerciseCategories> dataBox = Hive.box<ExerciseCategories>('exercise_box');
                List<ExerciseModel> x=[];
                ExerciseModel tempExercise=ExerciseModel(set: "1", reps: "10", weight: "100 KGS", weightMode: "Standard", assistMode: "NIL");
                x.add(tempExercise);
                //tempMovement.sets.add(tempExercise);
                //print("Adding Data");
                tempExercise=ExerciseModel(set: "2", reps: "20", weight: "200 KGS", weightMode: "Stand", assistMode: "NONE");
                x.add(tempExercise);
                //tempMovement.sets.add(tempExercise);
                //print("Adding Data");
                MovementModel tempMovement=MovementModel(name: "Standing Chest Press",sets: x);
                List<MovementModel> y=[];
                y.add(tempMovement);
                tempMovement=MovementModel(name: "Cable Chest Fly",sets: x);
                y.add(tempMovement);
                tempMovement=MovementModel(name: "Chest Press",sets: x);
                y.add(tempMovement);
                tempMovement=MovementModel(name: "Bench Press",sets: x);
                y.add(tempMovement);
                ExerciseCategories tempCategories=ExerciseCategories(name: "Chest",shortName: 'CH',movements: y);
                tempCategories.movements.add(tempMovement);
                dataBox.add(tempCategories);

                y=[];
                tempMovement=MovementModel(name: "Dual Handle Row",sets: x);
                y.add(tempMovement);
                tempMovement=MovementModel(name: "Arm Pull Down",sets: x);
                y.add(tempMovement);
                tempMovement=MovementModel(name: "Lat Pull Down",sets: x);
                y.add(tempMovement);
                tempCategories=ExerciseCategories(name: "Back",shortName: 'Bk',movements: y);
                //dataBox.add(newData);
                dataBox.add(tempCategories);
                y=[];
                tempMovement=MovementModel(name: "Front Raise",sets: x);
                y.add(tempMovement);
                tempMovement=MovementModel(name: "Reverse Cable Fly",sets: x);
                y.add(tempMovement);
                tempMovement=MovementModel(name: "Shoulder Press",sets: x);
                y.add(tempMovement);
                tempCategories=ExerciseCategories(name: "Shoulders",shortName: 'SH',movements: y);
                //dataBox.add(newData);
                dataBox.add(tempCategories);
                await dataBox.close();
                Fluttertoast.showToast(
                    msg: "Added New Data",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              }
              else if (x==3){
                Navigator.push(context,MaterialPageRoute(builder: (context) => Settingsscreen(userName: widget.userName)));

              }
            },
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: SizedBox(height: 40,child: 
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FloatingActionButton.extended(
                heroTag: "Btn1",
                backgroundColor: Colors.lightGreenAccent.withOpacity(0.5),
                onPressed: () {
                  //print(findFirstDateOfTheWeek(DateTime.now()));
                  // printCurrentWeek();
                  Navigator.push(context,MaterialPageRoute(builder: (context) => StrengthGaugePage()));
                },
                label:Text("Strength Gauge"),
                icon:Icon(Icons.navigate_before),
                ),
              FloatingActionButton.extended(
                heroTag: "Btn2",
                backgroundColor: Colors.lightGreenAccent.withOpacity(0.6),
                onPressed: () {
                  //print(DateFormat('EEE').format(findLastDateOfTheWeek(DateTime.now())));
                  Navigator.push(context,MaterialPageRoute(builder: (context) => JustLiftPage()));
                },
                label:Text("Just Lift"),
                icon:Icon(Icons.navigate_before),
              ),
            ],
          ),
        ),
        ),
        floatingActionButtonLocation:FloatingActionButtonLocation.centerDocked,
    ),
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


  DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }
  DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime
        .add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
  }
  void printCurrentWeek(){
    DateTime today=DateTime.now();
    for(int i =1;i<=7;i++){
      print(DateFormat("EEE").format(today.subtract(Duration(days: today.weekday - i))));
      print(DateFormat("dd").format(today.subtract(Duration(days: today.weekday - i))));
    }
  }

  Widget buildActivityDay(BuildContext context, String day, double height) {
    return Padding(padding: EdgeInsets.only(left:10),child:
    Column(
        children:[
      Row(children: [
        Container(
          width:10,
          height: height,
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.circular(5.0),
            color: Colors.green,
          ),
        ),
      ],),
      Row(children: [
        Text(day,style: TextStyle(color: Colors.white),),
      ],),
    ]),
    );
  }
  
  
  Widget activityGraph(){
    final List<String> entries = <String>['Mon', 'Tue', 'Wed','Thu', 'Fri', 'Sat','Sun'];
    final List<String> values = <String>['150', '80', '120','40', '130', '90','30'];
    return Padding(padding: EdgeInsets.only(top:10,bottom:10),child:
    Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          child: Align(alignment: Alignment.bottomCenter,child:
          ListView.builder(
              scrollDirection: Axis.horizontal,
              //shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              itemCount: entries.length,
              itemBuilder: (BuildContext context, int index) {
                return
                Padding(padding: EdgeInsets.only(left: 25),child:
                    Column(children:[
                      Spacer(),
                      Row(children: [
                        Container(
                          width:25,
                          height:double.parse(values[index]),
                          decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.circular(5.0),
                            color: Colors.green,
                          ),
                        ),
                      ],),
                      Row(children: [
                        Text(entries[index],),
                      ],),
                    ]),
                    );
                  }
                ),
              ),
            ),
      ],),
    );
  }

 /* Widget activityGraph(){
    return Padding(padding: EdgeInsets.only(top:10,bottom:10),child:
    Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(children:[
          Row(children: [
            Container(
              width:25,
              height:150,
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(5.0),
                color: Colors.green,
              ),
            ),
          ],),
          Row(children: [
            Text("Mon",style: TextStyle(color: Colors.white),),
          ],),
        ]),

        Column(
            children:[
              Row(
                children: [
                  Container(
                    width:25,
                    height:100,
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.circular(5.0),
                      color: Colors.green,
                    ),
                  ),
                ],),
              Row(children: [
                Text("Tue",style: TextStyle(color: Colors.white),),
              ],),
            ]),

        Column(children:[
          Row(children: [
            Container(
              width:25,
              height:150,
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(5.0),
                color: Colors.green,
              ),
            ),
          ],),
          Row(children: [
            Text("Wed",style: TextStyle(color: Colors.white),),
          ],),
        ]),

        Column(
            children:[
              Row(
                children: [
                  Container(
                    width:25,
                    height:70,
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.circular(5.0),
                      color: Colors.green,
                    ),
                  ),
                ],),
              Row(children: [
                Text("Thu",style: TextStyle(color: Colors.white),),
              ],),
            ]),

        Column(children:[
          Row(children: [
            Container(
              width:25,
              height:150,
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(5.0),
                color: Colors.green,
              ),
            ),
          ],),
          Row(children: [
            Text("Fri",style: TextStyle(color: Colors.white),),
          ],),
        ]),

        Column(
            children:[
              Row(
                children: [
                  Container(
                    width:25,
                    height:100,
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.circular(5.0),
                      color: Colors.green,
                    ),
                  ),
                ],),
              Row(children: [
                Text("Sat",style: TextStyle(color: Colors.white),),
              ],),
            ]),

        Column(children:[
          Row(children: [
            Container(
              width:25,
              height:110,
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(5.0),
                color: Colors.green,
              ),
            ),
          ],),
          Row(children: [
            Text("Sun",style: TextStyle(color: Colors.white),),
          ],),
        ]),

      ],),
    );
  }*/
  
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
  }

  Widget pieChart() {
    Box<ExerciseCategories> dataBox;
    //Box<ExerciseCategories> dataBox = Hive.box<ExerciseCategories>('exercise_box');
    /*final List<ChartData> chartData = [
      ChartData('CH', 25),
      ChartData('SH', 38),
      ChartData('BH', 34),
      ChartData('LH', 52)
    ];*/
    final List<ChartData> chartData = [];



    return FutureBuilder(future: Hive.openBox<ExerciseCategories>('exercise_box'),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                  child: Text(snapshot.error.toString(),style: TextStyle(color: Colors.white),),
                );
            } else {
              dataBox = Hive.box<ExerciseCategories>('exercise_box');
              var rng = Random();
              for(int i=0;i<dataBox.length;i++){
                chartData.add(ChartData(dataBox.getAt(i)!.shortName,double.parse(rng.nextInt(70).toString())));
              }
              return Container(
                  child: SfCircularChart(
                      //centerX: '0%',
                      //centerY: '10%',
                      legend: Legend(
                          isVisible: true, position: LegendPosition.bottom),
                      series: <CircularSeries>[
                        // Render pie chart
                        DoughnutSeries<ChartData, String>(
                          dataSource: chartData,
                          pointColorMapper: (ChartData data, _) => data.color,
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y,
                          dataLabelMapper: (ChartData data, _) =>
                              data.y.toString(),
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          innerRadius: '60%',
                          //radius: '120%',
                        )
                      ]
                  )
              );
            }
          } else {
            return Center(
                child: CircularProgressIndicator(),
              );
          }
        },);
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color? color;
}
