import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:http/http.dart' as http;

class P2PVideo extends StatefulWidget {
  const P2PVideo({super.key});

  @override
  _P2PVideoState createState() => _P2PVideoState();
}

class _P2PVideoState extends State<P2PVideo> {
  RTCPeerConnection? _peerConnection;
  final _localRenderer = RTCVideoRenderer();
  MediaStream? _localStream;
  RTCDataChannelInit? _dataChannelDict;
  RTCDataChannel? _dataChannel;
  String? selectedColor;
  bool _loading = true;

  void _onTrack(RTCTrackEvent event) {
    if (event.track.kind == "video") {
      _localRenderer.srcObject = event.streams[0];
    }
  }

  void _onDataChannelState(RTCDataChannelState? state) {
    switch (state) {
      case RTCDataChannelState.RTCDataChannelClosed:
        print("Camera Closed!");
        break;
      case RTCDataChannelState.RTCDataChannelOpen:
        print("Camera Opened!");
        break;
      default:
        print("Data Channel State: $state");
    }
  }

  Future<bool> _waitForGatheringComplete(_) async {
    if (_peerConnection!.iceGatheringState ==
        RTCIceGatheringState.RTCIceGatheringStateComplete) {
      return true;
    } else {
      await Future.delayed(Duration(seconds: 1));
      return await _waitForGatheringComplete(_);
    }
  }

  void _toggleCamera() async {
    if (_localStream == null) throw Exception('Stream is not initialized');
    final videoTrack = _localStream!
        .getVideoTracks()
        .firstWhere((track) => track.kind == 'video');
    await Helper.switchCamera(videoTrack);
  }

  Future<void> _negotiateRemoteConnection() async {
    return _peerConnection!
        .createOffer()
        .then((offer) {
          return _peerConnection!.setLocalDescription(offer);
        })
        .then(_waitForGatheringComplete)
        .then((_) async {
          var des = await _peerConnection!.getLocalDescription();
          var headers = {
            'Content-Type': 'application/json',
          };
          var request = http.Request(
            'POST',
            Uri.parse('http://10.95.149.241:8081/offer'), //16.16.185.100
          );
          request.body = json.encode({
            "sdp": des!.sdp,
            "type": des.type,
            "video_transform": "edges", // Always use edges transform
            "selected_color": selectedColor,
          });
          request.headers.addAll(headers);

          http.StreamedResponse response = await request.send();

          if (response.statusCode == 200) {
            String data = await response.stream.bytesToString();
            var dataMap = json.decode(data);
            await _peerConnection!.setRemoteDescription(
              RTCSessionDescription(
                dataMap["sdp"],
                dataMap["type"],
              ),
            );
          } else {
            print(response.reasonPhrase);
          }
        });
  }

  Future<void> _startCall() async {
    var configuration = <String, dynamic>{
      'sdpSemantics': 'unified-plan',
      
    };

    if (_peerConnection != null) return;
    _peerConnection = await createPeerConnection(configuration);

    _peerConnection!.onTrack = _onTrack;

    _dataChannelDict = RTCDataChannelInit();
    _dataChannelDict!.ordered = true;
    _dataChannelDict!.maxRetransmits = 0;
    _dataChannelDict!.maxRetransmitTime = 0;
    
    _dataChannel = await _peerConnection!.createDataChannel(
      "video",
      _dataChannelDict!,
    );
    _dataChannel!.onDataChannelState = _onDataChannelState;

    final mediaConstraints = <String, dynamic>{
    'audio': false,
    'video': {
      'mandatory': {
        'minWidth': '640',    // Reduced from 500
        'minHeight': '480',   // Reduced from 500
        'minFrameRate': '24', // Reduced from 30
        'maxBitrate': 2000000, // Add bitrate constraint
      },
      'facingMode': 'environment',
      'optional': [
        {'DtlsSrtpKeyAgreement': true},
        {'RtpDataChannels': true}
      ],
    }
  };

    try {
      var stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
      _localStream = stream;

      stream.getTracks().forEach((element) {
        _peerConnection!.addTrack(element, stream);
      });

      await _negotiateRemoteConnection();
    } catch (e) {
      print(e.toString());
    }

    if (!mounted) return;

    setState(() {
      _loading = false;
    });
  }

  Future<void> initLocalRenderers() async {
    await _localRenderer.initialize();
  }

  @override
  void initState() {
    super.initState();
    initLocalRenderers();
    
    // Get arguments and start call automatically
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        selectedColor = args['selectedColor'] as String;
      }
      _startCall(); // Start call automatically
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.black,
              child: _loading
                  ? Center(child: CircularProgressIndicator())
                  : RTCVideoView(_localRenderer),
            ),
          ),
          // Only show camera switch button
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.black.withOpacity(0.6),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _toggleCamera,
                    child: const Icon(Icons.cameraswitch),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _localStream?.dispose();
    _dataChannel?.close();
    _peerConnection?.close();
    super.dispose();
  }
}