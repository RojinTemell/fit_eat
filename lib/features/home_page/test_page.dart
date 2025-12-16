import 'package:fit_eat/core/constants/text_constants.dart';
import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'EAT FIT',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Constant.textSecondaryDark(context),
          ),
        ),
      ),
    );
  }
}
