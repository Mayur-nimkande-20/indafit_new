import 'package:flutter/material.dart';
import 'package:indafit/Screensfromsettings/account.dart';
//import 'package:flutter_health/screens/empty_main_screen.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'package:indafit/model/model.dart';
import 'package:indafit/model/settings_options_model.dart';
import 'Screensfromsettings/color_theme_screen.dart';
import 'package:indafit/startupPage.dart';
class Settingsscreen extends StatefulWidget {
  const Settingsscreen({super.key, required this.userName});
  final String userName;
  @override
  State<Settingsscreen> createState() => _SettingsscreenState();
}

class _SettingsscreenState extends State<Settingsscreen> {
  Box<UserModel>? userBox;

  UserModel? userData;

  String username="";

  // settingsOptionModel to make the view of options in a simple way.
  late final List<SettingsOptionModel> settingsOptions = [
    SettingsOptionModel(title: 'Account', screen: Accountscreen(userName: widget.userName,)),
    SettingsOptionModel(title: 'Machine info', screen: MachineInfoScreen()),
    SettingsOptionModel(title: 'My device', screen: MyDeviceScreen()),
    SettingsOptionModel(title: 'Body health', screen: BodyHealthScreen()),
    SettingsOptionModel(title: 'Color theme', screen: Colorthemescreen()),
    // SettingsOptionModel(title: 'Color theme', screen: ColorThemeScreen()),
    SettingsOptionModel(title: 'Legal', screen: LegalScreen()),
    SettingsOptionModel(title: 'Settings', screen: MoreSettingsScreen()),
  ];

  @override
  void initState(){
    super.initState();
    _initializeHive();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // _updateUsername();
    _initializeHive();
  }

  // Initialising the username var with the username from db
  // after update inn userName in account here name is not being updated
  Future<void> _initializeHive() async {
    userBox = await Hive.box('user');
    userData = userBox?.getAt(0);
    if (userData != null) {
      setState(() {
        username = userData!.userName;
      });
    }
  }
  // refreshing userName
  // Future<void> _updateUsername() async {
  //   userData = userBox?.getAt(0);
  //   if (userData != null) {
  //     setState(() {
  //       username = userData!.userName;
  //     });
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        leading:
        Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.blueAccent,
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded,size: 20,),
            onPressed: () {
              Navigator.pop(context);
              /*Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePageWidget(userName: widget.userName)),
                    (Route<dynamic> route) => false, // Removes all routes from the stack
              );*/
              // Navigator.pop(context); // Navigate back to the previous screen
            },
          ),
        ),



        actions: [
          IconButton(
            icon: Icon(Icons.connect_without_contact),
             // Placeholder for "Connect"
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ConnectScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.av_timer), // Placeholder for "Target"
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TargetScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 55,
                  child: Icon(Icons.person_2_rounded),
                ),
                SizedBox(width: 16),
                Text(
                    username,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 40),
            Expanded(
              child: ListView.builder(

                padding: EdgeInsets.symmetric(horizontal: 20),
                itemCount: settingsOptions.length,
                itemBuilder: (context, index) {
                  return _buildsettingsoption(
                      context, settingsOptions[index].title, settingsOptions[index].screen);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      _signOut(context);
                    },
                    child: Text(
                      'Sign Out',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // list widget
  Widget _buildsettingsoption(BuildContext context, String title, Widget screen) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black, width: 1),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 0),
        title: Text(title),
        trailing: Icon(Icons.arrow_forward_ios_rounded,size: 20,color: Colors.red,),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
      ),
    );
  }

  void _signOut(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

}

// class AccountScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Account')),
//       body: Center(child: Text('Account Screen')),
//     );
//   }
// }

class MachineInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Machine Info')),
      body: Center(child: Text('Machine Info Screen')),
    );
  }
}

class MyDeviceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Device')),
      body: Center(child: Text('My Device Screen')),
    );
  }
}

class BodyHealthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Body Health')),
      body: Center(child: Text('Body Health Screen')),
    );
  }
}

class ColorThemeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Color Theme')),
      body: Center(child: Text('Color Theme Screen')),
    );
  }
}

class LegalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Legal')),
      body: Center(child: Text('Legal Screen')),
    );
  }
}

class MoreSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('More Settings')),
      body: Center(child: Text('More Settings Screen')),
    );
  }
}

class ConnectScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Connect')),
      body: Center(child: Text('Connect Screen')),
    );
  }
}

class TargetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Target')),
      body: Center(child: Text('Target Screen')),
    );
  }
}
