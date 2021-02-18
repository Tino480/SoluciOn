import 'package:flutter/material.dart';
import 'package:solucion/services/auth.dart' as auth;
import 'package:solucion/components/clipper.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

enum FormType { login, register }

class _SignUpState extends State<SignUp> {
  final _forKey = GlobalKey<FormState>();

  bool _isHidden = true;

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  String _email;
  String _password;
  String _name;
  static const List<String> _states = [
    'Aguascalientes',
    'Baja California',
    'Baja California Sur',
    'Campeche',
    'Chiapas',
    'Chihuahua',
    'Ciudad de México',
    'Coahuila',
    'Colima',
    'Durango',
    'Estado de México',
    'Guanajuato',
    'Guerrero',
    'Hidalgo',
    'Jalisco',
    'Michoacán',
    'Morelos',
    'Nayarit',
    'Nuevo León',
    'Oaxaca',
    'Puebla',
    'Querétaro',
    'Quintana Roo',
    'San Luis Potosí',
    'Sinaloa',
    'Sonora',
    'Tabasco',
    'Tamaulipas',
    'Tlaxcala',
    'Veracruz',
    'Yucatán',
    'Zacatecas'
  ];
  String _state;
  String _municipality;
  static const List<String> _bloodTypes = [
    'O-',
    'O+',
    'A-',
    'A+',
    'B-',
    'B+',
    'AB-',
    'AB+'
  ];
  String _bloodType;
  String _confirmpass;

  bool validateAndSave() {
    final form = _forKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _showRegistrationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Registro Exitoso',
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
                  'Por favor revisa el correo y verifica tu cuenta',
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

  login() async {
    Navigator.popAndPushNamed(context, '/Login');
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _forKey,
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
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Ingresa Tu Correo Electronico',
                                hintStyle: const TextStyle(color: Colors.grey),
                              ),
                              validator: (value) =>
                                  value.isEmpty ? 'Requirido' : null,
                              onSaved: (value) => _email = value,
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
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Ingresa Tu Contraseña',
                                hintStyle: const TextStyle(color: Colors.grey),
                                suffix: InkWell(
                                  onTap: _togglePasswordView,
                                  child: const Icon(
                                    Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              obscureText: _isHidden,
                              validator: (value) {
                                _confirmpass = value;
                                if (value.isEmpty) {
                                  return "Requerido";
                                } else if (value.length < 8) {
                                  return "La contraseña debe ser mayor a 8 letras";
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) => _password = value,
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
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Verifica Tu Contraseña',
                                hintStyle: const TextStyle(color: Colors.grey),
                                suffix: InkWell(
                                  onTap: _togglePasswordView,
                                  child: const Icon(
                                    Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              obscureText: _isHidden,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Requerido";
                                } else if (value.length < 8) {
                                  return "La contraseña debe ser mayor a 8 letras";
                                } else if (value != _confirmpass) {
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
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Ingresa Tu Nombre',
                                hintStyle: const TextStyle(color: Colors.grey),
                              ),
                              validator: (value) =>
                                  value.isEmpty ? 'Requirido' : null,
                              onSaved: (value) => _name = value,
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
                            value: _state,
                            onChanged: (newValue) {
                              setState(() {
                                _state = newValue;
                              });
                            },
                            items: _states.map((location) {
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
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Escoje Tu Municipio',
                                hintStyle: const TextStyle(color: Colors.grey),
                              ),
                              validator: (value) =>
                                  value.isEmpty ? 'Requirido' : null,
                              onSaved: (value) => _municipality = value,
                            ),
                          )
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
                            value: _bloodType,
                            onChanged: (newValue) {
                              setState(() {
                                _bloodType = newValue;
                              });
                            },
                            items: _bloodTypes.map((location) {
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
                                      offset: Offset(15.0, 0.0),
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
                                              auth.createUserAndLogIn(
                                                  context,
                                                  validateAndSave(),
                                                  _email,
                                                  _password,
                                                  _name,
                                                  _state,
                                                  _municipality,
                                                  _bloodType);
                                              _showRegistrationDialog();
                                            }),
                                      ),
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  auth.createUserAndLogIn(
                                      context,
                                      validateAndSave(),
                                      _email,
                                      _password,
                                      _name,
                                      _state,
                                      _municipality,
                                      _bloodType);
                                  _showRegistrationDialog();
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
                                  "¿Ya Tienes Cuenta?",
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
        ));
  }
}
