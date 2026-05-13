import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/general_controller.dart';
import '../widgets/custom_snackbar_widget.dart';
import '../api_services/get_service.dart';
import '../api_services/urls.dart';
import 'student_appointment_history_repo.dart';

addAppointmentRatingRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  Get.find<GeneralController>().updateAppointmentStatusLoaderController(false);
  if (responseCheck) {
    if (response['success'] == true) {
      log("Rating added successfully");
      showSnackBar("Success", "Rating added successfully", color: Colors.green);
      // Reload history to reflect changes
      Get.find<GeneralController>().updateBottomNavIndex(1);
      getMethod(context, "$getStudentAppointmentHistory?page=1", null, true,
          getAllStudentAppointmentHistoryRepo);
      Get.back();
    } else {
      log("Failed to add rating: ${response['message']}");
      showSnackBar("Error", response['message'] ?? "Failed to add rating", color: Colors.red);
    }
  }
}
