import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';

import '../../multi_language/language_constants.dart';
import '../api_services/post_service.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../controllers/general_controller.dart';
import '../controllers/academy_reviews_controller.dart';

import '../repositories/academy_reviews_repo.dart';

import 'button_widget.dart';
import 'custom_skeleton_loader.dart';

class AcademyReviewsListWidget extends StatefulWidget {
  final String academyReviewsSlug;
  AcademyReviewsListWidget({
    super.key,
    required this.academyReviewsSlug,
  });

  @override
  State<AcademyReviewsListWidget> createState() =>
      _AcademyReviewsListWidgetState();
}

class _AcademyReviewsListWidgetState extends State<AcademyReviewsListWidget> {
  final logic = Get.put(AcademyReviewsController());

  @override
  void initState() {
    super.initState();
    postMethod(context, '$getAcademyReviews/${widget.academyReviewsSlug}', null,
        false, getAcademyReviewsRepo);
    print(
        "${logic.getAcademyReviewsModel.data?.data!.length} Academy reviews length");
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(builder: (generalController) {
      return GetBuilder<AcademyReviewsController>(
          builder: (teacherReviewsController) {
        return Scaffold(
          backgroundColor: AppColors.white,
          body: SingleChildScrollView(
            child: !teacherReviewsController.allAcademyReviewsLoader
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(0, 18, 0, 0),
                    child: CustomVerticalSkeletonLoader(
                      height: 200.h,
                      highlightColor: AppColors.grey,
                      seconds: 2,
                      totalCount: 5,
                      width: 140.w,
                    ),
                  )
                : Column(
                    children: [
                      SizedBox(height: 18.h),
                      ...List.generate(
                          teacherReviewsController.getAcademyReviewsModel.data!
                              .data!.length, (index) {
                        return Container(
                          padding: const EdgeInsets.fromLTRB(8, 14, 8, 14),
                          margin: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(12.w, 0, 6.w, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  teacherReviewsController
                                      .getAcademyReviewsModel
                                      .data!
                                      .data![index]
                                      .student!
                                      .name
                                      .toString()
                                      .capitalize!,
                                  textAlign: TextAlign.start,
                                  style: AppTextStyles.bodyTextStyle13,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Text(
                                  '${teacherReviewsController.getAcademyReviewsModel.data!.data![index].comment}',
                                  textAlign: TextAlign.start,
                                  style: AppTextStyles.bodyTextStyle9,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          RatingBar.builder(
                                            initialRating:
                                                teacherReviewsController
                                                    .getAcademyReviewsModel
                                                    .data!
                                                    .data![index]
                                                    .rating!
                                                    .toDouble(),
                                            minRating: 1,
                                            itemSize: 15.h,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            ignoreGestures: true,
                                            itemPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 0.0),
                                            itemBuilder: (context, _) =>
                                                const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (double value) {},
                                          ),
                                          SizedBox(width: 5.w),
                                          Text(
                                            // '4.5',
                                            // "${teacherReviewsController.getAcademyReviewsModel.data!.data![index].rating!}",
                                            generalController.displayDateTime(
                                                teacherReviewsController
                                                    .getAcademyReviewsModel
                                                    .data!
                                                    .data![index]
                                                    .createdAt),
                                            textAlign: TextAlign.start,
                                            style: AppTextStyles.bodyTextStyle8,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),

                      // allTeachersController
                      //         .teacherListForPagination.isNotEmpty
                      teacherReviewsController
                                  .teacherReviewsListForPagination.length !=
                              teacherReviewsController
                                  .getAcademyReviewsModel.data!.data!.length
                          ? Center(
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(0, 0, 0, 18),
                                width: MediaQuery.of(context).size.width * .35,
                                child: generalController
                                        .getPaginationProgressCheck
                                    ? Container(
                                        height: generalController
                                                .getPaginationProgressCheck
                                            ? 50.0
                                            : 0,
                                        color: Colors.transparent,
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                      )
                                    : teacherReviewsController
                                            .teacherReviewsListForPagination
                                            .isNotEmpty
                                        ? ButtonWidgetOne(
                                            buttonText:
                                                LanguageConstant.loadMore.tr,
                                            onTap: () {
                                              teacherReviewsController
                                                  .paginationDataLoad(context);
                                            },
                                            buttonTextStyle:
                                                AppTextStyles.buttonTextStyle1,
                                            borderRadius: 40,
                                            buttonColor: AppColors.gradientOne,
                                          )
                                        : const Center(
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 50, 0, 0),
                                              child: Text(
                                                "No Reviews Found",
                                                style: AppTextStyles
                                                    .bodyTextStyle2,
                                              ),
                                            ),
                                          ),
                              ),
                            )
                          : teacherReviewsController
                                  .getAcademyReviewsModel.data!.data!.isNotEmpty
                              ? const SizedBox()
                              : const Center(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                                    child: Text(
                                      "No Reviews Found",
                                      style: AppTextStyles.bodyTextStyle2,
                                    ),
                                  ),
                                ),
                    ],
                  ),
          ),
        );
      });
    });
  }
}
