import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../multi_language/language_constants.dart';
import '../config/app_colors.dart';
import '../controllers/general_controller.dart';
import '../controllers/pusher_beams_controller.dart';
import '../controllers/sign_out_user_controller.dart';

import '../routes.dart';
import '../widgets/custom_dialog.dart';

signOutUserRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  Get.find<GeneralController>().storageBox.erase();

  Get.find<GeneralController>().storageBox.remove('userData');
  Get.find<GeneralController>().storageBox.remove('seen');
  Get.find<GeneralController>().storageBox.remove('userID');
  Get.find<GeneralController>().currentUserModel = null;

  Get.find<SignOutUserController>().updateSignOutLoaderController(false);

  Get.offAndToNamed(PageRoutes.homeScreen);
  
  try {
    Get.find<PusherBeamsController>().clearAllStatePusherBeams();
    Get.find<PusherBeamsController>().clearDeviceInterests();
  } catch (e) {
    // Ignore pusher errors on logout
  }

  Get.find<GeneralController>().updateFormLoaderController(false);
}
