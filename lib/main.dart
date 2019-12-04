import 'package:flutter/material.dart';

import 'package:certificate_generator/screens/home.dart';
import 'package:certificate_generator/screens/result.dart';
import 'package:certificate_generator/screens/viewer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Certificate Generator',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        accentColor: Colors.yellowAccent,
      ),
      routes: {
        '/': (context) => HomeScreen(),
        '/result': (context) => ResultScreen(),
        '/viewer': (context) => ViewerScreen(),
      },
      initialRoute: '/',
    );
  }
}
