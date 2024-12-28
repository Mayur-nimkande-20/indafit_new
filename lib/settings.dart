// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:indafit/landingPage.dart';
import 'package:indafit/singup.dart';
import 'package:indafit/startupPage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:indafit/model/model.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() async {
  // Fetch the available cameras before initializing the app.
  //runApp(MyApp());
  runApp(const SettingsApp());
}
class SettingsApp extends StatelessWidget {
  //final token="", stationName="", empId=0;
  //const MyApp({this.token, this.stationName, this.empId, super.key});
  const SettingsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue,scaffoldBackgroundColor: const Color(0xFFEFEFEF)),
      home: SettingsPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }


  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      //appBar: AppBar(title: Text("Windals App", textDirection: TextDirection.ltr)),
      // endDrawer: const MyDrawer(),
      //bottomNavigationBar: myFooter,
      body: SafeArea(child:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(27.0, 0, 27.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(children: [
                /*CircleAvatar(
                  radius: 58,
                  backgroundImage: AssetImage("assets/images/clock.png"),
                  child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.bottomRight,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.white70,
                            child: Icon(CupertinoIcons.camera),
                          ),
                        ),
                      ]
                  ),
                ),
                Text("GANESH Katke ABCDEFG",style: TextStyle(color: Colors.white,fontSize: 30),overflow: TextOverflow.fade),
                */
                Column(children: [
                  CircleAvatar(
                    radius: 58,
                    backgroundImage: AssetImage("assets/images/clock.png"),
                    child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomRight,
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.white70.withOpacity(0.4),
                              child: Icon(CupertinoIcons.camera),
                            ),
                          ),
                        ]
                    ),
                  ),
                ],),
                Column(
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(height: 110,width: 220,child:
                    Wrap(children: [
                      Text("GANESH KATKE",style: TextStyle(color: Colors.white,fontSize: 30),overflow: TextOverflow.fade),
                      //Text("Katke ABCDEFG",style: TextStyle(color: Colors.white,fontSize: 30),overflow: TextOverflow.fade),

                    ],)),
                    /*Expanded(
                      child: Column(children: [
                        Text("GANESH Katke ABCDEFG",style: TextStyle(color: Colors.white,fontSize: 30),overflow: TextOverflow.fade),
                      ],),
                    )*/
                    /*Column(
                      children: [
                      Text("GANESH",style: TextStyle(color: Colors.white,fontSize: 30),overflow: TextOverflow.fade),
                      Text("KATKE ABCDERF",style: TextStyle(color: Colors.white,fontSize: 30),overflow: TextOverflow.fade,),
                    ],),*/
                  /*Container(color: Colors.red,height: 100,child:
                    Flexible(child:
                      Text("GANESH KATKE ABCDERF",style: TextStyle(color: Colors.white,fontSize: 30),softWrap: false,maxLines: 2,),
                    ),
                    ),*/
                ],)
              ],),

              SizedBox(height: 30,),
              Row(children: [
                Expanded(child: Text("Account",style: TextStyle(color: Colors.white,fontSize: 18),)),
                Container(child: Icon(Icons.arrow_forward_ios_sharp,color: Colors.white,)),
              ],),
              SizedBox(height: 30,),
              Row(children: [
                Expanded(child: Text("Machine Info",style: TextStyle(color: Colors.white,fontSize: 18),)),
                Container(child: Icon(Icons.arrow_forward_ios_sharp,color: Colors.white,)),
              ],),
              SizedBox(height: 30,),
              Row(children: [
                Expanded(child: Text("My Devices",style: TextStyle(color: Colors.white,fontSize: 18),)),
                Container(child: Icon(Icons.arrow_forward_ios_sharp,color: Colors.white,)),
              ],),
              SizedBox(height: 30,),
              Row(children: [
                Expanded(child: Text("Body and Health",style: TextStyle(color: Colors.white,fontSize: 18),)),
                Container(child: Icon(Icons.arrow_forward_ios_sharp,color: Colors.white,)),
              ],),
              SizedBox(height: 30,),
              Row(children: [
                Expanded(child: Text("Color Theme",style: TextStyle(color: Colors.white,fontSize: 18),)),
                Container(child: Icon(Icons.arrow_forward_ios_sharp,color: Colors.white,)),
              ],),
              SizedBox(height: 30,),
              Row(children: [
                Expanded(child: Text("legel",style: TextStyle(color: Colors.white,fontSize: 18),)),
                Container(child: Icon(Icons.arrow_forward_ios_sharp,color: Colors.white,)),
              ],),
              SizedBox(height: 30,),
              Row(children: [
                Expanded(child: Text("Settings",style: TextStyle(color: Colors.white,fontSize: 18),)),
                Container(child: Icon(Icons.arrow_forward_ios_sharp,color: Colors.white,)),
              ],)
            ],
          ),
        ),
      ),
      ),
    );
  }
}

