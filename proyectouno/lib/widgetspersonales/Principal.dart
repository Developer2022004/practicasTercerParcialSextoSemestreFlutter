import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proyectouno/bd/BdLogin.dart';
import 'package:proyectouno/widgetspersonales/CrearUsuario.dart';

class Principal extends StatefulWidget {
  const Principal({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return VistaPrincipal();
  }
}

class VistaPrincipal extends State<Principal> {
  TextEditingController ctrl_usuario = TextEditingController();
  TextEditingController ctrl_password = TextEditingController();
  final gl_clave_validacion = GlobalKey<FormState>();

  void mensaje(String contenido) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(contenido)),
    );
  }

  Future<bool> validarCredenciales(String usuario, String password) async {
    Map<String, dynamic>? usuario_buscado =
        await BdLogin().buscarUsuario(usuario);

    if (usuario_buscado != null) {
      if (usuario == usuario_buscado['Usuario'] &&
          password == usuario_buscado['Password']) {
        return true;
      }
    }
    return false;
  }

  void iniciarSesion() async {
    if (gl_clave_validacion.currentState!.validate()) {
      if (await validarCredenciales(ctrl_usuario.text, ctrl_password.text)) {
        mensaje("Inicio de Sesion exitoso");
      } else {
        mensaje("Credenciales incorrectas");
      }
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
          padding: const EdgeInsets.all(8.0),
          child: Container(
            //Nota si no se especifica el ancho o el alto, estos seran relativos al espacio consumido por los elementos hijos
            width: double.infinity,
            height: 400,
            color: Colors.blueGrey[100],
            child: Form(
              key: gl_clave_validacion,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 100,
                      child: Icon(
                        Icons.person,
                        size: 100,
                      )),
                  SizedBox(
                    width: 250,
                    child: TextFormField(
                      decoration: InputDecoration(hintText: "Usuario"),
                      inputFormatters: [
                        FilteringTextInputFormatter(RegExp(r'[a-z0-9]+'),
                            allow: true)
                      ],
                      controller: ctrl_usuario,
                      validator: (value) => (value!.isEmpty)
                          ? "Ingresa un valor al campo usuario"
                          : null,
                    ),
                  ),
                  SizedBox(
                    width: 250,
                    child: TextFormField(
                      decoration: InputDecoration(hintText: "Constraseña"),
                      obscureText: true,
                      obscuringCharacter: "*",
                      controller: ctrl_password,
                      validator: (value) => (value!.isEmpty)
                          ? "Ingresa un valor al campo password"
                          : null,
                    ),
                  ),
                  Divider(
                    height: 10,
                    thickness: 10,
                    color: Colors.transparent,
                  ),
                  SizedBox(
                    width: 250,
                    child: ElevatedButton(
                        onPressed: () => iniciarSesion(),
                        child: const Text("Iniciar Sesion")),
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("No tienes Cuenta?"),
                          TextButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_contex) => CrearUsuario())),
                              child: Text("Crear Una"))
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
