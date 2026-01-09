import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../auth_page/service/auth_service.dart';
import '../viewmodel/splash_viewmodel.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashViewmodel(AuthService()),
      child: BlocListener<SplashViewmodel, bool>(
        listener: (context, isReady) {
          if (isReady) {
            context.go('/home');
          }
        },
        child: const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
    );
  }
}
