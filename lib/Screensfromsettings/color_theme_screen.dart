// some imps for theme
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:indafit/color_themes_file/theme_notifier.dart';


class Colorthemescreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('COLOR THEME')),
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
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  themeNotifier.setLightMode();
                },
                child: Text('Light'),
              ),
              ElevatedButton(
                onPressed: () {
                  themeNotifier.setDarkMode();
                },
                child: Text('Dark'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
