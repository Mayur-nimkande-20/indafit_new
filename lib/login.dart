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
import 'package:provider/provider.dart';
import 'color_themes_file/theme_notifier.dart';

class GymApp extends StatelessWidget {
  //final token="", stationName="", empId=0;
  //const MyApp({this.token, this.stationName, this.empId, super.key});
  const GymApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      themeMode: themeNotifier.themeMode, // Apply the theme mode from the notifier
      theme: ThemeData.light(), // Light theme
      darkTheme: ThemeData.dark(),
      home: GymLogin(),
      debugShowCheckedModeBanner: false,
    );
  }
}
class GymLogin extends StatefulWidget {
  const GymLogin({super.key});

  @override
  State<GymLogin> createState() => GymLoginState();
}

class GymLoginState extends State<GymLogin> {
  //make text editing controller
  late TextEditingController controllerIpAddress;
  late TextEditingController controllerusername;
  late TextEditingController controllerpass;
  late var employeeInfo;
  late List<dynamic> stationInfo=[];
  // late var token;

  int? employeeID;
  String? ipAddress;
  String? userName  ;
  String? password;
  bool isChecked = false;
  bool obscureText = true;


  @override
  void initState() {
    // getStationInfo();
    //getCurrentShiftFunc();
    controllerIpAddress = TextEditingController();
    controllerusername = TextEditingController(text : "mayur");
    controllerpass = TextEditingController(text : "123456");
    //initSharedPref();
    super.initState();
    //controllerIpAddress = new TextEditingController(text: '10.0.2.2');
    //controllerIpAddress = new TextEditingController(text: '192.168.0.40');    //windals IP
    //controllerIpAddress = new TextEditingController(text: '192.168.137.1');
    //controllerIpAddress = new TextEditingController(text: '114.143.123.182');    //Bhopal IP


    //getStationInfo();
    //getProductInfo();

  }


  @override
  void dispose() {
    controllerIpAddress.dispose();
    controllerusername.dispose();
    controllerpass.dispose();
    super.dispose();
  }


  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text("Windals App", textDirection: TextDirection.ltr)),
      // endDrawer: const MyDrawer(),
      //bottomNavigationBar: myFooter,
      body: SafeArea(child:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(27.0, 0, 27.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                // width: MediaQuery.sizeOf(context).width / 1.5,
                height: 170,
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      child: Image.asset(
                        'assets/images/gym1.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Center(
                      child: Text(
                        "Welcome to IndiaFIT",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextField(
                controller: controllerusername,
                autofocus: true,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Icon(Icons.person_2),
                  ),
                  hintText: 'Username',
                  labelText: 'Username',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    userName = value;
                  });
                },
              ),
              const SizedBox(
                height: 18.0,
              ),
              TextField(
                obscureText: obscureText,
                textInputAction: TextInputAction.next,
                controller: controllerpass,
                decoration: InputDecoration(
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ExcludeFocus(
                      excluding: true,
                      child:IconButton(
                        icon: Icon(Icons.hide_source),
                        onPressed: () {
                          setState(() {
                            obscureText=!obscureText;
                            /*obscureText
                              ? obscureText = false
                              : obscureText = true;*/
                          });
                        },
                      ),
                    ),
                  ),
                  // contentPadding: EdgeInsets.only(top: 20 ,bottom: 20,left: 40),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Icon(Icons.lock),
                  ),
                  hintText: 'Password',
                  labelText: 'Password',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: 18.0,
              ),
              Center(child:ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.lightGreenAccent,
                  minimumSize: const Size(150, 45),
                ),
                onPressed: () async {
                    print("Logged in");
                    final appDocumentDirectory = await getApplicationDocumentsDirectory();
                    Hive.init(appDocumentDirectory.path);
                    if (!Hive.isAdapterRegistered(4)) {
                      Hive.registerAdapter<UserModel>(UserModelAdapter());
                    }
                    //print(Hive.isBoxOpen('exercise_box'));
                    if(!Hive.isBoxOpen('userInfo_box')){
                      await Hive.openBox<UserModel>('userInfo_box');
                    }
                    Box<UserModel> dataBox = Hive.box<UserModel>('userInfo_box');
                    bool allowEntry=false;
                    dataBox.values.forEach((user){
                      if(user.userName==controllerusername.text && user.passWord==controllerpass.text)
                        {
                          allowEntry=true;
                        }
                    });
                    dataBox.close();
                    await Hive.close();

                    if(controllerusername.text =="admin" && controllerpass.text == "admin") {
                      Navigator.push(context,MaterialPageRoute(builder: (context) => HomePageWidget(userName: controllerusername.text,)));
                    }
                    else if(allowEntry) {
                      Navigator.push(context,MaterialPageRoute(builder: (context) => HomePageWidget(userName: controllerusername.text,)));
                    }
                    else{
                      Fluttertoast.showToast(
                          msg: "Please Check User Name/Password",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    }
                },
                child: Text("Login"),
              )),
              // ElevatedButton(
              //     onPressed: () {
              //       //supervisor page
              //       Navigator.push(
              //           context,
              //           CupertinoPageRoute(
              //             builder: (context) => SupervisorPage(),
              //           ));
              //     },
              //     child: Text("Supervisor Page")),
              Center(child:  Padding(
                padding: const EdgeInsets.only(top: 5),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context,MaterialPageRoute(builder: (context) => SignUpPage()));
                    WidgetsBinding.instance.addPostFrameCallback((_) => setState((){}));
                  },
                  child:
                  Text(
                    'New User?Signup',
                    style: TextStyle(fontSize: 11),
                  ),
                ),
              ),
              )
            ],
          ),
        ),
      ),
    ),
    );
  }
}

