import 'dart:math';

import 'package:flutter/material.dart';
import 'package:proyectounoconexionbd/bd/BdTienda.dart';
import 'package:proyectounoconexionbd/complemento/Validaciones.dart';

/*
Nota: Las ListView estan sujetas a un contenedor padre de alto fijo o bien que no dependan completamente de esta,
ya que puede ocacionar un colapso del widget padre, esto al no tomar en cuenta la existencia de la falta de elementos
hijos de la propia lista.
*/

class TiendaPrincipal extends StatefulWidget {
  const TiendaPrincipal({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return VistaTiendaPrincipal();
  }
}

class VistaTiendaPrincipal extends State<TiendaPrincipal> {
  TextEditingController controlador_nombre = TextEditingController();
  TextEditingController controlador_precio = TextEditingController();
  TextEditingController controlador_cantidad = TextEditingController();
  Validaciones validar = Validaciones();

  List<Map<String, dynamic>> productos = [];
  final clave_validacion_global = GlobalKey<FormState>();
  double total = 0.0;

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

  void limpiarFormulario() {
    controlador_nombre.clear();
    controlador_cantidad.clear();
    controlador_precio.clear();
  }

  void actualizarCarrito() async {
    double total_sumado = 0.0;
    final productos_bd = await BdTienda().obtenerProductos();

    if (productos_bd.isNotEmpty) {
      for (final producto in productos_bd) {
        // alerta("Aviso", producto['Precio'].toString());
        total_sumado += producto['Precio'] * producto['Cantidad'];
      }
    }
    setState(() {
      total = total_sumado;
      productos = productos_bd;
    });
  }

  void agregarProducto() async {
    if (clave_validacion_global.currentState!.validate()) {
      String nombre_p = controlador_nombre.text;
      double precio = double.parse(controlador_precio.text);
      int cantidad = int.parse(controlador_cantidad.text);
      //Comenzamos con la carga a la BD
      int respuesta = await BdTienda().crearProducto(
        nombre_p,
        precio,
        cantidad,
      );
      if (respuesta != 0) {
        actualizarCarrito();
        alerta("Aviso", "Producto agregado al carrito de manera satisfactoria");
        limpiarFormulario();
      } else {
        alerta("Aviso", "Ocurrio un error al intentar guardar el producto");
      }
    }
  }

  //Metodo principal para actualizar el producto
  void actualizarProducto(
    int id,
    String nombre_pm,
    double precio_m,
    int cantidad_m,
  ) async {
    List<String>? datos = await cajaModificarProducto(
      nombre_pm,
      precio_m.toString(),
      cantidad_m.toString(),
    );
    if (datos != null) {
      //Modificamos el producto enviando la informacion a la base de datos
      int respuesta = await BdTienda().modificarProducto(
        id,
        datos[1],
        double.parse(datos[2]),
        int.parse(datos[3]),
      );
      if (respuesta != 0) {
        alerta(
          "Aviso",
          "El producto de nombre ${datos[0]} se actualizo a ${datos[1]}",
        );
        actualizarCarrito();
      } else {
        alerta("Aviso", "Ocurrio un error al actualizar ${datos[0]}");
      }
    }
  }

  //Metodo conectado a la caja de dialogo para modificar el producto
  //BuilContexto recibira el objeto del contexto actual del usuario dentro de la aplicacion
  void validacionCajaModificarProducto(
    BuildContext context_m,
    GlobalKey<FormState> gl,
    String nombre_anterior,
    String nombre_m,
    String precio_m,
    String cantidad_m,
  ) {
    if (gl.currentState!.validate()) {
      //Pasamos los paramentros que deseamos que retorne el widget AlertDialog dentro de []
      Navigator.pop(context, [nombre_anterior, nombre_m, precio_m, cantidad_m]);
    }
  }

  Future<List<String>?> cajaModificarProducto(
    String nombre,
    String precio,
    String cantidad,
  ) async {
    TextEditingController controlador_nombre_md = TextEditingController();
    TextEditingController controlador_precio_md = TextEditingController();
    TextEditingController controlador_cantidad_md = TextEditingController();
    final gl_validacion = GlobalKey<FormState>();
    return showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Actualizacion de producto"),
            content: IntrinsicHeight(
              //Para adaptar la altura del contendor que almacena el alertDialog
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: null,
                        child: Text(
                          "Ingresa la informacion a modificar del producto: \n Nombre (actual):$nombre Precio (actual): \$$precio Cantidad (actual): $cantidad",
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: null,
                        child: Form(
                          key: gl_validacion,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                height: null,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    label: Text("Nombre"),
                                  ),
                                  controller: controlador_nombre_md,
                                  validator:
                                      (value) =>
                                          (value!.isNotEmpty)
                                              ? validar.validarLetrasEspacio(
                                                value,
                                              )
                                              : "Ingresa un valor al campo nombre",
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                height: null,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    label: Text("Precio"),
                                  ),
                                  controller: controlador_precio_md,
                                  validator:
                                      (value) =>
                                          (value!.isNotEmpty)
                                              ? validar.validarNumerosDecimal(
                                                value,
                                              )
                                              : "Ingresa un valor al campo precio",
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                height: null,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    label: Text("Cantidad"),
                                  ),
                                  controller: controlador_cantidad_md,
                                  validator:
                                      (value) =>
                                          (value!.isNotEmpty)
                                              ? validar.validarNumerosEnteros(
                                                value,
                                              )
                                              : "Ingresa un valor al campo cantidad",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed:
                    () => validacionCajaModificarProducto(
                      context,
                      gl_validacion,
                      nombre,
                      controlador_nombre_md.text,
                      controlador_precio_md.text,
                      controlador_cantidad_md.text,
                    ),
                child: Text("Actualizar"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, null),
                child: Text("Cancelar"),
              ),
            ],
          ),
    );
  }

  void eliminarProducto(
    BuildContext context_pe,
    int id,
    String nombre_pe,
  ) async {
    bool? confirmacion = await cajaEliminarProducto(context_pe, nombre_pe);
    if (confirmacion!) {
      int respuesta = await BdTienda().eliminarProducto(id);
      if (respuesta != 0) {
        alerta("Aviso", "El producto de nombre $nombre_pe a sido eliminado");
        actualizarCarrito();
      } else {
        alerta(
          "Aviso",
          "Ocurrio un error al intentar eliminar el producto de nombre $nombre_pe",
        );
      }
    }
  }

  Future<bool?> cajaEliminarProducto(
    BuildContext context_pe,
    String nombre_pe,
  ) async {
    return showDialog(
      context: context_pe,
      builder:
          (context) => AlertDialog(
            title: Text("Alerta"),
            content: Text(
              "Esta seguro de eliminar el producto $nombre_pe del carrito?",
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text("Si"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text("No"),
              ),
            ],
          ),
    );
  }

  Future<bool?> ventanaFactura() async {
    return showDialog(
      context: context,
      builder:
          (context_fac) => AlertDialog(
            title: Text("Factura", textAlign: TextAlign.center),
            content: SingleChildScrollView(
              child: Wrap(
                spacing: 5,
                children:
                    productos
                        .map(
                          (producto) => Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ListTile(
                                leading: Image.asset('assets/imagen.png'),
                                title: Text(producto['Nombre'].toString()),
                                subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("Precio: \$${producto['Precio']}"),
                                    Text("Cantidad ${producto['Cantidad']}"),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                height: null,
                child: Text(
                  "Total: \$${(total * 1.16).toStringAsFixed(2)}    IVA 16%: ${(total * 0.16).toStringAsFixed(2)}",
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context_fac, true),
                    child: Text("Pagar"),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context_fac, false),
                    child: Text("Regresar"),
                  ),
                ],
              ),
            ],
          ),
    );
  }

  void pagar() async {
    if (productos.isNotEmpty) {
      bool? confirmacion = await ventanaFactura();
      int respuesta =
          (confirmacion!) ? await BdTienda().eliminarProductos() : -1;
      (respuesta > 0) ? alerta("Aviso", "Carrito Pagado") : null;
      actualizarCarrito();
    } else {
      alerta("Aviso", "Antes de pagar, registra al menos un producto");
    }
  }

  @override
  //Nota, para correr determinadas funciones de carga de contexto se recomienda
  //Ejecutarlas dentro de initState() ya que de no hacerlo BuildContext no tendra
  //Entorno de ejecucion, esto al no lograr crearse previamente al lanzamiento de la funcion
  //indicada, y que ademas hace uso de su contexto
  void initState() {
    super.initState();
    actualizarCarrito();
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: null,
              color: Colors.amber,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: clave_validacion_global,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  label: const Text("Nombre Producto"),
                                ),
                                controller: controlador_nombre,
                                validator:
                                    (value) =>
                                        (value!.isNotEmpty)
                                            ? validar.validarLetrasEspacio(
                                              value,
                                            )
                                            : "Ingresa un valor al campo nombre",
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  label: const Text("Precio \$"),
                                ),
                                controller: controlador_precio,
                                validator:
                                    (value) =>
                                        (value!.isNotEmpty)
                                            ? validar.validarNumerosDecimal(
                                              value,
                                            )
                                            : "Ingresa un valor al campo precio",
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  label: const Text("Cantidad"),
                                ),
                                controller: controlador_cantidad,
                                validator:
                                    (value) =>
                                        (value!.isNotEmpty)
                                            ? validar.validarNumerosEnteros(
                                              value,
                                            )
                                            : "Ingresa un valor al campo cantidad",
                              ),
                            ),
                            Divider(
                              height: 10,
                              thickness: 10,
                              color: Colors.transparent,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.lightBlueAccent,
                                ),
                                onPressed: () => agregarProducto(),
                                child: const Text("Agregar al carrito"),
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
            Container(
              width: double.infinity,
              height: null,
              child: Center(
                child: Text(
                  "Total: \$${(total * 1.16).toStringAsFixed(2)}    IVA 16%: ${(total * 0.16).toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: null,
              color: Colors.red,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: null, //Aqui revisa
                    child: ListView.builder(
                      physics:
                          NeverScrollableScrollPhysics(), //Bloquea el scroll
                      shrinkWrap: true, //Evita la expansion infinita
                      itemCount: productos.length,
                      itemBuilder:
                          (context, index) => Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: ListTile(
                              leading: Image.asset(
                                'assets/imagen.png',
                                width: 60,
                              ),
                              title: Text(productos[index]['Nombre']),
                              subtitle: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Precio: \$${productos[index]['Precio'].toString()}",
                                  ),
                                  Text(
                                    "Cantidad: ${productos[index]['Cantidad'].toString()}",
                                  ),
                                ],
                              ),
                              trailing: Wrap(
                                direction: Axis.vertical,
                                spacing: 5,
                                children: [
                                  IconButton(
                                    onPressed:
                                        () => actualizarProducto(
                                          productos[index]['Id'],
                                          productos[index]['Nombre'],
                                          productos[index]['Precio'],
                                          productos[index]['Cantidad'],
                                        ),
                                    icon: Icon(Icons.create_rounded),
                                  ),
                                  IconButton(
                                    onPressed:
                                        () => eliminarProducto(
                                          context,
                                          productos[index]['Id'],
                                          productos[index]['Nombre'],
                                        ),
                                    icon: Icon(Icons.delete_forever),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    ),
                  ),

                  SizedBox(
                    width: double.infinity,
                    height: null,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: ElevatedButton(
                        onPressed: () => pagar(),
                        child: const Text("Pagar"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
