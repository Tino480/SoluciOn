import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

loading() {
  return SafeArea(
    child: Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: HexColor('#e30713'),
              image: const DecorationImage(
                image: const AssetImage("assets/logo.jpeg"),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    const CircularProgressIndicator(),
                    const Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                    ),
                    const Text(
                      "Unidos Por La Vida",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold),
                    ),
                    const Padding(
                      padding: const EdgeInsets.only(bottom: 40.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
