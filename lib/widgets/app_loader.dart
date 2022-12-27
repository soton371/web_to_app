import 'package:flutter/cupertino.dart';

class AppLoader{
  static loaderDialog(BuildContext context,String msg) {
    CupertinoAlertDialog alert= CupertinoAlertDialog(
      content: Row(
        children: [
          const CupertinoActivityIndicator(),
          Text("  $msg"),
        ],),
    );
    showCupertinoDialog(
      barrierDismissible: true,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }
}