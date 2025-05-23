import 'package:flutter/material.dart';

class Mostrar extends StatefulWidget {
  const Mostrar({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return VistaMostrar();
  }
}

class VistaMostrar extends State<Mostrar> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(body: Center(child: Text("Mostrar Tareas")));
  }
}
