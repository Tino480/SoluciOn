import 'package:flutter/material.dart';

loading() {
  return Scaffold(
    body: SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: const AssetImage("assets/logo.jpeg"),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // Expanded(
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: <Widget>[
              //       const Text(
              //         "Salva Una Vida Con",
              //         style: const TextStyle(
              //             color: Colors.red,
              //             fontSize: 30.0,
              //             fontWeight: FontWeight.bold),
              //       ),
              //     ],
              //   ),
              // ),
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
                          color: Colors.red,
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
