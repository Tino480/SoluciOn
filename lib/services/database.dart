import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solucion/models/user.dart';
import 'package:solucion/providers/signup_page_providers.dart' as sign;

class DatabaseService {
  final FirebaseFirestore _firebaseDb;
  DatabaseService(this._firebaseDb);

  Future<void> createUser(
      {String uid,
      String name,
      String state,
      String municipality,
      String bloodType,
      List<String> compatibleBloodTypes}) async {
    await _firebaseDb.collection('Users').doc(uid).set({
      'User': uid,
      'Name': name,
      'State': state,
      'Municipality': municipality,
      'Blood Type': bloodType,
      'Compatible Blood Types': compatibleBloodTypes
    });
    user = MyUser(
        name: name,
        uid: uid,
        municipality: municipality,
        state: state,
        bloodtype: bloodType,
        compatiblebloodtypes: compatibleBloodTypes);
  }

  getUser(String uid) async {
    await _firebaseDb
        .collection('Users')
        .where('User', isEqualTo: uid)
        .get()
        .then((val) {
      if (val.docs.length > 0) {
        user = MyUser(
            name: val.docs[0]["Name"],
            uid: val.docs[0]["User"],
            municipality: val.docs[0]["Municipality"],
            state: val.docs[0]["State"],
            bloodtype: val.docs[0]["Blood Type"],
            compatiblebloodtypes: val.docs[0]["Compatible Blood Types"]);
      }
    });
    getContacts();
  }

  getStates() async {
    await _firebaseDb
        .collection('States')
        .doc('states_doc')
        .get()
        .then((value) {
      if (value.exists) {
        sign.newStates = value.data()['States List'];
      }
    });
  }

  getMunicipalities() async {
    await _firebaseDb
        .collection('Municipalities')
        .doc('municipalities_doc')
        .get()
        .then((value) {
      if (value.exists) {
        sign.newM = value.data()['municipalities_map'];
      }
    });
  }

  getcards() async {
    await getContacts();
    List cards = [];
    await _firebaseDb
        .collection('Users')
        .where('Blood Type', whereIn: user.compatiblebloodtypes)
        .where('State', isEqualTo: user.state)
        .get()
        .then((value) {
      if (value.docs.length > 0) {
        for (var doc in value.docs) {
          if (!user.contacts.contains(doc.data()['User'])) {
            cards.add(doc.data());
          }
        }
      }
    });
    return cards;
  }

  getchats() async {
    List chats = [];
    await _firebaseDb
        .collection('Chats')
        .doc(user.uid)
        .collection('User Chats')
        .get()
        .then((value) {
      if (value.docs.length > 0) {
        for (var doc in value.docs) {
          chats.add(doc.data());
        }
      }
    });
    return chats;
  }

  getContacts() async {
    if (user.contacts != null) {
      user.contacts.clear();
      String uid = user.uid;
      user.contacts.add(uid);
      await _firebaseDb.collection('Chats/$uid/User Chats').get().then((val) {
        if (val.docs.length > 0) {
          for (var doc in val.docs) {
            user.contacts.add(doc.data()['contact uid']);
          }
        }
      });
    } else {
      user.contacts = ['default'];
      getContacts();
    }
  }

  setAndCreateCombined(toUid, toUserName) async {
    String uid = user.uid;
    var combined;
    var firstUid = uid.codeUnits;
    var secondUid = toUid.toString().codeUnits;
    if (firstUid.reduce((value, element) => value + element) >
        secondUid.reduce((value, element) => value + element)) {
      combined = uid + toUid;
    } else {
      combined = toUid + uid;
    }
    await _firebaseDb.doc('Chats/$uid/User Chats/$combined').set({
      'Combined Uid': combined,
      'contact': toUserName,
      'contact uid': toUid
    });
    await _firebaseDb.doc('Chats/$toUid/User Chats/$combined').set(
        {'Combined Uid': combined, 'contact': user.name, 'contact uid': uid});
    user.combined = combined;
  }

  sendMessage(text) async {
    await _firebaseDb.collection('Messages').add({
      'text': text,
      'from': user.name,
      'combined uid': user.combined,
      'date': DateTime.now().toIso8601String().toString(),
    });
  }

  getMessages() {
    return _firebaseDb
        .collection('Messages')
        .orderBy('date')
        .where('combined uid', isEqualTo: user.combined)
        .snapshots();
  }

  deleteConversation(toUid, combined) async {
    String uid = user.uid;
    WriteBatch batch = _firebaseDb.batch();
    batch.delete(_firebaseDb.doc('Chats/$uid/User Chats/$combined'));
    batch.delete(_firebaseDb.doc('Chats/$toUid/User Chats/$combined'));
    await _firebaseDb
        .collection('Messages')
        .where('combined uid', isEqualTo: combined)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((document) {
        batch.delete(document.reference);
      });
    });
    batch.commit();
  }
}
