import 'package:crypto_wallet/api/api.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChartFullScreen extends StatefulWidget {
  String coinSymbol;


  ChartFullScreen({required this.coinSymbol});

  @override
  State<ChartFullScreen> createState() => _ChartFullScreenState();
}

class _ChartFullScreenState extends State<ChartFullScreen> {
  WebViewController? _webViewController;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 1.sh,
          width: 1.sw,
          child: Image.asset(
            AppImage.imgBg,
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          appBar: AppBar(title: Text("Chart"),),
          backgroundColor: Colors.transparent,
          body: WebView(
            onWebViewCreated: (WebViewController? webViewController) {
              _webViewController = webViewController;
              _webViewController?.loadUrl(
                  "${ApiUrl.graphUrl}/${widget.coinSymbol}",
                  headers: {"Authorization": ""});
            },
            onPageFinished: (String url) {

              // _webViewController?.evaluateJavascript('document.body.style.overflow = \'hidden\';');
            },
            initialUrl: "${ApiUrl.graphUrl}/${widget.coinSymbol}",
            debuggingEnabled: true,
            gestureNavigationEnabled: true,
            javascriptMode: JavascriptMode.unrestricted,
            // gestureNavigationEnabled: true,
            // backgroundColor: Colors.red,
            onPageStarted: (s) {
              print("object ===>   $s");
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
