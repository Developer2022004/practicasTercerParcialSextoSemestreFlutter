import 'package:flutter/material.dart';
import 'package:proyectounoconexionbd/bd/Bd.dart';
import 'package:proyectounoconexionbd/widgetspersonales/MostrarDatos.dart';

class Principal extends StatefulWidget {
  const Principal({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return VistaPrincipal();
  }
}

class VistaPrincipal extends State<Principal> {
  final TextEditingController usuario_controlador = TextEditingController();
  final TextEditingController password_controlador = TextEditingController();

  void agregar() async {
    String usuario_str = usuario_controlador.text;
    String password_str = password_controlador.text;

    if (usuario_str.isNotEmpty && password_str.isNotEmpty) {
      await Bd().insertarUsuario(usuario_str, password_str);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Datos del formulario"),
            content: Text("Informacion guardada, correctamente"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Aceptar"),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Datos del formulario"),
            content: Text(
              "El formulario se encuentra vacio, \nfavor de ingresar la informacion correspondiente",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Aceptar"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Conexion a Base de Datos"),
        centerTitle: true,
        backgroundColor: Colors.amber[200],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: IntrinsicHeight(
            child: Container(
              //Nota si no se especifica el ancho o el alto, estos seran relativos al espacio consumido por los elementos hijos
              width: double.infinity,
              color: Colors.blue[300],
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Ingresa el usuario",
                        ),
                        controller: usuario_controlador,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Ingresa el password",
                        ),
                        controller: password_controlador,
                      ),
                    ),
                    Divider(
                      height: 20,
                      thickness: 10,
                      color: Colors.transparent,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: agregar,
                        child: const Text("Aceptar"),
                      ),
                    ),
                    Divider(
                      height: 20,
                      thickness: 10,
                      color: Colors.transparent,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Mostrardatos(),
                              ),
                            ),
                        child: const Text("Mostrar Datos"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
