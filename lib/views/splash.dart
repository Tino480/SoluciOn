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
    final _db = watch(dbServicesProvider);
    return _authState.when(
      data: (value) {
        _db.getStates();
        _db.getMunicipalities();
        if (value != null) {
          _db.getUser(value.uid);

          Future.delayed(Duration(seconds: 10), () {
            Navigator.popAndPushNamed(context, '/Home');
          });
          return loading();
        }
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
