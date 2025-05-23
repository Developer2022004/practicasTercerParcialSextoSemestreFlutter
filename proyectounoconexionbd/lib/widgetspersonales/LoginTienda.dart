import 'package:flutter/material.dart';
import 'package:proyectounoconexionbd/bd/BdTienda.dart';
import 'package:proyectounoconexionbd/complemento/Validaciones.dart';
import 'package:proyectounoconexionbd/widgetspersonales/FormLogin.dart';
import 'package:proyectounoconexionbd/widgetspersonales/TiendaPrincipal.dart';

class LoginTienda extends StatefulWidget {
  const LoginTienda({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return VistaLoginTienda();
  }
}

class VistaLoginTienda extends State<LoginTienda> {
  Validaciones validacion = Validaciones();
  TextEditingController controlador_usuario = TextEditingController();
  TextEditingController controlador_password = TextEditingController();
  final clave_validacion_global = GlobalKey<FormState>();

  void alerta(String titulo, String mensaje) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(titulo),
            content: Text(mensaje),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text("De acuerdo"),
              ),
            ],
          ),
    );
  }

  Future<bool> verificarUsuario(String usuario, String password) async {
    Map<String, dynamic>? usuario_obj = await BdTienda().buscarUsuario(usuario);
    // alerta("Aviso", "${(usuario_obj == null) ? 1 : 0}");
    if (usuario_obj == null) {
      return false;
    }

    if (!(usuario_obj['Usuario'] == usuario &&
        usuario_obj['Password'] == password)) {
      return false;
    }

    return true;
  }

  void iniciarSesion() async {
    if (clave_validacion_global.currentState!.validate()) {
      String usuario = controlador_usuario.text;
      String password = controlador_password.text;
      bool respuesta = await verificarUsuario(usuario, password);
      if (respuesta) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Iniciando sesion")));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TiendaPrincipal()),
        );
      } else {
        alerta("Aviso", "Credenciales incorrectas");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "OXXO",
          style: TextStyle(
            color: Color.fromARGB(255, 251, 201, 0),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(188, 242, 18, 18),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: IntrinsicHeight(
            //Adaptamos el alto a los elementos dentro del contenedor
            child: SizedBox(
              width: 300,
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
                color: const Color.fromARGB(255, 220, 220, 220),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Form(
                    key: clave_validacion_global,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          child: Icon(Icons.account_circle_rounded, size: 80),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: TextFormField(
                            decoration: InputDecoration(
                              label: const Text("Usuario"),
                            ),
                            controller: controlador_usuario,
                            validator:
                                (value) =>
                                    (value!.isNotEmpty)
                                        ? validacion.validarLetrasNumeros(value)
                                        : "Ingresa un valo al campo usuario",
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: TextFormField(
                            decoration: InputDecoration(
                              label: const Text("Contraseña"),
                            ),
                            obscureText: true,
                            obscuringCharacter: "*",
                            controller: controlador_password,
                            validator:
                                (value) =>
                                    (value!.isEmpty)
                                        ? "Ingresa un valor al campo contraseña"
                                        : null,
                          ),
                        ),
                        Divider(
                          height: 10,
                          thickness: 15,
                          color: Colors.transparent,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => iniciarSesion(),
                            child: const Text("Iniciar Sesion"),
                          ),
                        ),
                        Divider(
                          height: 10,
                          thickness: 15,
                          color: Colors.transparent,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            children: [
                              const Text("No tienes cuenta?"),
                              TextButton(
                                onPressed:
                                    () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FormLogin(),
                                      ),
                                    ),
                                child: const Text("Crea Una"),
                              ),
                            ],
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
