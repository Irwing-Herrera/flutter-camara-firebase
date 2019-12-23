import 'package:flutter/material.dart';

import 'package:flutter_app/src/blocs/provaider.dart';

import 'package:flutter_app/src/pages/home_page.dart';
import 'package:flutter_app/src/pages/login_page.dart';
import 'package:flutter_app/src/pages/producto_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provaider(
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'home',
      routes: {
        'login'   : (BuildContext context) => LoginPage(),
        'home'    : (BuildContext context) => HomePage(),
        'producto': (BuildContext context) => ProductoPage()
      },
      theme: ThemeData(
        primaryColor: Color.fromRGBO(1, 111, 138, 1.0)
      ),
    ));
  }
}
