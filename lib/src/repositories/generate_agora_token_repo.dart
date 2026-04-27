import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../multi_language/language_constants.dart';
import '../config/app_colors.dart';
import '../controllers/general_controller.dart';
import '../models/generate_agoratoken_model.dart';
import '../routes.dart';
import '../widgets/custom_dialog.dart';

/// Repository handler for Agora token generation for Students.
/// Fetches the token, saves it to GeneralController, and navigates to the
/// corresponding call screen based on the appointment type.
getApiGenerateAgoraToken(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  final gc = Get.find<GeneralController>();

  if (responseCheck) {
    gc.generateAgoraTokenModel = GenerateAgoraTokenModel.fromJson(response);

    if (gc.generateAgoraTokenModel.success == true) {
      log('getApiGenerateAgoraToken: Token fetched successfully');

      // 1. Save the token
      // In student model, the token is in 'data' field directly.
      gc.updateTokenForCall(gc.generateAgoraTokenModel.data);

      // 2. Navigate based on the appointment type of the selected appointment
      final typeId = gc.selectedAppointmentHistoryForView.appointmentTypeId;

      if (typeId == 1) {
        // Video Call
        Get.toNamed(PageRoutes.videoCallScreen);
      } else if (typeId == 2) {
        // Audio Call
        Get.toNamed(PageRoutes.audioCallScreen);
      } else if (typeId == 3) {
        // Chat
        Get.toNamed(PageRoutes.liveChatScreen);
      }

    } else {
      log('getApiGenerateAgoraToken: success=false – ${gc.generateAgoraTokenModel.message}');
      _showErrorDialog(context, gc.generateAgoraTokenModel.message ?? 'Unknown error');
    }
  } else {
    log('getApiGenerateAgoraToken: API request failed');
    _showErrorDialog(context, 'Failed to connect to server');
  }
}

void _showErrorDialog(BuildContext context, String message) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogBox(
          title: LanguageConstant.failed.tr,
          titleColor: AppColors.customDialogErrorColor,
          descriptions: message,
          text: LanguageConstant.ok.tr,
          functionCall: () {
            Navigator.pop(context);
          },
          img: 'assets/icons/dialog_error.png',
        );
      });
}
