import 'package:flutter/material.dart';

import '../../../services/Secure_Storage.dart';
import '../blocs/create_workspace/create_workspace_bloc.dart';
import '../../../shared/constants/constants.dart';
import '../../../shared/utils/snack_bar_util.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_switch.dart';
import '../../../shared/widgets/custom_textfield.dart';
import '../../../shared/widgets/row_widget_title_widget.dart';

class ContactsInfo extends StatefulWidget {
  const ContactsInfo({required this.bloc, super.key});

  final CreateWorkSpaceBloc bloc;

  @override
  State<ContactsInfo> createState() => _ContactsInfoState();
}

class _ContactsInfoState extends State<ContactsInfo> {
  TextEditingController phone1Controller = TextEditingController();
  TextEditingController phone2Controller = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController faxController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController siteController = TextEditingController();
  TextEditingController telegramController = TextEditingController();
  TextEditingController instaController = TextEditingController();
//work time textcontrollers
  TextEditingController satFController = TextEditingController();
  TextEditingController satTController = TextEditingController();

  TextEditingController sunFController = TextEditingController();
  TextEditingController sunTController = TextEditingController();

  TextEditingController monFController = TextEditingController();
  TextEditingController monTController = TextEditingController();

  TextEditingController tueFController = TextEditingController();
  TextEditingController tueTController = TextEditingController();

  TextEditingController wedFController = TextEditingController();
  TextEditingController wedTController = TextEditingController();

  TextEditingController thuFController = TextEditingController();
  TextEditingController thuTController = TextEditingController();

  TextEditingController friFController = TextEditingController();
  TextEditingController friTController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.khorisontal,
      ),
      child: Container(
        // height: Dimensions.height * .7,
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width * 0.01,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colora.primaryColor),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 7),
              CustomTextField(
                isRequired: true,
                controller: phone1Controller,
                borderColor: widget.bloc.state.phoneBorder,
                keyboardType: TextInputType.phone,
                text: "تلفن همراه"
              ),
              const SizedBox(height: 7),
              CustomTextField(
                controller: phone2Controller,
                text: "تلفن همراه",
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 7),
              CustomTextField(
                isRequired: true,
                controller: phoneNumberController,
                text: "تلفن ثابت",
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 7),
              CustomTextField(
                controller: faxController,
                text: "فکس",
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 7),
              CustomTextField(
                  borderColor: widget.bloc.state.emailBorder,
                  isRequired: true,
                  controller: emailController,
                  text: "ایمیل"),
              const SizedBox(height: 7),
              CustomTextField(controller: siteController, text: "سایت"),
              const SizedBox(height: 7),
              CustomTextField(controller: telegramController, text: "تلگرام"),
              const SizedBox(height: 7),
              CustomTextField(controller: instaController, text: "اینستاگرام"),
              const SizedBox(height: 7),

              //time
              const Text(
                "وارد کردن ساعت کاری باعث نمایش باز یا بسته بودن محل کار شما و جلب مشتری می شود.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
              CustomSwitch(
                  title: "دارای ساعت کاری",
                  onChanged: (p0) {
                    widget.bloc.add(ChangeHasWorkTime(hasWorkTime: p0));
                  },
                  switchValue: widget.bloc.state.hasWorkTime),

              if(widget.bloc.state.hasWorkTime == true)...[
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white
                  ),
                  child: FittedBox(
                    alignment: Alignment.centerRight,
                    child: Column(children: [
                      RowWidgetTitle(
                          title: "شنبه",
                          widget: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 18),
                                  child: Container(
                                    width: 200,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colora.primaryColor
                                    ),
                                    child: Center(
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 90,
                                            child: CustomTextField(
                                              color: Colora.primaryColor,
                                              controller: satFController,
                                              text: 'از ساعت',
                                              keyboardType: TextInputType.number,
                                              hintStyle: const TextStyle(color: Colors.white),
                                            ),
                                          ),
                                          const Text(
                                            '-',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          SizedBox(
                                            width: 90,
                                            child: CustomTextField(
                                              color: Colora.primaryColor,
                                              controller: satTController,
                                              text: 'تا ساعت',
                                              keyboardType: TextInputType.number,
                                              hintStyle: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      const Divider(
                        thickness: 1,
                      ),
                      RowWidgetTitle(
                          title: "یکشنبه",
                          widget: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 30.0),
                                  child: Container(
                                    width: 200,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colora.primaryColor),
                                    child: Center(
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 90,
                                            child: CustomTextField(
                                              color: Colora.primaryColor,
                                              controller: sunFController,
                                              text: 'از ساعت',
                                              keyboardType: TextInputType.number,
                                              hintStyle: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          const Text(
                                            '-',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          SizedBox(
                                            width: 90,
                                            child: CustomTextField(
                                              color: Colora.primaryColor,
                                              controller: sunTController,
                                              text: 'تا ساعت',
                                              keyboardType: TextInputType.number,
                                              hintStyle: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      const Divider(
                        thickness: 1,
                      ),
                      RowWidgetTitle(
                          title: "دوشنبه",
                          widget: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: Container(
                                width: 200,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colora.primaryColor),
                                child: Center(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 90,
                                        child: CustomTextField(
                                          color: Colora.primaryColor,
                                          controller: monFController,
                                          text: 'از ساعت',
                                          keyboardType: TextInputType.number,
                                          hintStyle:
                                          const TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      const Text(
                                        '-',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(
                                        width: 90,
                                        child: CustomTextField(
                                          color: Colora.primaryColor,
                                          controller: monTController,
                                          text: 'تا ساعت',
                                          keyboardType: TextInputType.number,
                                          hintStyle:
                                          const TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )),
                      const Divider(
                        thickness: 1,
                      ),
                      RowWidgetTitle(
                          title: "سه شنبه",
                          widget: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 35),
                              child: Container(
                                width: 200,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colora.primaryColor),
                                child: Center(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 90,
                                        child: CustomTextField(
                                          color: Colora.primaryColor,
                                          controller: tueFController,
                                          text: 'از ساعت',
                                          keyboardType: TextInputType.number,
                                          hintStyle:
                                          const TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      const Text(
                                        '-',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(
                                        width: 90,
                                        child: CustomTextField(
                                          color: Colora.primaryColor,
                                          controller: tueTController,
                                          text: 'تا ساعت',
                                          keyboardType: TextInputType.number,
                                          hintStyle:
                                          const TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )),
                      const Divider(
                        thickness: 1,
                      ),
                      RowWidgetTitle(
                          title: "چهارشنبه",
                          widget: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 35),
                              child: Container(
                                width: 200,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colora.primaryColor),
                                child: Center(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 90,
                                        child: CustomTextField(
                                          color: Colora.primaryColor,
                                          controller: wedFController,
                                          text: 'از ساعت',
                                          keyboardType: TextInputType.number,
                                          hintStyle:
                                          const TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      const Text(
                                        '-',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(
                                        width: 90,
                                        child: CustomTextField(
                                          color: Colora.primaryColor,
                                          controller: wedTController,
                                          text: 'تا ساعت',
                                          keyboardType: TextInputType.number,
                                          hintStyle:
                                          const TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )),
                      const Divider(
                        thickness: 1,
                      ),
                      RowWidgetTitle(
                          title: "پنجشنبه",
                          widget: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 35),
                              child: Container(
                                width: 200,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colora.primaryColor),
                                child: Center(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 90,
                                        child: CustomTextField(
                                          color: Colora.primaryColor,
                                          controller: thuFController,
                                          text: 'از ساعت',
                                          keyboardType: TextInputType.number,
                                          hintStyle:
                                          const TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      const Text(
                                        '-',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(
                                        width: 90,
                                        child: CustomTextField(
                                          color: Colora.primaryColor,
                                          controller: thuTController,
                                          text: 'تا ساعت',
                                          keyboardType: TextInputType.number,
                                          hintStyle:
                                          const TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )),
                      const Divider(
                        thickness: 1,
                      ),
                      RowWidgetTitle(
                          title: "جمعه",
                          widget: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 18),
                              child: Container(
                                width: 200,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colora.primaryColor),
                                child: Center(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 90,
                                        child: CustomTextField(
                                          color: Colora.primaryColor,
                                          controller: friFController,
                                          text: 'از ساعت',
                                          keyboardType: TextInputType.number,
                                          hintStyle:
                                          const TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      const Text(
                                        '-',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(
                                        width: 90,
                                        child: CustomTextField(
                                          color: Colora.primaryColor,
                                          controller: friTController,
                                          text: 'تا ساعت',
                                          keyboardType: TextInputType.number,
                                          hintStyle:
                                          const TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )),
                    ]),
                  ),
                ),
              ],
              SizedBox(
                height: Dimensions.height * 0.01
              ),

              //button
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(left: 7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomButton(
                        width: 100,
                        onPress: () {
                          widget.bloc.add(const ChangeTabView(activeTabIndex: 0));
                        },
                        text: "قبلی",
                        color: Colors.white,
                        textColor: Colora.primaryColor,
                        height: 40,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      CustomButton(
                        width: 100,
                        onPress: () async{
                          widget.bloc.add(
                            Validator(
                              phoneNumber1: phone1Controller.text,
                              email: emailController.text
                            )
                          );
                          String marketId = await SecureStorage().readSecureStorage('market_id');
                          if (phone1Controller.text.isNotEmpty &&
                              phoneNumberController.text.isNotEmpty &&
                              emailController.text.isNotEmpty) {

                            widget.bloc.add(
                              MarketContact(
                                marketId: int.parse(marketId),
                                phoneNumber1: phone1Controller.text,
                                phoneNumber2: phone1Controller.text,
                                telephone: phoneNumberController.text,
                                fax: faxController.text,
                                email: emailController.text,
                                websiteUrl: siteController.text,
                                instagramId: instaController.text,
                                telegramId: telegramController.text,
                              )
                            );

                            if(widget.bloc.state.hasWorkTime == true){

                              print(satFController.text);
                              print(satTController.text);

                              print(sunFController.text);
                              print(sunTController.text);

                              print(monFController.text);
                              print(monTController.text);

                              print(tueFController.text);
                              print(tueTController.text);

                              print(wedFController.text);
                              print(wedTController.text);

                              print(thuFController.text);
                              print(thuTController.text);

                              print(friFController.text);
                              print(friTController.text);


                            }


                          } else {
                            showSnackBar(
                                context, "لطفا فیلد های لازم را پر کنید");
                          }
                        },
                        text: "بعدی",
                        color: Colors.white,
                        textColor: Colora.primaryColor,
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: Dimensions.height * 0.03,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
