import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';

import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../controllers/all_academies_controller.dart';
import '../controllers/general_controller.dart';

import '../routes.dart';
import 'custom_skeleton_loader.dart';

class HomeAcademiesListWidget extends StatefulWidget {
  const HomeAcademiesListWidget({
    Key? key,
  }) : super(key: key);

  @override
  _HomeAcademiesListWidgetState createState() =>
      _HomeAcademiesListWidgetState();
}

class _HomeAcademiesListWidgetState extends State<HomeAcademiesListWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(builder: (generalController) {
      return GetBuilder<AllAcademiesController>(
          builder: (allAcademiesController) {
        return !allAcademiesController.allAcademiesLoader
            ? CustomHorizontalSkeletonLoader(
                containerHeight: 140.h,
                listHeight: 140.h,
                highlightColor: AppColors.grey,
                seconds: 2,
                totalCount: 5,
                containerWidth: 110.w,
              )
            : allAcademiesController.getAllAcademiesModel.data!.data!.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AspectRatio(
                        aspectRatio: 3 / 0.6,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: allAcademiesController
                              .getAllAcademiesModel.data!.data!.length,
                          padding: EdgeInsets.fromLTRB(18.w, 0, 18.w, 0),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                generalController.updateSelectedAcademyForView(
                                    allAcademiesController.getAllAcademiesModel
                                        .data!.data![index]);
                                Get.toNamed(PageRoutes.academyProfileScreen);
                              },
                              child: Container(
                                margin: EdgeInsets.fromLTRB(0, 10.h, 0, 10.h),
                                padding:
                                    EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 8.h),
                                decoration: BoxDecoration(
                                    color: AppColors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 5,
                                        blurRadius: 10,
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: allAcademiesController
                                                      .getAllAcademiesModel
                                                      .data!
                                                      .data![index]
                                                      .image !=
                                                  null &&
                                              allAcademiesController
                                                  .getAllAcademiesModel
                                                  .data!
                                                  .data![index]
                                                  .image!
                                                  .isNotEmpty
                                          ? Image(
                                              image: NetworkImage(
                                                  "$mediaUrl${allAcademiesController.getAllAcademiesModel.data!.data![index].image}"),
                                              height: 60.h,
                                            )
                                          : Image(
                                              image: const AssetImage(
                                                  'assets/images/events-image-2.png'),
                                              height: 60.h,
                                            ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Text(
                                      allAcademiesController
                                          .getAllAcademiesModel
                                          .data!
                                          .data![index]
                                          .name!,
                                      style: AppTextStyles.bodyTextStyle9,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, position) {
                            return SizedBox(width: 18.w);
                          },
                        ),
                      ),
                    ],
                  )
                : const SizedBox(
                    child: Center(
                      child: Text(
                        "No Data Found",
                        style: AppTextStyles.bodyTextStyle13,
                      ),
                    ),
                  );
      });
    });
  }
}
