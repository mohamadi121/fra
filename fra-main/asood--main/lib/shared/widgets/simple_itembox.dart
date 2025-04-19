import 'package:flutter/material.dart';

import '../constants/constants.dart';

class SimpleItemBox extends StatelessWidget {
  final Function() onTap;
  final Color? boxColor;
  final Widget child;
  final String title;
  const SimpleItemBox({
    super.key,
    required this.onTap,
    this.boxColor,
    required this.child,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: 30,
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 5
          ),
          decoration: BoxDecoration(
              color: boxColor ?? Colora.lightBlue,
              borderRadius: BorderRadius.circular(8)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // const SizedBox(
              //   height: 30,
              // ),
              // child,
              // const SizedBox(
              //   height: 13,
              // ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: Dimensions.width * 0.038
                ),
              ),
            ],
          )),
    );
  }
}
