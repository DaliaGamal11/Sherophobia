import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;

const APP_ID = '<09a8c603f8594904b6808368cdb8f81f>';
const Token = '<007eJxTYLBZmi3uXsDRNv36S8erlxZIqqjtj7NeXOt8npnpQbXeU2sFBgPLRItkMwPjNAtTSxNLA5MkMwsDC2Mzi+SUJIs0C8M0B5mGtIZARgY97UQGRigE8TkZnPNzc0vzMksqGRgAJBkeHw==>'; // Replace with your token if using authentication

class VideoChatScreen extends StatefulWidget {
  const VideoChatScreen({Key? key}) : super(key: key);

  @override
  _VideoChatScreenState createState() => _VideoChatScreenState();
}

class _VideoChatScreenState extends State<VideoChatScreen> {
  bool _joined = false;
  int _remoteUid = 0;
  bool _switch = false;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone, Permission.camera].request();
    }

    // Create an instance of the Agora RtcEngine
    final engine = await RtcEngine.createWithContext(RtcEngineContext(APP_ID));

    // Set up event handling logic
    engine.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: (String channel, int uid, int elapsed) {
        print('joinChannelSuccess $channel $uid');
        setState(() {
          _joined = true;
        });
      },
      userJoined: (int uid, int elapsed) {
        print('userJoined $uid');
        setState(() {
          _remoteUid = uid;
        });
      },
      userOffline: (int uid, UserOfflineReason reason) {
        print('userOffline $uid');
        setState(() {
          _remoteUid = 0;
        });
      },
    ));

    // Enable video
    await engine.enableVideo();

    // Join channel with channel name as '123'
    await engine.joinChannel(Token, '123', null, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Agora Video Chat'),
      ),
      body: Stack(
        children: [
          Center(
            child: _switch ? _renderRemoteVideo() : _renderLocalPreview(),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _switch = !_switch;
                });
              },
              child: Container(
                width: 100,
                height: 100,
                color: Colors.blue,
                child: Center(
                  child: _switch ? _renderLocalPreview() : _renderRemoteVideo(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderLocalPreview() {
    if (_joined &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS)) {
      return RtcLocalView.SurfaceView();
    } else if (_joined &&
        (defaultTargetPlatform == TargetPlatform.windows ||
            defaultTargetPlatform == TargetPlatform.macOS)) {
      return RtcLocalView.TextureView();
    } else {
      return Center(
        child: Text(
          'Please join channel first',
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  Widget _renderRemoteVideo() {
    if (_remoteUid != 0 &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS)) {
      return RtcRemoteView.SurfaceView(
        uid: _remoteUid,
        channelId: '123',
      );
    } else if (_remoteUid != 0 &&
        (defaultTargetPlatform == TargetPlatform.windows ||
            defaultTargetPlatform == TargetPlatform.macOS)) {
      return RtcRemoteView.TextureView(
        uid: _remoteUid,
        channelId: '123',
      );
    } else {
      return Center(
        child: Text(
          'Waiting for remote user to join',
          textAlign: TextAlign.center,
        ),
      );
    }
  }
}

