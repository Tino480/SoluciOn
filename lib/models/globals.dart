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
var userContacts = List();

getData(currentUser) async {
  final User user = currentUser;
  uid = user.uid;
  await FirebaseFirestore.instance
      .collection('Users')
      .where('User', isEqualTo: user.uid)
      .get()
      .then((val) {
    if (val.docs.length > 0) {
      state = val.docs[0]["State"];
      bloodType = val.docs[0]["Blood Type"];
      userName = val.docs[0]["First"] + ' ' + val.docs[0]["Last"];
    }
  });
}

getContacts() async {
  await FirebaseFirestore.instance
      .collection('Chats/$uid/User Chats')
      .get()
      .then((val) {
    if (val.docs.length > 0) {
      for (int ctr = 0; ctr < val.docs.length; ctr++) {
        userContacts.add(val.docs[ctr]['contact uid']);
      }
    }
  });
}

getToData(toUser) async {
  toUid = toUser;
  await FirebaseFirestore.instance
      .collection('Users')
      .where('User', isEqualTo: toUid)
      .get()
      .then((val) {
    if (val.docs.length > 0) {
      toUserName = val.docs[0]["First"] + ' ' + val.docs[0]["Last"];
    }
  });
}

createCombined() async {
  await FirebaseFirestore.instance.doc('Chats/$uid/User Chats/$combined').set(
      {'Combined Uid': combined, 'contact': toUserName, 'contact uid': toUid});
  await FirebaseFirestore.instance
      .doc('Chats/$toUid/User Chats/$combined')
      .set({'Combined Uid': combined, 'contact': userName, 'contact uid': uid});
}

setAndCreateCombined() async {
  var firstUid = uid.codeUnits;
  var secondUid = toUid.codeUnits;
  if (firstUid.reduce((value, element) => value + element) >
      secondUid.reduce((value, element) => value + element)) {
    combined = uid + toUid;
  } else {
    combined = toUid + uid;
  }
  await FirebaseFirestore.instance
      .doc('Chats/$uid/User Chats/$combined')
      .get()
      .then((doc) {
    if (doc.exists) {
    } else {
      createCombined();
    }
  });
}

checkIfOngoing() async {
  var firstUid = uid.codeUnits;
  var secondUid = toUid.codeUnits;
  if (firstUid.reduce((value, element) => value + element) >
      secondUid.reduce((value, element) => value + element)) {
    combined = uid + toUid;
  } else {
    combined = toUid + uid;
  }
  await FirebaseFirestore.instance
      .doc('Chats/$uid/User Chats/$combined')
      .get()
      .then((doc) {
    if (doc.exists) {
      return true;
    } else {
      return false;
    }
  });
}

batchDelete() async {
  WriteBatch batch = FirebaseFirestore.instance.batch();
  await FirebaseFirestore.instance
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
  await FirebaseFirestore.instance
      .doc('Chats/$uid/User Chats/$combined')
      .delete();
  await FirebaseFirestore.instance
      .doc('Chats/$toUid/User Chats/$combined')
      .delete();
  batchDelete();
}

createChat(toUser) async {
  await getToData(toUser);
  await setAndCreateCombined();
}
