import 'package:flutter/material.dart';
import 'package:practicacuatro/widgetspersonales/Principal.dart';
import 'package:practicacuatro/widgetspersonales/Tareas.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PracticaCuatro',
      debugShowCheckedModeBanner: false,
      home: Tareas(),
    );
  }
}
