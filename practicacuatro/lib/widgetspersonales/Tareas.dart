import 'package:flutter/material.dart';
import 'package:practicacuatro/widgetspersonales/Agregar.dart';
import 'package:practicacuatro/widgetspersonales/Mostrar.dart';

class Tareas extends StatefulWidget {
  const Tareas({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return VistaTareas();
  }
}

class VistaTareas extends State<Tareas> {
  int seleccion_pagina = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Tareas"),
        centerTitle: true,
        backgroundColor: Colors.amber[200],
      ),
      body: seleccion_pagina == 0 ? Agregar() : Mostrar(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Agregar Tarea",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_work_outlined),
            label: "Mostrar Tarea",
          ),
        ],
        currentIndex: seleccion_pagina,
        selectedItemColor: Colors.red,
        onTap:
            (index) => setState(() {
              seleccion_pagina = index;
            }), //Asignamos el color al elemento seleccionado
      ),
    );
  }
}
