import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../../constants/constants.dart';
import '../../../widgets/colorpicker.dart';
// import '../../../shared/widgets/custom_bottom_navigation_bar_widget.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/font_list_widget.dart';
import '../../../widgets/default_appbar.dart';
import '../../../widgets/simple_bot_navbar.dart';
@RoutePage()
class FontColorSettingScreen extends StatefulWidget {
  const FontColorSettingScreen({super.key});

  @override
  State<FontColorSettingScreen> createState() => _FontColorSettingScreenState();
}

class _FontColorSettingScreenState extends State<FontColorSettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(context: context),
      bottomNavigationBar: const SimpleBotNavBar(),
      body: Container(
        height: Dimensions.height,
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //select font widget
              AFontWidget(
                titleWidget: Container(
                  height: 40,
                  width: Dimensions.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colora.primaryColor,
                  ),
                  child: const Center(
                    child: Text("انتخاب فونت دلخواه",
                        style: TextStyle(color: Colora.scaffold)),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              AColorPicker(
                paletteType: PaletteType.hsl,
                titleWidget: Container(
                  height: 40,
                  width: Dimensions.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colora.primaryColor,
                  ),
                  child: const Center(
                    child: Text("رنگ متن",
                        style: TextStyle(color: Colora.scaffold)),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CustomButton(
                onPress: () {},
                text: "ذخیره",
                color: Colora.primaryColor,
                height: 40,
                width: 100,
              )
            ],
          ),
        ),
      ),
    );
  }
}
