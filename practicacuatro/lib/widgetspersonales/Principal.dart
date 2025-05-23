import 'package:flutter/material.dart';

class Principal extends StatefulWidget {
  const Principal({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return VistaPrincipal();
  }
}

class VistaPrincipal extends State<Principal> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Practica Cuatro", textAlign: TextAlign.center),
      ),
      body: Text("Hola mundo"),
    );
  }
}
