import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:practicacinco/bd/BdQR.dart';
import 'package:practicacinco/widgetspersonales/Mostrar.dart';

class Principal extends StatefulWidget {
  const Principal({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return VistaPrincipal();
  }
}

class VistaPrincipal extends State<Principal> {
  TextEditingController controlador_nombre = TextEditingController();
  TextEditingController controlador_precio = TextEditingController();
  bool ventana = false;

  void mostrarDatos(String numeros) {
    String nombre = "", precio = "";
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Dato QR"),
            content: Column(
              mainAxisSize:
                  MainAxisSize
                      .min, //Se adapta el tamaño al minimo de los elementos internos del contenedor
              children: [
                Text(
                  "Codigo $numeros",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Nombre"),
                  controller: controlador_nombre,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Precio"),
                  controller: controlador_precio,
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  nombre = controlador_nombre.text;
                  precio = controlador_precio.text;
                  if (nombre.isNotEmpty && precio.isNotEmpty) {
                    await BdQR().insertarProducto(
                      numeros,
                      nombre,
                      double.tryParse(precio) ?? 0.0,
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Producto Guardado")),
                    );
                  }
                },
                child: Text("Guardar"),
              ),
            ],
          ),
    ).then(
      (_) => ventana = false,
    ); //Esperamos la respuesta de la promesa o ejecucion del proceso en 2do plano
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR en Base de Datos"),
        backgroundColor: Colors.amber[100],
        centerTitle: true,
        //botones para redirigirse a otra parte de la aplicacion
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_context) =>
                          Mostrar(mensaje: "Hola Mundo"), //Ejecutamos la vista
                ),
              );
            },
            icon: Icon(Icons.list),
          ),
        ],
      ),
      body: MobileScanner(
        onDetect: (capture) {
          if (ventana)
            return; //Evaluamos la bandera ventana si es falso brinda la orden de capturar e primer valor del lector de QR (el lector QR actua como un buffer de datos.) al igual que el arduino
          final codigo = capture.barcodes.first;
          final String numeros = codigo.rawValue ?? 'Sin codigo';
          if (numeros != 'Sin codigo') {
            ventana = true;
            mostrarDatos(numeros);
          }
        },
      ),
    );
  }
}
