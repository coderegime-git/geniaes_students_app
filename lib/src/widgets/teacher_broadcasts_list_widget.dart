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
import '../controllers/teacher_broadcasts_controller.dart';
import '../repositories/teacher_broadcasts_repo.dart';
import 'button_widget.dart';
import 'custom_skeleton_loader.dart';

class TeacherBroadcastsListWidget extends StatefulWidget {
  final String teacherBroadcastsSlug;
  TeacherBroadcastsListWidget({
    super.key,
    required this.teacherBroadcastsSlug,
  });

  @override
  State<TeacherBroadcastsListWidget> createState() =>
      _TeacherBroadcastsListWidgetState();
}

class _TeacherBroadcastsListWidgetState
    extends State<TeacherBroadcastsListWidget> {
  final logic = Get.put(TeacherBroadcastsController());

  @override
  void initState() {
    super.initState();
    postMethod(context, '$getTeacherBroadcasts/${widget.teacherBroadcastsSlug}',
        null, false, getTeacherBroadcastsRepo);
    print(
        "${logic.getTeacherBroadcastsModel.data?.data!.length} teacher Broadcasts length");
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(builder: (generalController) {
      return GetBuilder<TeacherBroadcastsController>(
          builder: (teacherBroadcastsController) {
        return Scaffold(
          backgroundColor: AppColors.bgColorTwo,
          body: SingleChildScrollView(
            child: !teacherBroadcastsController.allTeacherBroadcastsLoader
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
                          teacherBroadcastsController.getTeacherBroadcastsModel
                              .data!.data!.length, (index) {
                        return Container(
                          padding: const EdgeInsets.fromLTRB(8, 14, 8, 14),
                          margin: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12, 0, 6, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${teacherBroadcastsController.getTeacherBroadcastsModel.data!.data![index].name}",
                                  textAlign: TextAlign.start,
                                  style: AppTextStyles.bodyTextStyle13,
                                ),
                                Html(
                                    data: teacherBroadcastsController
                                        .getTeacherBroadcastsModel
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
                      teacherBroadcastsController
                                  .teacherBroadcastsListForPagination.length !=
                              teacherBroadcastsController
                                  .getTeacherBroadcastsModel.data!.data!.length
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
                                    : teacherBroadcastsController
                                            .teacherBroadcastsListForPagination
                                            .isNotEmpty
                                        ? ButtonWidgetOne(
                                            buttonText:
                                                LanguageConstant.loadMore.tr,
                                            onTap: () {
                                              teacherBroadcastsController
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
                          : teacherBroadcastsController
                                  .getTeacherBroadcastsModel
                                  .data!
                                  .data!
                                  .isNotEmpty
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
