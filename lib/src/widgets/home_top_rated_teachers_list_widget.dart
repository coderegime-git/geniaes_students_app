import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../controllers/all_teachers_controller.dart';
import '../controllers/all_top_rated_teachers_controller.dart';
import '../controllers/general_controller.dart';

import '../routes.dart';
import 'custom_skeleton_loader.dart';
import 'home_teacher_card_widget.dart';

class HomeTopRatedTeachersListWidget extends StatefulWidget {
  const HomeTopRatedTeachersListWidget({
    Key? key,
  }) : super(key: key);

  @override
  _HomeTopRatedTeachersListWidgetState createState() =>
      _HomeTopRatedTeachersListWidgetState();
}

class _HomeTopRatedTeachersListWidgetState
    extends State<HomeTopRatedTeachersListWidget> {
  final logic = Get.put(AllTopRatedTeachersController());
  final allTeacherslogic = Get.put(AllTeachersController());

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
      return GetBuilder<AllTopRatedTeachersController>(
          builder: (allTopRatedTeachersController) {
        return !allTopRatedTeachersController.topRatedTeachersLoader
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
                      itemCount: allTopRatedTeachersController
                          .getAllTopRatedTeachersModel.data!.length,
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                      itemBuilder: (context, index) {
                        return HomeTeacherCardWidget(
                          image: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            // ignore: unrelated_type_equality_checks
                            child: allTopRatedTeachersController
                                        .getAllTopRatedTeachersModel
                                        .data![index]
                                        .image !=
                                    null &&
                                allTopRatedTeachersController
                                    .getAllTopRatedTeachersModel
                                    .data![index]
                                    .image!
                                    .isNotEmpty
                                ? Image(
                                    image: NetworkImage(
                                        "$mediaUrl${allTopRatedTeachersController.getAllTopRatedTeachersModel.data![index].image}"),
                                    height: 150.h,
                                  )
                                : Image(
                                    image: const AssetImage(
                                        'assets/images/teacher-image.png'),
                                    height: 150.h,
                                  ),
                          ),
                          name: allTopRatedTeachersController
                              .getAllTopRatedTeachersModel.data![index].name
                              .toString(),
                          categoryName: 'Math',
                          premiumImage: Image.asset(
                            "assets/icons/premium_star.png",
                          ),
                          onSearchTap: () {
                            generalController.updateSelectedTeacherForView(
                                allTopRatedTeachersController
                                    .getAllTopRatedTeachersModel.data![index]);

                            Get.toNamed(PageRoutes.teacherProfileScreen);
                          },
                        );
                        // return Container(
                        //   padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                        //   decoration: BoxDecoration(
                        //     border: Border.all(color: AppColors.primaryColor),
                        //     borderRadius: BorderRadius.circular(18),
                        //   ),
                        //   child: Row(
                        //     mainAxisSize: MainAxisSize.min,
                        //     children: [
                        //       ClipRRect(
                        //         borderRadius: BorderRadius.circular(18),
                        //         // ignore: unrelated_type_equality_checks
                        // child: allTopRatedTeachersController
                        //             .getAllTopRatedTeachersModel
                        //             .data![index]
                        //             .image
                        //             ?.length !=
                        //                 null
                        //             ? Image(
                        //                 image: NetworkImage(
                        //                     "$mediaUrl${allTopRatedTeachersController.getAllTopRatedTeachersModel.data![index].image}"),
                        //               )
                        //             : const Image(
                        //                 image: AssetImage(
                        //                     'assets/images/teacher-image.png'),
                        //               ),
                        //       ),
                        //       Padding(
                        //         padding:
                        //             const EdgeInsets.fromLTRB(14, 0, 14, 0),
                        //         child: Column(
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           children: [
                        //             const SizedBox(
                        //               height: 10,
                        //             ),
                        //             Text(
                        //               // "Jhon Doe",
                        //               allTopRatedTeachersController
                        //                   .getAllTopRatedTeachersModel
                        //                   .data![index]
                        //                   .name
                        //                   .toString(),
                        //               textAlign: TextAlign.start,
                        //               style: AppTextStyles.bodyTextStyle2,
                        //             ),
                        //             SizedBox(
                        //               height: 10.h,
                        //             ),
                        //             SizedBox(
                        //               height: 15.h,
                        //               width: 120.w,
                        //               child: ListView(
                        //                 shrinkWrap: true,
                        //                 scrollDirection: Axis.horizontal,
                        //                 physics:
                        //                     const NeverScrollableScrollPhysics(),
                        //                 children: List.generate(
                        //                     allTopRatedTeachersController
                        //                         .getAllTopRatedTeachersModel
                        //                         .data![index]
                        //                         .teacherCategories!
                        //                         .length, (index1) {
                        //                   return Text(
                        //                     "${allTopRatedTeachersController.getAllTopRatedTeachersModel.data![index].teacherCategories![index1].name} | ",
                        //                     textAlign: TextAlign.start,
                        //                     style: AppTextStyles.bodyTextStyle3,
                        //                   );
                        //                 }),
                        //               ),
                        //             ),
                        //             SizedBox(
                        //               height: 10.h,
                        //             ),
                        //             SizedBox(
                        //               width: 120.w,
                        //               child: Text(
                        //                 allTopRatedTeachersController
                        //                             .getAllTopRatedTeachersModel
                        //                             .data![index]
                        //                             .description !=
                        //                         null
                        //                     ? allTopRatedTeachersController
                        //                         .getAllTopRatedTeachersModel
                        //                         .data![index]
                        //                         .description
                        //                         .toString()
                        //                     : "",
                        //                 textAlign: TextAlign.start,
                        //                 softWrap: true,
                        //                 overflow: TextOverflow.ellipsis,
                        //                 maxLines: 2,
                        //                 style: AppTextStyles.bodyTextStyle4,
                        //               ),
                        //             ),
                        //             Padding(
                        //               padding: const EdgeInsets.fromLTRB(
                        //                   0, 12, 0, 8),
                        //               child: ButtonWidgetOne(
                        //                 buttonText: 'Book Now',
                        //                 onTap: () {
                        // generalController
                        //     .updateSelectedTeacherForView(
                        //         allTopRatedTeachersController
                        //             .getAllTopRatedTeachersModel
                        //             .data![index]);

                        // Get.toNamed(
                        //     PageRoutes.teacherProfileScreen);
                        //                 },
                        //                 buttonTextStyle:
                        //                     AppTextStyles.buttonTextStyle6,
                        //                 borderRadius: 5,
                        //                 buttonColor: AppColors.gradientOne,
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       )
                        //     ],
                        //   ),
                        // );
                      },
                      separatorBuilder: (context, position) {
                        return SizedBox(width: 18.w);
                      },
                    ),
                  ),
                ],
              );
      });
    });
  }
}
