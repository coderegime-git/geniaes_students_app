import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/general_controller.dart';
import '../widgets/custom_snackbar_widget.dart';

appointmentStatusUpdateRepo(BuildContext context, dynamic response) {
  Get.find<GeneralController>().updateAppointmentStatusLoaderController(false);
  if (response != null) {
    if (response['success'] == true) {
      log("Appointment status updated successfully");
      showSnackBar("Success", "Appointment status updated successfully", color: Colors.green);
      // Reload history
      Get.find<GeneralController>().updateBottomNavIndex(1);
    } else {
      log("Failed to update status: ${response['message']}");
      showSnackBar("Error", response['message'] ?? "Failed to update status", color: Colors.red);
    }
  }
}
