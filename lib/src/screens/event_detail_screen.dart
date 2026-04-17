import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:resize/resize.dart';

import '../../multi_language/language_constants.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';

import '../controllers/all_events_controller.dart';
import '../controllers/general_controller.dart';
import '../widgets/appbar_widget.dart';

// ignore: must_be_immutable
class EventDetailScreen extends StatelessWidget {
  EventDetailScreen({super.key});
  final logic = Get.put(AllEventsController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(
      builder: (generalController) {
        return GetBuilder<AllEventsController>(
          builder: (allEventsController) {
            return Scaffold(
              backgroundColor: AppColors.white,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(56),
                child: AppBarWidget(
                    leadingIcon: 'assets/icons/Expand_left.png',
                    leadingOnTap: () {
                      Get.back();
                    },
                    titleText: LanguageConstant.eventDetail.tr),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: generalController.selectedEventForView.image
                                    ?.length.toString !=
                                'null'
                            ? Image(
                                image: NetworkImage(
                                    "$mediaUrl${generalController.selectedEventForView.image}"),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 200.h,
                              )
                            : Image(
                                image: const AssetImage(
                                    "assets/images/events-image-2.png"),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                              ),
                      ),
                      SizedBox(height: 18.h),
                      Text(
                        // "Event title here Lorum Ipsum Dollar sit emit",
                        "${generalController.selectedEventForView.name}",
                        style: AppTextStyles.bodyTextStyle13,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        // "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam vitae arcu ac elit dapibus pharetra. Aliquam magna elit, porttitor a elementum Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam vitae arcu ac elit dapibus pharetra. Aliquam magna elit, porttitor a elementum Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam vitae arcu ac elit dapibus pharetra. Aliquam magna elit, porttitor a elementum Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam vitae arcu ac elit dapibus pharetra. Aliquam magna elit, porttitor a elementum",
                        "${generalController.selectedEventForView.description}",
                        style: AppTextStyles.bodyTextStyle2,
                      ),
                      SizedBox(height: 18.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.25),
                                    spreadRadius: 4,
                                    blurRadius: 15,
                                    offset: const Offset(
                                        0, 0), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.calendar_month_outlined,
                                    size: 30.h,
                                    color: AppColors.textColorOne,
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    LanguageConstant.eventStarts.tr,
                                    style: AppTextStyles.bodyTextStyle2,
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    "${DateTime.parse("${generalController.selectedEventForView.startsAt}").day}-${DateTime.parse("${generalController.selectedEventForView.startsAt}").month}-${DateTime.parse("${generalController.selectedEventForView.startsAt}").year}",
                                    style: AppTextStyles.bodyTextStyle11,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 18.w),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.25),
                                    spreadRadius: 4,
                                    blurRadius: 15,
                                    offset: const Offset(
                                        0, 0), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.calendar_month_outlined,
                                    size: 30.h,
                                    color: AppColors.textColorOne,
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    LanguageConstant.eventEnds.tr,
                                    style: AppTextStyles.bodyTextStyle2,
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    "${DateTime.parse("${generalController.selectedEventForView.endsAt}").day}-${DateTime.parse("${generalController.selectedEventForView.endsAt}").month}-${DateTime.parse("${generalController.selectedEventForView.endsAt}").year}",
                                    style: AppTextStyles.bodyTextStyle11,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 18.h),
                      Text(
                        LanguageConstant.sponsors.tr,
                        style: AppTextStyles.bodyTextStyle13,
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        padding: EdgeInsets.all(8.h),
                        decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: generalController
                                .selectedEventForView.image!.isNotEmpty
                            ? Image(
                                image: NetworkImage(
                                    "$mediaUrl${generalController.selectedEventForView.sponsor}"),
                                fit: BoxFit.cover,
                                width: 120,
                                height: 120.h,
                              )
                            : Image(
                                image: const AssetImage(
                                    "assets/images/events-image-2.png"),
                                fit: BoxFit.cover,
                                width: 80.w,
                                height: 80.h,
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
