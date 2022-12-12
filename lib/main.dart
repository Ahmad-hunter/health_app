import 'package:flutter/material.dart';
import 'package:medical_app/provider/provider.dart';
import 'package:provider/provider.dart';
import 'main_page.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: ((context) => ReminderProvider()), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(typeId: 1),
    );
  }
}
