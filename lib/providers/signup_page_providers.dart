import 'package:flutter_riverpod/flutter_riverpod.dart';

final nameProvider = StateProvider<String>((ref) {
  return null;
});

var newStates;

var newM;

final stateProvider = StateProvider<String>((ref) {
  return null;
});

final statesProvider = StateProvider<List>((ref) {
  return newStates;
});

final municipalityProvider = StateProvider<String>((ref) {
  return null;
});

final municipalitiesProvider = StateProvider<Map>((ref) {
  return newM;
});

final bloodTypeProvider = StateProvider<String>((ref) {
  return null;
});

const List<String> bloodTypes = [
  'O-',
  'O+',
  'A-',
  'A+',
  'B-',
  'B+',
  'AB-',
  'AB+'
];

const compatibleBloodTypes = <String, List<String>>{
  'O-': ['O-'],
  'O+': ['O-', 'O+'],
  'A-': ['A-', 'O-'],
  'A+': ['A+', 'A-', 'O+', 'O-'],
  'B-': ['B-', 'O-'],
  'B+': ['B+', 'B-', 'O+', 'O-'],
  'AB-': ['AB-', 'A-', 'B-', 'O-'],
  'AB+': ['O-', 'O+', 'A-', 'A+', 'B-', 'B+', 'AB-', 'AB+'],
};
