import 'package:flutter/material.dart';

import 'package:flutter_app/src/blocs/provaider.dart';

import 'package:flutter_app/src/pages/home_page.dart';
import 'package:flutter_app/src/pages/login_page.dart';
import 'package:flutter_app/src/pages/producto_page.dart';
import 'package:flutter_app/src/pages/registro_page.dart';
import 'package:flutter_app/src/preferencias_usuario/preferencias_usuario.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final prefs = new PreferenciasUsuario();
    print(prefs.token);

    return Provaider(
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'login',
      routes: {
        'login'      : (BuildContext context) => LoginPage(),
        'registro'   : (BuildContext context) => RegistroPage(),
        'home'       : (BuildContext context) => HomePage(),
        'producto'   : (BuildContext context) => ProductoPage()
      },
      theme: ThemeData(
        primaryColor: Color.fromRGBO(1, 111, 138, 1.0)
      ),
    ));
  }
}
