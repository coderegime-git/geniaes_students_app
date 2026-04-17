import 'package:get/get.dart';

import '../models/teacher_profile_model.dart';

class TeacherProfileController extends GetxController {
  GetTeacherProfileModel teacherProfileModel = GetTeacherProfileModel();
  bool? allteacherProfileLoader = true;

  updateTeacherProfileLoader(bool? newValue) {
    allteacherProfileLoader = newValue;
    update();
  }

  bool? loader = true;
  updateLoaderForViewProfile(bool? newValue) {
    loader = newValue;
    update();
  }
}
