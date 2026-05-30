import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart' as dio_instance;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:resize/resize.dart';

import 'in_app_attachment_viewer.dart';

import '../api_services/get_service.dart';
import '../api_services/post_service.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../config/app_configs.dart';
import '../config/app_font.dart';
import '../config/app_text_styles.dart';
import '../controllers/all_settings_controller.dart';
import '../controllers/general_controller.dart';
import '../controllers/live_chat_controller.dart';
import '../repositories/live_chat_messages_repo.dart';
import '../widgets/appbar_widget.dart';

class LiveChatScreen extends StatefulWidget {
  const LiveChatScreen({super.key});

  @override
  State<LiveChatScreen> createState() => _LiveChatScreenState();
}

class _LiveChatScreenState extends State<LiveChatScreen> {
  final logic = Get.put(LiveChatController());
  PusherChannelsFlutter pusherChannels = PusherChannelsFlutter.getInstance();

  String get _apiKey => AppConfigs.pusherAppKey.toString();
  String get _appSecret => AppConfigs.pusherAppSecret.toString();
  String get _appCluster => AppConfigs.pusherAppCluster.toString();

  final _channelName =
      "private-chat-message.${Get.find<GeneralController>().selectedAppointmentHistoryForView.id}";
  final _eventName = "chat-message";
  // PusherClient? pusher;
  // Channel? channel;
  String responseData = '';

  Map<String, dynamic> eventResponseMap = {};

  dynamic messageData = {};

  @override
  void initState() {
    super.initState();

    getMethod(
        context,
        "$getMessagesUrl${Get.find<GeneralController>().selectedAppointmentHistoryForView.id}",
        null,
        true,
        getLiveChatMessagesRepo);

    // Initialize Pusher Channel
    // Initialize Pusher Channel
    try {
      pusherChannels.init(
        apiKey: _apiKey,
        cluster: _appCluster,
        logToConsole: true,
        onConnectionStateChange: onConnectionStateChange,
        onError: onError,
        onSubscriptionSucceeded: onSubscriptionSucceeded,
        onEvent: (event) => onEvent(event),
        onSubscriptionError: onSubscriptionError,
        onDecryptionFailure: onDecryptionFailure,
        onMemberAdded: onMemberAdded,
        onMemberRemoved: onMemberRemoved,
        onAuthorizer: onAuthorizer,
      );

      final myChannel = pusherChannels.subscribe(
          channelName: _channelName,
          onEvent: (event) {
            PusherEvent eventTest = event;

            setState(() {
              responseData = eventTest.data.toString();
            });

            eventResponseMap = jsonDecode(responseData);

            log("Got channel event1: ${eventTest.data}");
            log("Got channel event messageData: ${Get.find<LiveChatController>().getLiveChatMessagesDataModel}");

            log("${Get.find<LiveChatController>().messageList} 333");
            Get.find<LiveChatController>()
                .updateMessageList(eventResponseMap["message"]);

            log("${Get.find<LiveChatController>().getLiveChatMessagesModel.data} 555");
            log("${Get.find<LiveChatController>().messageList.length} length");
          });
      pusherChannels.connect();
    } catch (e) {
      log("ERROR: $e");
    }
    log("${pusherChannels.channels.toString()} PUSHERDATA");
  }

  dynamic onAuthorizer(String channelName, String socketId, dynamic options) {
    if (_appSecret.isEmpty) {
      log("LiveChat: appSecret is empty, auth will fail");
      return {"auth": ""};
    }
    String stringToSign = "$socketId:$channelName";
    var bytesToSign = utf8.encode(stringToSign);
    var secretKey = utf8.encode(_appSecret);
    var hmacSha256 = Hmac(sha256, secretKey);
    var signature = hmacSha256.convert(bytesToSign);
    String auth = "$_apiKey:$signature";
    return {"auth": auth};
  }

  void onConnectionStateChange(dynamic currentState, dynamic previousState) {
    if (currentState == "CONNECTING" || currentState == "RECONNECTING") {
      Get.find<GeneralController>().updateCallLoaderController(true);
    } else if (currentState == "CONNECTED") {
      Get.find<GeneralController>().updateCallLoaderController(false);
    }
    log("Connection: $currentState");
  }

  void onError(String message, int? code, dynamic e) {
    log("onError: $message code: $code exception: $e");
  }

  onEvent(PusherEvent event) {
    log("onEvent: ${event.data}");
  }

  void onSubscriptionSucceeded(String channelName, dynamic data) {
    log("onSubscriptionSucceeded: $channelName data: $data");
  }

  void onSubscriptionError(String message, dynamic e) {
    log("onSubscriptionError: $message Exception: $e");
  }

  void onDecryptionFailure(String event, String reason) {
    log("onDecryptionFailure: $event reason: $reason");
  }

  void onMemberAdded(String channelName, PusherMember member) {
    log("onMemberAdded: $channelName user: $member");
  }

  void onMemberRemoved(String channelName, PusherMember member) {
    log("onMemberRemoved: $channelName user: $member");
  }

  void _sendMessage() async {
    final generalController = Get.find<GeneralController>();
    final liveChatController = Get.find<LiveChatController>();

    generalController.focusOut(context);

    if (liveChatController.messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please type a message"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (liveChatController.selectedFile != null) {
      dio_instance.FormData formData = dio_instance.FormData.fromMap({
        'appointment_id': generalController.selectedAppointmentHistoryForView.id,
        'message': liveChatController.messageController.text,
        'attachment_file': await dio_instance.MultipartFile.fromFile(
          liveChatController.selectedFile!.path,
          filename: liveChatController.selectedFile!.path.split('/').last,
        ),
      });
      postMethodwithFile(
          context,
          sendMessageUrl,
          formData,
          true,
          (context, success, data) {
            sendMessagesRepo(context, success, data);
            if (success) {
              liveChatController.updateSelectedFile(null);
            }
          });
    } else {
      postMethod(
          context,
          sendMessageUrl,
          {
            'appointment_id': generalController.selectedAppointmentHistoryForView.id,
            'attachment_file': null,
            'message': liveChatController.messageController.text
          },
          true,
          sendMessagesRepo);
    }
  }

  @override
  Widget build(BuildContext context) {
    final generalController = Get.find<GeneralController>();
    return GetBuilder<GeneralController>(builder: (generalController) {
      return GetBuilder<LiveChatController>(builder: (liveChatController) {
        return ModalProgressHUD(
          progressIndicator: const CircularProgressIndicator(
            color: AppColors.primaryColor,
          ),
          inAsyncCall: generalController.callLoaderController,
          child: Scaffold(
            backgroundColor: AppColors.white,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: AppBarWidget(
                leadingIcon: 'assets/icons/Expand_left.png',
                leadingOnTap: () {
                  Get.back();
                  pusherChannels.unsubscribe(channelName: _channelName);
                  pusherChannels.disconnect();
                },
                titleText: generalController
                        .selectedAppointmentHistoryForView.teacherName ??
                    "Teacher",
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: !liveChatController.getMessagesLoader
                ? Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
                    child: liveChatController.messageList.isNotEmpty
                        ? ListView(
                            controller: liveChatController.chatScrollController,
                            children: List.generate(
                              liveChatController.messageList.length,
                              (index) {
                                return Align(
                                  alignment: (liveChatController
                                                  .messageList[index] !=
                                              null &&
                                          liveChatController.messageList[index]
                                                  ["sender_id"] !=
                                              null)
                                      ? (liveChatController.messageList[index]
                                                  ["sender_id"] ==
                                              generalController
                                                  .selectedAppointmentHistoryForView
                                                  .studentId
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft)
                                      : Alignment.centerLeft,
                                  child: Container(
                                    margin:
                                        EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 8.h),
                                    padding: EdgeInsets.fromLTRB(
                                        10.w, 12.h, 10.w, 12.h),
                                    decoration: BoxDecoration(
                                        color: (liveChatController
                                                        .messageList[index] !=
                                                    null &&
                                                liveChatController
                                                            .messageList[index]
                                                        ["sender_id"] ==
                                                    generalController
                                                        .selectedAppointmentHistoryForView
                                                        .studentId)
                                            ? AppColors.primaryColor
                                            : AppColors.primaryColor
                                                .withOpacity(0.6),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (liveChatController.messageList[index]?["is_attachment"] == 1 || liveChatController.messageList[index]?["is_attachment"] == true || liveChatController.messageList[index]?["attachment_url"] != null)
                                          GestureDetector(
                                            onTap: () {
                                              final urlStr = liveChatController.messageList[index]?["attachment_url"]?.toString() ?? "";
                                              if (urlStr.isNotEmpty) {
                                                final fullUrl = urlStr.startsWith('http') ? urlStr : "$mediaUrl$urlStr";
                                                Get.to(() => InAppAttachmentViewer(url: fullUrl));
                                              }
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(bottom: 8.h),
                                              padding: EdgeInsets.all(8.w),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(Icons.insert_drive_file, color: AppColors.primaryColor),
                                                  SizedBox(width: 8.w),
                                                  Flexible(
                                                    child: Text(
                                                      "View Attachment",
                                                      style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        if (liveChatController.messageList[index]?["message"] != null && liveChatController.messageList[index]["message"].toString().isNotEmpty)
                                          Text(
                                            "${liveChatController.messageList[index]?["message"] ?? ""}",
                                            style: AppTextStyles.bodyTextStyle16,
                                          ),
                                        SizedBox(height: 6.h),
                                        Text(
                                          generalController.displayDateTime(
                                              "${liveChatController.messageList[index]?["created_at"] ?? ""}"),
                                          style: AppTextStyles.bodyTextStyle4,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : Container(),
                  )
                  : Container(),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(5.w, 0, 5.w, 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (liveChatController.selectedFile != null)
                        Container(
                          padding: EdgeInsets.all(8.w),
                          margin: EdgeInsets.only(bottom: 8.h),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.insert_drive_file, color: AppColors.primaryColor),
                              SizedBox(width: 8.w),
                              Flexible(
                                child: Text(
                                  liveChatController.selectedFile!.path.split(Platform.pathSeparator).last,
                                  style: TextStyle(color: Colors.black),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.close, color: Colors.red, size: 20),
                                onPressed: () {
                                  liveChatController.updateSelectedFile(null);
                                },
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                              ),
                            ],
                          ),
                        ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.attach_file, color: AppColors.primaryColor),
                            onPressed: () async {
                              FilePickerResult? result = await FilePicker.platform.pickFiles();
                              if (result != null && result.files.single.path != null) {
                                liveChatController.updateSelectedFile(File(result.files.single.path!));
                              }
                            },
                          ),
                          Expanded(
                            child: TextFormField(
                              style: TextStyle(
                                fontFamily: AppFont.primaryFontFamily,
                                fontSize: 14.sp,
                                color: Colors.white,
                              ),
                              controller: liveChatController.messageController,
                              onTap: () {
                                Future.delayed(const Duration(seconds: 1)).whenComplete(
                                    () => liveChatController.chatScrollController
                                        .animateTo(
                                            liveChatController.chatScrollController
                                                .position.maxScrollExtent,
                                            curve: Curves.easeOut,
                                            duration:
                                                const Duration(milliseconds: 500)));
                              },
                              textInputAction: TextInputAction.send,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              onChanged: (value) {
                              },
                              onFieldSubmitted: (value) {
                                _sendMessage();
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.h, horizontal: 20.w),
                                filled: true,
                                fillColor: AppColors.primaryColor,
                                hintText: 'Your Text Here.....',
                                hintStyle: AppTextStyles.bodyTextStyle16,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14.r),
                                    borderSide: const BorderSide(color: Colors.white)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14.r),
                                    borderSide: const BorderSide(
                                        color: AppColors.primaryColor)),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14.r),
                                    borderSide: const BorderSide(color: Colors.red)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14.r),
                                    borderSide: const BorderSide(color: Colors.white)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(10.w, 0, 0, 0),
                            child: InkWell(
                              onTap: _sendMessage,
                              child: const CircleAvatar(
                                radius: 20,
                                backgroundColor: AppColors.primaryColor,
                                child: Icon(
                                  Icons.send,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
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
