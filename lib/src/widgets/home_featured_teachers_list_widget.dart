import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';

import '../controllers/all_featured_teachers_controller.dart';
import '../controllers/all_teachers_controller.dart';
import '../controllers/general_controller.dart';

import '../routes.dart';

import 'custom_skeleton_loader.dart';
import 'home_teacher_card_widget.dart';

class HomeFeaturedTeachersListWidget extends StatefulWidget {
  const HomeFeaturedTeachersListWidget({
    Key? key,
  }) : super(key: key);

  @override
  _HomeFeaturedTeachersListWidgetState createState() =>
      _HomeFeaturedTeachersListWidgetState();
}

class _HomeFeaturedTeachersListWidgetState
    extends State<HomeFeaturedTeachersListWidget> {
  final logic = Get.put(AllFeaturedTeachersController());
  final allTeacherslogic = Get.put(AllTeachersController());

  // ✅ Safely builds image URL — avoids null and double-slash issues
  String? _buildImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty || imagePath == 'null') {
      return null;
    }
    final base = mediaUrl.endsWith('/') ? mediaUrl : '$mediaUrl/';
    final path = imagePath.startsWith('/') ? imagePath.substring(1) : imagePath;
    return '$base$path';
  }

  // ✅ Returns correct image widget — network or asset fallback
  Widget _buildTeacherImage(String? imagePath) {
    final url = _buildImageUrl(imagePath);
    if (url != null) {
      return Image.network(
        url,
        height: 150.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          'assets/images/teacher-image.png',
          height: 150.h,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Image.asset(
        'assets/images/teacher-image.png',
        height: 150.h,
        fit: BoxFit.cover,
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(builder: (generalController) {
      return GetBuilder<AllFeaturedTeachersController>(
          builder: (allFeaturedTeachersController) {
        return !allFeaturedTeachersController.featuredTeachersLoader
            ? CustomHorizontalSkeletonLoader(
                containerHeight: 140.h,
                listHeight: 140.h,
                highlightColor: AppColors.grey,
                seconds: 2,
                totalCount: 5,
                containerWidth: 200.w,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 3 / 1.92,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: allFeaturedTeachersController
                          .getAllFeaturedTeachersModel.data!.length,
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                      itemBuilder: (context, index) {
                        final teacher = allFeaturedTeachersController
                            .getAllFeaturedTeachersModel.data![index];

                        return HomeTeacherCardWidget(
                          // ✅ Fixed: proper null check + safe URL + error fallback
                          image: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: _buildTeacherImage(teacher.image),
                          ),
                          name: teacher.name ?? '',
                          categoryName: 'Math',
                          premiumImage: Image.asset(
                            "assets/icons/premium_star.png",
                          ),
                          onSearchTap: () {
                            generalController
                                .updateSelectedTeacherForView(teacher);
                            Get.toNamed(PageRoutes.teacherProfileScreen);
                          },
                        );
                      },
                      separatorBuilder: (context, position) {
                        return const SizedBox(width: 18);
                      },
                    ),
                  ),
                ],
              );
      });
    });
  }
}
