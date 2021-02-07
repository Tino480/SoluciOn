import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solucion/globals.dart' as globals;

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

enum FormType { login, register }

class _SignUpState extends State<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _forKey = GlobalKey<FormState>();

  String _email;
  String _password;
  String _name;
  String _lastName;
  List<String> _states = [
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
  String _city;
  List<String> _bloodTypes = ['O-', 'O+', 'A-', 'A+', 'B-', 'B+', 'AB-', 'AB+'];
  String _bloodType;

  bool validateAndSave() {
    final form = _forKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void valadateAndSave() async {
    if (validateAndSave()) {
      try {
        UserCredential result = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        User user = result.user;
        FirebaseFirestore.instance.collection('Users').doc().set({
          'User': user.uid,
          'Email': _email,
          'First': _name,
          'Last': _lastName,
          'State': _state,
          'City': _city,
          'Blood Type': _bloodType,
        });
        globals.getData();
        Navigator.popAndPushNamed(context, '/Home');
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  void login() async {
    Navigator.popAndPushNamed(context, '/Login');
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _forKey,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ClipPath(
                    clipper: MyClipper(),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/logo_solucion.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(top: 50.0, bottom: 100.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Salva Una Vida Con",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                          Text(
                            "SoluciOn",
                            style: TextStyle(
                                fontSize: 50.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: Text(
                      "Correo Electronico",
                      style: TextStyle(color: Colors.red, fontSize: 16.0),
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
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15.0),
                          child: Icon(
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
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Ingresa Tu Correo Electronico',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                            validator: (value) =>
                                value.isEmpty ? 'Requirido' : null,
                            onSaved: (value) => _email = value,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: Text(
                      "Contraseña",
                      style: TextStyle(color: Colors.red, fontSize: 16.0),
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
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15.0),
                          child: Icon(
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
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                            obscureText: true,
                            validator: (value) =>
                                value.isEmpty ? 'Requirido' : null,
                            onSaved: (value) => _password = value,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: Text(
                      "Nombre",
                      style: TextStyle(color: Colors.red, fontSize: 16.0),
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
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15.0),
                          child: Icon(
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
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Ingresa Tu Nombre',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                            validator: (value) =>
                                value.isEmpty ? 'Requirido' : null,
                            onSaved: (value) => _name = value,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: Text(
                      "Apellido",
                      style: TextStyle(color: Colors.red, fontSize: 16.0),
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
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15.0),
                          child: Icon(
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
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Ingresa Tu Apellido',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                            validator: (value) =>
                                value.isEmpty ? 'Requirido' : null,
                            onSaved: (value) => _lastName = value,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: Text(
                      "Estado",
                      style: TextStyle(color: Colors.red, fontSize: 16.0),
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
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15.0),
                          child: Icon(
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
                            child: DropdownButton(
                          hint: Text('Ingressa Tu Estado'),
                          value: _state,
                          onChanged: (newValue) {
                            setState(() {
                              _state = newValue;
                            });
                          },
                          items: _states.map((location) {
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
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: Text(
                      "Ciudad",
                      style: TextStyle(color: Colors.red, fontSize: 16.0),
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
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15.0),
                          child: Icon(
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
                              hintText: 'Ingresa Tu Ciudad',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                            validator: (value) =>
                                value.isEmpty ? 'Requirido' : null,
                            onSaved: (value) => _city = value,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: Text(
                      "Tipo De Sangre",
                      style: TextStyle(color: Colors.red, fontSize: 16.0),
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
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15.0),
                          child: Icon(
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
                          hint: Text('Escoje Tu Tipo De Sangre'),
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
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Text(
                                    "Registrarme",
                                    style: TextStyle(
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
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.black,
                                      ),
                                      onPressed: valadateAndSave,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onPressed: valadateAndSave,
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
                              child: Text(
                                "¿Ya Tienes Cuenta?",
                                style: TextStyle(
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
        ));
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path p = Path();
    p.lineTo(size.width, 0.0);
    p.lineTo(size.width, size.height * 0.85);
    p.arcToPoint(
      Offset(0.0, size.height * 0.85),
      radius: const Radius.elliptical(50.0, 10.0),
      rotation: 0.0,
    );
    p.lineTo(0.0, 0.0);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
