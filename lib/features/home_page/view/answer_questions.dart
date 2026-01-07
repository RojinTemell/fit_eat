import 'package:fit_eat/core/components/appbar.dart';
import 'package:fit_eat/core/constants/dynamic_constants.dart';
import 'package:fit_eat/core/theme/custom_themes/text_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/constants/text_constants.dart';

class AnswerQuestions extends StatelessWidget {
  const AnswerQuestions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Questions Answers '),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return Container(
              padding: context.allPadding(12),
              margin: context.symmetricPadding(4, 0),
              decoration: BoxDecoration(
                color: Constant.fillWhite(context),
                border: Border.all(color: Constant.borderLight(context)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: Constant.fillBase(context),
                            backgroundImage: NetworkImage(
                              'https://cdn.bynogame.com/shop/shop-default-square-1642511991533.jpeg',
                            ),
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Rojin Temel',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              SizedBox(height: 2),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '5 minutes ago',
                                  style: Theme.of(context).textTheme.labelSmall,

                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      PhosphorIcon(
                        PhosphorIconsBold.dotsThree,
                        color: Constant.iconDark(context),
                      ),
                    ],
                  ),
                  Padding(
                    padding: context.symmetricPadding(8, 0),
                    child: Text(
                      'Uygulaman bir yemek/tarif uygulaması olduğu için şu detaylar seni öne çıkarır',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                  Column(
                    children: List.generate(2, (index) {
                      return Container(
                        padding: context.allPadding(12),
                        margin: context.symmetricPadding(4, 0),
                        decoration: BoxDecoration(
                          color: Constant.fillWhite(context),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Constant.fillBase(context),
                                    backgroundImage: NetworkImage(
                                      'https://archive.smashing.media/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/68dd54ca-60cf-4ef7-898b-26d7cbe48ec7/10-dithering-opt.jpg',
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Anonim',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleSmall,
                                            ),
                                            SizedBox(width: 2),
                                            Text(
                                              '5m',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.labelSmall,
                                            ),
                                          ],
                                        ),

                                        Padding(
                                          padding: context.symmetricPadding(
                                            3,
                                            0,
                                          ),
                                          child: RichText(
                                            text: TextSpan(
                                              // text: 'Merhaba ',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.labelMedium,
                                              children: [
                                                TextSpan(
                                                  text: '@rojin ',
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () =>
                                                            context.pushNamed(
                                                              "profile",
                                                            ),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelMedium
                                                      ?.copyWith(
                                                        color:
                                                            Constant.textPrimary(
                                                              context,
                                                            ),
                                                      ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      'tek satır içinde farklı stillerde metinler gösteren temiz ve sık kullanılan bir örnek var',
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'Reply',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmallStrong
                                              .copyWith(
                                                color: Constant.textBase(
                                                  context,
                                                ),
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Column(
                              children: [
                                PhosphorIcon(
                                  PhosphorIcons.heart(),
                                  size: 18,
                                  color: Constant.iconDark(context),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '123',
                                  style: Theme.of(context).textTheme.labelSmall,

                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
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
