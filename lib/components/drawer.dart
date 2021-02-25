import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solucion/providers/db_provider.dart';
import 'package:solucion/models/user.dart' as UserModel;
import 'package:solucion/components/alert.dart';

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
                child: const Text(
                  'Conversaciones',
                  style: const TextStyle(color: Colors.white, fontSize: 30),
                ),
                decoration: BoxDecoration(color: Colors.red),
              ),
            ),
            Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Consumer(builder: (context, watch, child) {
                final chats = watch(chatStreamProvider);
                final _db = watch(dbServicesProvider);
                return chats.when(
                  data: (chat) => ListView.builder(
                      shrinkWrap: true,
                      itemCount: chat.length,
                      itemBuilder: (BuildContext context, int index) {
                        String contact = chat[index]['contact'];
                        String combined = chat[index]['Combined Uid'];
                        String toUid = chat[index]['contact uid'];
                        return Column(children: <Widget>[
                          ListTile(
                            title: Text('$contact'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_forever),
                              onPressed: () {
                                _db.deleteConversation(
                                    UserModel.uid, toUid, combined);
                                Future.delayed(Duration(seconds: 2), () {
                                  context.refresh(chatStreamProvider);
                                  context.refresh(cardStreamProvider);
                                });
                              },
                            ),
                            onTap: () {
                              UserModel.combined = combined;
                              Navigator.of(context).pushNamed('/Chat');
                            },
                          ),
                          Divider(
                            color: Colors.red,
                            thickness: 5,
                            height: 5,
                          )
                        ]);
                      }),
                  loading: () => Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, __) => showErrorDialog(context, error),
                );
              }),
            ),
          ])),
    );
  }
}
