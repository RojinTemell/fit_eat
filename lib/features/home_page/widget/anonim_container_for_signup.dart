import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/components/base_button.dart';
import '../../../core/constants/dynamic_constants.dart';
import '../../../core/constants/text_constants.dart';

class AnonimContainerForSignUp extends StatelessWidget {
  const AnonimContainerForSignUp({super.key, this.margin, this.borderRadius});
  final double? margin;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: context.allPadding(margin ?? 16), // Dışarıdan biraz boşluk
      padding: context.symmetricPadding(16, 24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(borderRadius ?? 24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: DefaultUserImage(),
            title: Text(
              'Merhaba 👋',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Fırsatları kaçırmamak için giriş yapın.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 16),
          BaseButton(
            callback: () async {
              context.go("/signUp");
            },
            title: 'Giriş Yap / Hesap Oluştur',
            width: double.infinity, // Tam genişlik daha modern durur
            baseButtonType: BaseButtonType.filledDark,
            baseButtonSize: BaseButtonSize.small,
          ),
        ],
      ),
    );
  }
}

class DefaultUserImage extends StatelessWidget {
  const DefaultUserImage({super.key, this.radius});
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius ?? 24,
      backgroundColor: Constant.iconDark(context).withOpacity(0.1),
      child: PhosphorIcon(
        PhosphorIconsBold.user,
        color: Constant.iconDark(context),
      ),
    );
  }
}
