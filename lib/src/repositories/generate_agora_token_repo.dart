import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../multi_language/language_constants.dart';
import '../config/app_colors.dart';
import '../controllers/general_controller.dart';

import '../models/generate_agoratoken_model.dart';
import '../widgets/custom_dialog.dart';

getApiGenerateAgoraToken(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    Get.find<GeneralController>().generateAgoraTokenModel =
        GenerateAgoraTokenModel.fromJson(response);

    print(
        "${jsonEncode(Get.find<GeneralController>().generateAgoraTokenModel)} Generate Agora Token");
    // if (Get.find<SigninController>().signInUserModel.data!.user!.isStudent ==
    //     true) {
    //   Get.find<GeneralController>().storageBox.write(
    //       'userData',
    //       jsonEncode(
    //           Get.find<LoggedInUserController>().loggedInUserModel.data));
    //   print(
    //       "${Get.find<GeneralController>().storageBox.read('userData')} Logged In User Data Test");
    // }
    // Get.find<GeneralController>().currentUserModel ==
    //     GetLoggedInUserDataModel.fromJson(response);
    // print("${response} Logged In user repo response");
    // print(
    //     "${Get.find<GeneralController>().currentUserModel!.loginInfo!.firstName.toString()} Logged In user repo Controller Data");
    // Get.find<LoggedInUserController>().update();
  } else {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: LanguageConstant.failed.tr,
            titleColor: AppColors.customDialogErrorColor,
            descriptions:
                '${Get.find<GeneralController>().generateAgoraTokenModel.message}',
            text: LanguageConstant.ok.tr,
            functionCall: () {
              Navigator.pop(context);
            },
            img: 'assets/icons/dialog_error.png',
          );
        });
  }
}
