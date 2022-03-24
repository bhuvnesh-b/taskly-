import 'package:flutter/material.dart';
import 'package:taskly/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async{
  //to use hive we need to intialise it first ,hive stores the data in boxes 

  // we use this async and await to tell flutter that this line needs to execute first before starting the app
  await Hive.initFlutter("hive_boxes");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taskly',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomePage(),
    );
  }
}
