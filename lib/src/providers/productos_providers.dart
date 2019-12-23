import 'dart:convert';
import 'dart:io';

import 'package:flutter_app/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

import 'package:flutter_app/src/models/producto.dart';

class ProductosProvider {
  final String _url = 'https://flutter-varios-9a9e8.firebaseio.com';
  final _prefs = new PreferenciasUsuario();

  Future<bool> crearProducto(ProductoModel producto) async {
    final url = '$_url/productos.json?auth=${_prefs.token}';
    final response = await http.post(url, body: productoModelToJson(producto));
    final decodeData = json.decode(response.body);
    print(decodeData);
    return false;
  }

  Future<List<ProductoModel>> getProductos() async {
    final url = '$_url/productos.json?auth=${_prefs.token}';
    final response = await http.get(url);
    final Map<String, dynamic> decodeData = json.decode(response.body);
    final List<ProductoModel> productos = new List();

    if (decodeData == null) return [];

    decodeData.forEach((id, prod) {
      final prodTep = ProductoModel.fromJson(prod);
      prodTep.id = id;
      productos.add(prodTep);
    });

    return productos;
  }

  Future<bool> updateProducto(ProductoModel producto) async {
    final url = '$_url/productos/${producto.id}.json?auth=${_prefs.token}';
    final response = await http.put(url, body: productoModelToJson(producto));
    final decodeData = json.decode(response.body);
    print(decodeData);
    return false;
  }

  Future<bool> deleteProducto(String id) async {
    final url = '$_url/productos/$id.json?auth=${_prefs.token}';
    final response = await http.delete(url);
    print(json.decode(response.body));
    return true;
  }

  Future<String> subirImagen(File imagen) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/ddw7ircba/image/upload?upload_preset=tyyco02s');
    final mimeTipe = mime(imagen.path).split('/'); //image/jpeg

    final imagenUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath(
      'file', 
      imagen.path,
      contentType: MediaType(mimeTipe[0], mimeTipe[1]));

    imagenUploadRequest.files.add(file);

    final streamResponse = await imagenUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Algo salio mal');
      print(resp.body);
      return null;
    }

    final responseData = json.decode(resp.body);
    return responseData['secure_url'];
  }
}
