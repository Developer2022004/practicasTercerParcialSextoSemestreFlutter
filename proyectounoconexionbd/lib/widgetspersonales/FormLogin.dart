import 'package:flutter/material.dart';
import 'package:proyectounoconexionbd/bd/BdTienda.dart';
import 'package:proyectounoconexionbd/complemento/Validaciones.dart';
import 'package:proyectounoconexionbd/widgetspersonales/LoginTienda.dart';

class FormLogin extends StatefulWidget {
  const FormLogin({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return VistaFormLogin();
  }
}

class VistaFormLogin extends State<FormLogin> {
  Validaciones Validar = Validaciones();
  TextEditingController controlador_usuario = TextEditingController();
  TextEditingController controlador_password = TextEditingController();
  final clave_validacion_global = GlobalKey<FormState>();

  void alerta(String titulo, String mensaje, bool cambio_ventana) {
    if (!cambio_ventana) {
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
    } else {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text(titulo),
              content: Text(mensaje),
              actions: [
                ElevatedButton(
                  onPressed:
                      () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginTienda()),
                      ),
                  child: Text("De acuerdo"),
                ),
              ],
            ),
      );
    }
  }

  void cargarUsuario() async {
    if (clave_validacion_global.currentState!.validate()) {
      int respuesta = await BdTienda().crearUsuario(
        controlador_usuario.text,
        controlador_password.text,
      );
      //el 0 quiere indicar que pudo haber un fallo al crear el usuario
      if (respuesta != 0) {
        alerta("Aviso", "Usuario creado", true);
      } else {
        alerta("Aviso", "Ocurrio un error al guardar el usuario", false);
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
                                        ? Validar.validarLetrasNumeros(value)
                                        : "Ingresa un valor al campo usuario",
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: TextFormField(
                            decoration: InputDecoration(
                              label: const Text("Contraseña"),
                            ),
                            obscureText:
                                true, //Habilitamos el ocultamiento del campo
                            obscuringCharacter:
                                "*", //Cambiamos los caracteres por otros para ocultarlos
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
                            onPressed: () => cargarUsuario(),
                            child: const Text("Crear Cuenta"),
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
