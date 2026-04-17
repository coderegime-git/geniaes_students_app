import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/general_controller.dart';
import '../controllers/teacher_profile_controller.dart';
import '../models/teacher_profile_model.dart';

getTeacherProfileRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    Get.find<TeacherProfileController>().teacherProfileModel =
        GetTeacherProfileModel.fromJson(response);
    Get.find<TeacherProfileController>().update();
  } else if (!responseCheck) {
    // Get.find<TeacherProfileController>().updateConsultantProfileLoader(false);
    Get.find<GeneralController>().updateFormLoaderController(false);
  }
}
