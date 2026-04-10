import 'package:fit_eat/features/auth_page/model/app_user.dart';
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
      context.read<AuthViewmodel>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthViewmodel, AuthState>(
      listenWhen: (previous, current) =>
          previous.user != current.user ||
          previous.isLoading != current.isLoading,
      listener: (context, state) {
        if (state.isLoading) return;
        if (state.status == AuthStatus.unauthenticated ||
            state.status == AuthStatus.initial) {
          context.go('/signUp');
        } else {
          context.go('/home');
        }
      },
      child: const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
