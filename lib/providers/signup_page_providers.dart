import 'package:flutter_riverpod/flutter_riverpod.dart';

final nameProvider = StateProvider<String>((ref) {
  return null;
});

final userNameProvider = StateProvider<String>((ref) {
  return null;
});

final updateUserNameProvider = StateProvider<String>((ref) {
  return null;
});

final phoneNumberProvider = StateProvider<int>((ref) {
  return null;
});

final updatePhoneNumberProvider = StateProvider<int>((ref) {
  return null;
});

List<String> newStates = ['Durango'];

var newM = <String, List<String>>{
  'Durango': [
    'Canatlán',
    'Canelas',
    'Coneto de Comonfort',
    'Cuencamé',
    'Durango',
    'General Simón Bolívar',
    'Gómez Palacio',
    'Guadalupe Victoria',
    'Guanaceví',
    'Hidalgo',
    'Indé',
    'Lerdo',
    'Mapimí',
    'Mezquital',
    'Nazas',
    'Ocampo',
    'El Oro',
    'Pánuco de Coronado',
    'Peñón Blanco',
    'Poanas',
    'Pueblo Nuevo',
    'Rodeo',
    'San Bernardo',
    'San Dimas',
    'San Juan de Guadalupe',
    'San Juan del Río',
    'San Luis del Cordero',
    'San Pedro del Gallo',
    'Santa Clara',
    'Santiago Papasquiaro',
    'Súchil',
    'Tamazula',
    'Tepehuanes',
    'Tlahualilo',
    'Topia',
    'Vicente Guerrero',
    'Nuevo Ideal',
    'Nombre de Dios'
  ]
};

final stateProvider = StateProvider<String>((ref) {
  return null;
});

final updateStateProvider = StateProvider<String>((ref) {
  return null;
});

final statesProvider = StateProvider<List>((ref) {
  return newStates;
});

final municipalityProvider = StateProvider<String>((ref) {
  return null;
});

final updateMunicipalityProvider = StateProvider<String>((ref) {
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
