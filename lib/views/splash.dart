import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solucion/providers/auth_provider.dart';
import 'package:solucion/providers/db_provider.dart';
import 'package:solucion/components/alert.dart';
import 'package:solucion/components/loading.dart';
import 'dart:async';

class SplashScreenPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _authState = watch(authStateProvider);
    final _auth = watch(authServicesProvider);
    final _db = watch(dbServicesProvider);
    return _authState.when(
      data: (value) {
        if (value != null) {
          _db.getUser(value.uid);
          _db.getStates();
          _db.getMunicipalities();
          _auth.deleteAppDir();
          _auth.deleteCacheDir();
          Future.delayed(Duration(seconds: 10), () {
            Navigator.popAndPushNamed(context, '/Home');
          });
          return loading();
        }
        _db.getStates();
        _db.getMunicipalities();
        Future.delayed(Duration(seconds: 10), () {
          Navigator.popAndPushNamed(context, '/Login');
        });
        return loading();
      },
      loading: () => loading(),
      error: (error, __) => showErrorDialog(context, error),
    );
  }
}
