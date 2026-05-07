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

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(builder: (generalController) {
      final double screenWidth = MediaQuery.of(context).size.width;

      // Logic: On wide screens, use a wider ratio to keep height in check.
      // Phone (~400px width) -> 2.2 ratio -> ~180px height
      // iPad (~1024px width) -> 5.0 ratio -> ~200px height
      final double dynamicRatio = screenWidth > 600 ? 5.0 : 2.2;
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
                      return PremierTeacherCardWidget(
                        teacherImage: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: allFeaturedTeachersController
                                              .getAllFeaturedTeachersModel
                                              .data![index]
                                              .image !=
                                          null &&
                                      allFeaturedTeachersController
                                          .getAllFeaturedTeachersModel
                                          .data![index]
                                          .image!
                                          .isNotEmpty &&
                                      allFeaturedTeachersController
                                              .getAllFeaturedTeachersModel
                                              .data![index]
                                              .image
                                              .toString() !=
                                          'null'
                                  ? Image(
                                      image: NetworkImage(
                                          "$mediaUrl${allFeaturedTeachersController.getAllFeaturedTeachersModel.data![index].image}"),
                                      height: 110.h,
                                    )
                              : Image(
                                  image: const AssetImage(
                                      'assets/images/teacher-image.png'),
                                  height: 110.h,
                                ),
                        ),
                        teacherName:
                            "${allFeaturedTeachersController.getAllFeaturedTeachersModel.data![index].name}",
                        categories: SizedBox(
                          height: 16.h,
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            physics: const NeverScrollableScrollPhysics(),
                            children: List.generate(
                              allFeaturedTeachersController
                                  .getAllFeaturedTeachersModel
                                  .data![index]
                                  .teacherCategories!
                                  .length,
                              (index1) {
                                return Text(
                                  "${allFeaturedTeachersController.getAllFeaturedTeachersModel.data![index].teacherCategories![index1].name} | ",
                                  textAlign: TextAlign.start,
                                  style: AppTextStyles.bodyTextStyle7,
                                );
                              },
                            ),
                          ),
                        ),
                        teacherRating:
                            "(${allFeaturedTeachersController.getAllFeaturedTeachersModel.data![index].rating})",
                        initRating: allFeaturedTeachersController
                            .getAllFeaturedTeachersModel.data![index].rating!
                            .toDouble(),
                        onTap: () {
                          generalController.updateSelectedTeacherForView(
                              allFeaturedTeachersController
                                  .getAllFeaturedTeachersModel.data![index]);
              
                          Get.toNamed(PageRoutes.teacherProfileScreen);
                        },
                      );
                    },
                  ),
                  carouselController: _controller,
                  options: CarouselOptions(
                      autoPlay: false,
                      height: 200.h, // explicit height instead of aspectRatio
                      enlargeCenterPage: true,
                      enlargeFactor: 0.2, // reduce from 0.5 to prevent overflow
                      viewportFraction: 0.85,
                      enlargeStrategy:
                          CenterPageEnlargeStrategy.scale, // use height strategy
                      onPageChanged: (index, reason) {
                        setState(() {});
                      }),
                ),
            );
      });
    });
  }
}
