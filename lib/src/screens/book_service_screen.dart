import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:resize/resize.dart';
import 'package:dio/dio.dart' as dio_instance;
import '../../multi_language/language_constants.dart';
import '../api_services/get_service.dart';
import '../api_services/post_service.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../controllers/all_services_controller.dart';
import '../controllers/all_settings_controller.dart';

import '../controllers/general_controller.dart';
import '../controllers/teacher_book_service_controller.dart';
import '../controllers/make_payment_controller.dart';
import '../controllers/payment_gateways_controller.dart';
import '../repositories/get_payment_gateways_repo.dart';

import '../repositories/make_payment_repo.dart';
import '../widgets/appbar_widget.dart';
import '../widgets/button_widget.dart';

class BookServiceScreen extends StatefulWidget {
  // final num? appointmentTypeId;
  const BookServiceScreen({
    super.key,
    // this.appointmentTypeId,
  });

  @override
  State<BookServiceScreen> createState() => _BookServiceScreenState();
}

class _BookServiceScreenState extends State<BookServiceScreen> {
  final teacherBookServicelogic = Get.put(TeacherBookServiceController());

  final paymentGatewaysLogic = Get.put(PaymentGatewaysController());
  final makePaymentLogic = Get.put(MakePaymentController());

  String formattedDate = DateFormat.yMd().format(DateTime.now());
  String values = 'no';
  int indexPage = 0;
  int activeStep = 3;
  int upperBound = 4;
  bool boolValue = false;
  int? value;
  var selectedSlot;
  File? file;
  dynamic selectedPaymentGateway;
  DateTime selectedDate = DateTime.now();

  var dayToday = DateFormat('EEEE').format(DateTime.now());
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

  @override
  void initState() {
    super.initState();

    print(
        "${Get.find<AllServicesController>().selectedServiceForView.id} SERVICE ID");

    getMethod(
        context, getPaymentGatewaysURL, null, false, getPaymentGatewaysRepo);
    print("$selectedDate DateNow");
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TeacherBookServiceController>(
        builder: (teacherBookServiceController) {
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: AppBarWidget(
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
            titleText: LanguageConstant.bookService.tr,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 0.h, 16.w, 0.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Get.find<AllServicesController>()
                                  .selectedServiceForView
                                  .image
                                  ?.length !=
                              null
                          ? Image(
                              image: NetworkImage(
                                  "$mediaUrl${Get.find<AllServicesController>().selectedServiceForView.image}"),
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
                          Get.find<AllServicesController>()
                              .selectedServiceForView
                              .name
                              .toString(),
                          textAlign: TextAlign.start,
                          style: AppTextStyles.bodyTextStyle14,
                        ),
                        SizedBox(height: 18.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LanguageConstant.type.tr,
                              textAlign: TextAlign.start,
                              style: AppTextStyles.bodyTextStyle13,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              LanguageConstant.service.tr,
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
                              initialRating: Get.find<GeneralController>()
                                  .selectedTeacherForView
                                  .rating!
                                  .toDouble(),
                              minRating: 1,
                              itemSize: 15.h,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              ignoreGestures: true,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 0.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (double value) {},
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              // '4.5',
                              "(${Get.find<AllServicesController>().selectedServiceForView.rating!})",
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
                                  .getDisplayAmount(
                                      Get.find<AllServicesController>()
                                          .selectedServiceForView
                                          .price!),
                              style: AppTextStyles.bodyTextStyle11,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              indexPage == 0
                  ? personalInformation()
                  : indexPage == 1
                      ?
                      // ? !teacherBookServiceController.getTeacherBookServiceLoader
                      //     ?
                      //     Padding(
                      //         padding: EdgeInsets.fromLTRB(0, 250.h, 0, 250.h),
                      //         child: const CircularProgressIndicator(
                      //           backgroundColor: AppColors.transparent,
                      //           color: AppColors.primaryColor,
                      //         ),
                      //       )
                      //     :
                      timeSchedule()
                      : indexPage == 2
                          ? paymentMethod()
                          : paymentMethod(),
            ],
          ),
        ),
      );
    });
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
          SizedBox(height: 20.h),
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
                            .data!
                            .map((gatewaysName) {
                          return DropdownMenuItem(
                            value: gatewaysName.code,
                            child: DropdownMenuItem(
                              child: Row(
                                children: [
                                  Image.network(
                                    "$mediaUrl${gatewaysName.image!}",
                                    height: 35.h,
                                  ),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  Text(gatewaysName.name!,
                                      style: AppTextStyles.bodyTextStyle11),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
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
                          color: AppColors.secondaryColor,
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
                      .data!
                      .enableWalletSystem ==
                  "1"
              ? ButtonWidgetOne(
                  onTap: () {
                    // Book Service API Make Payment via Wallet
                    postMethod(
                        context,
                        studentBookService,
                        {
                          "service_id": Get.find<AllServicesController>()
                              .selectedServiceForView
                              .id,
                          "question": Get.find<TeacherBookServiceController>()
                              .serviceQuestionFieldController
                              .text,
                          "date": selectedDate.toString(),
                          "attachment": file?.path,
                          "gateway": "wallet",
                        },
                        true,
                        makeServicePaymentViaWalletRepo);
                  },
                  buttonText: LanguageConstant.payViaWallet.tr,
                  buttonTextStyle: AppTextStyles.buttonTextStyle6,
                  borderRadius: 40,
                  buttonColor: AppColors.gradientFour)
              : SizedBox(),
          SizedBox(height: 48.h),
          ButtonWidgetOne(
              onTap: () {
                // Book Service API Make Payment
                postMethodwithFile(
                    context,
                    studentBookService,
                    dio_instance.FormData.fromMap(
                      <String, dynamic>{
                        "service_id": Get.find<AllServicesController>()
                            .selectedServiceForView
                            .id,
                        "question": Get.find<TeacherBookServiceController>()
                            .serviceQuestionFieldController
                            .text,
                        "date": selectedDate.toString(),
                        "attachment": file?.path,
                        "gateway": selectedPaymentGateway,
                      },
                    ),
                    true,
                    makeServicePaymentRepo);
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 18.h),
              Row(
                children: [
                  Text(
                    "$dayToday / ",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(0, 18.h, 0, 18.h),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.primaryColor)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            LanguageConstant.serviceBy.tr,
                            style: AppTextStyles.headingTextStyle2,
                          ),
                          Text(
                            Get.find<AllServicesController>()
                                    .selectedServiceForView
                                    .teacher
                                    ?.name ??
                                Get.find<AllServicesController>()
                                    .selectedServiceForView
                                    .academy
                                    ?.name ??
                                "",
                            textAlign: TextAlign.center,
                            style: AppTextStyles.subHeadingTextStyle1,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 18.w),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(0, 18.h, 0, 18.h),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.primaryColor)),
                      child: Column(
                        children: [
                          Text(
                            LanguageConstant.serviceFee.tr,
                            style: AppTextStyles.headingTextStyle2,
                          ),
                          Text(
                            Get.find<GetAllSettingsController>()
                                .getDisplayAmount(
                                    Get.find<AllServicesController>()
                                        .selectedServiceForView
                                        .price!),
                            style: AppTextStyles.subHeadingTextStyle1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
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
          TextField(
            style: AppTextStyles.hintTextStyle1,
            maxLines: 5,
            controller: Get.find<TeacherBookServiceController>()
                .serviceQuestionFieldController,
            decoration: InputDecoration(
              hintText: LanguageConstant.writeYourQuestionHere.tr,
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
          SizedBox(height: 24.h),
          Text(
            LanguageConstant.doYouHaveImageWithYou.tr,
            style: AppTextStyles.subHeadingTextStyle1,
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
                              SizedBox(width: 10.w),
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
                  print(
                      "${Get.find<TeacherBookServiceController>().serviceQuestionFieldController.text} SERVICEQUESTION");
                  print("${file?.path} PATHSERVICE");
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
