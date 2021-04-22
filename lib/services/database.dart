import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solucion/models/user.dart';
import 'package:solucion/providers/signup_page_providers.dart' as sign;
import 'package:solucion/providers/db_provider.dart';

class DatabaseService {
  final FirebaseFirestore _firebaseDb;
  DatabaseService(this._firebaseDb);

  Future<void> createUser(
      {String uid,
      String name,
      String userName,
      int phoneNumber,
      String email,
      String state,
      String municipality,
      String bloodType,
      List<String> compatibleBloodTypes}) async {
    await _firebaseDb.collection('Users').doc(uid).set({
      'User': uid,
      'Name': name,
      'User Name': userName,
      'Phone Number': phoneNumber,
      'Email': email,
      'State': state,
      'Municipality': municipality,
      'Blood Type': bloodType,
      'Compatible Blood Types': compatibleBloodTypes
    });
    user = MyUser(
        name: name,
        userName: userName,
        phoneNumber: phoneNumber,
        email: email,
        uid: uid,
        municipality: municipality,
        state: state,
        bloodtype: bloodType,
        compatiblebloodtypes: compatibleBloodTypes);
  }

  getUser(String uid) async {
    await _firebaseDb.collection('Users').doc(uid).get().then((val) {
      if (val.exists) {
        user = MyUser(
            name: val.data()["Name"],
            userName: val.data()["User Name"],
            phoneNumber: val.data()["Phone Number"],
            email: val.data()["Email"],
            uid: val.data()["User"],
            municipality: val.data()["Municipality"],
            state: val.data()["State"],
            bloodtype: val.data()["Blood Type"],
            compatiblebloodtypes: val.data()["Compatible Blood Types"]);
      }
    });
    getContacts();
  }

  updateFirebaseUser() async {
    await _firebaseDb.collection('Users').doc(user.uid).update({
      'User Name': user.userName,
      'Phone Number': user.phoneNumber,
      'State': user.state,
      'Municipality': user.municipality,
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
    List cards = [];
    await _firebaseDb
        .collection('Requests')
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
    if (cards.length == 0) {
      cards.add({
        'Description':
            'Aquí aparecerán las solicitudes de otras personas a las que puede donar',
        'Municipality': '',
        'User': null
      });
    }
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
    await _firebaseDb.doc('Chats/$toUid/User Chats/$combined').set({
      'Combined Uid': combined,
      'contact': user.userName,
      'contact uid': uid
    });
    user.combined = combined;
  }

  sendMessage(text) async {
    await _firebaseDb.collection('Messages').add({
      'text': text,
      'from': user.userName,
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

  makeBloodRequest(bloodType, description, context) async {
    if (!sign.bloodTypes.contains(bloodType)) {
      await _firebaseDb.collection('Requests').add({
        'Description': description,
        'User': user.uid,
        'State': user.state,
        'Municipality': user.municipality,
        'Blood Type': user.bloodtype,
        'Name': user.userName,
        'Compatible Blood Types': user.compatiblebloodtypes,
        'Create Date': DateTime.now().toIso8601String().toString(),
      });
      context.refresh(requestsStreamProvider);
    } else {
      await _firebaseDb.collection('Requests').add({
        'Description': description,
        'User': user.uid,
        'State': user.state,
        'Municipality': user.municipality,
        'Blood Type': bloodType,
        'Name': user.userName,
        'Compatible Blood Types': sign.compatibleBloodTypes[bloodType],
        'Create Date': DateTime.now().toIso8601String().toString(),
      });
      context.refresh(requestsStreamProvider);
    }
  }

  getBloodRequest() async {
    await getContacts();
    List requests = [];
    await _firebaseDb
        .collection('Requests')
        .orderBy('Create Date')
        .where('User', isEqualTo: user.uid)
        .get()
        .then((value) {
      if (value.docs.length > 0) {
        for (var doc in value.docs) {
          requests.add(doc.data());
        }
      }
    });
    if (requests.length == 0) {
      requests.add({
        'Description': """Bienvenido!! aquí aparecerán todas sus solicitudes.
            \nPara solicitar sangre presione el botón + en la parte inferior""",
        'Municipality': '',
      });
    }
    return requests;
  }

  updateBloodRequest(date, description, blood, name, bloodType) async {
    String request;
    String des;
    String bl;
    if (description != null) {
      if (description != name) {
        des = description;
      } else {
        des = name;
      }
    } else {
      des = name;
    }
    if (blood != null) {
      if (blood != bloodType) {
        bl = blood;
      } else {
        bl = bloodType;
      }
    } else {
      bl = bloodType;
    }
    await _firebaseDb
        .collection('Requests')
        .where('User', isEqualTo: user.uid)
        .where('Create Date', isEqualTo: date)
        .get()
        .then((value) {
      if (value.docs.length > 0) {
        for (var doc in value.docs) {
          request = doc.id;
        }
      }
    });
    await _firebaseDb.collection('Requests').doc(request).update({
      'Description': des,
      'Blood Type': bl,
      'Compatible Blood Types': sign.compatibleBloodTypes[blood],
    });
  }

  deleteBloodRequest(date) async {
    String request;
    await _firebaseDb
        .collection('Requests')
        .where('User', isEqualTo: user.uid)
        .where('Create Date', isEqualTo: date)
        .get()
        .then((value) {
      if (value.docs.length > 0) {
        for (var doc in value.docs) {
          request = doc.id;
        }
      }
    });
    await _firebaseDb.collection('Requests').doc(request).delete();
  }
}
