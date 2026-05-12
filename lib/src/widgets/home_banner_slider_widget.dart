import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../controllers/all_featured_teachers_controller.dart';
import '../controllers/general_controller.dart';
import '../routes.dart';
import 'custom_skeleton_loader.dart';
import 'premier_teacher_card_widget.dart';

class HomePremierTeacherSliderWidget extends StatefulWidget {
  HomePremierTeacherSliderWidget({Key? key}) : super(key: key);

  @override
  State<HomePremierTeacherSliderWidget> createState() =>
      _HomePremierTeacherSliderWidgetState();
}

class _HomePremierTeacherSliderWidgetState
    extends State<HomePremierTeacherSliderWidget> {
  final CarouselSliderController _controller = CarouselSliderController();

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
        height: 110.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          'assets/images/teacher-image.png',
          height: 110.h,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Image.asset(
        'assets/images/teacher-image.png',
        height: 110.h,
        fit: BoxFit.cover,
      );
    }
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
            : ClipRect(
                child: CarouselSlider(
                  items: List.generate(
                    allFeaturedTeachersController
                        .getAllFeaturedTeachersModel.data!.length,
                    (index) {
                      final teacher = allFeaturedTeachersController
                          .getAllFeaturedTeachersModel.data![index];

                      return PremierTeacherCardWidget(
                        // ✅ Fixed: constrained width + proper null/URL handling
                        teacherImage: SizedBox(
                          width: 100.w,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: _buildTeacherImage(teacher.image),
                          ),
                        ),
                        teacherName: teacher.name ?? '',
                        categories: SizedBox(
                          height: 16.h,
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            physics: const NeverScrollableScrollPhysics(),
                            children: List.generate(
                              teacher.teacherCategories?.length ?? 0,
                              (index1) {
                                return Text(
                                  "${teacher.teacherCategories![index1].name} | ",
                                  textAlign: TextAlign.start,
                                  style: AppTextStyles.bodyTextStyle7,
                                );
                              },
                            ),
                          ),
                        ),
                        teacherRating: "(${teacher.rating ?? 0})",
                        initRating: (teacher.rating ?? 0).toDouble(),
                        onTap: () {
                          generalController
                              .updateSelectedTeacherForView(teacher);
                          Get.toNamed(PageRoutes.teacherProfileScreen);
                        },
                      );
                    },
                  ),
                  carouselController: _controller,
                  options: CarouselOptions(
                    autoPlay: false,
                    height: 200.h,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.2,
                    viewportFraction: 0.85,
                    enlargeStrategy: CenterPageEnlargeStrategy.scale,
                    onPageChanged: (index, reason) {
                      setState(() {});
                    },
                  ),
                ),
              );
      });
    });
  }
}
