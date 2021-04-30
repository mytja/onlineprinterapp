import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:typed_data';
import 'dart:async';

class MjpegView extends StatefulWidget {
  MjpegView({required this.url, this.fps = 2});

  final String url;
  final int fps;

  @override
  MjpegViewState createState() => MjpegViewState();
}

class MjpegViewState extends State<MjpegView> {
  Image? mjpeg;
  var imgBuf;
  Stopwatch timer = Stopwatch();

  http.Client client = http.Client();
  StreamSubscription? videoStream;

  @override
  void initState() {
    super.initState();

    var request = http.Request("GET", Uri.parse(widget.url));

    client.send(request).then((response) {
      var startIndex = -1;
      var endIndex = -1;
      List<int> buf = [];

      Duration ts;

      timer.start();

      videoStream = response.stream.listen((List<int> data) {
        for (var i = 0; i < data.length - 1; i++) {
          if (data[i] == 0xff && data[i + 1] == 0xd8) {
            startIndex = buf.length + i;
          }

          if (data[i] == 0xff && data[i + 1] == 0xd9) {
            endIndex = buf.length + i;
          }
        }

        buf.addAll(data);

        if (startIndex != -1 && endIndex != -1) {
          // print('start $startIndex, end $endIndex');

          timer.stop();
          ts = timer.elapsed;

          if (ts.inMilliseconds > 1000 / widget.fps) {
            // print('duration ${ts.inMilliseconds / 1000}');

            imgBuf = List<int>.from(buf.getRange(startIndex, endIndex + 2));
            mjpeg = Image.memory(Uint8List.fromList(imgBuf));

            precacheImage(mjpeg!.image, context);

            Future.delayed(const Duration(milliseconds: 100)).then((_) {
              if (mounted) setState(() {});
            });

            timer.reset();
          }

          startIndex = endIndex = -1;
          buf = [];
          timer.start();
        }
      });
    });
  }

  @override
  void deactivate() {
    timer.stop();
    videoStream?.cancel();
    client.close();

    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    if (mjpeg == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Center(child: mjpeg);
    }
  }
}
