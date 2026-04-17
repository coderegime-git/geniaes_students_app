import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';

import '../../multi_language/language_constants.dart';
import '../api_services/post_service.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../config/app_font.dart';
import '../config/app_text_styles.dart';
import '../controllers/general_controller.dart';
import '../controllers/teacher_podcasts_controller.dart';
import '../repositories/teacher_podcasts_repo.dart';
import 'button_widget.dart';
import 'custom_skeleton_loader.dart';

class TeacherPodcastsListWidget extends StatefulWidget {
  final String teacherPodcastsSlug;
  TeacherPodcastsListWidget({
    super.key,
    required this.teacherPodcastsSlug,
  });

  @override
  State<TeacherPodcastsListWidget> createState() =>
      _TeacherPodcastsListWidgetState();
}

class _TeacherPodcastsListWidgetState extends State<TeacherPodcastsListWidget> {
  final logic = Get.put(TeacherPodcastsController());

  @override
  void initState() {
    super.initState();
    postMethod(context, '$getTeacherPodcasts/${widget.teacherPodcastsSlug}',
        null, false, getTeacherPodcastsRepo);
    print(
        "${logic.getTeacherPodcastsModel.data?.data!.length} teacher podcasts length");
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(builder: (generalController) {
      return GetBuilder<TeacherPodcastsController>(
          builder: (teacherPodcastsController) {
        return Scaffold(
          backgroundColor: AppColors.white,
          body: SingleChildScrollView(
            child: !teacherPodcastsController.allTeacherPodcastsLoader
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
                      const SizedBox(height: 18),
                      ...List.generate(
                          teacherPodcastsController.getTeacherPodcastsModel
                              .data!.data!.length, (index) {
                        return Container(
                          padding: EdgeInsets.fromLTRB(8.w, 14.h, 8.w, 14.h),
                          margin: EdgeInsets.fromLTRB(18.w, 0, 18.w, 18.h),
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
                                  "${teacherPodcastsController.getTeacherPodcastsModel.data!.data![index].name}",
                                  textAlign: TextAlign.start,
                                  style: AppTextStyles.bodyTextStyle13,
                                ),
                                // SizedBox(
                                //   height: 10.h,
                                // ),
                                // Text(
                                //   '${teacherPodcastsController.getTeacherPodcastsModel.data!.data![index].description}',
                                //   textAlign: TextAlign.start,
                                //   style: AppTextStyles.bodyTextStyle7,
                                // ),
                                Html(
                                    data: teacherPodcastsController
                                        .getTeacherPodcastsModel
                                        .data!
                                        .data![index]
                                        .description,
                                    style: {
                                      "body": Style(
                                        fontFamily: AppFont.primaryFontFamily,
                                        fontSize: FontSize(12),
                                      ),
                                    })
                              ],
                            ),
                          ),
                        );
                      }),

                      // allTeachersController
                      //         .teacherListForPagination.isNotEmpty
                      teacherPodcastsController
                                  .teacherPodcastsListForPagination.length !=
                              teacherPodcastsController
                                  .getTeacherPodcastsModel.data!.data!.length
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
                                    : teacherPodcastsController
                                            .teacherPodcastsListForPagination
                                            .isNotEmpty
                                        ? ButtonWidgetOne(
                                            buttonText:
                                                LanguageConstant.loadMore.tr,
                                            onTap: () {
                                              teacherPodcastsController
                                                  .paginationDataLoad(context);
                                            },
                                            buttonTextStyle:
                                                AppTextStyles.buttonTextStyle1,
                                            borderRadius: 40,
                                            buttonColor: AppColors.gradientOne,
                                          )
                                        : Center(
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 50.h, 0, 0),
                                              child: Text(
                                                LanguageConstant.noDataFound.tr,
                                                style: AppTextStyles
                                                    .bodyTextStyle2,
                                              ),
                                            ),
                                          ),
                              ),
                            )
                          : teacherPodcastsController.getTeacherPodcastsModel
                                  .data!.data!.isNotEmpty
                              ? const SizedBox()
                              : Center(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 50.h, 0, 0),
                                    child: Text(
                                      LanguageConstant.noDataFound.tr,
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
