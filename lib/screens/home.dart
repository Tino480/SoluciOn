import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:solucion/models/globals.dart' as globals;
import 'package:solucion/components/drawer.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.popAndPushNamed(context, '/Splash');
  }

  var filtered = List();
  var bloodCompatability = <String, List>{
    'O-': ['O-'],
    'O+': ['O-', 'O+'],
    'A-': ['A-', 'O-'],
    'A+': ['A+', 'A-', 'O+', 'O-'],
    'B-': ['B-', 'O-'],
    'B+': ['B+', 'B-', 'O+', 'O-'],
    'AB-': ['AB-', 'A-', 'B-', 'O-'],
    'AB+': ['O-', 'O+', 'A-', 'A+', 'B-', 'B+', 'AB-', 'AB+'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SoluciOn'),
        centerTitle: true,
        actions: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: GestureDetector(
                  child: Icon(Icons.exit_to_app, size: 30.0),
                  onTap: () {
                    _signOut();
                  },
                ),
              )
            ],
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/logo_solucion.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('Users').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                globals.getContacts();
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                for (int ctr = 0; ctr < snapshot.data.docs.length; ctr++) {
                  String user = snapshot.data.docs[ctr]['User'];
                  globals.getToData(user);
                  if (user == globals.uid) {
                  } else if (globals.userContacts.contains(user)) {
                  } else if (snapshot.data.docs[ctr]['State'] !=
                      globals.state) {
                  } else if (bloodCompatability[globals.bloodType]
                      .contains(snapshot.data.docs[ctr]['Blood Type'])) {
                    filtered.add(ctr);
                  }
                }
                return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (BuildContext context, int index) {
                      int newindex = filtered[index];
                      String first = snapshot.data.docs[newindex]['First'];
                      String city = snapshot.data.docs[newindex]['City'];
                      String last = snapshot.data.docs[newindex]['Last'];
                      String toUid = snapshot.data.docs[newindex]['User'];
                      return Card(
                        color: Colors.transparent,
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: [
                            ListTile(
                              title: Text('$first'),
                              subtitle: Text(
                                '$last',
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.6)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                '$city',
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.6)),
                              ),
                            ),
                            ButtonBar(
                              alignment: MainAxisAlignment.start,
                              children: [
                                FlatButton(
                                  textColor: Colors.black,
                                  splashColor: Colors.red,
                                  onPressed: () {
                                    globals.createChat(toUid);
                                    Navigator.of(context)
                                        .popAndPushNamed('/Chat');
                                  },
                                  child: const Text('Chat'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    });
              })),
    );
  }
}
