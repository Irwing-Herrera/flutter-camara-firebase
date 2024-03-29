import 'package:flutter/material.dart';

bool isNumeric(String valor) {
  if (valor.isEmpty) return false;
  final numero = num.tryParse(valor);
  return (numero == null) ? false : true;
}

void mostrarAlerta(BuildContext context, String mensaje) {

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Informacion Incorrecta'),
        content: Text(mensaje),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      );
    }
  );

}