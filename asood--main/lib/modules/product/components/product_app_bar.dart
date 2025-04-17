import 'package:asood/shared/constants/constants.dart';
import 'package:flutter/material.dart';

class ProductAppBar extends StatelessWidget {

  final String title;

  const ProductAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.width,
      height: Dimensions.height * 0.1,
      decoration: const BoxDecoration(
        color: Colora.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16)
        )
      ),
      child: Row(

        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [

          IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colora.scaffold,
            )
          ),

          Text(
            title,
            style: const TextStyle(
              color: Colora.scaffold,
              fontWeight: FontWeight.bold,
              fontSize: 20
            ),
          ),

          IconButton(
            onPressed: (){},
            icon: const Icon(
              Icons.menu_rounded,
              color: Colora.scaffold,
            )
          )

        ],
      ),
    );
  }
}

