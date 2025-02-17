import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewPage extends StatefulWidget {
  final String snapToken;

  PaymentWebViewPage({required this.snapToken});

  @override
  _PaymentWebViewPageState createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
  late final WebViewController _webViewController;

  @override
  void initState() {
    super.initState();

    // Inisialisasi WebViewController
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse("https://app.sandbox.midtrans.com/snap/v2/vtweb/${widget.snapToken}"),
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            print('Halaman mulai dimuat: $url');
          },
          onPageFinished: (url) {
            print('Halaman selesai dimuat: $url');
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halaman Pembayaran'),
      ),
      body: WebView(
        initialUrl: "https://app.sandbox.midtrans.com/snap/v2/vtweb/${widget.snapToken}",
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}

WebView({required String initialUrl, required javascriptMode}) {
}

class JavascriptMode {
  static var unrestricted;
}
