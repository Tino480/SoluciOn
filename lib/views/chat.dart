import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solucion/providers/db_provider.dart';
import 'package:solucion/components/drawer.dart';
import 'package:solucion/models/user.dart';
import 'package:solucion/components/message.dart';
import 'package:solucion/components/send_button.dart';

class ChatPage extends ConsumerWidget {
  var db;
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  Future<void> callback() async {
    if (messageController.text.length > 0) {
      await db.sendMessage(messageController.text);
      messageController.clear();
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _db = watch(dbServicesProvider);
    db = _db;
    return Scaffold(
      appBar: AppBar(
        title: const Text("RedBlood Chat"),
        centerTitle: true,
        actions: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: GestureDetector(
                  child: const Icon(Icons.home, size: 30.0),
                  onTap: () {
                    Navigator.of(context).pushNamed('/Home');
                  },
                ),
              )
            ],
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<dynamic>(
                stream: _db.getMessages(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: const CircularProgressIndicator(),
                    );

                  List<dynamic> docs = snapshot.data.docs;

                  List<Widget> messages = docs
                      .map((doc) => Message(
                            from: doc['from'],
                            text: doc['text'],
                            me: user.name == doc['from'],
                          ))
                      .toList();

                  return ListView(
                    controller: scrollController,
                    children: <Widget>[
                      ...messages,
                    ],
                  );
                },
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onSubmitted: (value) => callback(),
                      decoration: const InputDecoration(
                        hintText: "Escribe tu Mensaje...",
                        border: const OutlineInputBorder(),
                      ),
                      controller: messageController,
                    ),
                  ),
                  SendButton(
                    text: "Enviar",
                    callback: callback,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
