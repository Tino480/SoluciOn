import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solucion/services/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseDbProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final dbServicesProvider = Provider<DatabaseService>((ref) {
  return DatabaseService(ref.read(firebaseDbProvider));
});

final cardStreamProvider = StreamProvider.autoDispose((ref) {
  final database = ref.watch(dbServicesProvider);
  return database != null
      ? database.getcards().asStream()
      : const Stream.empty();
});

final chatStreamProvider = StreamProvider.autoDispose((ref) {
  final database = ref.watch(dbServicesProvider);
  return database != null
      ? database.getchats().asStream()
      : const Stream.empty();
});

final messagesStreamProvider = StreamProvider.autoDispose((ref) {
  final database = ref.watch(dbServicesProvider);
  return database != null
      ? database.getMessages().asStream()
      : const Stream.empty();
});
