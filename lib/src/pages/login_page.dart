import 'package:flutter/material.dart';

import 'package:flutter_app/src/blocs/login_bloc.dart';
import 'package:flutter_app/src/blocs/provaider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[_crearFondo(context), _loginForm(context)],
      ),
    );
  }

  Widget _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final fondoMorado = Container(
        padding: EdgeInsets.zero,
        height: size.height * 0.4,
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/img/back.jpg'), fit: BoxFit.cover)));

    // final circulo = Container(
    //   width: 100.0,
    //   height: 100.0,
    //   decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(100.0),
    //       color: Color.fromRGBO(255, 255, 255, 0.2)),
    // );

    return Stack(
      children: <Widget>[
        fondoMorado,
        // Positioned(top: -20.0, left: -10.0, child: circulo),
        // Positioned(top: -40.0, right: 30.0, child: circulo),
        // Positioned(bottom: -50.0, right: -10.0, child: circulo),
        // Positioned(bottom: 120.0, right: 20.0, child: circulo),
        // Positioned(bottom: -50.0, left: -20.0, child: circulo),
        Container(
          padding: EdgeInsets.only(top: 50.0),
          child: Column(
            children: <Widget>[
              Image(
                image: AssetImage('assets/img/logo.png'),
                width: 150.0,
                fit: BoxFit.cover,
              ),
              SizedBox(width: double.infinity),
              Text('Ojo del Agua',
                  style: TextStyle(color: Colors.white, fontSize: 25.0))
            ],
          ),
        )
      ],
    );
  }

  Widget _loginForm(BuildContext context) {
    final bloc = Provaider.of(context);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
            child: Container(
              height: 180.0,
            ),
          ),
          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 30.0),
            padding: EdgeInsets.symmetric(vertical: 50.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3.0,
                      offset: Offset(0.0, 5.0),
                      spreadRadius: 3.0),
                ]),
            child: Column(
              children: <Widget>[
                Text('Ingreso', style: TextStyle(fontSize: 20.0)),
                SizedBox(height: 60.0),
                _crearEmail(bloc),
                SizedBox(height: 30.0),
                _crearPassword(bloc),
                SizedBox(height: 30.0),
                _crearBoton(bloc)
              ],
            ),
          ),
          Text('¿Olvide la Contraseña?'),
          SizedBox(height: 100.0)
        ],
      ),
    );
  }

  Widget _crearEmail(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    icon: Icon(Icons.alternate_email, color: Colors.grey),
                    hintText: 'ejemplo@correo.com',
                    labelText: 'Coreo Electrónico',
                    counterText: snapshot.data,
                    errorText: snapshot.error),
                onChanged: bloc.changeEmail));
      },
    );
  }

  Widget _crearPassword(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
                icon: Icon(Icons.lock_outline, color: Colors.grey),
                labelText: 'Contraseña',
                counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changePassword,
          ),
        );
      },
    );
  }

  Widget _crearBoton(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 10.0),
            child: Text('Ingresar'),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          elevation: 0.0,
          color: Color.fromRGBO(1, 111, 138, 1.0),
          textColor: Colors.white,
          onPressed: snapshot.hasData ? () => _login(bloc, context) : null
        );
      },
    );
  }

  _login(LoginBloc bloc, BuildContext context) {
    print('Email: ${bloc.email}');
    print('Password: ${bloc.password}');

    Navigator.of(context).pushReplacementNamed('home');
  }
}
