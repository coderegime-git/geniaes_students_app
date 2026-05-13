import 'dart:async';
import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:resize/resize.dart';

import '../../api_services/urls.dart';
import '../../config/app_colors.dart';
import '../../config/app_font.dart';
import '../../controllers/general_controller.dart';
import 'agora.config.dart' as config;

/// Student-side audio call screen.
class JoinChannelAudio extends StatefulWidget {
  final String? channelId;

  const JoinChannelAudio({super.key, this.channelId});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<JoinChannelAudio> {
  late final RtcEngine _engine;
  bool isJoined = false;
  bool openMicrophone = true;
  bool enableSpeakerphone = false;
  int? callEnd = 0;
  bool _disposed = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    log('Student JoinChannelAudio: initState');

    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _callEndCheckMethod();
    });

    _initAndJoin();
  }

  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }

  Future<void> _initAndJoin() async {
    await _initEngine();
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!_disposed) await _joinChannel();
  }

  Future<void> _initEngine() async {
    // Wait for Agora App ID to be loaded if it's currently empty
    int retryCount = 0;
    while (config.agoraAppId.isEmpty && retryCount < 10 && !_disposed) {
      log('Student JoinChannelAudio: Agora App ID is empty, waiting... (Attempt ${retryCount + 1})');
      await Future.delayed(const Duration(milliseconds: 500));
      retryCount++;
    }

    if (config.agoraAppId.isEmpty) {
      log('Student JoinChannelAudio: Agora App ID is still empty after retries. Initialization aborted.');
      return;
    }

    _engine = createAgoraRtcEngineEx();
    await _engine.initialize(RtcEngineContext(
      appId: config.agoraAppId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));

    _addListeners();

    await _engine.enableAudio();
    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    log('Student JoinChannelAudio: engine ready');
  }

  void _addListeners() {
    _engine.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        log('Student JoinChannelAudio: joined channel ${connection.channelId}');
        if (!_disposed) setState(() => isJoined = true);
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        log('Student JoinChannelAudio: left channel');
        if (!_disposed) setState(() => isJoined = false);
      },
      onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
        log('Student JoinChannelAudio: teacher $remoteUid joined');
        if (!_disposed) setState(() => callEnd = 1);
      },
      onUserOffline: (RtcConnection connection, int remoteUid,
          UserOfflineReasonType reason) {
        log('Student JoinChannelAudio: teacher $remoteUid offline');
        if (!_disposed) {
          setState(() {
            if (callEnd == 1) callEnd = 2;
          });
        }
      },
    ));
  }

  Future<void> _joinChannel() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await Permission.microphone.request();
    }

    final gc = Get.find<GeneralController>();
    // Student joins as UID 2 (Teacher is 1) to avoid UID collision.
    final uid = gc.callerType == 1 ? 2 : gc.callerType;
    log('Student JoinChannelAudio: joining channel=${gc.channelForCall} uid=$uid');

    await _engine
        .joinChannel(
          token: gc.tokenForCall ?? '',
          channelId: gc.channelForCall!,
          uid: uid,
          options: const ChannelMediaOptions(
            // channelProfile removed – already set in RtcEngineContext
            clientRoleType: ClientRoleType.clientRoleBroadcaster,
            publishMicrophoneTrack: true,
            publishCameraTrack: false,
            autoSubscribeAudio: true,
            autoSubscribeVideo: false,
          ),
        )
        .catchError((e) => log('Student JoinChannelAudio error: $e'));
    log('Student JoinChannelAudio: joinChannel called');
  }

  Future<void> _leaveChannel() async {
    await _engine.leaveChannel();
  }

  void _callEndCheckMethod() {
    if (callEnd == 2 && !_disposed) {
      _timer?.cancel();
      _leaveChannel();
      Get.back();
    }
  }

  void _switchMicrophone() {
    _engine.enableLocalAudio(!openMicrophone).then((_) {
      if (!_disposed) setState(() => openMicrophone = !openMicrophone);
    }).catchError((e) => log('mic toggle error: $e'));
  }

  void _switchSpeakerphone() {
    _engine.setEnableSpeakerphone(!enableSpeakerphone).then((_) {
      if (!_disposed) setState(() => enableSpeakerphone = !enableSpeakerphone);
    }).catchError((e) => log('speaker toggle error: $e'));
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/call-bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * .1),

                // Teacher Avatar (fallback to login info image if not available)
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      '$mediaUrl${Get.find<GeneralController>().selectedAppointmentHistoryForView.teacherImage ?? ""}'),
                  radius: 75.h,
                ),

                SizedBox(height: 16.h),

                // Status
                Text(
                  isJoined ? 'Audio Call in Progress' : 'Connecting…',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontFamily: AppFont.primaryFontFamily,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: MediaQuery.of(context).size.height * .12),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Mute
                          InkWell(
                            onTap: _switchMicrophone,
                            child: CircleAvatar(
                              radius: 30.r,
                              backgroundColor: !openMicrophone
                                  ? AppColors.primaryColor
                                  : Colors.white,
                              child: Icon(
                                openMicrophone ? Icons.mic : Icons.mic_off,
                                color: openMicrophone
                                    ? AppColors.primaryColor
                                    : Colors.white,
                                size: 25,
                              ),
                            ),
                          ),

                          // Speaker
                          InkWell(
                            onTap: _switchSpeakerphone,
                            child: CircleAvatar(
                              radius: 30.r,
                              backgroundColor: enableSpeakerphone
                                  ? AppColors.primaryColor
                                  : Colors.white,
                              child: Icon(
                                enableSpeakerphone
                                    ? Icons.volume_up
                                    : Icons.volume_off,
                                color: enableSpeakerphone
                                    ? Colors.white
                                    : AppColors.primaryColor,
                                size: 25,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // End call
                      InkWell(
                        onTap: () async {
                          await _leaveChannel();
                          Get.back();
                        },
                        child: const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.red,
                          child: Icon(Icons.call_end,
                              color: Colors.white, size: 25),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
