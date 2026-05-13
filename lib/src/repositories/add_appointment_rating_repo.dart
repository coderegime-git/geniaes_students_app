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
      
      // Update local state to reflect rating added
      var generalController = Get.find<GeneralController>();
      generalController.updateSelectedAppointmentHistoryForView(
        generalController.selectedAppointmentHistoryForView.copyWith(
          isRating: 1,
          // We assume the response data might contain the rating/comment or we just mark as rated
          rating: response['data'] != null ? response['data']['rating'] : null,
          comment: response['data'] != null ? response['data']['comment'] : null,
        )
      );

      // Reload history to reflect changes in the background
      getMethod(context, "$getStudentAppointmentHistory?page=1", null, true,
          getAllStudentAppointmentHistoryRepo);
    } else {
      log("Failed to add rating: ${response['message']}");
      showSnackBar("Error", response['message'] ?? "Failed to add rating", color: Colors.red);
    }
  }
}
