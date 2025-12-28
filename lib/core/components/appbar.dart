import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../constants/text_constants.dart';
import '../theme/custom_themes/text_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final Color? color;
  final PreferredSizeWidget? bottom;
  final bool? centerTitle;
  final Color? backgroundColor;
  final Color? bottomBorder;
  final VoidCallback? onTap;
  final VoidCallback? ontapActions;
  final bool? isVisibleLeading; //whether leading widget is showm or not
  final bool? isVisibleWidth;
  final Widget? centerWidget;
  final Alignment? centerWidgetAlignment;
  final bool? isCenterTitle;
  final double? height;
  final Widget? bottomIndicator;

  CustomAppBar({
    super.key,
    this.title,
    this.actions,
    this.bottom,
    this.centerTitle,
    this.onTap,
    this.isCenterTitle,
    this.isVisibleLeading = true,
    this.color,
    this.backgroundColor,
    this.bottomBorder,
    this.ontapActions,
    this.centerWidgetAlignment,
    this.centerWidget,
    this.height,
    this.isVisibleWidth,
    this.bottomIndicator,
  }) : preferredSize = Size.fromHeight(
         (height ?? kToolbarHeight) +
             (bottom?.preferredSize.height ?? 0) +
             (bottomIndicator != null ? 6 : 0) +
             1, // border
       );

  @override
  final Size preferredSize;
  @override
  Widget build(BuildContext context) {
    final bool showLeading = isVisibleLeading ?? true;
    final bool showWidth = isVisibleWidth ?? true;
    return Column(
      children: [
        AppBar(
          elevation: 0,
          backgroundColor: backgroundColor ?? Constant.fillWhite(context),
          centerTitle: centerTitle ?? true,
          titleSpacing: 0,
          toolbarHeight: height ?? kToolbarHeight,
          title: Align(
            alignment: centerWidgetAlignment ?? Alignment.center,
            child:
                centerWidget ??
                Text(
                  title ?? '',
                  style: Theme.of(context).textTheme.labelStrong,
                ),
          ),
          automaticallyImplyLeading: showLeading,
          leadingWidth: showWidth ? null : 0,
          leading: isVisibleLeading!
              ? Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: GestureDetector(
                    onTap: onTap ?? () => context.pop(),
                    child: PhosphorIcon(
                      PhosphorIcons.arrowLeft(PhosphorIconsStyle.bold),
                      size: 24,
                      color: Constant.iconDark(context),
                    ),
                  ),
                )
              : SizedBox.shrink(),
          actions:
              actions ??
              [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0, left: 8),
                  child: GestureDetector(
                    onTap:
                        ontapActions ??
                        () {
                          // showBottomBar.value = true;
                          // GoRouter.of(context).push('/account');
                        },
                    child: PhosphorIcon(
                      PhosphorIcons.x(PhosphorIconsStyle.bold),
                      size: 24,
                      color: Constant.iconDark(context),
                    ),
                  ),
                ),
              ],
          bottom: bottom,
        ),
        Container(
          height: 1.0,
          color:
              bottomBorder ??
              Constant.borderLighter(context), // Border rengini belirle
        ),
        if (bottomIndicator != null) bottomIndicator!,
      ],
    );
  }
}
