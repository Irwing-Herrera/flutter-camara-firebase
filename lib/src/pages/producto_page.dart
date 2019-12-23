import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/src/utils/utils.dart';

import 'package:image_picker/image_picker.dart';

import 'package:flutter_app/src/providers/productos_providers.dart';
import 'package:flutter_app/src/models/producto.dart';


class ProductoPage extends StatefulWidget {
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  
  final formKey = GlobalKey<FormState>();
  final scaffoldmKey = GlobalKey<ScaffoldState>();
  final productosProvider = new ProductosProvider();

  ProductoModel producto = new ProductoModel();
  bool _guardando = false;
  File foto;

  @override
  Widget build(BuildContext context) {
    final ProductoModel prodArgumento =
        ModalRoute.of(context).settings.arguments;

    if (prodArgumento != null) producto = prodArgumento;

    return Scaffold(
      key: scaffoldmKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _seleccionarFoto,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _tomarFoto,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _mostrarFoto(),
                _crearNombre(),
                _crearPrecio(),
                _crearDisponible(),
                SizedBox(height: 10.0),
                _crearBoton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearNombre() {
    return TextFormField(
        initialValue: producto.titulo,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(labelText: 'Producto'),
        onSaved: (value) => producto.titulo = value,
        validator: (value) {
          if (value.length > 3) {
            return null;
          } else {
            return 'Tienes que poner al menos 3 caracteres.';
          }
        });
  }

  Widget _crearPrecio() {
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: 'Precio'),
      onSaved: (value) => producto.valor = double.parse(value),
      validator: (valor) {
        if (isNumeric(valor)) {
          return null;
        } else {
          return 'Solo Numeros.';
        }
      },
    );
  }

  Widget _crearBoton(BuildContext context) {
    return RaisedButton.icon(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        label: Text('Guardar'),
        icon: Icon(Icons.save),
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
        onPressed: (_guardando) ? null : _submit);
  }

  Widget _crearDisponible() {
    return SwitchListTile(
      value: producto.disponible,
      title: Text('Disponible'),
      activeColor: Theme.of(context).primaryColor,
      onChanged: (value) => setState(() {
        producto.disponible = value;
      }),
    );
  }

  void _submit() async {

    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();
    
    setState(() { _guardando = true; });

    if (foto != null) {
      producto.fotoUrl = await productosProvider.subirImagen(foto);
    }

    if (producto.id == null)
      productosProvider.crearProducto(producto);
    else
      productosProvider.updateProducto(producto);

    final String mensaje =
        (producto.id == null) ? 'Creando Producto' : 'Actualizando Producto';
    mostrarSnackBar(mensaje);
    Navigator.pop(context);
  }

  _mostrarFoto() {
    if (producto.fotoUrl != null) {
      return FadeInImage(
        image: NetworkImage(producto.fotoUrl),
        placeholder: AssetImage('assets/img/loading.gif'),
        height: 300.0,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else {
      return Image(
        image: AssetImage(foto?.path ?? 'assets/img/no-image.png'),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }
  } 

  void mostrarSnackBar(String mensaje) {
    final snackBar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );

    scaffoldmKey.currentState.showSnackBar(snackBar);
  }

  _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery);
  }

  _tomarFoto() async {
    _procesarImagen(ImageSource.camera);
  }

  _procesarImagen(ImageSource origen) async {
    foto = await ImagePicker.pickImage(source: origen);

    if ( foto != null ) {
      producto.fotoUrl = null;
    }

    setState(() {});
  }

}
