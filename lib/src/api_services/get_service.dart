import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart' as dio_instance;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../multi_language/language_constants.dart';
import '../config/app_colors.dart';
import '../controllers/general_controller.dart';
import '../widgets/custom_dialog.dart';
import 'header.dart';
import 'logic.dart';

getMethod(BuildContext context, String apiUrl, dynamic queryData,
    bool addAuthHeader, Function executionMethod) async {
  dio_instance.Response response;
  dio_instance.Dio dio = dio_instance.Dio();

  if (addAuthHeader &&
      Get.find<GeneralController>().storageBox.hasData('authToken')) {
    setCustomHeader(dio, 'Authorization',
        'Bearer ${Get.find<GeneralController>().storageBox.read('authToken')}');
    setCustomHeader(dio, 'logged-in-as', 'student');
  }
  setLanguageHeader(dio, 'locale',
      '${Get.find<GeneralController>().storageBox.read('languageCode')}');
  log('Get Method Api $apiUrl ---->>>>');
  log('queryData $queryData ---->>>>');
  log('Get Token ${Get.find<GeneralController>().storageBox.read('authToken')}} ---->>>>');

  Get.find<ApiController>().changeInternetCheckerState(true);

  try {
    response = await dio.get(apiUrl, queryParameters: queryData);

    if (response.statusCode == 200) {
      log('getApi $apiUrl ---->>>>  ${response.data}');
      executionMethod(context, true, response.data);
      return;
    }
    log('getApi $apiUrl ---->>>>  ${response.data}');
    executionMethod(context, false, response.data);
  } on dio_instance.DioError catch (e) {
    log('Dio Error     $apiUrl $queryData ---->>>>${e.response}');
    if (e.type == dio_instance.DioErrorType.connectionError ||
        e.type == dio_instance.DioErrorType.connectionTimeout ||
        e.error is SocketException) {
      Get.find<GeneralController>().updateFormLoaderController(false);
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: LanguageConstant.pleaseTryAgain.tr,
              titleColor: AppColors.customDialogErrorColor,
              descriptions: LanguageConstant.internetNotConnected.tr,
              text: LanguageConstant.ok.tr,
              functionCall: () {
                Navigator.pop(context);
              },
              // img: 'assets/icons/dialog_error.png',
              img: 'assets/icons/View@2x.png',
            );
          });
      Get.find<ApiController>().changeInternetCheckerState(false);
    } else {
      executionMethod(context, false, e.response?.data ?? {'message': e.message});
    }
  }
}
