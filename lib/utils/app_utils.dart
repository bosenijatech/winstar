import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:powergroupess/utils/appcolor.dart';
import 'package:path_provider/path_provider.dart';

class AppUtils {
  static void hideKeyboard(context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static String capitalize(String value) =>
      value.trim().length > 1 ? value.toUpperCase() : value;

  static void showSnackbar({context, message, backgroundColor}) {
    if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: message,
          backgroundColor: backgroundColor ?? Colors.red,
        ),
      );
    }
    Timer(const Duration(seconds: 4), () {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    });
  }

  // show dialog popup
  static Future showSingleDialogPopup(
      context, title, buttonname, onPressed, icons) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            icon: (icons != null)
                ? Image.asset(
                    icons,
                    width: 80,
                    height: 80,
                  )
                : const Visibility(visible: false, child: Icon(null)),
            title: Text(
              title.toString(),
              maxLines: null,
              style: const TextStyle(fontSize: 14),
            ),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(0xFFFFFFFF),
                    minimumSize: const Size(0, 45),
                    backgroundColor: Appcolor.buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: onPressed,
                  child:
                      Text(buttonname, style: const TextStyle(fontSize: 14))),
            ],
          );
        });
  }

  // show confirmation dialog
  static Future showconfirmDialog(
      context, title, yesstring, nostring, onPressedYes, onPressedNo) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            //TextButton(onPressed: onPressedYes, child: Text(yesstring)),
            // TextButton(onPressed: onPressedNo, child: Text(nostring)),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xFFFFFFFF),
                  minimumSize: const Size(0, 45),
                  backgroundColor: Appcolor.buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: onPressedYes,
                child: Text(yesstring, style: const TextStyle(fontSize: 14))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(0, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: onPressedNo,
              child: Text(
                nostring,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        );
      },
    );
  }

  //Text
  static Widget buildHeaderText({final String? text}) {
    return Text(
      text.toString(),
      style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
    );
  }

  static Widget buildNormalText(
      {@required text,
      color,
      double fontSize = 12,
      textAlign,
      fontWeight,
      letterSpacing,
      wordSpacing,
      fontFamily,
      maxLines,
      overflow,
      decoration,
      lineSpacing,
      fontStyle}) {
    return Text(
      text ?? '--',
      textAlign: textAlign ?? TextAlign.left,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
          decoration: decoration ?? TextDecoration.none,
          color: color ?? Colors.black,
          fontSize: fontSize ?? 12,
          fontWeight: fontWeight ?? FontWeight.w400,
          letterSpacing: letterSpacing ?? 0,
          wordSpacing: wordSpacing ?? 0.0,
          height: lineSpacing != null ? lineSpacing + 0.0 : null,
          fontStyle: fontStyle ?? FontStyle.normal),
    );
  }

  static iconWithText(
      {@required icons,
      @required text,
      MaterialColor? iconcolor,
      color,
      double fontSize = 12,
      textAlign,
      fontWeight,
      letterSpacing,
      wordSpacing,
      fontFamily,
      maxLines,
      overflow,
      decoration,
      lineSpacing,
      fontStyle}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icons,
          color: iconcolor ?? Colors.black,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          text ?? '--',
          textAlign: textAlign ?? TextAlign.left,
          maxLines: maxLines,
          overflow: overflow,
          style: TextStyle(
              decoration: decoration ?? TextDecoration.none,
              color: color ?? Colors.black,
              fontSize: fontSize ?? 12,
              fontWeight: fontWeight ?? FontWeight.w400,
              letterSpacing: letterSpacing ?? 0,
              wordSpacing: wordSpacing ?? 0.0,
              height: lineSpacing != null ? lineSpacing + 0.0 : null,
              fontStyle: fontStyle ?? FontStyle.normal),
        )
      ],
    );
  }

  static void showBottomCupertinoDialog(BuildContext context,
      {@required String? title,
      @required btn1function,
      @required btn2function}) async {
    return showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
          title: Text(title.toString()),
          actions: [
            CupertinoActionSheetAction(
                onPressed: btn1function, child: const Text('Camera')),
            CupertinoActionSheetAction(
                onPressed: btn2function, child: const Text('Files'))
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            },
            child: const Text('Cancel'),
          )),
    );
  }

  static pop(context) {
    Navigator.pop(context);
  }

  static Widget bottomHanger(BuildContext context) {
    return Center(
        child: Container(
      height: 5,
      width: MediaQuery.of(context).size.width / 6,
      decoration: BoxDecoration(
          color: Colors.grey, borderRadius: BorderRadius.circular(100)),
    ));
  }

  static void changeNodeFocus(BuildContext context,
      {FocusNode? current, FocusNode? next}) {
    current!.unfocus();
    FocusScope.of(context).requestFocus(next);
  }

  static errorsnackBar(String message, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(message)));
  }

  static successsnackBar(String message, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.green, content: Text(message)));
  }
  // average for ratings

  static double averageRatings(List<int> ratings) {
    double avg = 0;
    for (int i = 0; i < ratings.length; i++) {
      avg += ratings[i];
    }
    avg /= ratings.length;

    return avg;
  }

  static Widget gethanger(BuildContext context) {
    return Center(
        child: Container(
      height: 5,
      width: MediaQuery.of(context).size.width / 6,
      decoration: BoxDecoration(
          color: Colors.grey, borderRadius: BorderRadius.circular(100)),
    ));
  }

  static Future<String> createFolderInAppDocDir(String folderName) async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final Directory appDocDirFolder =
        Directory('${appDocDir.path}/$folderName/');

    if (await appDocDirFolder.exists()) {
      return appDocDirFolder.path;
    } else {
      final Directory appDocDirNewFolder =
          await appDocDirFolder.create(recursive: true);
      return appDocDirNewFolder.path;
    }
  }
  // _callFolderCreationMethod() async {
  //   String folderInAppDocDir =
  //       await AppUtil.createFolderInAppDocDir('your_folder_name_here');
  // }
}
