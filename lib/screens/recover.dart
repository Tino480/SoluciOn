import 'package:flutter/material.dart';
import 'package:solucion/services/auth.dart' as auth;
import 'package:solucion/components/clipper.dart';

class RecoverPage extends StatefulWidget {
  @override
  _RecoverPageState createState() => _RecoverPageState();
}

enum FormType { login, register }

class _RecoverPageState extends State<RecoverPage> {
  final _formKey = GlobalKey<FormState>();

  String _email;

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void login() async {
    Navigator.popAndPushNamed(context, '/Login');
  }

  Future<void> _showRecoverDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Recuperacion Exitosa',
            style: const TextStyle(
                fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Se a enviado un correo a $_email',
                  style: const TextStyle(fontSize: 15.0, color: Colors.red),
                ),
                const Text(
                  'Por favor revisa el correo y cambia tu contraseña',
                  style: const TextStyle(fontSize: 15.0, color: Colors.red),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              color: Colors.red,
              child: const Text(
                'Listo! Ingresar A Mi Cuenta',
                style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              onPressed: () {
                Navigator.popAndPushNamed(context, '/Login');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Form(
            key: _formKey,
            child: Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ClipPath(
                          clipper: MyClipper(),
                          child: Container(
                            decoration: const BoxDecoration(
                              image: const DecorationImage(
                                image: const AssetImage(
                                    "assets/logo_solucion.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                            alignment: Alignment.center,
                            padding:
                                const EdgeInsets.only(top: 50.0, bottom: 100.0),
                            child: Column(
                              children: <Widget>[
                                const Text(
                                  "Salva Una Vida Con",
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                                const Text(
                                  "SoluciOn",
                                  style: const TextStyle(
                                      fontSize: 50.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Padding(
                          padding: const EdgeInsets.only(left: 40.0),
                          child: const Text(
                            "Correo Electronico",
                            style: const TextStyle(
                                color: Colors.red, fontSize: 16.0),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.5),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          margin: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: Row(
                            children: <Widget>[
                              const Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 15.0),
                                child: const Icon(
                                  Icons.person_outline,
                                  color: Colors.grey,
                                ),
                              ),
                              Container(
                                height: 30.0,
                                width: 1.0,
                                color: Colors.grey.withOpacity(0.5),
                                margin: const EdgeInsets.only(
                                    left: 00.0, right: 10.0),
                              ),
                              Expanded(
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Ingresa Tu Correo Electronico',
                                    hintStyle:
                                        const TextStyle(color: Colors.grey),
                                  ),
                                  validator: (value) =>
                                      value.isEmpty ? 'Requirido' : null,
                                  onSaved: (value) => _email = value,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20.0),
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0)),
                                    splashColor: Colors.red,
                                    color: Colors.red,
                                    child: Row(
                                      children: <Widget>[
                                        const Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
                                          child: const Text(
                                            "Recuperar",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.0),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(),
                                        ),
                                        Transform.translate(
                                          offset: const Offset(15.0, 0.0),
                                          child: Container(
                                            padding: const EdgeInsets.all(5.0),
                                            child: FlatButton(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            28.0)),
                                                splashColor: Colors.white,
                                                color: Colors.white,
                                                child: const Icon(
                                                  Icons.check,
                                                  color: Colors.black,
                                                ),
                                                onPressed: () {
                                                  auth.resetPassword(
                                                    context,
                                                    validateAndSave(),
                                                    _email,
                                                  );
                                                  _showRecoverDialog();
                                                }),
                                          ),
                                        ),
                                      ],
                                    ),
                                    onPressed: () {
                                      auth.resetPassword(
                                          context, validateAndSave(), _email);
                                      _showRecoverDialog();
                                    }),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20.0),
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.0)),
                                  color: Colors.transparent,
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      "Pantalla de Inicio",
                                      style: const TextStyle(
                                          color: Colors.red, fontSize: 18.0),
                                    ),
                                  ),
                                  onPressed: login,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }
}
