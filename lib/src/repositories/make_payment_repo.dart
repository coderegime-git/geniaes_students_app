import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';

import '../../multi_language/language_constants.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../controllers/general_controller.dart';
import '../controllers/make_payment_controller.dart';
import '../models/book_appointment_model.dart';
import '../models/book_service_model.dart';
import '../screens/webview_screen.dart';
import '../widgets/button_widget.dart';
import '../widgets/custom_dialog.dart';

makePaymentRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    Get.find<MakePaymentController>().bookAppointmentModel =
        BookAppointmentModel.fromJson(response);
    Get.to(WebViewScreen(
      urlEndPoint:
          "${Get.find<MakePaymentController>().bookAppointmentModel.data!.fundTransaction}?user_id=${Get.find<GeneralController>().storageBox.read('mainUserId')}",
      fromScreen: "Appointment Screen",
    ));
    print(
        "${Get.find<MakePaymentController>().bookAppointmentModel.data!.fundTransaction}?user_id=${Get.find<GeneralController>().storageBox.read('mainUserId')} PAYMENTURL");
    Get.find<MakePaymentController>().update();
  } else if (!responseCheck) {
    // Get.find<TeacherProfileController>().updateConsultantProfileLoader(false);
    Get.find<GeneralController>().updateFormLoaderController(false);
  }
}

makePaymentViaWalletRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    Get.find<MakePaymentController>().bookAppointmentModel =
        BookAppointmentModel.fromJson(response);
    if (response["success"] == true) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: LanguageConstant.thankYou.tr,
              titleColor: AppColors.customDialogSuccessColor,
              descriptions: response['message'].toString(),
              text: LanguageConstant.ok.tr,
              functionCall: () {
                Navigator.pop(context);
                Get.back();
              },
              img: 'assets/icons/dialog_success.png',
            );
          });
    } else {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: "Try Again",
              titleColor: AppColors.customDialogErrorColor,
              descriptions: response["message"],
              text: "Ok",
              functionCall: () {
                Get.back();
              },
              img: 'assets/icons/dialog_error.png',
            );
          });
    }

    Get.find<MakePaymentController>().update();
  } else if (!responseCheck) {
    // Get.find<TeacherProfileController>().updateConsultantProfileLoader(false);
    Get.find<GeneralController>().updateFormLoaderController(false);
  }
}

makeServicePaymentRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    Get.find<MakePaymentController>().bookServiceModel =
        BookServiceModel.fromJson(response);
    Get.to(WebViewScreen(
      urlEndPoint:
          "${Get.find<MakePaymentController>().bookServiceModel.data!.fundTransaction}?user_id=${Get.find<GeneralController>().storageBox.read('mainUserId')}",
      fromScreen: "Service Screen",
    ));
    print(
        "${Get.find<MakePaymentController>().bookServiceModel.data!.fundTransaction}?user_id=${Get.find<GeneralController>().storageBox.read('mainUserId')} PAYMENTURL");
    Get.find<MakePaymentController>().update();
  } else if (!responseCheck) {
    // Get.find<LawyerProfileController>().updateConsultantProfileLoader(false);
    Get.find<GeneralController>().updateFormLoaderController(false);
  }
}

makeServicePaymentViaWalletRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    Get.find<MakePaymentController>().bookServiceModel =
        BookServiceModel.fromJson(response);
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: LanguageConstant.thankYou.tr,
            titleColor: AppColors.customDialogSuccessColor,
            descriptions:
                LanguageConstant.yourPaymentHasBeenSuccessfullyRecieved.tr,
            text: LanguageConstant.ok.tr,
            functionCall: () {
              Navigator.pop(context);
              Get.back();
            },
            img: 'assets/icons/dialog_success.png',
          );
        });
    Get.find<MakePaymentController>().update();
  } else if (!responseCheck) {
    // Get.find<LawyerProfileController>().updateConsultantProfileLoader(false);
    Get.find<GeneralController>().updateFormLoaderController(false);
  }
}
