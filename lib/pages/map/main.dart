import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';

class MapPage extends StatelessWidget {
  WebViewController _controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Help')),
      body: WebView(
        initialUrl: 'about:blank',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
          _loadHtmlFromAssets();
        },
        // javascriptChannels: <JavascriptChannel>[
        //   JavascriptChannel(
        //       name: "test",
        //       onMessageReceived: (JavascriptMessage message) {
        //         print("参数： $message");
        //       }),
        // ].toSet(),
      ),
    );
  }

  _loadHtmlFromAssets() async {
    String fileText = await rootBundle.loadString('assets/map/index.html');
    _controller.loadUrl(Uri.dataFromString(fileText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
    // Position position = await Geolocator()
    //     .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    // print(position);
  }
}
