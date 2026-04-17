import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/all_teacher_categories_controller.dart';
import '../models/all_teacher_categories_model.dart';

getAllTeacherCategoriesRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    Get.find<AllTeachersCategoriesController>().getAllTeacherCategoriesModel =
        GetAllTeacherCategoriesModel.fromJson(response);

    Get.find<AllTeachersCategoriesController>()
        .updateteacherCategoriesLoader(true);

    // if (Get.find<AllTeachersCategoriesController>().getAllTeacherCategoriesDataModel.status == true) {
    // } else {}
  } else if (!responseCheck) {
    Get.find<AllTeachersCategoriesController>()
        .updateteacherCategoriesLoader(true);
  }
}
