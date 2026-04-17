import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../multi_language/language_constants.dart';
import '../config/app_colors.dart';
import '../controllers/general_controller.dart';

import '../controllers/signin_controller.dart';
import '../widgets/custom_dialog.dart';

loggedInUserRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    print(
        "${jsonEncode(Get.find<GeneralController>().currentUserModel)} Logged In User Data Test");
  } else {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: LanguageConstant.pleaseTryAgain.tr,
            titleColor: AppColors.customDialogErrorColor,
            descriptions:
                '${Get.find<SigninController>().signInUserModel.message}',
            text: LanguageConstant.ok.tr,
            functionCall: () {
              Navigator.pop(context);
            },
            img: 'assets/icons/dialog_error.png',
          );
        });
  }
}
