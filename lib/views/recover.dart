import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:solucion/providers/auth_provider.dart';
import 'package:solucion/providers/login_page_providers.dart';

class RecoverPage extends ConsumerWidget {
  Future<void> _showRecoverDialog(context, email) async {
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
                  'Se a enviado un correo a $email',
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
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
              ),
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

  void updateEmail(BuildContext context, String email) {
    context.read(emailProvider).state = email;
  }

  Widget build(BuildContext context, ScopedReader watch) {
    final email = watch(emailProvider).state;
    final _auth = watch(authServicesProvider);
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor('#e30713'),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              color: HexColor('#e30713'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: const BoxDecoration(
                      image: const DecorationImage(
                        image: const AssetImage("assets/logo.jpeg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 50.0, bottom: 100.0),
                    child: Column(
                      children: <Widget>[
                        const Padding(
                            padding: const EdgeInsets.only(top: 200.0)),
                        const Text(
                          "Unidos Por La Vida",
                          style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: const Text(
                      "Correo Electrónico",
                      style:
                          const TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                          margin:
                              const EdgeInsets.only(left: 00.0, right: 10.0),
                        ),
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Ingresa Tu Correo Electrónico',
                              hintStyle: const TextStyle(color: Colors.grey),
                            ),
                            // validator: (value) =>
                            //     value.isEmpty ? 'Requirido' : null,
                            // onSaved: (value) => _email = value,
                            onChanged: (value) => updateEmail(context, value),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20.0),
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextButton(
                              style: TextButton.styleFrom(
                                shadowColor: Colors.red,
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  const Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: const Text(
                                      "Recuperar",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 18.0),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(),
                                  ),
                                  Transform.translate(
                                    offset: const Offset(5.0, 0.0),
                                    child: Container(
                                      padding: const EdgeInsets.all(5.0),
                                      child: TextButton(
                                          style: TextButton.styleFrom(
                                            shadowColor: Colors.white,
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(28.0),
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.check,
                                            color: Colors.black,
                                          ),
                                          onPressed: () {
                                            _auth.resetPassword(email: email);
                                            _showRecoverDialog(context, email);
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                _auth.resetPassword(email: email);
                                _showRecoverDialog(context, email);
                              }),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20.0),
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextButton(
                            child: Container(
                              padding: const EdgeInsets.only(left: 20.0),
                              alignment: Alignment.center,
                              child: const Text(
                                "Pantalla de Inicio",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18.0),
                              ),
                            ),
                            onPressed: () =>
                                Navigator.popAndPushNamed(context, '/Login'),
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
      ),
    );
  }
}
