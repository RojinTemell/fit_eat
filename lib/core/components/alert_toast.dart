import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../constants/dynamic_constants.dart';
import '../constants/text_constants.dart';

enum AlertToastType { success, warning, error, info, neutral }

class AlertToast extends StatefulWidget {
  AlertToast({
    super.key,
    required this.type,
    this.duration,
    this.buttons,
    this.message,
    this.titleWidget,
    this.icon,
    this.onClose,
    this.overlayEntry,
    this.width,
    this.suffix,
  });
  final AlertToastType type;
  final Widget? message;
  final Widget? buttons;
  final Widget? titleWidget;
  final Duration? duration;
  final Widget? icon;
  final VoidCallback? onClose;
  final OverlayEntry? overlayEntry;
  final double? width;
  final Widget? suffix;

  @override
  State<AlertToast> createState() => _AlertToastState();
}

class _AlertToastState extends State<AlertToast> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  void _removeToast() {
    if (widget.overlayEntry != null) {
      widget.overlayEntry!.remove();
    }
  }

  @override
  void initState() {
    super.initState();
    final duration = widget.duration ?? const Duration(seconds: 3);
    _controller = AnimationController(vsync: this, duration: duration);
    _animation = Tween<double>(
      begin: 5.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _removeToast();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _borderColor(BuildContext context) {
    switch (widget.type) {
      case AlertToastType.success:
        return Constant.successBorderDark(context);
      case AlertToastType.warning:
        return Constant.warningBorderDark(context);
      case AlertToastType.error:
        return Constant.errorBorderDark(context);
      case AlertToastType.info:
        return Constant.infoBorderDark(context);
      case AlertToastType.neutral:
        return Constant.borderDark(context);
    }
  }

  Color _iconColor() {
    switch (widget.type) {
      case AlertToastType.success:
        return Constant.successIcon(context);
      case AlertToastType.warning:
        return Constant.warningIcon(context);
      case AlertToastType.error:
        return Constant.errorIcon(context);
      case AlertToastType.info:
        return Constant.infoIcon(context);
      case AlertToastType.neutral:
        return Constant.iconDark(context);
    }
  }

  IconData _iconForType() {
    switch (widget.type) {
      case AlertToastType.success:
        return PhosphorIcons.checkCircle(PhosphorIconsStyle.fill);
      case AlertToastType.warning:
        return PhosphorIcons.warning(PhosphorIconsStyle.fill);
      case AlertToastType.error:
        return PhosphorIcons.xCircle(PhosphorIconsStyle.fill);
      case AlertToastType.info:
        return PhosphorIcons.info(PhosphorIconsStyle.fill);
      case AlertToastType.neutral:
        return PhosphorIconsBold.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: widget.width ?? context.dynamicWidth(0.8),
            decoration: BoxDecoration(
              color: Constant.fillWhite(context),
              borderRadius: BorderRadius.circular(8),
              border: Border(
                left: BorderSide(color: _borderColor(context), width: 6),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromRGBO(0, 0, 0, 0.05),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    widget.icon ??
                        Icon(_iconForType(), color: _iconColor(), size: 24),
                    const SizedBox(width: 8),
                    Expanded(child: widget.titleWidget ?? SizedBox()),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: AnimatedBuilder(
                            animation: _animation,
                            builder: (context, child) {
                              return CircularProgressIndicator(
                                value: _animation.value,
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Constant.borderLight(context),
                                ),
                              );
                            },
                          ),
                        ),
                        widget.suffix ??
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 0,
                                minHeight: 0,
                              ),
                              onPressed: _removeToast,
                              icon:
                                  widget.icon ??
                                  PhosphorIcon(PhosphorIconsBold.x, size: 16),
                            ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: widget.message != null ? 12 : 0),
                widget.message ?? SizedBox(),
                SizedBox(height: widget.buttons != null ? 12 : 0),
                widget.buttons ?? SizedBox(),
              ],
            ),
          );
        },
      ),
    );
  }
}

void showAlertToast(
  BuildContext context, {
  AlertToastType type = AlertToastType.neutral,
  Widget? icon,
  Widget? titleWidget,
  Widget? message,
  Widget? buttons,
  double? width,
  Widget? suffix,
}) {
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: context.dynamicHeight(0.1),
      left: context.dynamicWidth(0.04),
      right: context.dynamicWidth(0.04),
      child: AlertToast(
        titleWidget: titleWidget,
        icon: icon,
        type: type,
        buttons: buttons,
        message: message,
        overlayEntry: overlayEntry,
        width: width,
        suffix: suffix,
        onClose: () {
          overlayEntry.remove();
        },
      ),
    ),
  );

  overlay.insert(overlayEntry);
}
