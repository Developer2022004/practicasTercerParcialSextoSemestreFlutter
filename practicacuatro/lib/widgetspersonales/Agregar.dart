import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:practicacuatro/bd/BdTareas.dart';

class Agregar extends StatefulWidget {
  const Agregar({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return VistaAgregar();
  }
}

class VistaAgregar extends State<Agregar> {
  TextEditingController controlador_titulo = TextEditingController();
  TextEditingController controlador_descripcion = TextEditingController();
  final clave_formulario_global = GlobalKey<FormState>();

  void alerta(String titulo, String contenido) {
    showDialog(
      context: context,
      builder:
          (context_alr) => AlertDialog(
            title: Text(titulo),
            content: Text(contenido),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context_alr),
                child: Text("De acuerdo"),
              ),
            ],
          ),
    );
  }

  void agregarTarea() async {
    if (clave_formulario_global.currentState!.validate()) {
      String titulo = controlador_titulo.text.trim();
      String descripcion = controlador_descripcion.text.trim();

      int respuesta = await BdTareas().insertarTarea(titulo, descripcion);

      if (respuesta != 0) {
        alerta("Aviso", "Tarea Agregada Correctamente");
        controlador_titulo.clear();
        controlador_descripcion.clear();
      } else {
        alerta("Aviso", "Ocurrio un Error al Agregar la Tarea $titulo");
      }

      // int cantidad = (await BdTareas().obtenerTareas()).length;
      // alerta("Aviso", cantidad.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 25, right: 25),
          child: IntrinsicHeight(
            child: SizedBox(
              width: double.infinity,
              height: null,
              child: Card(
                color: Colors.grey[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
                child: Form(
                  key: clave_formulario_global,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: null,
                          height: null,
                          child: Text(
                            "Asignacion de Tareas",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: null,
                          child: TextFormField(
                            controller: controlador_titulo,
                            inputFormatters: [
                              FilteringTextInputFormatter(
                                RegExp(r"([a-zA-Z])+(\s)?"),
                                allow: true,
                              ),
                            ],
                            decoration: InputDecoration(
                              label: Text("Titulo de la Tarea"),
                            ),
                            validator:
                                (value) =>
                                    value!.isEmpty
                                        ? "Ingresa un dato al campo titulo"
                                        : null,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: null,
                          child: TextFormField(
                            controller: controlador_descripcion,
                            inputFormatters: [
                              FilteringTextInputFormatter(
                                RegExp(r"([a-zA-Z])+(\s)?"),
                                allow: true,
                              ),
                            ],
                            decoration: InputDecoration(
                              label: Text("Descripcion de la Tarea"),
                            ),
                            validator:
                                (value) =>
                                    value!.isEmpty
                                        ? "Ingresa un dato al campo descripcion"
                                        : null,
                          ),
                        ),
                        Divider(
                          height: 10,
                          thickness: 10,
                          color: Colors.transparent,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: null,
                          child: ElevatedButton(
                            onPressed: agregarTarea,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightBlue,
                            ),
                            child: const Text(
                              "Agregar Tarea",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
