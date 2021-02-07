import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solucion/models/globals.dart' as globals;

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
          decoration: BoxDecoration(color: Colors.red),
          child: ListView(shrinkWrap: true, children: <Widget>[
            Container(
              height: 80,
              child: DrawerHeader(
                child: Text(
                  'Conversaciones',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                decoration: BoxDecoration(color: Colors.red),
              ),
            ),
            Container(
                decoration: BoxDecoration(color: Colors.white),
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Chats')
                        .doc(globals.uid)
                        .collection('User Chats')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            String contact =
                                snapshot.data.docs[index]['contact'];
                            String toUid =
                                snapshot.data.docs[index]['contact uid'];
                            return Column(children: <Widget>[
                              ListTile(
                                title: Text('$contact'),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete_forever),
                                  onPressed: () {
                                    globals.toUid = toUid;
                                    globals.getToData();
                                    globals.checkCombined();
                                    globals.deleteConversation();
                                  },
                                ),
                                onTap: () {
                                  globals.toUid = toUid;
                                  globals.getToData();
                                  globals.checkCombined();
                                  Navigator.of(context).pushNamed('/Chat');
                                },
                              ),
                              Divider(
                                color: Colors.red,
                                thickness: 5,
                                height: 5,
                              )
                            ]);
                          });
                    }))
          ])),
    );
  }
}
