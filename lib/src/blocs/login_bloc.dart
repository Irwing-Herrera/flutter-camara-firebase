import 'dart:async';

import 'package:flutter_app/src/blocs/validators.dart';

import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators {

  final _emailController    = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  // RECUPERAR LOS DATOS DEL STREAM
  Stream<String> get emailStream    => _emailController.stream.transform(validaEmail);
  Stream<String> get passwordStream => _passwordController.stream.transform(validaPassword);

  Stream<bool> get formValidStream =>
    Observable.combineLatest2(emailStream, passwordStream, (email, pass) => true);

  // INSERTAR VALORES AL STREAM
  Function(String) get changeEmail    => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  // GET Streams
  String get email => _emailController.value;  
  String get password => _passwordController.value;  

  dispose() {
    _emailController?.close();
    _passwordController?.close();
  }
}