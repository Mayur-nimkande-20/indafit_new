import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:indafit/model/model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:animated_weight_picker/animated_weight_picker.dart';

void main() {
  print(DateFormat('dd-MM-yyyy').format(DateTime.now()));
  return runApp(SignUp());
}

/// Represents the GaugeApp class
class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /*return MaterialApp(
      title: 'Radial Gauge Demo',
      theme: ThemeData(primarySwatch: Colors.blue,scaffoldBackgroundColor: const Color(0xFFEFEFEF)),
      home: SignUpPage(),
    );*/
    return SignUpPage();
  }
}

/// Represents MyHomePage class
class SignUpPage extends StatefulWidget {
  /// Creates the instance of MyHomePage
  SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => SignUpPageState();
}
double _volumeValue = 50;

void onVolumeChanged(double value) {
  //setState(() {
  _volumeValue = value;
  //});
}

class SignUpPageState extends State<SignUpPage> {
  bool obscureTextPasswd = true;
  bool obscureTextRePasswd = true;
  late FocusNode userFocus;
//TextEditingController dateController = new TextEditingController(text: DateFormat('dd-MM-yyyy').format(DateTime.now()));
TextEditingController dateController = new TextEditingController();
TextEditingController firstName = new TextEditingController();
TextEditingController lastName = new TextEditingController();
TextEditingController userName = new TextEditingController();
TextEditingController passWord = new TextEditingController();
TextEditingController rePassWord = new TextEditingController();
TextEditingController mobile = new TextEditingController();
var _currentIntValue=10;
String selectedValue = '';

  @override
  void initState() {
    super.initState();

    userFocus = FocusNode();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      /*drawer: Drawer(child:
      ListView(children: [

        ListTile(title: Text("About ME"), onTap: (){ 					Navigator.pop(context);
    Navigator.pushNamed(context,'/studentAdd');
  },
),
ListTile(title: Text("Setup Goal")),
ListTile(title: Text("Setup Activity Level")),
ListTile(title: Text("Configure Workout")),
],)
),*/
      appBar: AppBar(title: Text("Sign UP"),backgroundColor:Colors.lightGreenAccent ,foregroundColor: Colors.red, actions: [IconButton(onPressed: () async{
        final appDocumentDirectory = await getApplicationDocumentsDirectory();
        Hive.init(appDocumentDirectory.path);
        if (!Hive.isAdapterRegistered(4)) {
          Hive.registerAdapter<UserModel>(UserModelAdapter());
        }
        //print(Hive.isBoxOpen('exercise_box'));
        if(!Hive.isBoxOpen('userInfo_box')){
          await Hive.openBox<UserModel>('userInfo_box');
        }
        bool duplicateUserName=false;
        Box<UserModel> dataBox = Hive.box<UserModel>('userInfo_box');
        dataBox.values.forEach((user){
          if(user.userName==userName.text )
          {
            duplicateUserName=true;
          }
        });
        if(duplicateUserName){
          Fluttertoast.showToast(
              msg: "Duplicate User Name. Please reenter.",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
          userFocus.requestFocus();
          userName.selection = TextSelection(baseOffset: 0, extentOffset: userName.value.text.length);
        }
        else{
          print(this.firstName.text);
          UserModel tempModel=UserModel(firstName: this.firstName.text, lastName: lastName.text, userName: userName.text, passWord: passWord.text, birthDate: dateController.text, mobile: mobile.text, email: "abc@abc.com", gender: "Male");
          dataBox.add(tempModel);
          //dataBox.put("name", tempModel);

          dataBox.close();
          await Hive.close();
          Navigator.of(context).pop();
        }
        }, icon: Icon(Icons.save_rounded,size: 35))],),
      body: SafeArea(
        child: SingleChildScrollView(child:         Column(
          children: [
            Container(
              child: Padding(padding: EdgeInsets.only(left: 10,right: 10,top: 10),
                child:
                TextField(
                  controller: firstName,
                  keyboardType: TextInputType.name,
                  inputFormatters: [FilteringTextInputFormatter(RegExp("[a-zA-Z]"),allow:true)], //,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: "First Name",
                    labelText: "First Name",
                    labelStyle: TextStyle(color: Colors.white,fontSize: 20),
                    fillColor: Colors.white70,
                  ),),
              ),
            ),
            Container(
              child:
              Padding(padding: EdgeInsets.only(left: 10,right: 10,top: 10),
                child:
                TextField(
                  controller: lastName,
                  keyboardType: TextInputType.name,
                  inputFormatters: [FilteringTextInputFormatter(RegExp("[a-zA-Z]"),allow:true)], //,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: "Last Name",
                    labelText: "Last Name",
                    labelStyle: TextStyle(color: Colors.white,fontSize: 20),
                    fillColor: Colors.white70,
                  ),),
              ),
            ),
            Container(
              child:
              Padding(padding: EdgeInsets.only(left: 10,right: 10,top: 10),
                child:
                TextField(
                  focusNode: userFocus,
                  controller: userName,
                  //inputFormatters: [FilteringTextInputFormatter(RegExp("[a-zA-Z]"),allow:true)], //,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: "User Name",
                    labelText: "User Name",
                    labelStyle: TextStyle(color: Colors.white,fontSize: 20),
                    fillColor: Colors.white70,
                  ),),
              ),
            ),
            Container(
              child:
              Padding(padding: EdgeInsets.only(left: 10,right: 10,top: 10),
                child:
                TextField(
                  controller: passWord,
                  obscureText: obscureTextPasswd,
                  //inputFormatters: [FilteringTextInputFormatter(RegExp("[a-zA-Z]"),allow:true)], //,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: "Password",
                    labelText: "Password",
                    labelStyle: TextStyle(color: Colors.white,fontSize: 20),
                    fillColor: Colors.white70,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ExcludeFocus(
                        excluding: true,
                        child:IconButton(
                          icon: Icon(Icons.hide_source),
                          onPressed: () {
                            setState(() {
                              obscureTextPasswd=!obscureTextPasswd;
                              /*obscureText
                              ? obscureText = false
                              : obscureText = true;*/
                            });
                          },
                        ),
                      ),
                    ),

                  ),),
              ),
            ),
            Container(
              child:
              Padding(padding: EdgeInsets.only(left: 10,right: 10,top: 10),
                child:
                TextField(
                  controller: rePassWord,
                  obscureText: obscureTextRePasswd,
                  //inputFormatters: [FilteringTextInputFormatter(RegExp("[a-zA-Z]"),allow:true)], //,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: "Reenter Password",
                    labelText: "ReEnter Password",
                    labelStyle: TextStyle(color: Colors.white,fontSize: 20),
                    fillColor: Colors.white70,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ExcludeFocus(
                        excluding: true,
                        child:IconButton(
                          icon: Icon(Icons.hide_source),
                          onPressed: () {
                            setState(() {
                              obscureTextRePasswd=!obscureTextRePasswd;
                              /*obscureText
                              ? obscureText = false
                              : obscureText = true;*/
                            });
                          },
                        ),
                      ),
                    ),
                  ),),
              ),
            ),
            Container(
              child:
              Row(
                children: [
                  Expanded(
                    child:
                    Padding(padding: EdgeInsets.only(left: 10,right: 10,top: 10),
                      child:
                      TextField(
                        controller: mobile,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        inputFormatters: [FilteringTextInputFormatter(RegExp("[0-9]"),allow:true)], //,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          hintStyle: TextStyle(color: Colors.grey[800]),
                          hintText: "Mobile Number",
                          labelText: "Mobile Number",
                          labelStyle: TextStyle(color: Colors.white,fontSize: 20),
                          fillColor: Colors.white70,
                        ),),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 10,right: 10),
                    //const Color.fromARGB(1,208,241,148))
                    child: ElevatedButton(child: Text("Verify",style: TextStyle(color: Colors.black,fontSize: 20),),onPressed:() {print("verify");},style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreenAccent),),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      ),
    );
  }
}