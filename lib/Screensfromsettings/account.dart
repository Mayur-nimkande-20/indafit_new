
import 'package:indafit/Screensfromsettings/change_password.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

// import '../../assets/blessings.jpg';
import 'package:indafit/model/model.dart';

class Accountscreen extends StatefulWidget {
  const Accountscreen({super.key, required this.userName});
  final String userName;
  @override
  _AccountscreenState createState() => _AccountscreenState();
}

class _AccountscreenState extends State<Accountscreen> {
  bool isEditing = false; // var to start edit mode
  bool hasChanged = false; // var to track if any field has been modified

  Box<UserModel>? userBox;
  UserModel? userData;

  // Controllers for text fields
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeHive();

    // Add listeners to the controllers to track changes
    firstNameController.addListener(_onFieldChanged);
    lastNameController.addListener(_onFieldChanged);
    userNameController.addListener(_onFieldChanged);
    emailController.addListener(_onFieldChanged);
    dobController.addListener(_onFieldChanged);
    genderController.addListener(_onFieldChanged);
    mobileController.addListener(_onFieldChanged);
  }

  Future<void> _initializeHive() async {
    print("Geeting hive data");

    // final appDocumentDir = await getApplicationDocumentsDirectory();
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
    print("Received User Name:"+widget.userName);
    userBox = await Hive.box<UserModel>('userInfo_box');

    //userData = userBox?.getAt(0); // Assuming user data is stored at index 0
    userBox!.values.forEach((user){
      print(user.userName);
      if((user.userName??'')==widget.userName)
      {
        print("user name found");
        firstNameController.text = user.firstName??'';
        lastNameController.text = user.lastName??'';
        userNameController.text = user.userName??'';
        emailController.text = user.email??'abc@abc.com';
        dobController.text = user.birthDate??'';
        genderController.text = user.gender??'';
        mobileController.text = user.mobile??'';
        setState(() {});
      }
    });

    /*print("User Information:" + userData!.firstName);
    if (userData != null) {
      firstNameController.text = userData!.firstName;
      lastNameController.text = userData!.lastName;
      userNameController.text = userData!.userName;
      emailController.text = userData!.email;
      dobController.text = userData!.birthDate;
      genderController.text = userData!.gender;
      mobileController.text = userData!.mobile;
      setState(() {});
    }*/
  }

  void _onFieldChanged() {
    if (!hasChanged) {
      setState(() {
        hasChanged = true;
      });
    }
  }

  @override
  void dispose() {
    // Dispose controllers when done
    firstNameController.dispose();
    lastNameController.dispose();
    userNameController.dispose();
    emailController.dispose();
    dobController.dispose();
    genderController.dispose();
    mobileController.dispose();
    super.dispose();
  }

  void _saveData() {
    if (hasChanged) {
      final newUser = UserModel(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        userName: userNameController.text,
        email: emailController.text,
        birthDate: dobController.text,
        gender: genderController.text,
        passWord: '',
        //passWord: 'shailesh@123', // Assuming password is unchanged
        mobile: mobileController.text,
      );
      for(var i=0;i<userBox!.length;i++){
        var temp=userBox!.getAt(i);
        newUser.passWord=temp!.passWord;
        if((temp!.userName??'')==widget.userName){
          userBox?.put(i, newUser); // Replace the old data with new data
        }
      }
      userBox?.put(0, newUser); // Replace the old data with new data
      // userBox?.add(newUser);
      setState(() {
        hasChanged = false;
        isEditing = false;
        userData = newUser;
      });
    }
  }

  // direct text field but svae in navgation
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        leading: Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.blueAccent,
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded,size: 20,),
            onPressed: () {
              Navigator.pop(context); // Navigate back to the previous screen
            },
          ),
        ),
        actions: [
          if (hasChanged || isEditing)  // Display the button only if there are changes or in edit mode
            Container(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Adjust margins as needed
              decoration: BoxDecoration(
                color: Colors.black, // Background color
                borderRadius: BorderRadius.circular(20.0), // Rounded edges
              ),
              child: TextButton(
                onPressed: () {
                  if (isEditing) {
                    _saveData(); // Call the method correctly using parentheses
                  } else {
                    setState(() {
                      isEditing = true; // Enable editing mode
                    });
                  }
                },
                child: Text(
                  isEditing ? 'Save Changes' : 'Edit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0,right: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundImage: AssetImage('assets/images/blessings.jpg'),
                    child: Icon(Icons.person_2_rounded),
                    // Image.asset('assets/images/blessings.jpg')

                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        _showeditprofileimageDialog(context);
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.blue,
                        // backgroundImage: ,
                        child: Icon(Icons.camera_alt, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              buildprofileField("First Name", firstNameController),
              buildprofileField("Last Name", lastNameController),
              buildprofileField("User Name", userNameController),
              buildprofileField("Email", emailController),
              buildprofileField("Mobile", mobileController),
              _buildDOBField(),
              buildprofileField("Gender", genderController),
              Row(
                children: [
                  /*Expanded(
                    child: buildprofileField("Password", TextEditingController(text: userData?.passWord ?? ""), isPassword: true),
                  ),*/
          
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.deepPurpleAccent,
                    ) ,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Changepasswordscreen(userName: widget.userName,)),
                        );
                      },
                      child: Text('Change Password',style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to show the edit profile image dialog
  void _showeditprofileimageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Profile Image'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Take from Camera'),
              onTap: () {
                // Handle taking photo from camera

              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Browse from Device'),
              onTap: () {
                // Handle browsing from device
              },
            ),
          ],
        ),
      ),
    );
  }

  // Method to build each profile field
  Widget buildprofileField(String label, TextEditingController controller, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        // obscureText: isPassword,
        readOnly: !isEditing,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  // Method to build the DOB field with a calendar icon
  Widget _buildDOBField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: dobController,
              decoration: InputDecoration(
                labelText: 'DOB',
                border: OutlineInputBorder(),
              ),
              readOnly: !isEditing,
              onTap: () {
                if(isEditing){
                  _selectDate(context);
                }
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              _selectDate(context);
            },
          ),
        ],
      ),
    );
  }

  // Method to handle date selection
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }
}

// trying to have images from cam or gallery



// CODE With direct textfield changes in account but save button on bootom out of size
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Account'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Stack(
//               children: [
//                 CircleAvatar(
//                   radius: 55,
//                   // backgroundImage: AssetImage('assets/profile.jpg'),
//                 ),
//                 Positioned(
//                   bottom: 0,
//                   right: 0,
//                   child: InkWell(
//                     onTap: () {
//                       _showeditprofileimageDialog(context);
//                     },
//                     child: CircleAvatar(
//                       radius: 20,
//                       backgroundColor: Colors.blue,
//                       child: Icon(Icons.camera_alt, color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             buildprofileField("First Name", _firstNameController),
//             buildprofileField("Last Name", _lastNameController),
//             buildprofileField("User Name", _userNameController),
//             buildprofileField("Email", _emailController),
//             _buildDOBField(),
//             buildprofileField("Gender", _genderController),
//             Row(
//               children: [
//                 Expanded(
//                   child: buildprofileField("Password", TextEditingController(text: password), isPassword: true),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     // Handle change password logic
//                   },
//                   child: Text('Change Password'),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             hasChanged
//                 ? ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   isEditing = false;
//                   hasChanged = false;
//                   // Save data logic
//                 });
//               },
//               child: Text('Save Data'),
//             )
//                 : Container(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Method to show the edit profile image dialog
//   void _showeditprofileimageDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Edit Profile Image'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: Icon(Icons.camera_alt),
//               title: Text('Take from Camera'),
//               onTap: () {
//                 // Handle taking photo from camera
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.photo_library),
//               title: Text('Browse from Device'),
//               onTap: () {
//                 // Handle browsing from device
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Method to build each profile field
//   Widget buildprofileField(String label, TextEditingController controller, {bool isPassword = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10.0),
//       child: TextFormField(
//         controller: controller,
//         obscureText: isPassword,
//         decoration: InputDecoration(
//           labelText: label,
//           border: OutlineInputBorder(),
//         ),
//       ),
//     );
//   }
//
//   // Method to build the DOB field with a calendar icon
//   Widget _buildDOBField() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10.0),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextFormField(
//               controller: _dobController,
//               decoration: InputDecoration(
//                 labelText: 'DOB',
//                 border: OutlineInputBorder(),
//               ),
//               readOnly: true,
//               onTap: () {
//                 _selectDate(context);
//               },
//             ),
//           ),
//           IconButton(
//             icon: Icon(Icons.calendar_today),
//             onPressed: () {
//               _selectDate(context);
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Method to handle date selection
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(1900),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null) {
//       setState(() {
//         _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
//       });
//     }
//   }
// }
