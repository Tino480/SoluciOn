import 'package:flutter_riverpod/flutter_riverpod.dart';

final solicitingProvider = StateProvider<bool>((ref) {
  return true;
});

final donatingProvider = StateProvider<bool>((ref) {
  return false;
});

final profileProvider = StateProvider<bool>((ref) {
  return false;
});

final messagingProvider = StateProvider<bool>((ref) {
  return false;
});

final requirmentsProvider = StateProvider<bool>((ref) {
  return false;
});

final selectedIndexProvider = StateProvider<int>((ref) {
  return 0;
});
