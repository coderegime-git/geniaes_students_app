import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/general_controller.dart';
import '../widgets/custom_snackbar_widget.dart';

addAppointmentRatingRepo(BuildContext context, dynamic response) {
  Get.find<GeneralController>().updateAppointmentStatusLoaderController(false);
  if (response != null) {
    if (response['success'] == true) {
      log("Rating added successfully");
      showSnackBar("Success", "Rating added successfully", color: Colors.green);
      // Reload history to reflect changes
      Get.find<GeneralController>().updateBottomNavIndex(1);
    } else {
      log("Failed to add rating: ${response['message']}");
      showSnackBar("Error", response['message'] ?? "Failed to add rating", color: Colors.red);
    }
  }
}
