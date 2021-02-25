import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solucion/providers/db_provider.dart';
import 'package:solucion/providers/auth_provider.dart';
import 'package:solucion/components/drawer.dart';
import 'package:solucion/components/alert.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SoluciOn'),
        centerTitle: true,
        actions: <Widget>[
          Consumer(builder: (context, watch, child) {
            final _auth = watch(authServicesProvider);
            return Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
            image: const AssetImage("assets/logo_solucion.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Consumer(builder: (context, watch, child) {
          final cards = watch(cardStreamProvider);
          final _db = watch(dbServicesProvider);
          return cards.when(
            data: (card) => ListView.builder(
                itemCount: card.length,
                itemBuilder: (BuildContext context, int index) {
                  final name = card[index]['Name'];
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
                            FlatButton(
                              textColor: Colors.black,
                              splashColor: Colors.red,
                              onPressed: () {
                                _db.setAndCreateCombined(toUid, name);
                                CircularProgressIndicator();
                                Future.delayed(Duration(seconds: 2), () {
                                  context.refresh(cardStreamProvider);
                                  Navigator.popAndPushNamed(context, '/Chat');
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
          );
        }),
      ),
    );
  }
}
