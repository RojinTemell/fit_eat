import 'package:flutter/material.dart';

import '../constants/text_constants.dart';

class BadgeWidget extends StatelessWidget {
  const BadgeWidget({
    super.key,
    required this.badgeType,
    required this.text,
    this.icon,
    this.radius,
  });
  final BadgeType badgeType;
  final Widget? icon;
  final String text;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: badgeType.buttonColor(context),
        border: Border.all(color: badgeType.borderColor(context), width: 2),
        shape: badgeType.boxShape,
        borderRadius: radius != null
            ? BorderRadius.circular(radius ?? 0)
            : badgeType.boxShape == BoxShape.circle
            ? null
            : badgeType.borderRadius,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null)
            Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: icon),
          Text(
            text,
            style: TextStyle(
              color: badgeType.textColor(context),
              // == BadgeType.errorOutlineBadge
              //     ? Constant.errorBorderDark
              //     : Constant.textLighter
              fontSize: badgeType.fontSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

enum BadgeType {
  circleErrorLargeBadge,
  circleErrorMediumBadge,
  circleWarningMediumBadge,
  circleWarningLargeBadge,
  circleDarkMediumBadge,
  circleDarkLargeBadge,
  errorDefaultFilled,
  warningBadge,
  errorBadge,
  infoBadge,
  errorOutlineBadge,
  succesOutlineBadge,
  greyBorderBadge,
}

extension BadgeStyleExtension on BadgeType {
  Color buttonColor(BuildContext context) {
    switch (this) {
      case BadgeType.circleErrorLargeBadge:
        return Constant.fillPrimaryBase(context);
      case BadgeType.errorBadge:
        return Constant.fillPrimaryBase(context);
      case BadgeType.circleErrorMediumBadge:
        return Constant.fillPrimaryBase(context);

      case BadgeType.circleWarningMediumBadge:
        return Constant.warningIcon(context);
      case BadgeType.circleWarningLargeBadge:
        return Constant.warningIcon(context);
      case BadgeType.warningBadge:
        return Constant.warningIcon(context);

      case BadgeType.circleDarkMediumBadge:
        return Constant.textDarker(context);
      case BadgeType.circleDarkLargeBadge:
        return Constant.textDarker(context);

      case BadgeType.infoBadge:
        return Constant.borderDark(context);
      case BadgeType.errorOutlineBadge:
        return Constant.fillWhite(context);
      case BadgeType.errorDefaultFilled:
        return Constant.errorBgPrimary(context);
      case BadgeType.succesOutlineBadge:
        return Constant.fillWhite(context);
      case BadgeType.greyBorderBadge:
        return Constant.fillWhite(context);
    }
  }

  Color borderColor(BuildContext context) {
    switch (this) {
      case BadgeType.circleErrorLargeBadge:
        return Constant.errorBorder(context);
      case BadgeType.circleErrorMediumBadge:
        return Constant.errorBorder(context);
      case BadgeType.circleWarningMediumBadge:
        return Constant.warningBorder(context);
      case BadgeType.circleWarningLargeBadge:
        return Constant.warningBorder(context);
      case BadgeType.warningBadge:
        return Constant.warningBorder(context);
      case BadgeType.errorBadge:
        return Constant.errorBorder(context);
      case BadgeType.circleDarkMediumBadge:
        return Constant.borderLight(context);
      case BadgeType.circleDarkLargeBadge:
        return Constant.borderLight(context);
      case BadgeType.infoBadge:
        return Constant.borderLight(context);
      case BadgeType.errorOutlineBadge:
        return Constant.errorBorderDark(context);
      case BadgeType.errorDefaultFilled:
        return Constant.errorBorder(context);
      case BadgeType.succesOutlineBadge:
        return Constant.successBorder(context);
      case BadgeType.greyBorderBadge:
        return Constant.borderLight(context);
    }
  }

  Color textColor(BuildContext context) {
    switch (this) {
      case BadgeType.circleErrorLargeBadge:
      case BadgeType.circleErrorMediumBadge:
      case BadgeType.circleWarningMediumBadge:
      case BadgeType.circleWarningLargeBadge:
      case BadgeType.circleDarkMediumBadge:
      case BadgeType.circleDarkLargeBadge:
      case BadgeType.infoBadge:
      case BadgeType.errorBadge:
      case BadgeType.warningBadge:
        return Constant.fillWhite(context);

      case BadgeType.errorOutlineBadge:
      case BadgeType.errorDefaultFilled:
        return Constant.errorIcon(context);

      case BadgeType.succesOutlineBadge:
        return Constant.successIcon(context);
      case BadgeType.greyBorderBadge:
        return Constant.textDarker(context);
    }
  }

  BoxShape get boxShape {
    switch (this) {
      case BadgeType.circleErrorLargeBadge:
      case BadgeType.circleErrorMediumBadge:
      case BadgeType.circleWarningMediumBadge:
      case BadgeType.circleWarningLargeBadge:
      case BadgeType.circleDarkMediumBadge:
      case BadgeType.circleDarkLargeBadge:
        return BoxShape.circle;
      case BadgeType.warningBadge:
      case BadgeType.errorBadge:
      case BadgeType.infoBadge:
      case BadgeType.errorOutlineBadge:
      case BadgeType.errorDefaultFilled:
      case BadgeType.succesOutlineBadge:
      case BadgeType.greyBorderBadge:
        return BoxShape.rectangle;
    }
  }

  BorderRadiusGeometry get borderRadius {
    switch (this) {
      case BadgeType.circleErrorLargeBadge:
      case BadgeType.circleErrorMediumBadge:
      case BadgeType.circleWarningMediumBadge:
      case BadgeType.circleWarningLargeBadge:
      case BadgeType.circleDarkLargeBadge:
      case BadgeType.circleDarkMediumBadge:
        return BorderRadius.zero;
      case BadgeType.warningBadge:
      case BadgeType.errorBadge:
      case BadgeType.infoBadge:
      case BadgeType.errorOutlineBadge:
      case BadgeType.errorDefaultFilled:
      case BadgeType.succesOutlineBadge:
      case BadgeType.greyBorderBadge:
        return BorderRadius.circular(4);
    }
  }

  Size get size {
    switch (this) {
      case BadgeType.circleErrorLargeBadge:
      case BadgeType.circleWarningLargeBadge:
      case BadgeType.circleDarkLargeBadge:
      case BadgeType.errorDefaultFilled:
        return Size(24, 24);
      case BadgeType.circleErrorMediumBadge:
      case BadgeType.circleDarkMediumBadge:
      case BadgeType.circleWarningMediumBadge:
      case BadgeType.warningBadge:
      case BadgeType.errorBadge:
      case BadgeType.infoBadge:
      case BadgeType.greyBorderBadge:
        return Size(18, 16);

      case BadgeType.errorOutlineBadge:
      case BadgeType.succesOutlineBadge:
        return Size(44, 18);
    }
  }

  double get fontSize {
    switch (this) {
      case BadgeType.circleErrorLargeBadge:
      case BadgeType.circleWarningLargeBadge:
      case BadgeType.circleDarkLargeBadge:
        return 14;
      case BadgeType.circleErrorMediumBadge:
      case BadgeType.circleWarningMediumBadge:
      case BadgeType.circleDarkMediumBadge:
      case BadgeType.greyBorderBadge:
        return 12;
      case BadgeType.warningBadge:
      case BadgeType.errorBadge:
      case BadgeType.infoBadge:
      case BadgeType.errorOutlineBadge:
      case BadgeType.errorDefaultFilled:
      case BadgeType.succesOutlineBadge:
        return 12;
    }
  }
}
