import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';

import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../controllers/all_events_controller.dart';
import '../controllers/general_controller.dart';
import '../routes.dart';
import 'button_widget.dart';
import 'custom_skeleton_loader.dart';

class HomeUpcomingEventsListWidget extends StatefulWidget {
  const HomeUpcomingEventsListWidget({
    Key? key,
  }) : super(key: key);

  @override
  _HomeUpcomingEventsListWidgetState createState() =>
      _HomeUpcomingEventsListWidgetState();
}

class _HomeUpcomingEventsListWidgetState
    extends State<HomeUpcomingEventsListWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(builder: (generalController) {
      return GetBuilder<AllEventsController>(builder: (allEventsController) {
        return !allEventsController.allEventsLoader
            ? CustomHorizontalSkeletonLoader(
                containerHeight: 140.h,
                listHeight: 140.h,
                highlightColor: AppColors.grey,
                seconds: 2,
                totalCount: 5,
                containerWidth: 110.w,
              )
            : allEventsController.getAllEventsModel.data!.data!.isNotEmpty
                ? AspectRatio(
                    aspectRatio: 3 / 1.6,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: allEventsController
                          .getAllEventsModel.data!.data!.length,
                      padding: EdgeInsets.fromLTRB(18.w, 0, 18.w, 0),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            generalController.updateSelectedEventForView(
                                allEventsController
                                    .getAllEventsModel.data!.data![index]);
                            Get.toNamed(PageRoutes.eventDetailScreen);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                    child: allEventsController.getAllEventsModel
                                                .data!.data![index].image !=
                                            null &&
                                        allEventsController.getAllEventsModel
                                            .data!.data![index].image!.isNotEmpty &&
                                        allEventsController.getAllEventsModel
                                                .data!.data![index].image
                                                .toString() !=
                                            'null'
                                    ? Image(
                                        image: NetworkImage(
                                            "$mediaUrl${allEventsController.getAllEventsModel.data!.data![index].image}"),
                                        width: 300.w,
                                        height: 140.h,
                                        fit: BoxFit.cover,
                                      )
                                    : Image(
                                        image: const AssetImage(
                                            'assets/images/events-image-2.png'),
                                        width: 300.w,
                                        height: 140.h,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              SizedBox(height: 8.h),
                              Padding(
                                padding: EdgeInsets.fromLTRB(8.w, 0, 0.w, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 110.w,
                                      child: Text(
                                        allEventsController.getAllEventsModel
                                            .data!.data![index].name
                                            .toString(),
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTextStyles.bodyTextStyle2,
                                      ),
                                    ),
                                    SizedBox(width: 150.w),
                                    ButtonWidgetFour(
                                      onTap: () {
                                        generalController
                                            .updateSelectedEventForView(
                                                allEventsController
                                                    .getAllEventsModel
                                                    .data!
                                                    .data![index]);
                                        Get.toNamed(
                                            PageRoutes.eventDetailScreen);
                                      },
                                      innerBorderColor: AppColors.white,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Padding(
                                padding: EdgeInsets.fromLTRB(8.w, 0, 0.w, 0),
                                child: Text(
                                  generalController.displayDateTime(
                                      allEventsController.getAllEventsModel
                                          .data!.data![index].startsAt
                                          .toString()),
                                  style: AppTextStyles.bodyTextStyle3,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, position) {
                        return SizedBox(width: 18.w);
                      },
                    ),
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
