import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/all_top_rated_teachers_controller.dart';
import '../models/all_top_rated_teachers_model.dart';

getAllTopRatedTeachersRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    Get.find<AllTopRatedTeachersController>().getAllTopRatedTeachersModel =
        GetAllTopRatedTeachersModel.fromJson(response);

    Get.find<AllTopRatedTeachersController>()
        .updateTopRatedTeachersLoader(true);

    // if (Get.find<AllTeachersCategoriesController>().getAllTeacherCategoriesDataModel.status == true) {
    // } else {}
  } else if (!responseCheck) {
    Get.find<AllTopRatedTeachersController>()
        .updateTopRatedTeachersLoader(true);
  }
}
