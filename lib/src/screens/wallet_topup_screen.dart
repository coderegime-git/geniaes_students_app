import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';

import '../../multi_language/language_constants.dart';
import '../api_services/post_service.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../controllers/make_payment_controller.dart';
import '../controllers/payment_gateways_controller.dart';
import '../repositories/make_wallet_topup_repo.dart';
import '../widgets/appbar_widget.dart';
import '../widgets/button_widget.dart';
import '../widgets/text_form_field_widget.dart';

class WalletTopUpScreen extends StatefulWidget {
  const WalletTopUpScreen({super.key});

  @override
  State<WalletTopUpScreen> createState() => _WalletTopUpScreenState();
}

class _WalletTopUpScreenState extends State<WalletTopUpScreen> {
  final makePaymentLogic = Get.put(MakePaymentController());
  dynamic selectedPaymentGateway;
  final GlobalKey<FormState> walletTopUpFromKey = GlobalKey();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: AppBarWidget(
            leadingIcon: 'assets/icons/Expand_left.png',
            leadingOnTap: () {
              Get.back();
            },
            titleText: LanguageConstant.walletTopup.tr,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 18.h),
          child: Form(
            key: walletTopUpFromKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LanguageConstant.chooseYourPaymentMethod.tr,
                  style: AppTextStyles.headingTextStyle5,
                ),
                SizedBox(height: 20.h),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color:
                        AppColors.white, //background color of dropdown button

                    borderRadius: BorderRadius.circular(
                        30), //border raiuds of dropdown button
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 16,
                        offset: Offset(2, 5), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: 1,
                        physics: const AlwaysScrollableScrollPhysics(),
                        // padding: const EdgeInsets.only(top: 18),
                        itemBuilder: (context, index) {
                          return DropdownButtonHideUnderline(
                            child: DropdownButtonFormField(
                              hint: Text(
                                LanguageConstant.pleaseChoosePaymentMethod.tr,
                                style: AppTextStyles.bodyTextStyle11,
                              ),

                              value: selectedPaymentGateway,

                              validator: (selectedPaymentGateway) {
                                if (selectedPaymentGateway == null) {
                                  return LanguageConstant
                                      .paymentMethodIsRequired.tr;
                                } else {
                                  return null;
                                }
                              },
                              items: Get.find<PaymentGatewaysController>()
                                  .getPaymentGatewaysModel
                                  .data!
                                  .map((gatewaysName) {
                                return DropdownMenuItem(
                                  value: gatewaysName.code,
                                  child: DropdownMenuItem(
                                    child: Row(
                                      children: [
                                        Image.network(
                                          "$mediaUrl${gatewaysName.image!}",
                                          height: 35.h,
                                        ),
                                        SizedBox(
                                          width: 8.w,
                                        ),
                                        Text(gatewaysName.name!,
                                            style:
                                                AppTextStyles.bodyTextStyle11),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedPaymentGateway = newValue;

                                  print(
                                      "GATEWAYS SELECTED NAME ${selectedPaymentGateway}");
                                });
                              },
                              decoration:
                                  const InputDecoration.collapsed(hintText: ''),
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColors.tertiaryColor,
                              ),
                              iconEnabledColor: Colors.white, //Icon color
                              style: AppTextStyles.subHeadingTextStyle1,
                              dropdownColor:
                                  AppColors.white, //dropdown background color
                              isExpanded: true, //make true to make width 100%
                            ),
                          );
                        }),
                  ),
                ),
                SizedBox(height: 20.h),
                TextFormFieldWidget(
                  hintText: LanguageConstant.amount.tr,
                  controller:
                      Get.find<MakePaymentController>().amountController,
                  onChanged: (String? value) {
                    Get.find<MakePaymentController>().amountController.text ==
                        value;
                    Get.find<MakePaymentController>().update();
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return LanguageConstant.amountFieldisRequired.tr;
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 20.h),
                ButtonWidgetOne(
                    onTap: () {
                      if (walletTopUpFromKey.currentState!.validate()) {
                        // Book Appointment API Make Payment
                        postMethod(
                            context,
                            walletTopupURL,
                            {
                              "gateway": selectedPaymentGateway,
                              "amount": int.parse(
                                  Get.find<MakePaymentController>()
                                      .amountController
                                      .text)
                            },
                            true,
                            makeWalletTopupRepo);
                      }
                    },
                    buttonText: LanguageConstant.makeTopup.tr,
                    buttonTextStyle: AppTextStyles.buttonTextStyle1,
                    borderRadius: 40,
                    buttonColor: AppColors.gradientOne),
              ],
            ),
          ),
        ));
  }
}
