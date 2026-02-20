import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppConstants {
  static String apiBaseUrl = 'https://mobapp.nijatech.com:5500/';
  //static String apiBaseUrl = 'http://192.168.0.101:4000/';

  static const String androidAppPackageName = "com.nijatech.winstar";
  static const String iOSAppID = "6738953923";

  static const String netSuiteapiBaseUrl =
      'https://9691235.restlets.api.netsuite.com/app/site/hosting/restlet.nl?';

  // static List<Map<String, dynamic>> categories = [
  //   {"icon": "assets/icons/locationicon.svg", "text": "Attendance"},
  //   {"icon": "assets/icons/leaveicon.svg", "text": "Leave Request"},
  //   {"icon": "assets/icons/lettericon.svg", "text": "Letter request"},
  //   // {"icon": "assets/icons/travelrequest.svg", "text": "Travel request"},
  //   {"icon": "assets/icons/payslip.svg", "text": "Payslip"},
  //   {"icon": "assets/icons/assets.svg", "text": "Asset Request"},
  //   {"icon": "assets/icons/rejoin.svg", "text": "Rejoin Request"},
  //   //  {"icon": "assets/icons/expenseclaim.svg", "text": "Expense Claim"},
  //   //{"icon": "assets/icons/grievance.svg", "text": "Grievance"},
  // ];

static List<Map<String, dynamic>> categories = [
  {"icon": Icons.fingerprint, "text": "Attendance"},
  {"icon": Icons.event_available, "text": "Leave Request"},
  {"icon": Icons.mark_email_read, "text": "Letter Request"},
  {"icon": Icons.receipt_long, "text": "Payslip"},
  {"icon": Icons.inventory_2, "text": "Asset Request"},
  {"icon": Icons.restart_alt, "text": "Rejoin Request"},
];


  static convertdateformat(from) {
    if (from.toString().isNotEmpty) {
      String concatefrom = '$from 00:00:00';

      DateTime dt1 = DateTime.parse(concatefrom);

      var convertiondate = DateFormat.yMMMEd().format(dt1);
      return convertiondate.toString();
    } else {
      return;
    }
  }

  static convertdateformat1(from) {
    if (from.toString().isNotEmpty) {
      String concatefrom = '$from';

      DateTime dt1 = DateTime.parse(concatefrom);

      var convertiondate = DateFormat.yMMMMEEEEd().format(dt1);
      return convertiondate.toString();
    } else {
      return;
    }
  }

  static changeddmmyyformat(datetime) {
    return DateFormat("dd-MM-yyyy").format(DateTime.parse(datetime));
  }

  static changeAMPMformat(datetime) {
    return DateFormat("hh:mm a").format(datetime);
  }

  static changeddmmyyhhmmssformat(datetime) {
    return DateFormat("dd-MM-yyyy hh:mm a").format(DateTime.parse(datetime));
  }

  static changeyymmddhoursformat(datetime) {
    var inputFormat = DateFormat('dd/MM/yyyy');
    var date1 = inputFormat.parse(datetime);

    var outputFormat = DateFormat('yyyy-MM-dd');
    var date2 = outputFormat.format(date1);
    return date2;
  }

  // netsuite

  static launchUrl(url, {bool isNewTab = true}) async {
    if (Platform.isAndroid) {
      if (!await launchUrl(
        url,
      )) {
        throw Exception('Could not launch $url');
      }
    } else if (Platform.isIOS) {
      if (!await launchUrl(
        url,
      )) {
        throw Exception('Could not launch $url');
      }
    }
  }

  static const int holidayscriptid = 444;
  static const int holidaydeployid = 1;

  static const int leavescriptid = 433;
  static const int leavedeployid = 1;

  static const int letterscriptid = 429;
  static const int lettereployid = 1;

  static const int assettypescriptid = 460;
  static const int assettypedeployid = 1;

  static const int assetnamescriptid = 461;
  static const int assetnamedeployid = 1;

  static const int timsheetapproversciptid = 253;
  static const int timsheetapproverdeployid = 1;

  static const int travelpurposcriptid = 3317;
  static const int travelpurposedeployid = 1;

  static const int travelmodesciptid = 3316;
  static const int travelmodedeployid = 1;

  static const int claimtypescriptid = 3311;
  static const int claimtypedeployid = 1;

  static const int empskillscriptid = 435;
  static const int empskilldeployid = 1;

  static const int empdocumentscriptid = 432;
  static const int empdocumentdeployid = 1;

  static const int empeducationscriptid = 431;
  static const int empeducationdeployid = 1;

  static const int emprelationscriptid = 430;
  static const int emprelationdeployid = 1;

  static const int empsalaryscriptid = 251;
  static const int empsalarydeployid = 1;

  static const int yearlistscriptid = 439;
  static const int yearlistdeployid = 1;

  static const int getcompanyscriptid = 437;
  static const int getcompanydeployod = 1;

  static const int getpayslipscriptid = 443;
  static const int getpayslipdeployid = 1;

  static const bool isyellow = true;

  static List<Color> colorArray = [
    const Color(0xFF1ea4a9),
    const Color(0xFF5697db),
    const Color(0xFFeb3f55),
    const Color(0xFFF39F5A),
    const Color(0xFF5B0888),
    const Color(0xFF618264),
    const Color(0xFF80B300),
    const Color(0xFF00B3E6),
    const Color(0xFF1ea4a9),
    const Color(0xFF5697db),
  ];

  static List<Color> containercolorArray = const [
    Color(0xFFF875AA),
    Color(0xFF00B3E6),
    Color(0xFFB931FC),
    Color(0xFF5697db),
    Color(0xFFeb3f55),
    Color(0xFF5B0888),
    Color(0xFF5697db),
    Color(0xFFF4CE14),
    Color(0xFFD83F31),
  ];

  static List<Color> lightcolorArray = [
    const Color(0xFF1ea4a9),
    const Color(0xFF5697db),
    const Color(0xFFeb3f55),
    const Color(0xFFF39F5A),
    const Color(0xFF8e18cd),
    const Color(0xFF618264),
  ];

  static List<Color> darkcolorArray = const [
    Color(0xFF1963b3),
    Color(0xff093e77),
    Color(0xFF841020),
    Color(0xFFcd6a18),
    Color(0xFF5B0888),
    Color(0xff0f7017)
  ];

  static String getFileTypeExtension(String fileName) {
    return ".${fileName.split('.').last}".toLowerCase();
  }

  // Future<String> getBase64(File file) async {
  //   String? base64;
  //   String? contentType = getContentType(file.path);
  //   if (contentType != null) {
  //     if (contentType.contains("image")) {
  //       final uInt8List = file.readAsBytesSync();
  //       base64 = base64Encode(uInt8List);
  //     } else {
  //       final uInt8List = await file.readAsBytes();
  //       base64 = base64Encode(uInt8List);
  //     }
  //     print("contentType: $contentType");
  //   }
  //   return base64 ?? "";
  // }

  // static String? getContentType(String filePath) {
  //   String extension = filePath.split('.').last;
  //   String? mimeType = lookupMimeType(filePath);
  //   return mimeType;
  // }

  static int daysBetween(from, to) {
    DateTime fromdatetime = DateTime.parse(from);
    DateTime toatetime = DateTime.parse(to);
    final differenceInDays = toatetime.difference(fromdatetime).inDays + 1;
    print(differenceInDays);
    return differenceInDays;
  }

  // static Future<void> launch(String url, {bool isNewTab = true}) async {
  //   await launchUrl(
  //     Uri.parse(url),
  //   );
  // }
}
