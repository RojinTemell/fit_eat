import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/dynamic_constants.dart';
import '../../../core/constants/text_constants.dart';

// ignore: must_be_immutable
class BaseFitreItem extends StatefulWidget {
  BaseFitreItem({
    super.key,
    required this.isChecked,
    required this.onChanged,
    required this.title,
    this.image,
  });
  bool isChecked;
  final VoidCallback onChanged;
  final String title;
  final String? image;

  @override
  State<BaseFitreItem> createState() => _BaseFitreItemState();
}

class _BaseFitreItemState extends State<BaseFitreItem> {
  // bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    final filterItemType = widget.isChecked
        ? FilterItemType.Selected
        : FilterItemType.Default;
    return GestureDetector(
      onTap: widget.onChanged,
      child: Container(
        padding: context.symmetricPadding(8, 8),
        color: filterItemType.backgroundColor(context),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: widget.onChanged,
                child: PhosphorIcon(
                  widget.isChecked
                      ? PhosphorIconsFill.checkSquare
                      : PhosphorIconsBold.square,
                  color: widget.isChecked
                      ? Constant.iconDark(context)
                      : Constant.iconBase(context),
                ),
              ),
            ),
            if ((widget.image ?? '').isNotEmpty)
              Expanded(
                flex: 2,
                child: Padding(
                  padding: context.symmetricPadding(0, 18),
                  child: widget.image?.isNotEmpty ?? false
                      ? Image.network(
                          widget.image ?? '',
                          width: 48,
                          height: 48,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              width: 48,
                              height: 48,
                              'assets/images/bynocan.png',
                            );
                          },
                        )
                      : SizedBox(height: 48),
                ),
              ),
            if ((widget.image ?? '').isEmpty) SizedBox(height: 30),
            Expanded(
              flex: 6,
              child: Text(
                widget.title,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum FilterItemType { Default, Selected, Disabled }

extension FilterColor on FilterItemType {
  Color backgroundColor(BuildContext context) {
    switch (this) {
      case FilterItemType.Default:
        return Constant.fillWhite(context);
      case FilterItemType.Selected:
        return Constant.fillLight(context);
      case FilterItemType.Disabled:
        return Constant.fillWhite(context);
    }
  }
}
