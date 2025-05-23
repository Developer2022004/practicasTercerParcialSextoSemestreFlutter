import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:proyectounoconexionbd/bd/Bd.dart';

class Mostrardatos extends StatefulWidget {
  const Mostrardatos({super.key});

  @override
  VistaMostrarDatos createState() => VistaMostrarDatos();
}

class VistaMostrarDatos extends State<Mostrardatos> {
  List<Map<String, dynamic>> usuarios = [];

  //Se ejecuta cuando se lanza la aplicacion
  @override
  void initState() {
    super.initState();
    obtenerUsuarios();
  }

  void obtenerUsuarios() async {
    List<Map<String, dynamic>> datos = await Bd().obtenerUsuarios();
    setState(() {
      usuarios = datos;
    });
  }

  void eliminarUsuario(int id, String usuario) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Alerta"),
          content: Text("Estas seguro de eliminar al usuario: $usuario"),
          actions: [
            TextButton(
              onPressed: () => eliminar(id),
              child: const Text("Aceptar"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Rechazar"),
            ),
          ],
        );
      },
    );
  }

  void actualizarUsuario(int id, String usuario, String password) async {
    TextEditingController usuario_controller = TextEditingController(
      text: usuario,
    );
    TextEditingController password_controller = TextEditingController(
      text: password,
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Alerta"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize:
                  MainAxisSize
                      .min, //Reduce el tamaño de la caja al minimo, en combinacion con SingleScrollView evita que se deforme la
              //caja o en su defecto un colapso de la interfaz que almacena los componentes de la caja
              children: [
                SizedBox(child: Text(id.toString())),
                SizedBox(
                  child: TextField(
                    decoration: InputDecoration(labelText: usuario),
                    controller: usuario_controller,
                  ),
                ),
                SizedBox(
                  child: TextField(
                    decoration: InputDecoration(labelText: password),
                    controller: password_controller,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed:
                  () => actualizar(
                    id,
                    usuario_controller.text,
                    password_controller.text,
                  ),
              child: const Text("Actualizar"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Rechazar"),
            ),
          ],
        );
      },
    );
  }

  void actualizar(int id, String usuario, password) async {
    await Bd().modificarUsuario(id, usuario, password);
    Navigator.pop(context);
    obtenerUsuarios();
  }

  void eliminar(int id) async {
    int respuesta = await Bd().eliminarUsuario(id);
    Navigator.pop(context);
    //print(respuesta);
    obtenerUsuarios();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recibiendo Datos"),
        backgroundColor: Colors.amber[200],
      ),
      body:
          usuarios.isEmpty
              ? Center(child: Text('datos vacios'))
              : ListView.builder(
                itemCount: usuarios.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.abc_sharp),
                    title: Text(usuarios[index]['Usuario']),
                    subtitle: Text(usuarios[index]['Password']),
                    trailing: Wrap(
                      //Conetenedor especifico para un ListView
                      direction: Axis.vertical,
                      spacing: 5,
                      children: [
                        IconButton(
                          onPressed:
                              () => actualizarUsuario(
                                usuarios[index]['Id'],
                                usuarios[index]['Usuario'],
                                usuarios[index]['Password'],
                              ),
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed:
                              () => eliminarUsuario(
                                usuarios[index]['Id'],
                                usuarios[index]['Usuario'],
                              ),
                          icon: Icon(Icons.delete),
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
