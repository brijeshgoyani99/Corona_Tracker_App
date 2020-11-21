import 'package:corona_tracker/constant.dart';
import 'package:corona_tracker/screens/homePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
 runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Corona Tracker',
      theme: ThemeData(
          scaffoldBackgroundColor: kBackgroundColor,
          fontFamily: "Poppins",
          textTheme: TextTheme(
         //   body1: TextStyle(color: kBodyTextColor),
          )),
      home: HomeScreen(),
    );
  }
}


  

