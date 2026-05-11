import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../auth_page/state/auth_state.dart';
import '../../auth_page/viewmodel/auth_viewmodel.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthViewmodel>().bootstrap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthViewmodel, AuthState>(
      listenWhen: (previous, current) => current is! AuthInitial,
      listener: (context, state) {
        print("Auth State Changed: $state ");
        switch (state) {
          case AuthAnonymous() || AuthAuthenticated():
            context.go('/home');
          case AuthUnauthenticated():
            context.go('/login');
          case AuthOtpPending():
            context.go('/verificationCode');
          case AuthInitial():
            break; // bekle
        }
      },
      child: const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
