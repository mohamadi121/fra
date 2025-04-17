// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/constants/constants.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/default_appbar.dart';
import '../../../shared/widgets/inquiry_top_bar_widget.dart';
import '../../../shared/widgets/product_service_inquiry_list_widget.dart';
import '../../../shared/widgets/simple_bot_navbar.dart';
import '../blocs/inquiry/inquiry_bloc.dart';

@RoutePage()
class InquiryDetailsScreen extends StatelessWidget {
  const InquiryDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(context: context),
      body: SafeArea(
        child: Center(
          child: Container(
            width: Dimensions.width * 0.9,
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: BlocConsumer<InquiryBloc, InquiryState>(
              listener: (context, state) {},
              builder: (context, state) {
                return Column(
                  children: [
                    const InquiryTopBar(),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colora.primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            child: const Text("مدت زمان باقی‌مانده:"),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.blue,
                            ),
                            child: const Text("۲۱:۱۱:۱۰"),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const ProductServiceInquiryList(),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          child: CustomButton(
                            onPress: () {},
                            text: "ارسال پاسخ",
                            width: 100,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      extendBody: true,
      bottomNavigationBar: SimpleBotNavBar(),
    );
  }
}
