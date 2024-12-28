import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:animated_weight_picker/animated_weight_picker.dart';
import 'package:indafit/globals.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
/*
void main() {
  print(DateFormat('dd-MM-yyyy').format(DateTime.now()));
  return runApp(GaugeApp());
}

 */
/*
class StateModel {
  const StateModel(this.name, this.code);
  final String code;
  final String name;

  @override
  String toString() => name;
}

 */
/*
/// Represents the GaugeApp class
class GaugeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Radial Gauge Demo',
      theme: ThemeData(primarySwatch: Colors.blue,scaffoldBackgroundColor: const Color(0xFFEFEFEF)),
      home: AboutMePage(),
    );
  }
}


 */
/// Represents MyHomePage class
class AboutMePage extends StatefulWidget {
  /// Creates the instance of MyHomePage
  AboutMePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
double _volumeValue = 50;

void onVolumeChanged(double value) {
  //setState(() {
  _volumeValue = value;
  //});
}

class _MyHomePageState extends State<AboutMePage> {

//TextEditingController dateController = new TextEditingController(text: DateFormat('dd-MM-yyyy').format(DateTime.now()));
  TextEditingController dateController = new TextEditingController();
  var _currentIntValue=10;
  String selectedValue = '';
  @override
  //var future1= showMaterialScrollPicker(context: context, items: usStates, selectedItem: selectedUsState), child: Text("Press ME")),
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: MyDrawer(),
      appBar: AppBar(title: Text("About ME"),backgroundColor:Colors.lightGreenAccent ,foregroundColor: Colors.red,),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              child:
              Row(
                children: [
                  Expanded(
                    child:
                    Padding(padding: EdgeInsets.only(left: 10,right: 10,top: 10),
                      child:
                      TextField(
                          controller: dateController, //editing controller of this TextField
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            hintText: "Birth Date",
                            labelText: "Birth Date",
                            fillColor: Colors.white70,
                          ),
                          readOnly: true,  // when true user cannot edit text
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(), //get today's date
                                firstDate:DateTime(1900), //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2101)
                            );
                            if(pickedDate != null ){
                              print(pickedDate);  //get the picked date in the format => 2022-07-04 00:00:00.000
                              String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                              print(formattedDate); //formatted date output using intl package =>  2022-07-04
                              //You can format date as per your need

                              setState(() {
                                dateController.text = formattedDate; //set foratted date to TextField value.
                              });
                            }else{
                              print("Date is not selected");
                            }
                          }
                      ),
                    ),
                  ),
                  Container(
                      width: 80,
                      margin: EdgeInsets.only(right: 80),
                      child:
                          Padding(padding: EdgeInsets.only(top: 10),
                            child:
                              DropdownMenu<String>(
                                textStyle: TextStyle(color: Colors.lightGreenAccent),
                                initialSelection: 'MALE',
                                dropdownMenuEntries: <String>['MALE', 'FEMALE'].map((String value) {
                                  return DropdownMenuEntry<String>(
                                    value: value,
                                    label: value,
                                  );
                                }).toList(),
                                onSelected: (value) {print(value);},
                              ),
                        ),
                  ),
                ],
              ),
            ),
            Container(
              child:
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10,right: 30),
                    child:
                    Text("Height",style: TextStyle(color: Colors.white,fontSize: 30),),
                  ),
                  NumberPicker(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 1.0, color: Colors.lightBlue.shade600),
                        bottom: BorderSide(width: 1.0, color: Colors.lightBlue.shade900),
                      ),
                      //color: Colors.deepOrangeAccent,
                      //borderRadius: BorderRadius.circular(30),
                    ),
                    textStyle: TextStyle(color: Colors.amber),
                    selectedTextStyle: TextStyle(color: Colors.lightGreenAccent,fontSize: 30,fontWeight: FontWeight.bold),
                    value: _currentIntValue,
                    minValue: 10,
                    maxValue: 500,
                    step: 10,
                    haptics: true,
                    onChanged: (value) => setState(() => _currentIntValue = value),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child:
                    Text("Cms",style: TextStyle(color: Colors.white,fontSize: 20),),
                  ),

                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10,bottom: 20),
              child:
              Text("Weight",style: TextStyle(color: Colors.white,fontSize: 30),),
            ),
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: AnimatedWeightPicker(
                      dialColor: Colors.red,
                      min: 0,
                      max: 200,
                      onChange: (newValue) {
                        setState(() {
                          selectedValue = newValue;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Container(
              child:
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10,right: 30),
                    child:
                    Text("GOAL",style: TextStyle(color: Colors.white,fontSize: 20),),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child:
                        Container(
                          width: 250,
                          child:
                          DropdownMenu<String>(
                            textStyle: TextStyle(color: Colors.lightGreenAccent,fontSize: 18),
                            initialSelection: 'Lose Weight',
                            dropdownMenuEntries: <String>['Lose Weight', 'Get FIT', 'Build Muscle'].map((String value) {
                              return DropdownMenuEntry<String>(
                                value: value,
                                label: value,
                              );
                            }).toList(),
                            onSelected: (value) {print(value);},
                          ),

                        ),
                  ),

                ],
              ),
            ),
            SizedBox(height: 20,),
            Container(
              child:
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10,right: 30),
                    child:
                    Text("Activity Level",style: TextStyle(color: Colors.white,fontSize: 20),),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child:
                    Container(
                      width: 200,
                      child:
                      DropdownMenu<String>(
                        textStyle: TextStyle(color: Colors.lightGreenAccent,fontSize: 18),
                        initialSelection: 'Begineer',
                        dropdownMenuEntries: <String>['Begineer', 'Intermediate', 'Advanced'].map((String value) {
                          return DropdownMenuEntry<String>(
                            value: value,
                            label: value,
                          );
                        }).toList(),
                        onSelected: (value) {print(value);},
                      ),

                    ),
                  ),

                ],
              ),
            ),
          ],
        )
        ,
      ),
    );
  }
}