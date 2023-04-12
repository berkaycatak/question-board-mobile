import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  WebViewController? controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = WebViewController()
      ..enableZoom(false)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) async {
            if (request.url.startsWith('https://sorutahtasi.com')) {
              // do something...
            } else if (request.url.startsWith('https://sorutahtasi.com')) {
              // prevent or do something else if this matches
            }
            return NavigationDecision.navigate; // <-- Set it to navigate
          },
        ),
      )
      ..loadRequest(
        Uri.parse('https://sorutahtasi.com'),
      );
    // #enddocregion webview_controller
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller!.runJavaScript('history.back()');
        return false;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(10, 0),
          child: AppBar(
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            elevation: 0,
          ),
        ),
        body: WebViewWidget(
          controller: controller!,
        ),
      ),
    );
  }
}
