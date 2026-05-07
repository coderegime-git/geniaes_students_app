// ignore_for_file: library_prefixes

import 'dart:async';
import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:resize/resize.dart';

import '../../config/app_colors.dart';
import '../../config/app_font.dart';
import '../../controllers/general_controller.dart';
import 'agora.config.dart' as config;

/// Student-side video call screen.
class JoinChannelVideo extends StatefulWidget {
  const JoinChannelVideo({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<JoinChannelVideo> {
  late final RtcEngine _engine;

  bool isJoined = false;
  int? remoteUid;
  int? callEnd = 0;
  bool muted = false;
  bool _disposed = false;

  Timer? _timer;

  // ─── Lifecycle ────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    log('Student JoinChannelVideo: initState');

    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
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

  // ─── Engine setup ─────────────────────────────────────────────────────────

  Future<void> _initAndJoin() async {
    await _initEngine();
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!_disposed) await _joinChannel();
  }

  Future<void> _initEngine() async {
    _engine = createAgoraRtcEngineEx();
    await _engine.initialize(RtcEngineContext(
      appId: config.agoraAppId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));

    _addListeners(); // Once only.

    await _engine.enableVideo();
    await _engine.startPreview();
    await _engine.enableLocalVideo(true);
    await _engine.setVideoEncoderConfiguration(
      const VideoEncoderConfiguration(),
    );
    log('Student JoinChannelVideo: engine ready');
  }

  /// All event handlers – registered once.
  void _addListeners() {
    _engine.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        log('Student: joined channel ${connection.channelId}');
        if (!_disposed) setState(() => isJoined = true);
      },
      onUserJoined: (RtcConnection connection, int uid, int elapsed) {
        log('Student: remote user $uid joined');
        if (!_disposed) {
          setState(() {
            remoteUid = uid;
            callEnd = 1;
          });
        }
      },
        onUserOffline: (connection, uid, reason) {
          log('Student: remote user $uid offline');

          if (!_disposed && remoteUid != null) {
            setState(() {
              callEnd = 2; // only if user was actually connected
              remoteUid = null;
            });
          }
        },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        log('Student: left channel');
        if (!_disposed) {
          setState(() {
            isJoined = false;
            remoteUid = null;
          });
        }
      },
    ));
  }

  Future<void> _joinChannel() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone, Permission.camera].request();
    }

    final gc = Get.find<GeneralController>();
    log('Channel ID: ${gc.channelForCall}');
    log('Token: ${gc.tokenForCall}');
    log('UID: ${gc.callerType}');
    await _engine.joinChannel(
      token: '0062f7fb6408d184598b5d465da7dd1fe66IABbVZVdoouiuGyxRzcWHn6rwVAj2pwACjqvpWtijf9acEsLMAQAAAAAIgCMGAAAg6n0aQQAAQBjYfNpAwBjYfNpAgBjYfNpBABjYfNp',   // null-safe: '' = no-token mode
      channelId: gc.channelForCall!,
      uid: gc.callerType,
      options: const ChannelMediaOptions(
        channelProfile: ChannelProfileType.channelProfileCommunication,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
        autoSubscribeAudio: true,
        autoSubscribeVideo: true,
      ),
    );
    log('Student JoinChannelVideo: joinChannel called');
  }

  Future<void> _leaveChannel() async {
    await _engine.leaveChannel();
  }

  void _callEndCheckMethod() {
    if (callEnd == 2 && remoteUid == null && !_disposed) {
      log("Call ended properly");
      _leaveChannel();
      Get.back();
    }
  }

  void _onToggleMute() {
    setState(() => muted = !muted);
    _engine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() => _engine.switchCamera();

  // ─── UI ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Full-screen remote video or waiting view
            Positioned.fill(child: _remoteVideoOrWaiting()),

            // Local PiP (top-right)
            Positioned(
              top: 50.h,
              right: 16.w,
              child: SizedBox(
                width: 100.w,
                height: 150.h,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: AgoraVideoView(
                    controller: VideoViewController(
                      rtcEngine: _engine,
                      canvas: const VideoCanvas(uid: 0),
                    ),
                  ),
                ),
              ),
            ),

            // Control toolbar (bottom)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _toolbar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _remoteVideoOrWaiting() {
    if (remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: remoteUid),
          connection: RtcConnection(
              channelId: Get.find<GeneralController>().channelForCall),
        ),
      );
    }

    // Waiting for teacher to appear
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor,
            AppColors.primaryColor.withOpacity(0.6),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white24,
              child: Icon(Icons.videocam, size: 50, color: Colors.white),
            ),
            SizedBox(height: 24.h),
            Text(
              'Video Call',
              style: TextStyle(
                fontSize: 22.sp,
                fontFamily: AppFont.primaryFontFamily,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              isJoined ? 'Waiting for teacher…' : 'Connecting…',
              style: TextStyle(
                fontSize: 16.sp,
                fontFamily: AppFont.primaryFontFamily,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toolbar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32.h),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black87, Colors.transparent],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _controlButton(
            icon: muted ? Icons.mic_off : Icons.mic,
            color: muted ? AppColors.primaryColor : Colors.white,
            iconColor: muted ? Colors.white : AppColors.primaryColor,
            onPressed: _onToggleMute,
          ),
          SizedBox(width: 24.w),
          _controlButton(
            icon: Icons.call_end,
            color: Colors.redAccent,
            iconColor: Colors.white,
            onPressed: () async {
              await _leaveChannel();
              Get.back();
            },
            padding: 18.0,
            size: 32.0,
          ),
          SizedBox(width: 24.w),
          _controlButton(
            icon: Icons.switch_camera,
            color: Colors.white,
            iconColor: AppColors.primaryColor,
            onPressed: _onSwitchCamera,
          ),
        ],
      ),
    );
  }

  Widget _controlButton({
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onPressed,
    double size = 24.0,
    double padding = 14.0,
  }) {
    return RawMaterialButton(
      onPressed: onPressed,
      shape: const CircleBorder(),
      elevation: 2.0,
      fillColor: color,
      padding: EdgeInsets.all(padding),
      child: Icon(icon, color: iconColor, size: size),
    );
  }
}