import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../multi_language/language_constants.dart';
import '../config/app_colors.dart';
import '../controllers/general_controller.dart';

import '../widgets/custom_dialog.dart';

forgotPasswordRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    if (response["success"] == true) {
    } else {
      Get.find<GeneralController>().updateFormLoaderController(false);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: LanguageConstant.pleaseTryAgain.tr,
              titleColor: AppColors.customDialogErrorColor,
              descriptions: '${response["message"]}',
              text: LanguageConstant.ok.tr,
              functionCall: () {
                Navigator.pop(context);
              },
              img: 'assets/icons/dialog_error.png',
            );
          });
    }
  } else if (!responseCheck) {
    Get.find<GeneralController>().updateFormLoaderController(false);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: LanguageConstant.pleaseTryAgain.tr,
            titleColor: AppColors.customDialogErrorColor,
            descriptions: '${response["message"]}!',
            text: LanguageConstant.ok.tr,
            functionCall: () {
              Navigator.pop(context);
            },
            img: 'assets/icons/dialog_error.png',
          );
        });
  }
}
