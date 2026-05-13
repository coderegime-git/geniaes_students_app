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

deleteMethod(BuildContext context, String apiUrl, dynamic queryData,
    bool addAuthHeader, Function executionMethod
    // for performing functionalities
    ) async {
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

  log('delete method api.... $apiUrl');
  log('queryData.... $queryData');
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      Get.find<ApiController>().changeInternetCheckerState(true);
      try {
        response = await dio.delete(apiUrl, queryParameters: queryData);

        if (response.statusCode == 200) {
          log('response  ....  ${response.data}');
          if (_isHtmlResponse(response.data)) {
            log('ERROR: API returned HTML for $apiUrl');
            executionMethod(context, false, <String, dynamic>{
              'success': false,
              'message': 'Unexpected HTML response from server.',
            });
            return;
          }
          executionMethod(context, true, response.data);

          return;
        }
        log('response   ....  $response');
        if (_isHtmlResponse(response.data)) {
          executionMethod(context, false, <String, dynamic>{
            'success': false,
            'message': 'Unexpected HTML response from server.',
          });
          return;
        }
        executionMethod(context, false, response.data);
      } on dio_instance.DioError catch (e) {
        log('Dio Error  ....  ${e.response}');
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
  } on SocketException catch (_) {
    Get.find<GeneralController>().updateFormLoaderController(false);
    // ignore: use_build_context_synchronously
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
            img: 'assets/icons/dialog_error.png',
          );
        });
    Get.find<ApiController>().changeInternetCheckerState(false);
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
