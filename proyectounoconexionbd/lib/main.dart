import 'package:flutter/material.dart';
//import 'package:proyectounoconexionbd/widgetspersonales/FormLogin.dart';
//import 'package:proyectounoconexionbd/widgetspersonales/Login.dart';
import 'package:proyectounoconexionbd/widgetspersonales/LoginTienda.dart';
//import 'package:proyectounoconexionbd/widgetspersonales/TiendaPrincipal.dart';
//import 'package:proyectounoconexionbd/widgetspersonales/Principal.dart';
// import 'package:sqflite/sqflite.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //return MaterialApp(title: 'PracticaUno', home: Login());
    return MaterialApp(
      title: 'PracticaDos',
      debugShowCheckedModeBanner: false,
      home: LoginTienda(),
    );
  }
}

//NOTA, ELIMINAS BUILD, LUEGO EJECUTAS EN TERMINAL flutter clean, flutter pub get, flutter run ESTO SOLO SI NO SE CORRIGE AL MOMENTO
//DE ACTUALIZAR DEPENDIENCIA DEL gradle de flutter, ademas, solo la carpeta build se debe de eliminar de manera externa a VS Code
