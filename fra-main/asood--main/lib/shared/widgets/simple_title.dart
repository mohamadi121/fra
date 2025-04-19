import 'package:flutter/material.dart';

import '../constants/constants.dart';

class SimpleTitle extends StatelessWidget {
  const SimpleTitle({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 15, top: 10),
        child: Text(title, style: ATextStyle.light18),
      ),
    );
  }
}
