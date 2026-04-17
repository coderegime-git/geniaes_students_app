import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';

import '../../multi_language/language_constants.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';

import '../controllers/all_events_controller.dart';
import '../controllers/general_controller.dart';

import '../routes.dart';
import '../widgets/appbar_widget.dart';
import '../widgets/button_widget.dart';
import '../widgets/custom_skeleton_loader.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => EventsScreenState();
}

class EventsScreenState extends State<EventsScreen> {
  final logic = Get.put(AllEventsController());
  // final List numbers = List.generate(30, (index) => "Item $index");

  @override
  void initState() {
    super.initState();
    // postMethod(context, '$getAllEvents?page=1', null, false, getAllEventsRepo);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(builder: (generalController) {
      return GetBuilder<AllEventsController>(builder: (allEventsController) {
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: AppBarWidget(
                leadingIcon: 'assets/icons/Expand_left.png',
                leadingOnTap: () {
                  Get.back();
                },
                titleText: LanguageConstant.events.tr),
          ),
          body: !allEventsController.allEventsLoader
              ? const CustomGridViewSkeletonLoader(
                  highlightColor: AppColors.grey,
                  seconds: 2,
                  totalCount: 5,
                  aspectRatio: 0.9,
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      GridView.count(
                        padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                        crossAxisCount: 2,
                        crossAxisSpacing: 18.0,
                        mainAxisSpacing: 12.0,
                        childAspectRatio: 0.85,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: List.generate(
                          allEventsController.eventsListForPagination.length,
                          (index) {
                            return InkWell(
                              onTap: () {
                                generalController.updateSelectedEventForView(
                                    allEventsController
                                        .eventsListForPagination[index]);

                                Get.toNamed(PageRoutes.eventDetailScreen);
                              },
                              child: Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0.h),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 4,
                                      blurRadius: 15,
                                      offset: const Offset(
                                          0, 0), // changes position of shadow
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(18),
                                        // ignore: unrelated_type_equality_checks
                                        child: allEventsController
                                                    .eventsListForPagination[
                                                        index]
                                                    .image
                                                    ?.length
                                                    .toString !=
                                                'null'
                                            ? Image(
                                                image: NetworkImage(
                                                    "$mediaUrl${allEventsController.eventsListForPagination[index].image}"),
                                                fit: BoxFit.cover,
                                                height: 110.h,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                              )
                                            : Image(
                                                image: const AssetImage(
                                                    'assets/images/events-image-2.png'),
                                                fit: BoxFit.cover,
                                                height: 110.h,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                              ),
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          4.w, 2.h, 4.w, 2.h),
                                      child: Text(
                                        // "Event title here",
                                        "${allEventsController.eventsListForPagination[index].name}",
                                        textAlign: TextAlign.start,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTextStyles.bodyTextStyle12,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(4.w, 0, 4.w, 2.h),
                                      child: Text(
                                        // "25th March, 2023",
                                        "${allEventsController.eventsListForPagination[index].createdAt?.split(",").first}",
                                        textAlign: TextAlign.start,
                                        style: AppTextStyles.bodyTextStyle3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      allEventsController.eventsListForPagination.length ==
                                  allEventsController
                                      .getAllEventsModel.data!.data!.length &&
                              allEventsController.getAllEventsModel.data!.meta!
                                      .currentPage !=
                                  allEventsController
                                      .getAllEventsModel.data!.meta!.lastPage
                          ? Container(
                              margin: EdgeInsets.fromLTRB(0, 18.h, 0, 18.h),
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
                                  : ButtonWidgetOne(
                                      buttonText: LanguageConstant.loadMore.tr,
                                      onTap: () {
                                        allEventsController
                                            .paginationDataLoad(context);
                                      },
                                      buttonTextStyle:
                                          AppTextStyles.buttonTextStyle1,
                                      borderRadius: 40,
                                      buttonColor: AppColors.gradientOne,
                                    ))
                          : const SizedBox(),
                    ],
                  ),
                ),
        );
      });
    });
  }
}
