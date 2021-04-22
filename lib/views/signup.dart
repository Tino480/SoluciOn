import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:solucion/providers/auth_provider.dart';
import 'package:solucion/providers/db_provider.dart';
import 'package:solucion/providers/login_page_providers.dart';
import 'package:solucion/providers/signup_page_providers.dart';
import 'package:solucion/components/alert.dart';
import 'package:solucion/components/loading.dart';

class SignUpPage extends ConsumerWidget {
  void updateEmail(BuildContext context, String email) {
    context.read(emailProvider).state = email;
  }

  void updatePassword(BuildContext context, String pass) {
    context.read(passwordProvider).state = pass;
  }

  void updateVerifyPassword(BuildContext context, String passVeri) {
    context.read(passwordVerifyProvider).state = passVeri;
  }

  void updateName(BuildContext context, String name) {
    context.read(nameProvider).state = name;
  }

  void updateUserName(BuildContext context, String userName) {
    context.read(userNameProvider).state = userName;
  }

  void updatePhoneNumber(BuildContext context, int phoneNumber) {
    context.read(phoneNumberProvider).state = phoneNumber;
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

  Future<void> _showDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Error de registro',
            style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text(
                  'Acuerda que:',
                  style: const TextStyle(fontSize: 15.0, color: Colors.red),
                ),
                const Text(
                  '1. Todos los campos son obligatorios.',
                  style: const TextStyle(fontSize: 15.0, color: Colors.red),
                ),
                const Text(
                  '2. El Correo electrónico debe de ser valido y no tener espacio vacío al final.',
                  style: const TextStyle(fontSize: 15.0, color: Colors.red),
                ),
                const Text(
                  '3. La contraseña debe ser igual en ambos campos y mayor de 7 caracteres.',
                  style: const TextStyle(fontSize: 15.0, color: Colors.red),
                ),
                const Text(
                  '4. El numero de telefono debe ser de 10 caracteres.',
                  style: const TextStyle(fontSize: 15.0, color: Colors.red),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  verifyForm(context, email, pass, passVeri, name, state, municipality,
      bloodType, phone) {
    if (email?.isEmpty ?? true) {
      _showDialog(context);
      return false;
    } else if (pass?.isEmpty ?? true) {
      _showDialog(context);
      return false;
    } else if (passVeri?.isEmpty ?? true) {
      _showDialog(context);
      return false;
    } else if (name?.isEmpty ?? true) {
      _showDialog(context);
      return false;
    } else if (state?.isEmpty ?? true) {
      _showDialog(context);
      return false;
    } else if (municipality?.isEmpty ?? true) {
      _showDialog(context);
      return false;
    } else if (bloodType?.isEmpty ?? true) {
      _showDialog(context);
      return false;
    } else if (pass != passVeri) {
      _showDialog(context);
      return false;
    } else if (pass.length < 8) {
      _showDialog(context);
      return false;
    } else if (phone.toString().length < 10) {
      _showDialog(context);
      return false;
    } else if (phone.toString().length > 10) {
      _showDialog(context);
      return false;
    } else if (phone.toString()?.isEmpty ?? true) {
      _showDialog(context);
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final email = watch(emailProvider).state;
    final pass = watch(passwordProvider).state;
    final passVeri = watch(passwordVerifyProvider).state;
    final name = watch(nameProvider).state;
    final userName = watch(userNameProvider).state;
    final phoneNumber = watch(phoneNumberProvider).state;
    final state = watch(stateProvider).state;
    final states = watch(statesProvider).state;
    final municipality = watch(municipalityProvider).state;
    final municipalities = watch(municipalitiesProvider).state;
    final bloodType = watch(bloodTypeProvider).state;
    final togglepass = watch(togglepasswordProvider).state;
    final _auth = watch(authServicesProvider);
    final _db = watch(dbServicesProvider);
    final _authState = watch(authStateProvider);
    List<String> defaultMunicipality = ['Escoge un estado primero!!'];
    return _authState.when(
      data: (value) {
        if (value != null) {
          _db.createUser(
              uid: value.uid,
              name: name,
              userName: userName,
              phoneNumber: phoneNumber,
              email: email,
              state: state,
              municipality: municipality,
              bloodType: bloodType,
              compatibleBloodTypes: compatibleBloodTypes[bloodType]);
          Future.delayed(Duration(seconds: 10), () {
            Navigator.popAndPushNamed(context, '/Home');
          });
          return loading();
        }
        if (states != null) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: HexColor('#e30713'),
              body: SingleChildScrollView(
                child: Container(
                  color: HexColor('#e30713'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        decoration: const BoxDecoration(
                          image: const DecorationImage(
                            image: const AssetImage("assets/redblood.jpeg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        alignment: Alignment.center,
                        padding:
                            const EdgeInsets.only(top: 50.0, bottom: 100.0),
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
                          "Correo electrónico",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16.0),
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
                                Icons.email,
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
                              child: TextField(
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Ingresa tu correo electrónico',
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                ),
                                onChanged: (value) =>
                                    updateEmail(context, value),
                              ),
                            )
                          ],
                        ),
                      ),
                      const Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: const Text(
                          "Nombre de usuario",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16.0),
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
                                Icons.person,
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
                              child: TextField(
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Ingresa tu nombre de usuario',
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                ),
                                onChanged: (value) =>
                                    updateUserName(context, value),
                              ),
                            )
                          ],
                        ),
                      ),
                      const Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: const Text(
                          "Contraseña",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16.0),
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
                                Icons.lock_open,
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
                              child: TextField(
                                obscureText: togglepass,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Ingresa tu contraseña',
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                  suffix: InkWell(
                                    onTap: () =>
                                        togglePasswordView(context, togglepass),
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
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16.0),
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
                                Icons.lock_open,
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
                              child: TextField(
                                obscureText: togglepass,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Verifica tu contraseña',
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                  suffix: InkWell(
                                    onTap: () =>
                                        togglePasswordView(context, togglepass),
                                    child: const Icon(
                                      Icons.visibility,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                onChanged: (value) =>
                                    updateVerifyPassword(context, value),
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
                          "Nombre completo",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16.0),
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
                                Icons.person,
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
                              child: TextField(
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Ingresa tu nombre completo',
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                ),
                                onChanged: (value) =>
                                    updateName(context, value),
                              ),
                            )
                          ],
                        ),
                      ),
                      const Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: const Text(
                          "Numero de teléfono",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16.0),
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
                                Icons.phone,
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
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Ingresa tu numero de teléfono',
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                ),
                                onChanged: (value) => updatePhoneNumber(
                                    context, int.parse(value)),
                              ),
                            )
                          ],
                        ),
                      ),
                      const Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: const Text(
                          "Estado",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16.0),
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
                                Icons.map,
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
                                child: DropdownButton(
                              hint: const Text('Escoje tu estado'),
                              value: state,
                              onChanged: (newValue) {
                                updateState(context, newValue);
                              },
                              items: states.map((location) {
                                return DropdownMenuItem(
                                  child: Text(location,
                                      style:
                                          const TextStyle(color: Colors.red)),
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
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16.0),
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
                                Icons.home,
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
                                child: (state != null)
                                    ? DropdownButton(
                                        hint: const Text('Escoje tu municipio'),
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
                                        hint: const Text('Escoje tu municipio'),
                                        value: municipality,
                                        onChanged: (newValue) {
                                          updateMunicipality(context, newValue);
                                        },
                                        items:
                                            defaultMunicipality.map((location) {
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
                          "Tipo de sangre",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16.0),
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
                                Icons.block,
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
                                child: DropdownButton(
                              hint: const Text('Escoje tu tipo de sangre'),
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
                              child: TextButton(
                                  style: TextButton.styleFrom(
                                    shadowColor: Colors.white,
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      const Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20.0),
                                        child: const Text(
                                          "Registrarme",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.0),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(),
                                      ),
                                      Transform.translate(
                                        offset: Offset(5.0, 0.0),
                                        child: Container(
                                          padding: const EdgeInsets.all(5.0),
                                          child: TextButton(
                                              style: TextButton.styleFrom(
                                                shadowColor: Colors.white,
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          28.0),
                                                ),
                                              ),
                                              child: const Icon(
                                                Icons.check,
                                                color: Colors.black,
                                              ),
                                              onPressed: () => {
                                                    if (verifyForm(
                                                        context,
                                                        email,
                                                        pass,
                                                        passVeri,
                                                        name,
                                                        state,
                                                        municipality,
                                                        bloodType,
                                                        phoneNumber))
                                                      {
                                                        _auth.signUp(
                                                            email: email,
                                                            password: pass)
                                                      }
                                                  }),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onPressed: () => {
                                        if (verifyForm(
                                            context,
                                            email,
                                            pass,
                                            passVeri,
                                            name,
                                            state,
                                            municipality,
                                            bloodType,
                                            phoneNumber))
                                          {
                                            _auth.signUp(
                                                email: email, password: pass)
                                          }
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
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    "¿Ya tienes cuenta?",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 18.0),
                                  ),
                                ),
                                onPressed: () =>
                                    Navigator.pushNamed(context, '/Login'),
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
        } else {
          return showErrorDialog(context, 'No tienes coneccion al internet!!!');
        }
      },
      loading: () => loading(),
      error: (error, __) => showErrorDialog(context, error),
    );
  }
}
