import 'dart:ui';

import 'package:fit_eat/core/components/circle_button.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/dynamic_constants.dart';
import '../../../core/constants/text_constants.dart';
import '../../../core/theme/custom_themes/text_theme.dart';

class LastVisitedWidget extends StatelessWidget {
  const LastVisitedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: Constant.fillWhite(context),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/task.jpg',
                    height: context.dynamicHeight(0.27),
                    width: context.dynamicWidth(0.45),
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleButton(
                    padding: 4,
                    widget: PhosphorIcon(
                      PhosphorIconsBold.heart,
                      color: Constant.iconDark(context),
                      size: 12,
                    ),
                    callback: () {},
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              // ignore: deprecated_member_use
                              Colors.black.withOpacity(0.15),
                              // ignore: deprecated_member_use
                              Colors.black.withOpacity(0.55),
                            ],
                          ),
                          // color: Colors.black.withOpacity(
                          //   0.1,
                          // ), // blur üstüne koyu overlay
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Healthy Salad Recipes',
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    color: Constant.textFixWhite(context),
                                  ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      PhosphorIcon(
                                        PhosphorIconsBold.clock,
                                        color: Constant.iconWhite(context),
                                        size: 12,
                                      ),
                                      // const SizedBox(width: 4),
                                      Text(
                                        '14 mins',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMediumStrong
                                            .copyWith(
                                              color: Constant.textFixWhite(
                                                context,
                                              ),
                                            ),
                                      ),
                                    ],
                                  ),

                                  Row(
                                    children: [
                                      PhosphorIcon(
                                        PhosphorIconsBold.fire,
                                        color: Constant.iconWhite(context),
                                        size: 12,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '200 cal',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              color: Constant.textFixWhite(
                                                context,
                                              ),
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
