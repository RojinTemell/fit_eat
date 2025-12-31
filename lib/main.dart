import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'core/cubits/bottom_sheet.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_mode.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider()..loadThemeMode(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => BottomSheetBloc())],
      child: MaterialApp.router(
        title: 'Flutter Demo',
        scrollBehavior: MaterialScrollBehavior().copyWith(
          physics: const BouncingScrollPhysics(),
        ),
        routerConfig: AppRouter.appRouter,
        theme: AppTheme.lightTheme(context),
        darkTheme: AppTheme.darkTheme(context),
        themeMode: themeProvider.themeMode,
      ),
    );
  }
}
