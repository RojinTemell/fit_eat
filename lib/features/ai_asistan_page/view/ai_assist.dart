import 'package:fit_eat/core/components/appbar.dart';
import 'package:fit_eat/core/components/circle_button.dart';
import 'package:fit_eat/core/components/text_input.dart';
import 'package:fit_eat/core/constants/dynamic_constants.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/constants/text_constants.dart';
import '../../../core/theme/custom_themes/text_theme.dart';
import '../widget/ai_static.dart';

class AiAssist extends StatefulWidget {
  const AiAssist({super.key});

  @override
  State<AiAssist> createState() => _AiAssistState();
}

class _AiAssistState extends State<AiAssist> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(),
      body: SafeArea(
        child: Padding(
          padding: context.symmetricPadding(12, 12),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AiStatic(),
                      SizedBox(height: 20),
                      Text(
                        'Create better and healthy recipe',
                        style: Theme.of(context).textTheme.bodyStrong,
                      ),
                      Text(
                        'write your items for finding meals',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  CircleButton(
                    widget: PhosphorIcon(
                      PhosphorIconsBold.plus,
                      color: Constant.iconDark(context),
                      // size: 18,
                    ),
                    callback: () {},
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextInputWidget(
                      hintText: 'Mesajınız',
                      suffixIcon: PhosphorIcon(
                        PhosphorIconsBold.paperPlaneRight,
                        color: Constant.iconDark(context),
                      ),
                      controller: _controller,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: Padding(
      //   padding: EdgeInsets.only(
      //     bottom: MediaQuery.of(context).viewInsets.bottom,
      //   ),
      //   child: Row(
      //     children: [
      //       Expanded(
      //         child: TextInputWidget(
      //           hintText: 'Mesajınız',
      //           suffixIcon: PhosphorIcon(
      //             PhosphorIconsBold.paperPlaneRight,
      //             color: Constant.iconDark(context),
      //           ),
      //           controller: _controller,
      //           keyboardType: TextInputType.text,
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
