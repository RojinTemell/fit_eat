import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth_page/viewmodel/auth_viewmodel.dart';

/// V0.1: Splash bootstrap'i tetikler ve spinner gösterir.
/// Navigation BURADA YOK — `auth_redirect.dart` AuthInitial→/splash pin'i
/// ve bootstrap sonrası state'e göre yönlendirmeyi yapar. Splash sadece
/// "bootstrap çalışıyor" görsel temsili.
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
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
