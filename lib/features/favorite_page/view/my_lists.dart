import 'package:fit_eat/core/constants/dynamic_constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

import '../../../core/components/base_button.dart';
import '../../../core/components/bottom_sheet_lists.dart';
import '../../../core/components/circle_button.dart';
import '../../../core/constants/text_constants.dart';
import '../../../core/cubits/bottom_sheet.dart';

class MyLists extends StatefulWidget {
  const MyLists({super.key});

  @override
  State<MyLists> createState() => _MyListsState();
}

class _MyListsState extends State<MyLists> {
  late List<Map<String, dynamic>> editList;
  @override
  void didChangeDependencies() {
    editList = [
      {
        'title': 'setDefault',
        'icon': PhosphorIconsBold.bookmarkSimple,
        'callback': (BuildContext ctx) {},
      },
      {
        'title': 'edit',
        'icon': PhosphorIconsBold.pencilSimpleLine,
        'callback': (BuildContext ctx) {},
      },
      {
        'title': 'delete',
        'icon': PhosphorIconsBold.trash,
        'callback': (BuildContext ctx) {
          // İstersen önce bottomsheet’i kapat:
          Navigator.of(ctx).pop(); // bottomSheet’i kapat

          // Sonra küçük bir gecikme ile popup’ı aç:
          Future.microtask(() {
            showDialog(
              // ignore: use_build_context_synchronously
              context: ctx,
              builder: (_) => Dialog(
                insetPadding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  // decoration: BoxDecoration(
                  //     color: Constant.fillWhite(context),
                  //     borderRadius: BorderRadius.circular(16)),
                  // width: context.dynamicWidth(0.8),
                  padding: context.onlyPadding(12, 20, 24, 20),
                  child: Stack(
                    children: [
                      Positioned(
                        right: 0,
                        top: 0,
                        child: CircleButton(
                          widget: PhosphorIcon(
                            PhosphorIconsBold.x,
                            size: 18,
                            color: Constant.iconDark(context),
                          ),
                          callback: () {
                            context.pop();
                          },
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(height: 12),

                          Padding(
                            padding: context.symmetricPadding(12, 0),
                            child: Text(
                              "Fatura Bilgilerini silmek istediğinize emin misiniz?",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                          ),

                          Padding(
                            padding: context.onlyPadding(20, 0, 8, 0),
                            child: BaseButton(
                              callback: () {
                                context.pop();
                              },
                              width: context.dynamicWidth(1),
                              title: "Vazgeç",
                              baseButtonType: BaseButtonType.filledDark,
                              baseButtonSize: BaseButtonSize.large,
                            ),
                          ),
                          BaseButton(
                            width: context.dynamicWidth(1),
                            title: 'Evet, fatura biliglerimi sil',
                            prefixIcon: PhosphorIcon(
                              PhosphorIconsBold.trash,
                              size: 18,
                              color: Constant.iconWhite(context),
                            ),
                            baseButtonType: BaseButtonType.filledRed,
                            baseButtonSize: BaseButtonSize.large,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        },
      },
    ];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: context.symmetricPadding(20, 12),
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Container(
              margin: context.symmetricPadding(8, 0),
              padding: context.allPadding(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Constant.fillWhite(context),
              ),
              // height: 60,
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Test Listesi',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            '27.12.2025',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          context.read<BottomSheetBloc>().showBottomSheet(
                            context: context,
                            widget: BottomSheetLists(bottomList: editList),
                          );
                        },
                        child: PhosphorIcon(
                          PhosphorIconsBold.dotsThree,
                          size: 24,
                          color: Constant.iconDark(context),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: context.symmetricPadding(18, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            // padding: context.allPadding(4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Constant.borderLighter(context),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                'assets/images/salad.jpeg',
                                // height: context.dynamicHeight(0.19),
                                width: context.dynamicWidth(0.4),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(0),
                            itemCount: 4,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 4,
                                  mainAxisSpacing: 4,
                                  // childAspectRatio: 0.9,
                                ),
                            itemBuilder: (context, index) {
                              if (index < 3) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    'assets/images/salad.jpeg',
                                    // height: context.dynamicHeight(0.15),
                                    // width: context.dynamicWidth(0.4),
                                    fit: BoxFit.fill,
                                  ),
                                );
                              } else {
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Constant.borderPrimary(context),
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    color: Constant.fillFixWhite(context),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      PhosphorIcon(
                                        PhosphorIconsBold.plusCircle,
                                        color: Constant.iconPrimary(context),
                                        size: 24,
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        'Ürün Ekle',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium
                                            ?.copyWith(
                                              color: Constant.textPrimary(
                                                context,
                                              ),
                                            ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
