import 'package:flutter/material.dart';
import 'package:proyectouno/widgetspersonales/Principal.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  //En la presente practica se realizara el proceso de conexion a una base de datos en local
  //Para ello se requiere de Sqflite.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Practica Uno',
      debugShowCheckedModeBanner: false,
      home: Principal(),
    );
  }
}
