import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:practicacinco/bd/BdQR.dart';

class Mostrar extends StatefulWidget {
  String mensaje;
  Mostrar({super.key, required this.mensaje});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return VistaMostrar();
  }
}

class VistaMostrar extends State<Mostrar> {
  List<Map<String, dynamic>> productos = [];

  void cargarDatos() async {
    List<Map<String, dynamic>> valores = await BdQR().obtenerProductos();
    setState(() {
      productos = valores;
    });
  }

  void enviarEliminar(String codigo) async {
    //int respuesta = await BdQR().eliminarProducto(codigo);
    bool? confirmacion = await showDialog(
      context: context,
      builder:
          (_context) => AlertDialog(
            title: Text("ATENCION"),
            content: Text("Desea eliminar el producto con el codigo $codigo"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(_context, true),
                child: Text("Si"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(_context),
                child: Text("No"),
              ),
            ],
          ),
    );

    if (confirmacion != null) {
      int respuesta = await BdQR().eliminarProducto(codigo);
      if (respuesta != 0) {
        showDialog(
          context: context,
          builder:
              (_context) => AlertDialog(
                title: Text("ATENCION"),
                content: Text("Elemento Eliminado"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(_context),
                    child: Text("Enterado"),
                  ),
                ],
              ),
        );
        cargarDatos();
      } else {
        showDialog(
          context: context,
          builder:
              (_context) => AlertDialog(
                title: Text("ATENCION"),
                content: Text(
                  "Ocurrio un error al intentar eliminar el elemento con el codigo $codigo",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(_context),
                    child: Text("Enterado"),
                  ),
                ],
              ),
        );
      }
    }
  }

  void enviarActualizar(String codigo, String nombre, double precio) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_context) =>
                Actualizar(codigo: codigo, nombre: nombre, precio: precio),
      ),
    );
  }

  void initState() {
    super.initState();
    cargarDatos();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Mostrar Datos"),
        backgroundColor: Colors.amber[200],
      ),
      body:
          productos.isEmpty
              ? Center(child: Text("No hay productos añadidos"))
              : Center(
                child: ListView.builder(
                  itemCount: productos.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text("Clave: ${productos[index]["codigo"]}"),
                      subtitle: Text("Nombre: ${productos[index]["nombre"]}"),
                      trailing: Wrap(
                        direction: Axis.vertical,
                        children: [
                          Text(
                            "Precio: ${productos[index]["precio"].toString()}",
                          ),
                          IconButton(
                            onPressed: () {
                              enviarActualizar(
                                productos[index]["codigo"],
                                productos[index]["nombre"],
                                productos[index]["precio"],
                              );
                            },
                            icon: Icon(Icons.create_rounded),
                          ),
                          IconButton(
                            onPressed: () {
                              //Eliminamos el elemento seleccionado
                              enviarEliminar(productos[index]['codigo']);
                            },
                            icon: Icon(Icons.delete),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
    );
  }
}

//**************************************** */

class Actualizar extends StatefulWidget {
  final String codigo;
  final String nombre;
  final double precio;

  const Actualizar({
    super.key,
    required this.codigo,
    required this.nombre,
    required this.precio,
  });

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return VistaActualizar();
  }
}

class VistaActualizar extends State<Actualizar> {
  TextEditingController ctr_nombre = TextEditingController();
  TextEditingController ctr_precio = TextEditingController();
  final gl_validar_form = GlobalKey<FormState>();

  void actualizar() async {
    bool respuesta = false;

    if (gl_validar_form.currentState!.validate()) {
      respuesta = await showDialog(
        context: context,
        builder:
            (_context) => AlertDialog(
              title: Text("Aviso"),
              content: Text(
                "Estas seguro de actualizar el producto con el codigo ${widget.codigo}?",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text("Aceptar"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text("Cancelar"),
                ),
              ],
            ),
      );
    }

    int respuesta_actualizacion = 0;

    if (respuesta) {
      String nombre = ctr_nombre.text;
      double precio = double.parse(ctr_precio.text);
      respuesta_actualizacion = await BdQR().actualizarProducto(
        widget.codigo,
        nombre,
        precio,
      );

      if (respuesta_actualizacion > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Producto actualizado"),
            duration: Duration(seconds: 3),
          ),
        );
        ctr_nombre.clear();
        ctr_precio.clear();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_context) => Mostrar(mensaje: "")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Ocurrio un error al intentar actualizar el producto con el codigo ${widget.codigo}",
            ),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Modificar Producto"),
        centerTitle: true,
        backgroundColor: Colors.amber[200],
      ),
      body: Center(
        child: IntrinsicHeight(
          child: Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: SizedBox(
              width: double.infinity,
              height: null,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                elevation: 6,
                child: Padding(
                  padding: EdgeInsets.all(6),
                  child: Form(
                    key: gl_validar_form,

                    child: Wrap(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      runSpacing: 15,
                      children: [
                        Text(
                          "Modificar Producto \n Codigo: ${widget.codigo}",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 24),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: null,
                          child: TextFormField(
                            decoration: InputDecoration(
                              label: Text("Nombre anterior: ${widget.nombre}"),
                            ),
                            controller: ctr_nombre,
                            inputFormatters: [
                              FilteringTextInputFormatter(
                                RegExp(r'([a-zA-Z])+\s?'),
                                allow: true,
                              ),
                            ],
                            validator:
                                (value) =>
                                    value!.isEmpty
                                        ? "Ingresa algun valor al campo nombre"
                                        : null,
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: null,
                          child: TextFormField(
                            decoration: InputDecoration(
                              label: Text(
                                "Precio anterior: \$${widget.precio.toString()}",
                              ),
                            ),
                            controller: ctr_precio,
                            inputFormatters: [
                              FilteringTextInputFormatter(
                                RegExp(r'^[0-9]+\.?[0-9]{0,}'),
                                allow: true,
                              ),
                            ],
                            validator:
                                (value) =>
                                    value!.isEmpty
                                        ? "Ingresa un valor al campo precio"
                                        : null,
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: null,
                          child: ElevatedButton(
                            onPressed: () => actualizar(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightBlue[100],
                            ),
                            child: Text("Actualizar"),
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
