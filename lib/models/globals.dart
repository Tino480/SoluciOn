library my_prj.globals;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String uid;
String userName;
String toUid;
String toUserName;
String state;
String bloodType;
String combined;

getData() async {
  final User user = FirebaseAuth.instance.currentUser;
  uid = user.uid;
  return await FirebaseFirestore.instance
      .collection('Users')
      .where('User', isEqualTo: uid)
      .get()
      .then((val) {
    if (val.docs.length > 0) {
      state = val.docs[0]["State"];
      bloodType = val.docs[0]["Blood Type"];
      userName = val.docs[0]["First"] + ' ' + val.docs[0]["Last"];
    } else {
      print("Not Found");
    }
  });
}

getToData() async {
  return await FirebaseFirestore.instance
      .collection('Users')
      .where('User', isEqualTo: toUid)
      .get()
      .then((val) {
    if (val.docs.length > 0) {
      toUserName = val.docs[0]["First"] + ' ' + val.docs[0]["Last"];
    } else {
      print("Not Found");
    }
  });
}

checkCombined() async {
  var firstUid = uid.codeUnits;
  var secondUid = toUid.codeUnits;
  if (firstUid.reduce((value, element) => value + element) >
      secondUid.reduce((value, element) => value + element)) {
    combined = uid + toUid;
  } else {
    combined = toUid + uid;
  }
  try {
    await FirebaseFirestore.instance
        .doc('Chats/$uid/User Chats/$combined')
        .get()
        .then((doc) {
      if (doc.exists) {
      } else {
        FirebaseFirestore.instance.doc('Chats/$uid/User Chats/$combined').set({
          'Combined Uid': combined,
          'contact': toUserName,
          'contact uid': toUid
        });
        FirebaseFirestore.instance
            .doc('Chats/$toUid/User Chats/$combined')
            .set({
          'Combined Uid': combined,
          'contact': userName,
          'contact uid': uid
        });
      }
    });
  } catch (e) {
    return false;
  }
}

checkIfOngoing(toid) async {
  var combinedUid;
  var firstUid = uid.codeUnits;
  var secondUid = toid.codeUnits;
  if (firstUid.reduce((value, element) => value + element) >
      secondUid.reduce((value, element) => value + element)) {
    combinedUid = uid + toid;
  } else {
    combinedUid = toid + uid;
  }
  try {
    await FirebaseFirestore.instance
        .doc('Chats/$uid/User Chats/$combinedUid')
        .get()
        .then((doc) {
      if (doc.exists) {
        print('Tino Doc Exists');
        return true;
      } else {
        print('Tino Doc does not exist');
        return false;
      }
    });
  } catch (e) {
    return false;
  }
}

Future<void> batchDelete() {
  WriteBatch batch = FirebaseFirestore.instance.batch();

  return FirebaseFirestore.instance
      .collection('messages')
      .where('combined uid', isEqualTo: combined)
      .get()
      .then((querySnapshot) {
    querySnapshot.docs.forEach((document) {
      batch.delete(document.reference);
    });

    return batch.commit();
  });
}

deleteConversation() async {
  try {
    await FirebaseFirestore.instance
        .doc('Chats/$uid/User Chats/$combined')
        .delete();
    await FirebaseFirestore.instance
        .doc('Chats/$toUid/User Chats/$combined')
        .delete();
    batchDelete();
  } catch (e) {
    return false;
  }
}
