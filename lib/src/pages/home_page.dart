import 'package:flutter/material.dart';

import 'package:flutter_app/src/models/producto.dart';
import 'package:flutter_app/src/providers/productos_providers.dart';

class HomePage extends StatelessWidget {
  final productosProvider = new ProductosProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home Page'),
        ),
        body: _crearListado(),
        floatingActionButton: _crearBoton(context));
  }

  Widget _crearBoton(BuildContext context) {
    return FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => Navigator.pushNamed(context, 'producto'));
  }

  Widget _crearListado() {
    return FutureBuilder(
      future: productosProvider.getProductos(),
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) =>
                  _crearItem(context, snapshot.data[index]));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearItem(BuildContext context, ProductoModel producto) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red[300],
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (direccion) {
          //BORRAR PRODUCROS
          productosProvider.deleteProducto(producto.id);
        },
        child: Card(
          child: Column(
            children: <Widget>[
              (producto.fotoUrl == null)
                  ? Image(image: AssetImage('assets/img/no-image.png'))
                  : FadeInImage(
                      image: NetworkImage(producto.fotoUrl),
                      placeholder: AssetImage('assets/img/loading.gif'),
                      height: 300.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
              ListTile(
                title: Text('${producto.titulo} - ${producto.valor}'),
                subtitle: Text(producto.id),
                onTap: () => Navigator.pushNamed(context, 'producto',
                    arguments: producto),
              ),
            ],
          ),
        ));
  }
}
