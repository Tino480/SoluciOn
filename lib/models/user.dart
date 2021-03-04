import 'package:flutter/foundation.dart';

class MyUser {
  final String name;
  final String uid;
  final String municipality;
  final String state;
  final String bloodtype;
  final List<dynamic> compatiblebloodtypes;
  String combined;
  List<String> contacts;

  MyUser(
      {@required this.name,
      @required this.uid,
      @required this.municipality,
      @required this.state,
      @required this.bloodtype,
      @required this.compatiblebloodtypes,
      this.combined = '',
      this.contacts}) {
    assert(name != null, 'Name is null');
    assert(uid != null, 'Uid is null');
    assert(municipality != null, 'Municipality is null');
    assert(state != null, 'State is null');
    assert(bloodtype != null, 'Bloodtype is null');
    assert(!(compatiblebloodtypes.contains(null)),
        'Compatible blood types element is null');
    assert(combined != null, 'Combined is null');
  }
}

MyUser user;
