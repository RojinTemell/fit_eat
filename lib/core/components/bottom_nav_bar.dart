// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fit_eat/core/components/dialog.dart';
import 'package:fit_eat/features/auth_page/model/app_user.dart';
import 'package:fit_eat/features/auth_page/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../features/create_recipe_page/viewmodel/create_recipe_viewmodel.dart';
import '../constants/text_constants.dart';

final ValueNotifier<bool> showBottomBar = ValueNotifier(true);

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key, required this.shell});
  final StatefulNavigationShell shell;

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with SingleTickerProviderStateMixin {
  void resetNavigation() {
    Future.delayed(Duration(milliseconds: 50), () {
      if (mounted) {
        widget.shell.goBranch(0, initialLocation: true);
      }
    });
  }

  final List<BottomTabType> tabs = BottomTabType.values;
  int? lastTappedIndex;
  DateTime? lastTappedTime;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: Constant.fillWhite(context),
      bottomNavigationBar: ValueListenableBuilder<bool>(
        valueListenable: showBottomBar,
        builder: (context, value, _) {
          return value
              ? BottomNavigationBar(
                  backgroundColor: Constant.fillWhite(context),
                  selectedFontSize: 12,
                  unselectedFontSize: 12,
                  selectedItemColor: Constant.iconDark(context),
                  unselectedItemColor: Constant.iconDark(context),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  selectedLabelStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  type: BottomNavigationBarType.fixed,
                  onTap: (index) => _handleNavigation(context, index),
                  // onTap: (value) async {
                  //   final previousIndex = widget.shell.currentIndex;
                  //   final now = DateTime.now();

                  //   // CREATE RECIPE'DAN AYRILMA KONTROLÜ
                  //   if (previousIndex == 2 && value != 2) {
                  //     final viewModel = context.read<CreateRecipeViewModel>();

                  //     // Formda veri var mı kontrolü (State'deki hasData mantığına benzer)
                  //     final bool hasData =
                  //         viewModel.state.recipe.title?.isNotEmpty == true ||
                  //         (viewModel.state.recipe.ingredients?.isNotEmpty ??
                  //             false);

                  //     if (hasData) {
                  //       final bool? shouldSave = await AppPopup.show(
                  //         context: context,
                  //         type: AlertType.info,

                  //         title:
                  //             'Sekme değiştirmeden önce tarifinizi taslak olarak kaydetmek ister misiniz?',
                  //         message:
                  //             'it is help us translate  your voice to search within FitEat',
                  //       );

                  //       if (shouldSave == true) {
                  //         await viewModel.saveAsDraft();
                  //       } else if (shouldSave == false) {
                  //         viewModel.clearForm();
                  //         await viewModel.discardDraft();
                  //       }
                  //     }
                  //   }

                  //   // NAVİGASYON (GİTME İŞLEMİ)
                  //   if (lastTappedIndex == value &&
                  //       lastTappedTime != null &&
                  //       now.difference(lastTappedTime!) <
                  //           const Duration(milliseconds: 300)) {
                  //     widget.shell.goBranch(value, initialLocation: true);
                  //   } else {
                  //     widget.shell.goBranch(value);
                  //   }

                  //   // CREATE RECIPE'A GERİ DÖNÜNCE KONTROL ET
                  //   if (value == 2 && previousIndex != 2) {
                  //     WidgetsBinding.instance.addPostFrameCallback((_) {
                  //       if (mounted) {
                  //         context
                  //             .read<CreateRecipeViewModel>()
                  //             .checkAndLoadDraft();
                  //       }
                  //     });
                  //   }

                  //   lastTappedIndex = value;
                  //   lastTappedTime = now;
                  // },
                  currentIndex: widget.shell.currentIndex,
                  items: List.generate(
                    tabs.length,
                    (index) => tabItem(
                      tabs[index],
                      widget.shell.currentIndex == index,
                    ),
                  ),
                )
              : const SizedBox.shrink();
        },
      ),
      body: widget.shell,
    );
  }

  void _handleNavigation(BuildContext context, int index) async {
    final previousIndex = widget.shell.currentIndex;
    final targetTab = tabs[index];

    // 1. ADIM: Anonimlik Kontrolü (Create Recipe için)
    if (targetTab == BottomTabType.createRecipe) {
      final isAnonymous =
          _checkIfUserIsAnonymous(); // Bu metodu aşağıda tanımlayacağız
      if (isAnonymous) {
        _showAuthRequiredDialog(context);
        return; // İşlemi burada kes, navigasyon yapma
      }
    }

    // 2. ADIM: Create Recipe'dan Ayrılma Kontrolü (Taslak Kaydetme)
    if (previousIndex == 2 && index != 2) {
      await _handleDraftLeaving(context);
    }

    // 3. ADIM: Navigasyonu Gerçekleştir
    _performNavigation(index);

    // 4. ADIM: Create Recipe'a Giriş Kontrolü
    if (index == 2 && previousIndex != 2) {
      _checkDraftOnEntry(context);
    }
  }

  bool _checkIfUserIsAnonymous() {
    final status = context.read<AuthViewmodel>().state.status;
    if (status == AuthStatus.anonymous) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _showAuthRequiredDialog(BuildContext context) async {
    final bool shouldSave = await AppPopup.show(
      context: context,
      type: AlertType.info,
      title: 'Giriş Yapmalısın',
      message: 'Tarif oluşturmak için lütfen kayıt ol veya giriş yap.',
    );
    if (shouldSave) {
      context.go('/signUp');
    }
  }

  Future<void> _handleDraftLeaving(BuildContext context) async {
    final viewModel = context.read<CreateRecipeViewModel>();
    final bool hasData =
        viewModel.state.recipe.title?.isNotEmpty == true ||
        (viewModel.state.recipe.ingredients?.isNotEmpty ?? false);

    if (hasData) {
      final bool? shouldSave = await AppPopup.show(
        context: context,
        type: AlertType.info,
        title: 'Taslak Kaydedilsin mi?',
        message:
            'Sekme değiştirmeden önce tarifinizi taslak olarak kaydetmek ister misiniz?',
      );

      if (shouldSave == true) {
        await viewModel.saveAsDraft();
      } else if (shouldSave == false) {
        viewModel.clearForm();
        await viewModel.discardDraft();
      }
    }
  }

  void _performNavigation(int index) {
    final now = DateTime.now();
    if (lastTappedIndex == index &&
        lastTappedTime != null &&
        now.difference(lastTappedTime!) < const Duration(milliseconds: 300)) {
      widget.shell.goBranch(index, initialLocation: true);
    } else {
      widget.shell.goBranch(index);
    }
    lastTappedIndex = index;
    lastTappedTime = now;
  }

  void _checkDraftOnEntry(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CreateRecipeViewModel>().checkAndLoadDraft();
      }
    });
  }

  BottomNavigationBarItem tabItem(BottomTabType tab, bool isSelected) {
    return BottomNavigationBarItem(
      label: '',
      icon: SizedBox(
        width: 26,
        height: 26,
        child: PhosphorIcon(
          tab.icon(
            isSelected ? PhosphorIconsStyle.fill : PhosphorIconsStyle.bold,
          ),
          size: 20,
        ),
      ),
    );
  }
}

enum BottomTabType { home, listsTabPage, createRecipe, signUp, account }

extension BottomTabExtension on BottomTabType {
  String get label => name;

  String get title {
    switch (this) {
      case BottomTabType.home:
        return 'Home';
      case BottomTabType.listsTabPage:
        return 'My Lists';
      case BottomTabType.signUp:
        return 'Sign up';
      case BottomTabType.account:
        return "Account";
      case BottomTabType.createRecipe:
        return "Create Recipe";
    }
  }

  IconData icon(PhosphorIconsStyle style) {
    switch (this) {
      case BottomTabType.home:
        return PhosphorIcons.houseSimple(style);
      case BottomTabType.listsTabPage:
        return PhosphorIcons.heart(style);
      case BottomTabType.createRecipe:
        return PhosphorIcons.plus(style);
      case BottomTabType.signUp:
        return PhosphorIcons.log(style);
      case BottomTabType.account:
        return PhosphorIcons.user(style);
    }
  }
}
