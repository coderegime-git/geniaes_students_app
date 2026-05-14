import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart' as dio_instance;
import 'package:resize/resize.dart';

import '../../multi_language/language_constants.dart';
import '../api_services/get_service.dart';
import '../api_services/post_service.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../controllers/all_settings_controller.dart';
import '../controllers/general_controller.dart';
import '../controllers/teacher_book_appointment_controller.dart';
import '../controllers/make_payment_controller.dart';
import '../controllers/payment_gateways_controller.dart';
import '../repositories/get_payment_gateways_repo.dart';
import '../repositories/teacher_book_appointment_repo.dart';

import '../repositories/make_payment_repo.dart';
import '../widgets/appbar_widget.dart';
import '../widgets/button_widget.dart';

class CallAppointmentScreen extends StatefulWidget {
  // final num? appointmentTypeId;
  const CallAppointmentScreen({
    super.key,
    // this.appointmentTypeId,
  });

  @override
  State<CallAppointmentScreen> createState() => _CallAppointmentScreenState();
}

class _CallAppointmentScreenState extends State<CallAppointmentScreen> {
  final teacherAppointmentSchdulelogic =
      Get.put(TeacherAppointmentScheduleController());

  final paymentGatewaysLogic = Get.put(PaymentGatewaysController());
  final makePaymentLogic = Get.put(MakePaymentController());

  var appointmentTypeId = Get.parameters["appointmentTypeId"];
  String? screenTitle = Get.parameters["screenTitle"];
  String formattedDate = DateFormat.yMd().format(DateTime.now());
  String values = 'no';
  int indexPage = 0;
  int activeStep = 3;
  int upperBound = 4;
  bool boolValue = false;
  int? value;
  File? file;
  var selectedSlot;
  var scheduleSlotId;

  dynamic selectedPaymentGateway;

  DateTime selectedDate = DateTime.now();
  filePick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        file = File(result.files.single.path!);
      });

      print(file!.path);
    } else {
      // User canceled the picker
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor, // <-- SEE HERE
              onPrimary: AppColors.black, // <-- SEE HERE
              onSurface: AppColors.black, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.black,
                textStyle: AppTextStyles.bodyTextStyle2, // button text color
              ),
            ),
            textTheme: const TextTheme(
              headlineSmall:
                  AppTextStyles.bodyTextStyle2, // Selected Date landscape
              titleLarge:
                  AppTextStyles.bodyTextStyle2, // Selected Date portrait
              labelSmall:
                  AppTextStyles.headingTextStyle4, // Title - SELECT DATE
              bodyLarge: AppTextStyles.bodyTextStyle2, // year gridbview picker
              titleMedium: AppTextStyles.bodyTextStyle2, // input
              titleSmall: AppTextStyles.bodyTextStyle2, // month/year picker
              bodySmall: AppTextStyles.bodyTextStyle2, // days
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        String userName =
            Get.find<GeneralController>().selectedTeacherForView.userName ?? "";
        getMethod(
            context,
            '$getTeacherBookAppointment$userName/book_appointment',
            {
              "appointment_type_id": appointmentTypeId,
              "date": DateFormat('yyyy-MM-dd').format(selectedDate)
            },
            false,
            getTeacherBookAppointmentRepo);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // log("${Get.parameters['appointmentId']} PARAMETERS");
    log("$appointmentTypeId PARAMETERS2");
    String userName =
        Get.find<GeneralController>().selectedTeacherForView.userName ?? "";
    log("$userName TeacherUsername1");
    getMethod(
        context,
        '$getTeacherBookAppointment$userName/book_appointment',
        {
          "appointment_type_id": appointmentTypeId,
          "date": DateFormat('yyyy-MM-dd').format(selectedDate)
        },
        true,
        getTeacherBookAppointmentRepo);
    // Get All Payment Gateways
    getMethod(
        context, getPaymentGatewaysURL, null, false, getPaymentGatewaysRepo);

    print("$selectedDate DateNow");
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TeacherAppointmentScheduleController>(
        builder: (teacherBookAppointmentController) {
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: AppBarWidget(
            titleText: screenTitle ?? "",
            leadingIcon: "assets/icons/Expand_left.png",
            leadingOnTap: () {
              if (indexPage > 0) {
                setState(() {
                  indexPage--;
                });
              } else {
                Get.back();
                indexPage = 0;
              }
            },
          ),
        ),
        body: SingleChildScrollView(
          child: teacherBookAppointmentController
                  .getTeacherBookAppointmentLoader
              ? teacherBookAppointmentController
                          .getTeacherAppointmentScheduleModel.data?.schedule !=
                      null
                  ? Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(16.w, 0.h, 16.w, 0.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Get.find<GeneralController>()
                                            .selectedTeacherForView
                                            .image
                                            ?.length !=
                                        null
                                    ? Image(
                                        image: NetworkImage(
                                            "$mediaUrl${Get.find<GeneralController>().selectedTeacherForView.image}"),
                                        height: 110.h,
                                      )
                                    : Image(
                                        image: const AssetImage(
                                            'assets/images/teacher-image.png'),
                                        height: 110.h,
                                      ),
                              ),
                              SizedBox(width: 6.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    // "Jhon Doe",
                                    Get.find<GeneralController>()
                                        .selectedTeacherForView
                                        .name
                                        .toString(),
                                    textAlign: TextAlign.start,
                                    style: AppTextStyles.bodyTextStyle14,
                                  ),
                                  SizedBox(height: 18.h),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        LanguageConstant.appointmentType.tr,
                                        textAlign: TextAlign.start,
                                        style: AppTextStyles.bodyTextStyle13,
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        Get.find<
                                                TeacherAppointmentScheduleController>()
                                            .getTeacherAppointmentScheduleModel
                                            .data
                                            ?.schedule
                                            ?.appointmentType
                                            ?.displayName
                                            .toString() ??
                                        "",
                                        textAlign: TextAlign.start,
                                        style: AppTextStyles.bodyTextStyle9,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(width: 8.w),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      RatingBar.builder(
                                        initialRating:
                                            (Get.find<GeneralController>()
                                                        .selectedTeacherForView
                                                        .rating ??
                                                    0)
                                                .toDouble(),
                                        minRating: 1,
                                        itemSize: 15.h,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        ignoreGestures: true,
                                        itemPadding: const EdgeInsets.symmetric(
                                            horizontal: 0.0),
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (double value) {},
                                      ),
                                      SizedBox(width: 2.w),
                                      Text(
                                        // '4.5',
                                        "(${Get.find<GeneralController>().selectedTeacherForView.rating ?? 0})",
                                        textAlign: TextAlign.start,
                                        style: AppTextStyles.bodyTextStyle6,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 18.h),
                                  Column(
                                    children: [
                                      Text(
                                        LanguageConstant.fee.tr,
                                        textAlign: TextAlign.start,
                                        style: AppTextStyles.bodyTextStyle13,
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        Get.find<GetAllSettingsController>()
                                            .getDisplayAmount(int.tryParse(Get.find<
                                                    TeacherAppointmentScheduleController>()
                                                .getTeacherAppointmentScheduleModel
                                                .data
                                                ?.schedule
                                                ?.fee
                                                ?.toString() ??
                                            "0") ??
                                        0),
                                        style: AppTextStyles.bodyTextStyle11,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 0.h),
                          child: Divider(
                              thickness: 1.5.h,
                              height: 1.5.h,
                              color: AppColors.lightGrey.withOpacity(0.6)),
                        ),
                        indexPage == 0
                            ? personalInformation()
                            : indexPage == 1
                                ? !teacherBookAppointmentController
                                        .getTeacherBookAppointmentLoader
                                    ? Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            0, 250.h, 0, 250.h),
                                        child: const CircularProgressIndicator(
                                          backgroundColor:
                                              AppColors.transparent,
                                          color: AppColors.primaryColor,
                                        ),
                                      )
                                    : timeSchedule()
                                : indexPage == 2
                                    ? paymentMethod()
                                    : paymentMethod(),
                      ],
                    )
                  : Padding(
                      padding: EdgeInsets.fromLTRB(0, 100.h, 0, 100.h),
                      child: Center(
                        child: Text(
                          LanguageConstant.noDataFound.tr,
                          style: AppTextStyles.bodyTextStyle13,
                        ),
                      ),
                    )
              : Center(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 100.h, 0, 100.h),
                    child: const CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
        ),
      );
    });
  }

  // Review and Rating
  Widget reviewAndRating() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Rate This Tutor",
            style: AppTextStyles.headingTextStyle4,
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 30, 0, 18),
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
            decoration: BoxDecoration(
                color: AppColors.offWhite,
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Communication",
                  style: AppTextStyles.subHeadingTextStyle1,
                ),
                Image.asset("assets/icons/star.png")
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 30),
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
            decoration: BoxDecoration(
                color: AppColors.offWhite,
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Professional Skills",
                  style: AppTextStyles.subHeadingTextStyle1,
                ),
                Image.asset("assets/icons/star.png")
              ],
            ),
          ),
          TextField(
            style: AppTextStyles.hintTextStyle1,
            maxLines: 5,
            // controller: controller,
            decoration: InputDecoration(
              hintText: "Write your Feedback here",
              hintStyle: AppTextStyles.hintTextStyle1,
              labelStyle: AppTextStyles.hintTextStyle1,
              contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              isDense: true,
              border: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 1, color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 1, color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 1, color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 1, color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 30),
          ButtonWidgetOne(
              onTap: () {
                setState(() {
                  indexPage++;
                });
              },
              buttonText: "Continue",
              buttonTextStyle: AppTextStyles.bodyTextStyle8,
              borderRadius: 10,
              buttonColor: AppColors.gradientOne),
        ],
      ),
    );
  }

  // Payment Complete Thank You
  Widget paymentThankYou() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.offWhite,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 36, 0, 24),
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: AppColors.primaryColor),
                  child: const Icon(
                    Icons.check,
                    size: 36,
                    color: AppColors.offWhite,
                  ),
                ),
                const Text(
                  "Thank You",
                  style: AppTextStyles.headingTextStyle3,
                ),
                const SizedBox(height: 8),
                const Text(
                  "For your payment 50",
                  style: AppTextStyles.bodyTextStyle2,
                ),
                const SizedBox(height: 36),
              ],
            ),
          ),
          const SizedBox(height: 36),
          Text(
            "Your Video Call Starts",
            style: AppTextStyles.bodyTextStyle2,
          ),
          const SizedBox(height: 8),
          Text(
            "00:55",
            style: AppTextStyles.bodyTextStyle9,
          ),
          const SizedBox(height: 36),
          ButtonWidgetOne(
              onTap: () {
                setState(() {
                  indexPage++;
                });
              },
              buttonText: "Try Again",
              buttonTextStyle: AppTextStyles.bodyTextStyle8,
              borderRadius: 10,
              buttonColor: AppColors.gradientOne),
        ],
      ),
    );
  }

// Payment Method
  Widget paymentMethod() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LanguageConstant.chooseYourPaymentMethod.tr,
            style: AppTextStyles.headingTextStyle5,
          ),
          SizedBox(
            height: 16.h,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.white, //background color of dropdown button

              borderRadius:
                  BorderRadius.circular(30), //border raiuds of dropdown button
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 16,
                  offset: Offset(2, 5), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: 1,
                  physics: const AlwaysScrollableScrollPhysics(),
                  // padding: const EdgeInsets.only(top: 18),
                  itemBuilder: (context, index) {
                    return DropdownButtonHideUnderline(
                      child: DropdownButtonFormField(
                        hint: Text(
                          LanguageConstant.pleaseChoosePaymentMethod.tr,
                          style: AppTextStyles.bodyTextStyle11,
                        ), // Not necessary for Option 1
                        value: selectedPaymentGateway,

                        items: Get.find<PaymentGatewaysController>()
                            .getPaymentGatewaysModel
                            .data
                            ?.map((gatewaysName) {
                          return DropdownMenuItem(
                            value: gatewaysName.code,
                            child: Row(
                              children: [
                                if (gatewaysName.image != null)
                                  Image.network(
                                    "$mediaUrl${gatewaysName.image!}",
                                    height: 35.h,
                                  ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Text(gatewaysName.name ?? "",
                                    style: AppTextStyles.bodyTextStyle11),
                              ],
                            ),
                          );
                        }).toList() ?? [],
                        onChanged: (newValue) {
                          setState(() {
                            selectedPaymentGateway = newValue;

                            print(
                                "GATEWAYS SELECTED NAME ${selectedPaymentGateway}");
                          });
                        },
                        decoration:
                            const InputDecoration.collapsed(hintText: ''),
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.tertiaryColor,
                        ),
                        iconEnabledColor: Colors.white, //Icon color
                        style: AppTextStyles.subHeadingTextStyle1,
                        dropdownColor:
                            AppColors.white, //dropdown background color
                        isExpanded: true, //make true to make width 100%
                      ),
                    );
                  }),
            ),
          ),
          SizedBox(height: 16.h),
          Center(
            child: Text(
              LanguageConstant.or.tr,
              style: AppTextStyles.headingTextStyle5,
            ),
          ),
          SizedBox(height: 16.h),
          Get.find<GetAllSettingsController>()
                      .getAllSettingsModel
                      .data
                      ?.enableWalletSystem ==
                  "1"
              ? ButtonWidgetOne(
                  onTap: () async {
                    // Book Appointment API Make Payment via Wallet
                    postMethodwithFile(
                        context,
                        studentBookAppointment,
                        dio_instance.FormData.fromMap(<String, dynamic>{
                          "teacher_id": Get.find<GeneralController>()
                                  .selectedTeacherForView
                                  .id ??
                              0,
                          "question": Get.find<
                                          TeacherAppointmentScheduleController>()
                                      .getTeacherAppointmentScheduleModel
                                      .data
                                      ?.schedule
                                      ?.appointmentType
                                      ?.displayName ==
                                  "Video Call"
                              ? Get.find<TeacherAppointmentScheduleController>()
                                  .videCallQuestionFieldController
                                  .text
                              : Get.find<TeacherAppointmentScheduleController>()
                                          .getTeacherAppointmentScheduleModel
                                          .data
                                          ?.schedule
                                          ?.appointmentType
                                          ?.displayName ==
                                      "Audio Call"
                                  ? Get.find<
                                          TeacherAppointmentScheduleController>()
                                      .audioCallQuestionFieldController
                                      .text
                                  : Get.find<
                                          TeacherAppointmentScheduleController>()
                                      .videCallQuestionFieldController
                                      .text,
                          "appointment_type_id":
                              Get.find<TeacherAppointmentScheduleController>()
                                      .getTeacherAppointmentScheduleModel
                                      .data
                                      ?.schedule
                                      ?.appointmentTypeId
                                      ?.toInt() ??
                                  0,
                          "date": selectedDate.toString(),
                          "appointment_schedule_id":
                              Get.find<TeacherAppointmentScheduleController>()
                                      .getTeacherAppointmentScheduleModel
                                      .data
                                      ?.schedule
                                      ?.id
                                      ?.toInt() ??
                                  0,
                          "appointment_type":
                              Get.find<TeacherAppointmentScheduleController>()
                                  .getTeacherAppointmentScheduleModel
                                  .data
                                  ?.schedule
                                  ?.type,
                          "attachment": file ?? "",
                          "gateway": "wallet",
                        }),
                        true,
                        makePaymentViaWalletRepo);
                  },
                  buttonText: LanguageConstant.payViaWallet.tr,
                  buttonTextStyle: AppTextStyles.buttonTextStyle6,
                  borderRadius: 40,
                  buttonColor: AppColors.gradientFour)
              : const SizedBox(),
          SizedBox(height: 48.h),
          ButtonWidgetOne(
              onTap: () async {
                // Book Appointment API Make Payment
                postMethodwithFile(
                    context,
                    studentBookAppointment,
                    dio_instance.FormData.fromMap(<String, dynamic>{
                      "teacher_id": Get.find<GeneralController>()
                              .selectedTeacherForView
                              .id ??
                          0,
                      "question": Get.find<
                                      TeacherAppointmentScheduleController>()
                                  .getTeacherAppointmentScheduleModel
                                  .data
                                  ?.schedule
                                  ?.appointmentType
                                  ?.displayName ==
                              "Video Call"
                          ? Get.find<TeacherAppointmentScheduleController>()
                              .videCallQuestionFieldController
                              .text
                          : Get.find<TeacherAppointmentScheduleController>()
                                      .getTeacherAppointmentScheduleModel
                                      .data
                                      ?.schedule
                                      ?.appointmentType
                                      ?.displayName ==
                                  "Audio Call"
                              ? Get.find<TeacherAppointmentScheduleController>()
                                  .audioCallQuestionFieldController
                                  .text
                              : Get.find<TeacherAppointmentScheduleController>()
                                  .videCallQuestionFieldController
                                  .text,
                      "appointment_type_id":
                          Get.find<TeacherAppointmentScheduleController>()
                                  .getTeacherAppointmentScheduleModel
                                  .data
                                  ?.schedule
                                  ?.appointmentTypeId
                                  ?.toInt() ??
                              0,
                      "date": selectedDate.toString(),
                      "appointment_schedule_id":
                          Get.find<TeacherAppointmentScheduleController>()
                                  .getTeacherAppointmentScheduleModel
                                  .data
                                  ?.schedule
                                  ?.id
                                  ?.toInt() ??
                              0,
                      "appointment_type":
                          Get.find<TeacherAppointmentScheduleController>()
                              .getTeacherAppointmentScheduleModel
                              .data
                              ?.schedule
                              ?.type,
                      "attachment": file ?? "",
                      "gateway": selectedPaymentGateway,
                    }),
                    true,
                    makePaymentRepo);
              },
              buttonText: LanguageConstant.makePayment.tr,
              buttonTextStyle: AppTextStyles.bodyTextStyle16,
              borderRadius: 40,
              buttonColor: AppColors.gradientOne),
        ],
      ),
    );
  }

// Time Schedule
  Widget timeSchedule() {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 18.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LanguageConstant.selectDateForBookAppointment.tr,
                style: AppTextStyles.subHeadingTextStyle1,
              ),
              SizedBox(width: 18.w),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 5.h),
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      Text(
                        LanguageConstant.date.tr,
                        style: AppTextStyles.buttonTextStyle5,
                      ),
                      SizedBox(width: 5.w),
                      Image.asset(
                        "assets/icons/Date_range.png",
                        height: 22.h,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Get.find<TeacherAppointmentScheduleController>()
                      .getTeacherAppointmentScheduleModel
                      .data!
                      .schedule ==
                  null
              ? Padding(
                  padding: EdgeInsets.fromLTRB(0, 250.h, 0, 250.h),
                  child: Text(
                    LanguageConstant.noDataFound.tr,
                    style: AppTextStyles.bodyTextStyle2,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 18.h),
                    Row(
                      children: [
                        Text(
                          "${Get.find<TeacherAppointmentScheduleController>().getTeacherAppointmentScheduleModel.data!.schedule!.day!.capitalizeFirst!} / ",
                          textAlign: TextAlign.start,
                          style: AppTextStyles.subHeadingTextStyle1,
                        ),
                        Text(
                          "${selectedDate.toLocal()}".split(' ')[0],
                          textAlign: TextAlign.start,
                          style: AppTextStyles.subHeadingTextStyle1,
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h),
                    Wrap(
                      children: [
                        GridView.builder(
                          itemCount:
                              Get.find<TeacherAppointmentScheduleController>()
                                  .getTeacherAppointmentScheduleModel
                                  .data!
                                  .schedule!
                                  .scheduleSlots!
                                  .length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 2 / 0.50,
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 15,
                                  mainAxisSpacing: 8),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              decoration: BoxDecoration(
                                  color: value == index
                                      ? AppColors.primaryColor.withOpacity(0.3)
                                      : AppColors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 1,
                                      blurRadius: 16,
                                      offset: Offset(
                                          2, 5), // changes position of shadow
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(20)),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                    splashColor: AppColors.transparent,
                                    highlightColor: AppColors.transparent,
                                    canvasColor: AppColors.transparent),
                                child: ChoiceChip(
                                  labelPadding:
                                      EdgeInsets.fromLTRB(3.w, 0, 3.w, 0),
                                  visualDensity: const VisualDensity(
                                      horizontal: -1, vertical: -1),
                                  // label: const Text('08:00 - 08:30'),
                                  label: Text(
                                      '${Get.find<TeacherAppointmentScheduleController>().getTeacherAppointmentScheduleModel.data?.schedule?.scheduleSlots?[index].startTime ?? ""} - ${Get.find<TeacherAppointmentScheduleController>().getTeacherAppointmentScheduleModel.data?.schedule?.scheduleSlots?[index].endTime ?? ""}'),
                                  labelStyle: value == index
                                      ? AppTextStyles.chipsTextStyle2
                                      : AppTextStyles.chipsTextStyle1,
                                  backgroundColor: AppColors.transparent,
                                  selectedColor: AppColors.transparent,
                                  disabledColor: AppColors.black,
                                  surfaceTintColor: AppColors.offWhite,
                                  showCheckmark: false,
                                  selected: value == index,
                                  side: const BorderSide(
                                      color: AppColors.transparent),
                                  onSelected: (bool selected) {
                                    setState(() {
                                      value = selected ? index : null;
                                      selectedSlot = value != null
                                          ? "${Get.find<TeacherAppointmentScheduleController>().getTeacherAppointmentScheduleModel.data?.schedule?.scheduleSlots?.elementAt(value!).startTime ?? ""} - ${Get.find<TeacherAppointmentScheduleController>().getTeacherAppointmentScheduleModel.data?.schedule?.scheduleSlots?.elementAt(value!).endTime ?? ""}"
                                          : "";
                                      print("$selectedSlot SELECTEDSLOT");
                                      print("$selectedDate SELECTEDDATE");
                                      scheduleSlotId = Get.find<
                                              TeacherAppointmentScheduleController>()
                                          .getTeacherAppointmentScheduleModel
                                          .data
                                          ?.schedule
                                          ?.scheduleSlots?[index]
                                          .id;
                                      print("${scheduleSlotId} ScheduleID");
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    Divider(
                        thickness: 1.h,
                        height: 1.h,
                        color: AppColors.lightGrey),
                    SizedBox(height: 9.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.fromLTRB(0, 18.h, 0, 18.h),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    LanguageConstant.selectedDate.tr,
                                    style: AppTextStyles.headingTextStyle2,
                                  ),
                                  SizedBox(height: 5.h),
                                  Text(
                                    "${selectedDate.toLocal()}".split(' ')[0],
                                    style: AppTextStyles.subHeadingTextStyle1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 18.w),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.fromLTRB(0, 18.h, 0, 18.h),
                            child: Column(
                              children: [
                                Text(
                                  LanguageConstant.selectedTime.tr,
                                  style: AppTextStyles.headingTextStyle2,
                                ),
                                SizedBox(height: 5.h),
                                Text(
                                  value != null ? "$selectedSlot" : "-",
                                  style: AppTextStyles.subHeadingTextStyle1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 9.h),
                    ButtonWidgetOne(
                        onTap: () {
                          setState(() {
                            indexPage++;
                          });
                        },
                        buttonText: LanguageConstant.continuE.tr,
                        buttonTextStyle: AppTextStyles.buttonTextStyle1,
                        borderRadius: 40,
                        buttonColor: AppColors.gradientOne),
                  ],
                ),
        ],
      ),
    );
  }

// Personal Information
  Widget personalInformation() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LanguageConstant.enterYourInformation.tr,
            style: AppTextStyles.headingTextStyle1,
          ),
          SizedBox(height: 18.h),
          Material(
            elevation: 6.0,
            borderRadius: BorderRadius.circular(30),
            shadowColor: Colors.grey.withOpacity(0.4),
            child: TextField(
              style: AppTextStyles.hintTextStyle1,
              maxLines: 5,
              controller: Get.find<TeacherAppointmentScheduleController>()
                          .getTeacherAppointmentScheduleModel
                          .data
                          ?.schedule
                          ?.appointmentTypeId ==
                      1
                  ? Get.find<TeacherAppointmentScheduleController>()
                      .videCallQuestionFieldController
                  : Get.find<TeacherAppointmentScheduleController>()
                              .getTeacherAppointmentScheduleModel
                              .data
                              ?.schedule
                              ?.appointmentTypeId ==
                          2
                      ? Get.find<TeacherAppointmentScheduleController>()
                          .audioCallQuestionFieldController
                      : Get.find<TeacherAppointmentScheduleController>()
                          .videCallQuestionFieldController,
              decoration: InputDecoration(
                hintText: LanguageConstant.writeYourQuestionHere.tr,
                hintStyle: AppTextStyles.hintTextStyle1,
                labelStyle: AppTextStyles.hintTextStyle1,
                contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                isDense: true,
                border: OutlineInputBorder(
                  borderSide:
                      const BorderSide(width: 1, color: AppColors.transparent),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(width: 1, color: AppColors.transparent),
                  borderRadius: BorderRadius.circular(10),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(width: 1, color: AppColors.transparent),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(width: 1, color: AppColors.transparent),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            LanguageConstant.doYouHaveImageWithYou.tr,
            style: AppTextStyles.headingTextStyle1,
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: RadioListTile(
                  title: Text(
                    LanguageConstant.no.tr,
                    style: AppTextStyles.bodyTextStyle7,
                  ),
                  activeColor: AppColors.primaryColor,
                  selected: true,
                  value: "no",
                  groupValue: values,
                  onChanged: (value) {
                    setState(() {
                      values = value.toString();
                    });
                  },
                ),
              ),
              Expanded(
                child: RadioListTile(
                  title: Text(
                    LanguageConstant.yes.tr,
                    style: AppTextStyles.bodyTextStyle7,
                  ),
                  activeColor: AppColors.primaryColor,
                  value: "yes",
                  groupValue: values,
                  onChanged: (value) {
                    setState(() {
                      values = value.toString();
                    });
                  },
                ),
              ),
            ],
          ),
          values == 'no'
              ? Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 24),
                )
              : GestureDetector(
                  onTap: () {
                    filePick();
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 24),
                    decoration: BoxDecoration(
                        color: AppColors.offWhite,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.primaryColor)),
                    child: file == null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                LanguageConstant.uploadImage.tr,
                                style: AppTextStyles.buttonTextStyle7,
                              ),
                              const SizedBox(width: 10),
                              Image.asset("assets/icons/Upload.png")
                            ],
                          )
                        : Center(
                            child: Text(
                              file!.path.toString().split("/").last.toString(),
                              style: AppTextStyles.buttonTextStyle7,
                            ),
                          ),
                  ),
                ),
          ButtonWidgetOne(
              onTap: () {
                setState(() {
                  indexPage++;
                });
              },
              buttonText: LanguageConstant.continuE.tr,
              buttonTextStyle: AppTextStyles.buttonTextStyle1,
              borderRadius: 40,
              buttonColor: AppColors.gradientOne),
        ],
      ),
    );
  }
}
