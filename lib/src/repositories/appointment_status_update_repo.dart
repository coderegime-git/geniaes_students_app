import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../multi_language/language_constants.dart';
import '../api_services/get_service.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../controllers/general_controller.dart';
import '../widgets/custom_dialog.dart';
import 'student_appointment_history_repo.dart';

appointmentStatusUpdateRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    if (response['success'].toString() == 'true') {
      Get.find<GeneralController>()
          .updateAppointmentStatusLoaderController(false);
      Get.dialog(
        CustomDialogBox(
          title: LanguageConstant.success.tr,
          titleColor: AppColors.customDialogSuccessColor,
          descriptions: response['message'],
          text: LanguageConstant.ok.tr,
          functionCall: () {
            Get.back();
            getMethod(Get.context!, getStudentAppointmentHistory, null, false,
                getAllStudentAppointmentHistoryRepo);
          },
          img: 'assets/icons/dialog_success.png',
        ),
      );
    } else {
      Get.find<GeneralController>()
          .updateAppointmentStatusLoaderController(false);
      Get.dialog(
        CustomDialogBox(
          title: LanguageConstant.failed.tr,
          titleColor: AppColors.customDialogErrorColor,
          descriptions: response['message'],
          text: LanguageConstant.ok.tr,
          functionCall: () {
            Get.back();
          },
          img: 'assets/icons/dialog_error.png',
        ),
      );
    }
  } else {
    Get.find<GeneralController>()
        .updateAppointmentStatusLoaderController(false);
  }
}
