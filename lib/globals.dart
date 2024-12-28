import 'package:flutter/material.dart';
import 'package:indafit/exerciseStatus.dart';
import 'package:indafit/aboutME.dart';
import 'package:indafit/main.dart';
import 'package:indafit/landingPage.dart';
import 'package:indafit/planWorkOut.dart';
import 'package:indafit/exerciseStatus_1.dart';
import 'package:indafit/justLift.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(child:
    ListView(children: [
      ListTile(title: Text("Home Page"), onTap: (){
        Navigator.pop(context);
        Navigator.push(context,MaterialPageRoute(builder: (context) => MyHomePage()));
      },
      ),
      ListTile(title: Text("About ME"), onTap: (){
        Navigator.pop(context);
        Navigator.push(context,MaterialPageRoute(builder: (context) => AboutMePage()));
      },
      ),
      ListTile(title: Text("Setup Goal")),
      ListTile(title: Text("Setup Activity Level")),
      ListTile(title: Text("Configure Workout"),onTap: (){
        Navigator.pop(context);
        Navigator.push(context,MaterialPageRoute(builder: (context) => PlanworkoutHome()));
      },),
      ListTile(title: Text("Show Status"), onTap: (){
        Navigator.pop(context);
        Navigator.push(context,MaterialPageRoute(builder: (context) => StatusPage()));
      },
      ),
      ListTile(title: Text("New Status"), onTap: (){
        Navigator.pop(context);
        Navigator.push(context,MaterialPageRoute(builder: (context) => ExerciseStatusPage()));
      },
      ),
      ListTile(title: Text("Just Lift"), onTap: (){
        Navigator.pop(context);
        Navigator.push(context,MaterialPageRoute(builder: (context) => JustLiftPage()));
      },
      ),
    ],)
    );
  }
}



  /*Widget _drawerItemList(BuildContext context) {
    return Drawer(child:
    ListView(children: [
      ListTile(title: Text("Home Page"), onTap: (){
        Navigator.pop(context);
        Navigator.push(context,MaterialPageRoute(builder: (context) => MyHomePage()));
      },
      ),
      ListTile(title: Text("About ME"), onTap: (){
        Navigator.pop(context);
        Navigator.push(context,MaterialPageRoute(builder: (context) => AboutMePage()));
      },
      ),
      ListTile(title: Text("Setup Goal")),
      ListTile(title: Text("Setup Activity Level")),
      ListTile(title: Text("Configure Workout")),
      ListTile(title: Text("Show Status"), onTap: (){
        Navigator.pop(context);
        Navigator.push(context,MaterialPageRoute(builder: (context) => StatusPage()));
      },
      ),
    ],)
    );
}*/