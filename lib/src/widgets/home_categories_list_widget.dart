import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';

import '../config/app_colors.dart';

import '../config/app_text_styles.dart';
import '../controllers/general_controller.dart';
import '../controllers/teacher_main_categories_controller.dart';

import '../routes.dart';
import 'custom_skeleton_loader.dart';

class HomeCategoriesListWidget extends StatefulWidget {
  const HomeCategoriesListWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeCategoriesListWidget> createState() =>
      _HomeCategoriesListWidgetState();
}

class _HomeCategoriesListWidgetState extends State<HomeCategoriesListWidget> {
  final logic = Get.put(TeacherMainCategoriesController());
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(builder: (generalController) {
      return GetBuilder<TeacherMainCategoriesController>(
          builder: (teacherMainCategoriesController) {
        return !teacherMainCategoriesController.teacherMainCategoriesLoader
            ? CustomHorizontalSkeletonLoader(
                containerHeight: 110.h,
                listHeight: 110.h,
                highlightColor: AppColors.grey,
                seconds: 2,
                totalCount: 5,
                containerWidth: 100.w,
              )
            : AspectRatio(
                aspectRatio: 4 / 0.5,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: 5,
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                  itemBuilder: (context, position) {
                    return InkWell(
                      onTap: () {
                        Get.toNamed(PageRoutes.subCategoriesScreen, arguments: {
                          "categoryData": teacherMainCategoriesController
                              .getTeacherMainCategoriesModel
                              .data![position]
                              .categories,
                        }, parameters: {
                          "categoryName":
                              "${teacherMainCategoriesController.getTeacherMainCategoriesModel.data![position].name}",
                          "categoryImage":
                              "${teacherMainCategoriesController.getTeacherMainCategoriesModel.data![position].image}"
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 8.h, 0, 8.h),
                        padding: const EdgeInsets.fromLTRB(19, 0, 19, 0),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 3,
                              blurRadius: 12,
                            )
                          ],
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        child: Center(
                          child: Text(
                              teacherMainCategoriesController
                                  .getTeacherMainCategoriesModel
                                  .data![position]
                                  .name
                                  .toString(),
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodyTextStyle8),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, position) {
                    return const SizedBox(width: 12);
                  },
                ),
              );
      });
    });
  }
}
