import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../auth_page/model/app_user.dart';
import '../viewmodel/splash_viewmodel.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashViewmodel, AuthStatus>(
      listenWhen: (previous, current) =>
          previous != current, // Sadece durum değişirse tetiklenicek
      listener: (context, status) {
        print("heyy view $status");
        if (status == AuthStatus.anonymous ||
            status == AuthStatus.authenticated) {
          context.go('/signUp');
        } else if (status == AuthStatus.unauthenticated) {
          context.go('/home');
        }
      },
      child: const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
