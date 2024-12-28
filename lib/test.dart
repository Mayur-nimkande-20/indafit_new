import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[800],
          leading: Container(
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: () {

              },
            ),
          ),
          centerTitle: true,
          title: Text('Target', style: TextStyle(color: Colors.white)),
          actions: [
            Container(
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.more_horiz, color: Colors.white),
                onPressed: () {

                },
              ),
            ),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 138, 137, 137),
        body: SingleChildScrollView(
          child: Column(
            children: [

              Container(
                margin: EdgeInsets.all(16.0),
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.swap_vert, color: Colors.grey),
                        SizedBox(width: 8.0),
                        Text(
                          'Target - Volume',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.local_fire_department, color: Colors.black),
                          SizedBox(width: 4.0),
                          Text(
                            '1500 Kg',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(16.0),
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.swap_vert, color: Colors.grey),
                        SizedBox(width: 8.0),
                        Text(
                          'Target - Calories',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.local_fire_department, color: Colors.black),
                          SizedBox(width: 4.0),
                          Text(
                            '1500 Kcal',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(16.0),
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.swap_vert, color: Colors.grey),
                        SizedBox(width: 8.0),
                        Text(
                          'Target - Duration',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 42, 169, 10),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.local_fire_department, color: Colors.black),
                          SizedBox(width: 4.0),
                          Text(
                            '45 Min',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'May 2022',
                  style: TextStyle(
                    color: Color(0xFFB4FF4C),
                    fontSize: 16.0,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      buildDayContainer("Mon", "10", false),
                      buildDayContainer("Tue", "11", false),
                      buildDayContainer("Wed", "12", false),
                      buildDayContainer("Thurs", "13", false),
                      buildDayContainer("Fri", "14", true),
                      buildDayContainer("Sat", "15", false),
                      buildDayContainer("Sun", "16", false)
                    ],
                  ),
                ),
              ),


              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularUI(),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildRichText('VOLUME\n', '1250/1500 KG', Color(0xFF001380), Colors.orange),
                      SizedBox(height: 10),
                      buildRichText('CALORIES\n', '120/1200 K CAL', Color(0xFF001380), Colors.white),
                      SizedBox(height: 10),
                      buildRichText('DURATION\n', '120/100 MIN', Color(0xFF001380), Color.fromARGB(255, 11, 53, 13)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),


              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: () {


                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: Color(0xFFB4FF4C),
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                  ),
                  child: Text('Save', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDayContainer(String day, String date, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      padding: EdgeInsets.all(40.0),
      // height: 100,
      // width: 80,
      decoration: BoxDecoration(
        color: isSelected ? Color(0xFFB4FF4C) : Colors.black,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red, width: 5),
                ),
              ),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.yellow, width: 5),
                ),
              ),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                ),
                child: Center(
                  child: Icon(Icons.circle, color: Color.fromARGB(255, 116, 227, 252), size: 30),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Text(
            day,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.grey,
              fontSize: 16.0,
            ),
          ),
          Text(
            date,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.grey,
              fontSize: 16.0,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRichText(String label, String value, Color labelColor, Color valueColor) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: '$label ', style: TextStyle(color: labelColor, fontSize: 30, fontWeight: FontWeight.bold)),
          TextSpan(text: '95% ', style: TextStyle(color: valueColor, fontSize: 30, fontWeight: FontWeight.bold)),
          TextSpan(text: value, style: TextStyle(color: valueColor, fontSize: 30)),
        ],
      ),
    );
  }
}

class CircularUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 190,
          height: 190,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 232, 139, 0),
            shape: BoxShape.circle,
          ),
        ),
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
        ),
        Positioned(
          top: 20,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
