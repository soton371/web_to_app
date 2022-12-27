import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:web_to_app/providers/app_web_view_con.dart';
import 'package:web_to_app/widgets/app_loader.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({Key? key}) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {

  //for internet controller
  bool _status = true;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription _streamSubscription;

  void checkRealtimeConnection() {
    _streamSubscription = _connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.mobile) {
        _status = true;
      } else if (event == ConnectivityResult.wifi) {
        setState(() {
          _status = true;
        });

      } else {
        _status = false;
      }
      setState(() {});
    });
  }

  Widget noInternet(){
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/jsons/nointernet.json',height: 200),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text('No internet connection found.\nCheck your connection and try again.',
                style: TextStyle(
                    fontSize: 15,
                    letterSpacing: 1
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
  //end internet controller


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkRealtimeConnection();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        if( await AppWebViewController.controller.canGoBack()){
          AppWebViewController.controller.goBack();
          return false;
        }else{
          bool exitApp = await showCupertinoDialog(
              context: context,
              barrierDismissible: true,
              builder: (context){
                return CupertinoAlertDialog(
                  title: Text('Confirmation'),
                  content: Text('Are you sure you want to exit?'),
                  actions: [
                    TextButton(
                        child: Text('Cancel'),
                        onPressed: ()=>Navigator.of(context).pop(false)
                    ),
                    TextButton(
                        child: Text('Exit',style: TextStyle(color: Colors.redAccent),),
                        onPressed: ()=>Navigator.of(context).pop(true)
                    ),
                  ],
                );
              }
          );
          return exitApp;
        }
      },
      child: Scaffold(
        body: SafeArea(
            child:_status?
            WebViewWidget(
              controller: AppWebViewController.controller,
              gestureRecognizers: Set()
                ..add(Factory<VerticalDragGestureRecognizer>(
                        () => VerticalDragGestureRecognizer()
                      ..onDown = (DragDownDetails dragDownDetails) {
                        AppWebViewController.controller.getScrollPosition().then((value) {
                          if (value.dy == 0.0 &&
                              dragDownDetails.globalPosition.direction < 1) {
                            AppLoader.loaderDialog(context,'Loading..');
                            AppWebViewController.controller.reload();
                            Navigator.pop(context);
                          }
                        });
                      })),
            )
          :
          noInternet(),
        ),
      ),
    );
  }
}
