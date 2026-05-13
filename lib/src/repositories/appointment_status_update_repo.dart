import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/general_controller.dart';
import '../widgets/custom_snackbar_widget.dart';
import '../api_services/get_service.dart';
import '../api_services/urls.dart';
import 'student_appointment_history_repo.dart';

appointmentStatusUpdateRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  Get.find<GeneralController>().updateAppointmentStatusLoaderController(false);
  if (responseCheck) {
    if (response['success'] == true) {
      log("Appointment status updated successfully");
      showSnackBar("Success", "Appointment status updated successfully", color: Colors.green);
      // Reload history
      Get.find<GeneralController>().updateBottomNavIndex(1);
      getMethod(context, "$getStudentAppointmentHistory?page=1", null, true,
          getAllStudentAppointmentHistoryRepo);
      Get.back();
    } else {
      log("Failed to update status: ${response['message']}");
      showSnackBar("Error", response['message'] ?? "Failed to update status", color: Colors.red);
    }
  }
}
