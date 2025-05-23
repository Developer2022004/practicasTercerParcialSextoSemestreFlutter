import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/material.dart';

class Lector extends StatefulWidget {
  const Lector({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return VistaLector();
  }
}

class VistaLector extends State<Lector> {
  bool ventana = false;

  void mostrarDatos(String numeros) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Dato QR"),
            content: Text(numeros),
            actions: [
              ElevatedButton(
                onPressed:
                    () => setState(() {
                      Navigator.pop(context);
                    }),
                child: Text("Aceptar"),
              ),
            ],
          ),
    ).then(
      // Registra las devoluciones de llamadas que se invocaran cuando se complete este futuro.
      (_) => ventana = false,
    ); //Esperamos la respuesta de la promesa o ejecucion del proceso en 2do plano
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Lector QR", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.amber,
        centerTitle: true,
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
