import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_to_app/utilities/app_urls.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AppWebViewController{

  static WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {
        },
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('tel:')) {
            launchUrl(Uri.parse(request.url));
            return NavigationDecision.prevent;
          }
          else if (request.url.startsWith('mailto:')) {
            launchUrl(Uri.parse(request.url));
            return NavigationDecision.prevent;
          }
          else if (request.url.startsWith('https:')) {
            launchUrl(Uri.parse(request.url));
            return NavigationDecision.prevent;
          }
          else if (request.url.startsWith('sms:')) {
            launchUrl(Uri.parse(request.url));
            return NavigationDecision.prevent;
          }
          else if (request.url.startsWith('file:')) {
            launchUrl(Uri.parse(request.url));
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse(AppUrls.url));
}

