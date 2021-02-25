import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solucion/models/user.dart' as UserModel;
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
      List compatibleBloodTypes}) async {
    await _firebaseDb.collection('Users').add({
      'User': uid,
      'Name': name,
      'State': state,
      'Municipality': municipality,
      'Blood Type': bloodType,
      'Compatible Blood Types': compatibleBloodTypes
    });
    UserModel.uid = uid;
    UserModel.name = name;
    UserModel.state = state;
    UserModel.municipality = municipality;
    UserModel.bloodtype = bloodType;
    UserModel.compatiblebloodtypes = compatibleBloodTypes;
  }

  getUser(String uid) async {
    await _firebaseDb
        .collection('Users')
        .where('User', isEqualTo: uid)
        .get()
        .then((val) {
      if (val.docs.length > 0) {
        UserModel.uid = val.docs[0]["User"];
        UserModel.name = val.docs[0]["Name"];
        UserModel.state = val.docs[0]["State"];
        UserModel.municipality = val.docs[0]["Municipality"];
        UserModel.bloodtype = val.docs[0]["Blood Type"];
        UserModel.compatiblebloodtypes =
            val.docs[0]["Compatible Blood Types"].toList();
      }
    });
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
    var cards = List();
    await _firebaseDb
        .collection('Users')
        .where('Blood Type', whereIn: UserModel.compatiblebloodtypes)
        .where('State', isEqualTo: UserModel.state)
        .get()
        .then((value) {
      if (value.docs.length > 0) {
        for (var doc in value.docs) {
          if (!UserModel.contacts.contains(doc.data()['User'])) {
            cards.add(doc.data());
          }
        }
      }
    });
    return cards;
  }

  getchats() async {
    var chats = List();
    await _firebaseDb
        .collection('Chats')
        .doc(UserModel.uid)
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
    UserModel.contacts.clear();
    String uid = UserModel.uid;
    UserModel.contacts.add(uid);
    await _firebaseDb.collection('Chats/$uid/User Chats').get().then((val) {
      if (val.docs.length > 0) {
        for (var doc in val.docs) {
          UserModel.contacts.add(doc.data()['contact uid']);
        }
      }
    });
  }

  setAndCreateCombined(toUid, toUserName) async {
    String uid = UserModel.uid.toString();
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
    await _firebaseDb.doc('Chats/$toUid/User Chats/$combined').set({
      'Combined Uid': combined,
      'contact': UserModel.name,
      'contact uid': uid
    });
    UserModel.combined = combined;
  }

  sendMessage(text) async {
    await _firebaseDb.collection('Messages').add({
      'text': text,
      'from': UserModel.name,
      'combined uid': UserModel.combined,
      'date': DateTime.now().toIso8601String().toString(),
    });
  }

  getMessages() async {
    var chats = List();
    await _firebaseDb
        .collection('Messages')
        .orderBy('date')
        .where('combined uid', isEqualTo: UserModel.combined)
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

  deleteConversation(uid, toUid, combined) async {
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
