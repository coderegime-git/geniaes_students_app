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

  setAcceptHeader(dio);
  setContentHeader(dio);

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
  log('Get Token ${Get.find<GeneralController>().storageBox.read('authToken')} ---->>>>');

  Get.find<ApiController>().changeInternetCheckerState(true);

  try {
    response = await dio.get(apiUrl, queryParameters: queryData);

    if (response.statusCode == 200) {
      log('getApi $apiUrl ---->>>>  ${response.data}');
      if (_isHtmlResponse(response.data)) {
        log('ERROR: API returned HTML for $apiUrl — token may be invalid or missing Accept header.');
        executionMethod(context, false, <String, dynamic>{
          'success': false,
          'message': 'Unexpected HTML response from server.',
        });
        return;
      }
      executionMethod(context, true, response.data);
      return;
    }
    log('getApi $apiUrl ---->>>>  ${response.data}');
    if (_isHtmlResponse(response.data)) {
      executionMethod(context, false, <String, dynamic>{
        'success': false,
        'message': 'Unexpected HTML response from server.',
      });
      return;
    }
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
              img: 'assets/icons/View@2x.png',
            );
          });
      Get.find<ApiController>().changeInternetCheckerState(false);
    } else {
      final errorData = e.response?.data;
      if (_isHtmlResponse(errorData)) {
        log('ERROR: DioError HTML response for $apiUrl');
        executionMethod(context, false, <String, dynamic>{
          'success': false,
          'message': 'Unexpected HTML response from server.',
        });
      } else {
        executionMethod(context, false, errorData ?? {'message': e.message});
      }
    }
  }
}

/// Returns true if the response body is an HTML page rather than JSON.
bool _isHtmlResponse(dynamic data) {
  if (data is String) {
    final trimmed = data.trimLeft();
    return trimmed.startsWith('<!DOCTYPE') ||
        trimmed.startsWith('<!doctype') ||
        trimmed.startsWith('<html');
  }
  return false;
}
