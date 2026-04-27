import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:resize/resize.dart';

import '../../multi_language/language_constants.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../controllers/all_settings_controller.dart';
import '../controllers/general_controller.dart';

import '../controllers/live_chat_controller.dart';
import '../routes.dart';
import '../widgets/appbar_widget.dart';
import '../widgets/button_widget.dart';
import '../api_services/get_service.dart';
import '../repositories/generate_agora_token_repo.dart';

class AppointmentDetailScreen extends StatefulWidget {
  const AppointmentDetailScreen({super.key});

  @override
  State<AppointmentDetailScreen> createState() =>
      AppointmentDetailScreenState();
}

class AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  final liveChatLogic = Get.put(LiveChatController());
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(builder: (generalController) {
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: AppBarWidget(
            leadingIcon: 'assets/icons/Expand_left.png',
            leadingOnTap: () {
              Get.back();
            },
            titleText: LanguageConstant.appointmentDetail.tr,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(18.w, 0, 18.w, 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: generalController
                                    .selectedAppointmentHistoryForView
                                    .teacherImage !=
                                null
                            ? Image(
                                image: NetworkImage(
                                    "$mediaUrl${generalController.selectedAppointmentHistoryForView.teacherImage!}"),
                                height: 110.h,
                              )
                            : Image(
                                image: const AssetImage(
                                    'assets/images/teacher-image.png'),
                                height: 110.h,
                              ),
                      ),
                      SizedBox(width: 10.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            // "Jhon Doe",
                            generalController
                                .selectedAppointmentHistoryForView.teacherName ?? "Teacher",
                            textAlign: TextAlign.start,
                            style: AppTextStyles.bodyTextStyle14,
                          ),
                          SizedBox(height: 18.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                LanguageConstant.appointmentType.tr,
                                textAlign: TextAlign.start,
                                style: AppTextStyles.bodyTextStyle13,
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                generalController
                                    .selectedAppointmentHistoryForView
                                    .appointmentTypeName ?? "",
                                textAlign: TextAlign.start,
                                style: AppTextStyles.bodyTextStyle9,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 50.h),
                    decoration: BoxDecoration(
                        color: generalController
                                    .selectedAppointmentHistoryForView
                                    .appointmentStatusCode! ==
                                1
                            ? AppColors.beigeColor
                            : generalController
                                        .selectedAppointmentHistoryForView
                                        .appointmentStatusCode! ==
                                    5
                                ? AppColors.green.withOpacity(0.5)
                                : generalController
                                            .selectedAppointmentHistoryForView
                                            .appointmentStatusCode! ==
                                        2
                                    ? AppColors.orange.withOpacity(0.7)
                                    : AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      // "Pending",
                      generalController.selectedAppointmentHistoryForView
                          .appointmentStatusName ?? "",
                      style: AppTextStyles.bodyTextStyle4,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
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
                          SizedBox(height: 6.h),
                          Text(
                            LanguageConstant.date.tr,
                            style: AppTextStyles.headingTextStyle3,
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            // "Appointment Type",
                            "${generalController.selectedAppointmentHistoryForView.date ?? ""}",
                            style: AppTextStyles.bodyTextStyle11,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 18.w),
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
                      width: MediaQuery.of(context).size.width,
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
                            Icons.access_time,
                            size: 30.h,
                            color: AppColors.textColorOne,
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            LanguageConstant.callTime.tr,
                            style: AppTextStyles.headingTextStyle3,
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            // "Appointment Type",
                            "${generalController.selectedAppointmentHistoryForView.startTime ?? ""} - ${generalController.selectedAppointmentHistoryForView.endTime ?? ""}",
                            style: AppTextStyles.bodyTextStyle11,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
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
                          Text(
                            Get.find<GetAllSettingsController>()
                                .getDefaultCurrencySymbol(),
                            style: AppTextStyles.headingTextStyle4,
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            LanguageConstant.fee.tr,
                            style: AppTextStyles.headingTextStyle3,
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            // "Appointment Type",
                            Get.find<GetAllSettingsController>()
                                .getDisplayAmount(int.parse(generalController
                                    .selectedAppointmentHistoryForView.fee
                                    .toString())),
                            style: AppTextStyles.bodyTextStyle11,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 18.w),
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
                      width: MediaQuery.of(context).size.width,
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
                            Icons.access_time,
                            size: 30.h,
                            color: AppColors.textColorOne,
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            LanguageConstant.callDuration.tr,
                            style: AppTextStyles.headingTextStyle3,
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            // "Appointment Type",
                            "${generalController.selectedAppointmentHistoryForView.startTime ?? ""} - ${generalController.selectedAppointmentHistoryForView.endTime ?? ""}",
                            style: AppTextStyles.bodyTextStyle11,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.fromLTRB(14.w, 17.h, 14.w, 17.h),
                margin: EdgeInsets.only(bottom: 18.h, top: 18.h),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.25),
                      spreadRadius: 4,
                      blurRadius: 15,
                      offset: const Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LanguageConstant.questions.tr,
                      style: AppTextStyles.headingTextStyle5,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      generalController
                          .selectedAppointmentHistoryForView.question ?? "",
                      style: AppTextStyles.bodyTextStyle7,
                    ),
                    SizedBox(height: 18.h),
                    Text(
                      LanguageConstant.paymentStatus.tr,
                      style: AppTextStyles.headingTextStyle5,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      generalController
                                  .selectedAppointmentHistoryForView.isPaid ==
                              1
                          ? LanguageConstant.paid.tr
                          : LanguageConstant.notPaid.tr,
                      style: AppTextStyles.bodyTextStyle7,
                    ),
                    SizedBox(height: 18.h),
                    Text(
                      LanguageConstant.attachments.tr,
                      style: AppTextStyles.headingTextStyle5,
                    ),
                    SizedBox(height: 6.h),
                    const Text(
                      "",
                      // generalController
                      //     .selectedAppointmentHistoryForView.attachmentUrl!
                      //     .toString(),
                      style: AppTextStyles.bodyTextStyle7,
                    ),
                  ],
                ),
              ),
              generalController.selectedAppointmentHistoryForView
                              .appointmentStatusCode ==
                          2
                  ? Column(
                      children: [
                        generalController.selectedAppointmentHistoryForView
                                    .appointmentTypeId ==
                                1
                            ? ButtonWidgetOne(
                                onTap: () {
                                  final apptId = generalController
                                      .selectedAppointmentHistoryForView.id;
                                  final channel = "appt_$apptId";
                                  generalController
                                      .updateChannelForCall(channel);
                                  generalController.updateCallerType(2);

                                  // Dummy token for testing
                                  String dummyToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIzIiwianRpIjoiNjI2OTE3NmQwYzRiOTgzZDFiNzUxZTA1MTcxYzkyN2FiNjE4OTNjNGI3ZTk4YzBhM2U5Mjc4OGNiZDVhYThhZjZjNjA2YjEwNzhkY2U5ZWIiLCJpYXQiOjE3NzY4MzkzMjEuMzE0MDE0LCJuYmYiOjE3NzY4MzkzMjEuMzE0MDE3LCJleHAiOjE4MDgzNzUzMjEuMjk5MTk1LCJzdWIiOiIzMzAiLCJzY29wZXMiOltdfQ.myfmSMF9ZVnGbwGquvCvcA0eY0iaELcTaqF7zUkq-_CXTT3BtvRc3MKzNn-B7emCB6yNcJzyNXi-4uonxzp0usrblJi4MqMrUoRDf2oPeIlj-GYvHlbQR9urboojYWDcdflyEYABR3zPIUF7i0SRBixAnbRnh6tYgB0vXQQ9OQiydhTQ7YjIt8FncbjS3sqczEa3oLD5hZP3UxSDTo5YKkj-YAuRkpQ5brySq7j4NFrQuxnXJfscYFOu2HBZvbZxKkb0SDqu0RMTgxjrvE-kL5zq4MrexVPj9UR-f0OYrbiCVKzDL9BpFKOkVOFbsk7-tKYYUJCzXnOapTcx1J4ll_2PTl5Sppjrd5WjcDowkEpxRl6aqcpD0XEuWgp0OY_G83Owmvkhpz4_s_AQrlJTUzPiX_XmhkBmYLV8BOZ5xVZycmKnl_o9vb6NF1hwub3iK1HhVp06HkJA3sAkKkVTNPEBcSKxKQ67gHsy04RMl5TIKYVAhhSsJiT_3I7ZumPNE_rF0fybzuRwSRGJBJJQkMUae72QoT1XU4GiJW960f0DMwjMeJZ5XHI5u40yhON-A3ZrwlfP20o3ynYfBShHhGA13_2E1_7x4RWIwhOp9gYOn9gNsv4rdPjEQKwppj90Y5Wc35dNVZGYTA7e185IJcXK7pX6KaYvvA3ada4_ew8";
                                  generalController.updateTokenForCall(dummyToken);
                                  Get.toNamed(PageRoutes.videoCallScreen);
                                },
                                buttonText: LanguageConstant.videoCall.tr,
                                buttonTextStyle: AppTextStyles.buttonTextStyle1,
                                borderRadius: 40,
                                buttonColor: AppColors.gradientOne)
                            : generalController
                                        .selectedAppointmentHistoryForView
                                        .appointmentTypeId ==
                                    2
                                ? ButtonWidgetOne(
                                    onTap: () {
                                      final apptId = generalController
                                          .selectedAppointmentHistoryForView.id;
                                      final channel = "appt_$apptId";
                                      generalController
                                          .updateChannelForCall(channel);
                                      generalController.updateCallerType(2);

                                      // Dummy token for testing
                                      String dummyToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIzIiwianRpIjoiNjI2OTE3NmQwYzRiOTgzZDFiNzUxZTA1MTcxYzkyN2FiNjE4OTNjNGI3ZTk4YzBhM2U5Mjc4OGNiZDVhYThhZjZjNjA2YjEwNzhkY2U5ZWIiLCJpYXQiOjE3NzY4MzkzMjEuMzE0MDE0LCJuYmYiOjE3NzY4MzkzMjEuMzE0MDE3LCJleHAiOjE4MDgzNzUzMjEuMjk5MTk1LCJzdWIiOiIzMzAiLCJzY29wZXMiOltdfQ.myfmSMF9ZVnGbwGquvCvcA0eY0iaELcTaqF7zUkq-_CXTT3BtvRc3MKzNn-B7emCB6yNcJzyNXi-4uonxzp0usrblJi4MqMrUoRDf2oPeIlj-GYvHlbQR9urboojYWDcdflyEYABR3zPIUF7i0SRBixAnbRnh6tYgB0vXQQ9OQiydhTQ7YjIt8FncbjS3sqczEa3oLD5hZP3UxSDTo5YKkj-YAuRkpQ5brySq7j4NFrQuxnXJfscYFOu2HBZvbZxKkb0SDqu0RMTgxjrvE-kL5zq4MrexVPj9UR-f0OYrbiCVKzDL9BpFKOkVOFbsk7-tKYYUJCzXnOapTcx1J4ll_2PTl5Sppjrd5WjcDowkEpxRl6aqcpD0XEuWgp0OY_G83Owmvkhpz4_s_AQrlJTUzPiX_XmhkBmYLV8BOZ5xVZycmKnl_o9vb6NF1hwub3iK1HhVp06HkJA3sAkKkVTNPEBcSKxKQ67gHsy04RMl5TIKYVAhhSsJiT_3I7ZumPNE_rF0fybzuRwSRGJBJJQkMUae72QoT1XU4GiJW960f0DMwjMeJZ5XHI5u40yhON-A3ZrwlfP20o3ynYfBShHhGA13_2E1_7x4RWIwhOp9gYOn9gNsv4rdPjEQKwppj90Y5Wc35dNVZGYTA7e185IJcXK7pX6KaYvvA3ada4_ew8";
                                      generalController.updateTokenForCall(dummyToken);
                                      Get.toNamed(PageRoutes.audioCallScreen);
                                    },
                                    buttonText: LanguageConstant.audioCall.tr,
                                    buttonTextStyle:
                                        AppTextStyles.buttonTextStyle1,
                                    borderRadius: 40,
                                    buttonColor: AppColors.gradientOne)
                                : generalController
                                            .selectedAppointmentHistoryForView
                                            .appointmentTypeId ==
                                        3
                                    ? ButtonWidgetOne(
                                        onTap: () {
                                          Get.toNamed(PageRoutes.liveChatScreen);
                                        },
                                        buttonText: LanguageConstant.chatNow.tr,
                                        buttonTextStyle:
                                            AppTextStyles.buttonTextStyle1,
                                        borderRadius: 40,
                                        buttonColor: AppColors.gradientOne)
                                    : Container(),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      );
    });
  }
}
