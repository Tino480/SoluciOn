import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solucion/providers/auth_provider.dart';
import 'package:solucion/providers/db_provider.dart';
import 'package:solucion/providers/login_page_providers.dart';
import 'package:solucion/components/clipper.dart';
import 'package:solucion/components/alert.dart';
import 'package:solucion/components/loading.dart';

class LoginPage extends ConsumerWidget {
  void updateEmail(BuildContext context, String email) {
    context.read(emailProvider).state = email;
  }

  void updatePassword(BuildContext context, String pass) {
    context.read(passwordProvider).state = pass;
  }

  void togglePasswordView(BuildContext context, bool togglepass) {
    context.read(togglepasswordProvider).state = !togglepass;
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final email = watch(emailProvider).state;
    final pass = watch(passwordProvider).state;
    final togglepass = watch(togglepasswordProvider).state;
    final _auth = watch(authServicesProvider);
    final _db = watch(dbServicesProvider);
    final _authState = watch(authStateProvider);
    return _authState.when(
      data: (value) {
        if (value != null) {
          _db.getUser(value.uid);
          Future.delayed(Duration(seconds: 5), () {
            Navigator.popAndPushNamed(context, '/Home');
          });
          return loading();
        }
        return Scaffold(
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
                            image: const AssetImage("assets/logo_solucion.png"),
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
                        style:
                            const TextStyle(color: Colors.red, fontSize: 16.0),
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
                            margin:
                                const EdgeInsets.only(left: 00.0, right: 10.0),
                          ),
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Ingresa Tu Correo Electronico',
                                hintStyle: const TextStyle(color: Colors.grey),
                              ),
                              onChanged: (value) => updateEmail(context, value),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: const Text(
                        "Contraseña",
                        style:
                            const TextStyle(color: Colors.red, fontSize: 16.0),
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
                              Icons.lock_open,
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
                              obscureText: togglepass,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Ingresa Tu Contraseña',
                                hintStyle: const TextStyle(color: Colors.grey),
                                suffix: InkWell(
                                  onTap: () => togglePasswordView(context, togglepass),
                                  child: const Icon(
                                    Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              onChanged: (value) =>
                                  updatePassword(context, value),
                            ),
                          ),
                          Container(
                            height: 30.0,
                            width: 1.0,
                            color: Colors.grey.withOpacity(0.5),
                            margin:
                                const EdgeInsets.only(left: 10.0, right: 00.0),
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
                            child: FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                                splashColor: Colors.red,
                                color: Colors.red,
                                child: Row(
                                  children: <Widget>[
                                    const Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: const Text(
                                        "Iniciar",
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
                                            onPressed: () => {
                                                  _auth.login(
                                                      email: email,
                                                      password: pass),
                                                  CircularProgressIndicator(),
                                                }),
                                      ),
                                    ),
                                  ],
                                ),
                                onPressed: () => {
                                      _auth.login(email: email, password: pass),
                                      CircularProgressIndicator(),
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
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              color: Colors.transparent,
                              child: Container(
                                padding: const EdgeInsets.only(left: 20.0),
                                alignment: Alignment.center,
                                child: const Text(
                                  "¿No Tienes Cuenta?",
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 18.0),
                                ),
                              ),
                              onPressed: () =>
                                  Navigator.popAndPushNamed(context, '/Signup'),
                            ),
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
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              color: Colors.transparent,
                              child: Container(
                                padding: const EdgeInsets.only(left: 20.0),
                                alignment: Alignment.center,
                                child: const Text(
                                  "¿Olvidaste Tu Contraseña?",
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 18.0),
                                ),
                              ),
                              onPressed: () => Navigator.popAndPushNamed(
                                  context, '/Recover'),
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
        );
      },
      loading: () => loading(),
      error: (error, __) => showErrorDialog(context, error),
    );
  }
}
