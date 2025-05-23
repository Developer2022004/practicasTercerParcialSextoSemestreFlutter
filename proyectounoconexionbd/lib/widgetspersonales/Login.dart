import 'package:flutter/material.dart';
import 'package:proyectounoconexionbd/bd/Bd.dart';
import 'package:proyectounoconexionbd/widgetspersonales/MostrarDatos.dart';
import 'package:proyectounoconexionbd/widgetspersonales/Principal.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return VistaLogin();
  }
}

class VistaLogin extends State<Login> {
  final TextEditingController usuario_controlador = TextEditingController();
  final TextEditingController password_controlador = TextEditingController();

  void alerta(BuildContext _context, String titulo, String mensaje) {
    showDialog(
      context: _context,
      builder: (_context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(mensaje),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(_context),
              child: const Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }

  void iniciarSesion() async {
    String usuario_str = usuario_controlador.text;
    String password_str = password_controlador.text;

    if (usuario_str.isNotEmpty && password_str.isNotEmpty) {
      bool respuesta = await Bd().validarUsuario(usuario_str, password_str);
      if (respuesta) {
        alerta(context, "Aviso", "Inciando sesion");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Principal()),
        );
      } else {
        alerta(context, "Aviso", "Credenciales incorrectas");
        usuario_controlador.clear();
        password_controlador.clear();
      }
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
        title: const Text("Iniciar Sesion"),
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
              color: const Color.fromARGB(255, 233, 233, 233),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "Ingresa el usuario",
                        ),
                        controller: usuario_controlador,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "Ingresa el password",
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
                        onPressed: iniciarSesion,
                        child: const Text("Iniciar Sesion"),
                      ),
                    ),
                    Divider(
                      height: 20,
                      thickness: 10,
                      color: Colors.transparent,
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
