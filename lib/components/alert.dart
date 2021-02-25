import 'package:flutter/material.dart';

  showErrorDialog(context, error){
    return AlertDialog(
      title: const Text(
        'Error',
        style: const TextStyle(
            fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.red),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              'El Siguente error $error se a detectado',
              style: const TextStyle(fontSize: 15.0, color: Colors.red),
            ),
            const Text(
              'Por favor reinicie y intente de nuevo',
              style: const TextStyle(fontSize: 15.0, color: Colors.red),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          color: Colors.red,
          child: const Text(
            'Okey',
            style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          onPressed: () {
            Navigator.popAndPushNamed(context, '/Splash');
          },
        ),
      ],
    );
  }
