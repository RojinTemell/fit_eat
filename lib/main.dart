import 'package:fit_eat/features/auth_page/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/init/get_providers.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/custom_themes/scroll_behavior.dart';
import 'core/theme/theme_mode.dart';
import 'product/product_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  await GoogleSignIn.instance.initialize(
    serverClientId: dotenv.env['GOOGLE_SERVER_CLIENT_ID'],
  );

  ProductContainer.instance.setup();

  // Router AuthViewmodel'i inject ediyor — redirect ve refreshListenable
  // bu instance üzerinden state'i okuyacak. AuthViewmodel GetIt'te lazy
  // singleton olduğu için aşağıdaki get() ile MultiBlocProvider'ın
  // okuduğu aynı instance dönüyor.
  final appRouter = AppRouter.create(
    ProductContainer.instance.get<AuthViewmodel>(),
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider()..loadThemeMode(),
      child: MyApp(router: appRouter),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeProvider>().themeMode;

    return MultiBlocProvider(
      providers: AppProviders.getProviders(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'FitEat',
        scrollBehavior: constScrollBehavior,
        routerConfig: router,
        theme: AppTheme.lightTheme(context),
        darkTheme: AppTheme.darkTheme(context),
        themeMode: themeMode,
      ),
    );
  }
}
