// v2  with password checks
// Issue in old password checking.

import 'package:flutter/material.dart';
import 'package:indafit/model/model.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class Changepasswordscreen extends StatefulWidget {
  const Changepasswordscreen({super.key, required this.userName});
  final String userName;
  @override
  _Changepasswordscreenstate createState() => _Changepasswordscreenstate();
}

class _Changepasswordscreenstate extends State<Changepasswordscreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  Box? userBox;
  String? storedOldPassword; // Password stored in Hive
  bool isOldPasswordCorrect = false;
  bool isPasswordMatch = false;
  UserModel? userData;
  int userFoundAt=-1;
  @override
  void initState() {
    super.initState();
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter<UserModel>(UserModelAdapter());
    }
    //print(Hive.isBoxOpen('exercise_box'));
    if(!Hive.isBoxOpen('userInfo_box')){
      await Hive.openBox<UserModel>('userInfo_box');
    }
    //Box<UserModel> dataBox = Hive.box<UserModel>('userInfo_box');
    //print("Received User Name:"+widget.userName);
    userBox = await Hive.box<UserModel>('userInfo_box');

    for(var i=0;i<userBox!.length;i++){
      var temp=userBox!.getAt(i);
      if((temp!.userName??'')==widget.userName){
        userFoundAt=i; // Replace the old data with new data
      }
    }
    setState(() {
      if(userFoundAt>=0){
        userData =  userBox?.getAt(userFoundAt);
        // print(userData);// Retrieve the old password from Hive
        storedOldPassword =userData?.passWord;
        // print(storedOldPassword);
      }
    });
  }

  void _checkOldPassword(String input) {
    setState(() {
      print(input);
      print(storedOldPassword);
      print(userData);
      if(input.toString()==storedOldPassword.toString()){
        isOldPasswordCorrect=true;
      }
      else{
        isOldPasswordCorrect=false;
      }
      print(isOldPasswordCorrect);
      // isOldPasswordCorrect = input == storedOldPassword;
    });
  }

  void _checkPasswordMatch(String newPassword, String confirmPassword) {
    setState(() {
      isPasswordMatch = newPassword == confirmPassword;
    });
  }

  void _saveChanges() {
    if (isOldPasswordCorrect && isPasswordMatch) {
      userData!.passWord=_newPasswordController.text;
      userBox!.putAt(userFoundAt, userData);
      //userBox?.put('password', _newPasswordController.text);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Password updated successfully!'),
        backgroundColor: Colors.green,
      ));
      Navigator.pop(context); // Return to the previous screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fix the errors before saving.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.blueAccent,
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, size: 20),
            onPressed: () {
              Navigator.pop(context); // Navigate back to the previous screen
            },
          ),
        ),
        title: Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0,right: 16.0,top: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 55,
                child: Icon(Icons.person_2_rounded),
                // backgroundImage: AssetImage('assets/profile.jpg'),
              ),
              SizedBox(height: 20),
              _buildPasswordField(
                'Old Password',
                _oldPasswordController,
                    (input) => _checkOldPassword(input),
                isOldPasswordCorrect ? Icons.check_circle : Icons.cancel,
                isOldPasswordCorrect ? Colors.green : Colors.red,
              ),
              _buildPasswordField(
                'New Password',
                _newPasswordController,
                    (_) => _checkPasswordMatch(
                    _newPasswordController.text, _confirmPasswordController.text),
              ),
              _buildPasswordField(
                'Confirm Password',
                _confirmPasswordController,
                    (_) => _checkPasswordMatch(
                    _newPasswordController.text, _confirmPasswordController.text),
                isPasswordMatch ? Icons.check_circle : Icons.cancel,
                isPasswordMatch ? Colors.green : Colors.red,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Colors.blue, // Button color
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 15.0),
                  child: Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller,
      Function(String) onChanged,
      [IconData? icon, Color? iconColor]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          suffixIcon: icon != null
              ? Icon(icon, color: iconColor)
              : null,
        ),
        onChanged: onChanged,
      ),
    );
  }
}
