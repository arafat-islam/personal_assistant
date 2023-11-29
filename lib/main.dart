import 'package:flutter/material.dart';
import 'package:personal_assistant/screens/homepage.dart'; // Import the correct path for MyHomePage

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Personal Assistant',
      home: Directionality(
        textDirection: TextDirection.ltr, // Adjust as per your app's direction
        child: MyHomePage(),
      ),
    );
  }
}
