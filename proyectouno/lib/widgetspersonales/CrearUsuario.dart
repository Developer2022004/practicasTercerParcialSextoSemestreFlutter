import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proyectouno/bd/BdLogin.dart';
import 'package:proyectouno/widgetspersonales/Principal.dart';

class CrearUsuario extends StatefulWidget {
  const CrearUsuario({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return VistaCrearUsuario();
  }
}

class VistaCrearUsuario extends State<CrearUsuario> {
  TextEditingController ctrl_usuario = TextEditingController();
  TextEditingController ctrl_password = TextEditingController();
  TextEditingController ctrl_password_confirm = TextEditingController();
  final gl_clave_validacion = GlobalKey<FormState>();

  // if (gl_clave_validacion.currentState!.validate()) {
  //   //Sustituye ctrl_usuario.text por el controlador del campo correo
  //   String correo = ctrl_usuario.text;
  //   RegExp validar_correo =
  //       RegExp(r'^([a-z0-9_]\.?)+([a-z0-9_])+@{1}([a-z]+\.?)+[a-z]+\.com$');
  //   bool respuesta = validar_correo.hasMatch(correo);
  //   if (respuesta) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Formato correo correcto")),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Formato correo incorrecto")),
  //     );
  //   }
  // }

  Future<bool> validarExistenciaUsuario(String usuario) async {
    Map<String, dynamic>? usuario_buscado =
        await BdLogin().buscarUsuario(ctrl_usuario.text);

    return (usuario_buscado != null) ? true : false;
  }

  Future<bool> insertarUsuario(String usuario, String password) async {
    int respuesta = await BdLogin().crearUsuario(usuario, password);
    return (respuesta > 0) ? true : false;
  }

  void mensaje(String contenido) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(contenido)),
    );
  }

  void crearCuenta() async {
    if (gl_clave_validacion.currentState!.validate()) {
      if (!(await validarExistenciaUsuario(ctrl_usuario.text))) {
        if (await insertarUsuario(ctrl_usuario.text, ctrl_password.text)) {
          mensaje("Usuario guardado");
          ctrl_usuario.clear();
          ctrl_password.clear();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_context) => Principal()));
        } else {
          mensaje(
              "Ocurrio un error al registrar el usuario ${ctrl_usuario.text}");
        }
      } else {
        mensaje("El usuario ${ctrl_usuario.text} ya existe");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registro de Usuario"),
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
                      controller: ctrl_usuario,
                      inputFormatters: [
                        FilteringTextInputFormatter(RegExp(r'[a-z0-9]+'),
                            allow: true)
                      ],
                      validator: (value) => (value!.isEmpty)
                          ? "Ingresa un valor al campo usuario"
                          : null,
                    ),
                  ),
                  SizedBox(
                    width: 250,
                    child: TextFormField(
                      decoration: InputDecoration(hintText: "Contraseña"),
                      controller: ctrl_password,
                      obscureText: true,
                      obscuringCharacter:
                          "*", //obscuringCharacter depende de obscureText = true
                      validator: (value) => (value!.isEmpty)
                          ? "Ingresa un valor al campo password"
                          : null,
                    ),
                  ),
                  SizedBox(
                    width: 250,
                    child: TextFormField(
                      decoration:
                          InputDecoration(hintText: "Confirmar Contraseña"),
                      controller: ctrl_password_confirm,
                      obscureText: true,
                      obscuringCharacter: "*",
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Confirma constraseña";
                        }

                        return (ctrl_password.text !=
                                ctrl_password_confirm.text)
                            ? "Las contraseñas no coinciden"
                            : null;
                      },
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
                        onPressed: () => crearCuenta(),
                        child: const Text("Crear Cuenta")),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
