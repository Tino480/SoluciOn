import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solucion/providers/db_provider.dart';
import 'package:solucion/providers/auth_provider.dart';
import 'package:solucion/providers/home_page_providers.dart';
import 'package:solucion/providers/signup_page_providers.dart';
import 'package:solucion/components/drawer.dart';
import 'package:solucion/components/alert.dart';

class HomePage extends ConsumerWidget {
  void updateSwitch(BuildContext context, bool value) {
    context.read(donerSwitchProvider).state = value;
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final isSwitched = watch(donerSwitchProvider).state;
    final _db = watch(dbServicesProvider);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            Switch(
              value: isSwitched,
              onChanged: (value) {
                updateSwitch(context, value);
                context.refresh(cardStreamProvider);
                context.refresh(requestsStreamProvider);
              },
              activeColor: Colors.white,
            ),
            Expanded(
              child: (isSwitched != false)
                  ? Center(child: Text('Donador'))
                  : Center(child: Text('Solicitante')),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: <Widget>[
          Consumer(builder: (context, watch, child) {
            final _auth = watch(authServicesProvider);
            return Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: GestureDetector(
                    child: const Icon(Icons.exit_to_app, size: 30.0),
                    onTap: () {
                      _auth.signOut(context);
                    },
                  ),
                ),
              ],
            );
          }),
        ],
      ),
      drawer: MyDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          image: const DecorationImage(
            image: const AssetImage("assets/logo.jpeg"),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Consumer(builder: (context, watch, child) {
          final cards = watch(cardStreamProvider);
          final requests = watch(requestsStreamProvider);
          return (isSwitched != false)
              ? cards.when(
                  data: (card) => ListView.builder(
                      itemCount: card.length,
                      itemBuilder: (BuildContext context, int index) {
                        final name = card[index]['Description'];
                        final municipality = card[index]['Municipality'];
                        final toUid = card[index]['User'];
                        return Card(
                          color: Colors.transparent,
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(name),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  municipality,
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                ),
                              ),
                              ButtonBar(
                                alignment: MainAxisAlignment.start,
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      shadowColor: Colors.red,
                                      textStyle: TextStyle(color: Colors.black),
                                    ),
                                    onPressed: () {
                                      _db.setAndCreateCombined(toUid, name);
                                      CircularProgressIndicator();
                                      Future.delayed(Duration(seconds: 2), () {
                                        context.refresh(cardStreamProvider);
                                        context.refresh(chatStreamProvider);
                                        Navigator.pushNamed(context, '/Chat');
                                      });
                                    },
                                    child: const Text('Chat'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                  loading: () => Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, __) => showErrorDialog(context, error),
                )
              : requests.when(
                  data: (request) => ListView.builder(
                      itemCount: request.length,
                      itemBuilder: (BuildContext context, int index) {
                        final name = request[index]['Description'];
                        final municipality = request[index]['Municipality'];
                        final toUid = request[index]['User'];
                        return Card(
                          color: Colors.transparent,
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(name),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  municipality,
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                  loading: () => Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, __) => showErrorDialog(context, error),
                );
        }),
      ),
      floatingActionButton: (isSwitched != false)
          ? null
          : FloatingActionButton(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      bool isUser = false;
                      String blood;
                      String description;
                      return AlertDialog(
                        scrollable: true,
                        title: Text("Solicitud Para Donacion"),
                        content: StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Row(children: [
                                  Text("La solicitud is para mi?"),
                                  Switch(
                                      value: isUser,
                                      onChanged: (value) {
                                        setState(() => isUser = value);
                                      }),
                                  (isUser != false) ? Text('Si') : Text('No'),
                                ]),
                                const Padding(
                                  padding: const EdgeInsets.only(left: 0.0),
                                  child: const Text(
                                    "Descripcion",
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
                                            hintStyle: const TextStyle(
                                                color: Colors.grey),
                                          ),
                                          onChanged: (value) =>
                                              description = value,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                (isUser != false)
                                    ? Container()
                                    : Column(
                                        children: [
                                          const Padding(
                                            padding: const EdgeInsets.only(
                                                left: 0.0),
                                            child: const Text(
                                              "Tipo De Sangre",
                                              style: const TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 16.0),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 20.0),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  height: 30.0,
                                                  width: 1.0,
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  margin: const EdgeInsets.only(
                                                      left: 00.0, right: 10.0),
                                                ),
                                                Expanded(
                                                    child: DropdownButton(
                                                  value: blood,
                                                  onChanged: (value) {
                                                    setState(
                                                        () => blood = value);
                                                  },
                                                  items: bloodTypes
                                                      .map((location) {
                                                    return DropdownMenuItem(
                                                      child: Text(location,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red)),
                                                      value: location,
                                                    );
                                                  }).toList(),
                                                ))
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                Container(
                                  margin: const EdgeInsets.only(top: 20.0),
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 20.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: TextButton(
                                            style: TextButton.styleFrom(
                                              shadowColor: Colors.red,
                                              backgroundColor: Colors.red,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                              ),
                                            ),
                                            child: Row(
                                              children: <Widget>[
                                                const Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20.0),
                                                  child: const Text(
                                                    "Solicitar",
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
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: TextButton(
                                                        style: TextButton
                                                            .styleFrom(
                                                          shadowColor:
                                                              Colors.white,
                                                          backgroundColor:
                                                              Colors.white,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        28.0),
                                                          ),
                                                        ),
                                                        child: const Icon(
                                                          Icons.check,
                                                          color: Colors.black,
                                                        ),
                                                        onPressed: () => {
                                                              _db.makeBloodRequest(
                                                                  blood,
                                                                  description),
                                                              Navigator.pop(
                                                                  context)
                                                            }),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            onPressed: () => {
                                                  _db.makeBloodRequest(
                                                      blood, description),
                                                  Navigator.pop(context)
                                                }),
                                      ),
                                    ],
                                  ),
                                ),
                              ]);
                        }),
                      );
                    });
              },
              child: Icon(Icons.add),
            ),
    );
  }
}
