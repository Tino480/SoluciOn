import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solucion/providers/auth_provider.dart';
import 'package:solucion/providers/db_provider.dart';
import 'package:solucion/providers/login_page_providers.dart';
import 'package:solucion/providers/signup_page_providers.dart';
import 'package:solucion/components/clipper.dart';
import 'package:solucion/components/alert.dart';
import 'package:solucion/components/loading.dart';

class SignUpPage extends ConsumerWidget {
  void updateEmail(BuildContext context, String email) {
    context.read(emailProvider).state = email;
  }

  void updatePassword(BuildContext context, String pass) {
    context.read(passwordProvider).state = pass;
  }

  void updateName(BuildContext context, String name) {
    context.read(nameProvider).state = name;
  }

  void updateState(BuildContext context, String state) {
    context.read(stateProvider).state = state;
  }

  void updateMunicipality(BuildContext context, String municipality) {
    context.read(municipalityProvider).state = municipality;
  }

  void updateBloodType(BuildContext context, String bloodType) {
    context.read(bloodTypeProvider).state = bloodType;
  }

  void togglePasswordView(BuildContext context, bool togglepass) {
    context.read(togglepasswordProvider).state = !togglepass;
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final email = watch(emailProvider).state;
    final pass = watch(passwordProvider).state;
    final name = watch(nameProvider).state;
    final state = watch(stateProvider).state;
    final states = watch(statesProvider).state;
    final municipality = watch(municipalityProvider).state;
    final municipalities = watch(municipalitiesProvider).state;
    final bloodType = watch(bloodTypeProvider).state;
    final togglepass = watch(togglepasswordProvider).state;
    final _auth = watch(authServicesProvider);
    final _db = watch(dbServicesProvider);
    final _authState = watch(authStateProvider);
    List<String> _muni = ['default'];
    return _authState.when(
      data: (value) {
        if (value != null) {
          _db.createUser(
              uid: value.uid,
              name: name,
              state: state,
              municipality: municipality,
              bloodType: bloodType,
              compatibleBloodTypes: compatibleBloodTypes[bloodType]);
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
                              Icons.email,
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
                                const EdgeInsets.only(left: 10.0, right: 0.0),
                          ),
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
                            child: TextFormField(
                              obscureText: togglepass,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Verifica Tu Contraseña',
                                hintStyle: const TextStyle(color: Colors.grey),
                                suffix: InkWell(
                                  onTap: () => togglePasswordView(context, togglepass),
                                  child: const Icon(
                                    Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Requerido";
                                } else if (value.length < 8) {
                                  return "La contraseña debe ser mayor a 8 letras";
                                } else if (value != pass) {
                                  return "La contraseña debe ser igual que la anterior!";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          Container(
                            height: 30.0,
                            width: 1.0,
                            color: Colors.grey.withOpacity(0.5),
                            margin:
                                const EdgeInsets.only(left: 10.0, right: 0.0),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: const Text(
                        "Nombre",
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
                              Icons.person,
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
                                hintText: 'Ingresa Tu Nombre',
                                hintStyle: const TextStyle(color: Colors.grey),
                              ),
                              onChanged: (value) => updateName(context, value),
                              // validator: (value) =>
                              //     value.isEmpty ? 'Requirido' : null,
                              // onSaved: (value) => _name = value,
                            ),
                          )
                        ],
                      ),
                    ),
                    const Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: const Text(
                        "Estado",
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
                              Icons.map,
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
                              child: DropdownButton(
                            hint: const Text('Escoje Tu Estado'),
                            value: state,
                            onChanged: (newValue) {
                              updateState(context, newValue);
                            },
                            items: states.map((location) {
                              return DropdownMenuItem(
                                child: Text(location,
                                    style: const TextStyle(color: Colors.red)),
                                value: location,
                              );
                            }).toList(),
                          ))
                        ],
                      ),
                    ),
                    const Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: const Text(
                        "Municipio",
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
                              Icons.home,
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
                              child: (state != null)
                                  ? DropdownButton(
                                      hint: const Text('Escoje Tu Municipio'),
                                      value: municipality,
                                      onChanged: (newValue) {
                                        updateMunicipality(context, newValue);
                                      },
                                      items: municipalities[state]
                                          .map<DropdownMenuItem<String>>(
                                              (location) {
                                        return DropdownMenuItem<String>(
                                          child: Text(location,
                                              style: const TextStyle(
                                                  color: Colors.red)),
                                          value: location,
                                        );
                                      }).toList(),
                                    )
                                  : DropdownButton<String>(
                                      hint: const Text('Escoje Tu Municipio'),
                                      value: municipality,
                                      onChanged: (newValue) {
                                        updateMunicipality(context, newValue);
                                      },
                                      items: _muni.map((location) {
                                        return DropdownMenuItem(
                                          child: Text(location,
                                              style: const TextStyle(
                                                  color: Colors.red)),
                                          value: location,
                                        );
                                      }).toList(),
                                    )),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: const Text(
                        "Tipo De Sangre",
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
                              Icons.block,
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
                              child: DropdownButton(
                            hint: const Text('Escoje Tu Tipo De Sangre'),
                            value: bloodType,
                            onChanged: (newValue) {
                              updateBloodType(context, newValue);
                            },
                            items: bloodTypes.map((location) {
                              return DropdownMenuItem(
                                child: Text(location,
                                    style: TextStyle(color: Colors.red)),
                                value: location,
                              );
                            }).toList(),
                          ))
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
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: const Text(
                                      "Registrarme",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 18.0),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(),
                                  ),
                                  Transform.translate(
                                    offset: Offset(15.0, 0.0),
                                    child: Container(
                                      padding: const EdgeInsets.all(5.0),
                                      child: FlatButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(28.0)),
                                        splashColor: Colors.white,
                                        color: Colors.white,
                                        child: const Icon(
                                          Icons.check,
                                          color: Colors.black,
                                        ),
                                        onPressed: () => _auth.signUp(
                                            email: email, password: pass),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () =>
                                  _auth.signUp(email: email, password: pass),
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
                                  "¿Ya Tienes Cuenta?",
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 18.0),
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
        );
      },
      loading: () => loading(),
      error: (error, __) => showErrorDialog(context, error),
    );
  }
}
