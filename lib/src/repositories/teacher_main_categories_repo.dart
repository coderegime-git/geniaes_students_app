import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/teacher_main_categories_controller.dart';
import '../models/teacher_main_categories_model.dart';

getTeacherMainCategoriesRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    if (!Get.isRegistered<TeacherMainCategoriesController>()) {
      Get.put(TeacherMainCategoriesController());
    }
    Get.find<TeacherMainCategoriesController>().getTeacherMainCategoriesModel =
        GetTeacherMainCategoriesModel.fromJson(response);

    Get.find<TeacherMainCategoriesController>()
        .updateteacherMainCategoriesLoader(true);

    // if (Get.find<TeacherMainCategoriesController>().getAllTeacherCategoriesDataModel.status == true) {
    // } else {}
  } else if (!responseCheck) {
    Get.find<TeacherMainCategoriesController>()
        .updateteacherMainCategoriesLoader(true);
  }
}
