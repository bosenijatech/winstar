import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:winstar/models/loginmodel.dart';
import 'package:winstar/services/pref.dart';
import 'package:winstar/utils/api_details.dart';
import 'package:winstar/utils/constants.dart';
import 'package:winstar/utils/sharedprefconstants.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ApiService {
  static String mobilecurrentdate =
      DateFormat("yyyy-MM-dd").format(DateTime.now()); //2023-07-15";
  // static String mobilecurrentdatetime =
  //     DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()); //2023-07-15";

  static const int timeOutDuration = 35;

  static String sessiontoken = Prefs.getToken("Token").toString();
  static String empid = Prefs.getEmpID("empID")!.toString();

  static Future<http.Response> getlogin(
      String usename, String password, String imeino) async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.getLogin);
    Map<String, String> headers = {"Content-Type": "application/json"};

    var body = {
      "mobileusername": usename,
      "mobilepassword": password,
      "mobileuniqID": imeino
    };
    var response =
        await http.post(url, body: jsonEncode(body), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );
    return response;
  }

  static Future<http.Response> getemployeedetailsdata() async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.getProfile);
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${Prefs.getToken('token')}'
    };

    var body = {
      "nsId": Prefs.getNsID(SharefprefConstants.sharednsid.toString())
    };
    var response =
        await http.post(url, body: jsonEncode(body), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );
    print(jsonEncode(body));
    return response;
  }

  static Future<http.Response> getskills() async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.getProfile);
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${Prefs.getToken('token')}'
    };

    var body = {
      "nsid": Prefs.getUserName(SharefprefConstants.sharedempId).toString()
    };
    var response =
        await http.post(url, body: jsonEncode(body), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );
    return response;
  }

  static Future<http.Response> getEducation() async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.getProfile);
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${Prefs.getToken('token')}'
    };

    var body = {
      "nsid": Prefs.getUserName(SharefprefConstants.sharedempId).toString()
    };
    var response =
        await http.post(url, body: jsonEncode(body), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );
    return response;
  }

  static Future<http.Response> addprofiles(dynamic json) async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.addprofile1);
    Map<String, String> headers = {"Content-Type": "application/json"};
    var response = await http
        .post(url, body: jsonEncode(json), headers: headers)
        .timeout(const Duration(seconds: timeOutDuration));
    return response;
  }

  static Future<http.Response> updatemaster(dynamic json) async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.updatemaster1);

    Map<String, String> headers = {"Content-Type": "application/json"};

    var response =
        await http.post(url, body: jsonEncode(json), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );
    return response;
  }

  static Future<http.Response> viewattendancehistorylog() async {
    DateTime today = DateTime.now();
    String cdate = DateFormat("yyyy-MM-dd").format(today);

    DateTime yesterday = today.subtract(const Duration(days: 30));
    String ydate = DateFormat("yyyy-MM-dd").format(yesterday);

    var url = Uri.parse(
        AppConstants.apiBaseUrl + ApiDetails.viewbioattendancehistorylog);

    Map<String, String> headers = {"Content-Type": "application/json"};

    var body = {
      "nsId": int.parse(Prefs.getNsID('nsid').toString()),
      // "fromdate": ydate,
      // "todate": cdate
    };
    print(jsonEncode(body));
    var response =
        await http.post(url, body: jsonEncode(body), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );
    return response;
  }

  static Future<http.Response> viewattendancebiohistory() async {
    DateTime today = DateTime.now();
    String cdate = DateFormat("yyyy-MM-dd").format(today);

    var url = Uri.parse(
        AppConstants.apiBaseUrl + ApiDetails.viewbioattendancehistory);

    Map<String, String> headers = {"Content-Type": "application/json"};

    var body = {
      "nsId": Prefs.getNsID('nsid'),
      "docdate": cdate,
    };
    var response =
        await http.post(url, body: jsonEncode(body), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );
    print(jsonEncode(body));
    return response;
  }

  static Future<http.Response> viewbioattendance() async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.viewbioattendance);

    Map<String, String> headers = {
      "Content-Type": "application/json",
      //'Authorization': 'Bearer ${Prefs.getToken('token')}'
    };
    var body = {
      "nsId": Prefs.getNsID('nsid'),
      "currentdate": mobilecurrentdate
    };
    var response =
        await http.post(url, body: jsonEncode(body), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );
    return response;
  }

  static Future<http.Response> updateAttendance(dynamic json) async {
    var url =
        Uri.parse(AppConstants.apiBaseUrl + ApiDetails.updatebioattendance);

    Map<String, String> headers = {"Content-Type": "application/json"};

    var response =
        await http.post(url, body: jsonEncode(json), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );

    return response;
  }

  static Future<http.Response> postBioAttendance(dynamic json) async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.addbioattendance);
    Map<String, String> headers = {"Content-Type": "application/json"};
    var response = await http
        .post(url, body: jsonEncode(json), headers: headers)
        .timeout(const Duration(seconds: timeOutDuration));
    return response;
  }

  static Future<http.Response> postleave(dynamic json) async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.applyleave);

    Map<String, String> headers = {
      "Content-Type": "application/json",
      //'Authorization': 'Bearer ${Prefs.getToken('token')}'
    };
    var response =
        await http.post(url, body: jsonEncode(json), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );

    return response;
  }

  static Future<http.Response> viewleave() async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.viewleave);

    Map<String, String> headers = {
      "Content-Type": "application/json",
      //'Authorization': 'Bearer ${Prefs.getToken('token')}'
    };
    var body = {
      "nsid": int.parse(Prefs.getNsID('nsid').toString()),
    };

    var response =
        await http.post(url, body: jsonEncode(body), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );
    print(jsonEncode(body));
    return response;
  }

  static Future<http.Response> cancelleave(internalid, reason, uniqid) async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.cancelleave);

    Map<String, String> headers = {"Content-Type": "application/json"};
    String mobilecurrentdatetime1 =
        DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
    var body = {
      "internalid": internalid,
      "uniqid": uniqid,
      "iscancelledreason": reason,
      "iscancelleddate": mobilecurrentdatetime1
    };
    print(jsonEncode(body));
    var response =
        await http.post(url, body: jsonEncode(body), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );
    return response;
  }

  static Future<http.Response> pullbackleave(internalid, reason, uniqid) async {
    var url =
        Uri.parse(AppConstants.apiBaseUrl + ApiDetails.cancelpullbackleave);

    Map<String, String> headers = {"Content-Type": "application/json"};
    String mobilecurrentdatetime1 =
        DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
    var body = {
      "internalid": internalid,
      "uniqid": uniqid,
      "ispullbackcancelledreason": reason,
      "ispullbackcancelleddate": mobilecurrentdatetime1
    };

    var response =
        await http.post(url, body: jsonEncode(body), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );
    return response;
  }

  //RE JOIN

  static Future<http.Response> onpostdutyresumption(dynamic json) async {
    var url =
        Uri.parse(AppConstants.apiBaseUrl + ApiDetails.onpostdutyresumotion);

    Map<String, String> headers = {"Content-Type": "application/json"};

    var response =
        await http.post(url, body: jsonEncode(json), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );
    return response;
  }

  //ASSET

  static Future<http.Response> postassetrequest(dynamic json) async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.applyassetrequest);

    Map<String, String> headers = {
      "Content-Type": "application/json",
      //'Authorization': 'Bearer ${Prefs.getToken('token')}'
    };
    var response =
        await http.post(url, body: jsonEncode(json), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );

    return response;
  }

  static Future<http.Response> viewpostassetrequest() async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.viewassetrequest);

    Map<String, String> headers = {
      "Content-Type": "application/json",
      //'Authorization': 'Bearer ${Prefs.getToken('token')}'
    };
    var body = {
      "nsid": Prefs.getNsID('nsid'),
    };
    var response =
        await http.post(url, body: jsonEncode(body), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );

    return response;
  }

  static Future<http.Response> postletterrequest(dynamic json) async {
    var url =
        Uri.parse(AppConstants.apiBaseUrl + ApiDetails.applyletterrequest);

    Map<String, String> headers = {
      "Content-Type": "application/json",
      //'Authorization': 'Bearer ${Prefs.getToken('token')}'
    };
    var response =
        await http.post(url, body: jsonEncode(json), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );

    return response;
  }

  static Future<http.Response> viewpostletterrequest() async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.viewletterrequest);

    Map<String, String> headers = {
      "Content-Type": "application/json",
      //'Authorization': 'Bearer ${Prefs.getToken('token')}'
    };
    var body = {
      "nsid": Prefs.getNsID('nsid'),
    };
    var response =
        await http.post(url, body: jsonEncode(body), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );

    return response;
  }

  static Future<http.Response> getallemployee() async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.viewallemployee);

    Map<String, String> headers = {"Content-Type": "application/json"};

    var body = {
      "nsid": Prefs.getNsID('nsid'),
    };

    var response =
        await http.post(url, body: jsonEncode(body), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );
    return response;
  }

//START DUTY TRAVEL
  static Future<http.Response> postdutytravelrequest(dynamic json) async {
    var url =
        Uri.parse(AppConstants.apiBaseUrl + ApiDetails.applydutytravelrequest);

    Map<String, String> headers = {
      "Content-Type": "application/json",
      //'Authorization': 'Bearer ${Prefs.getToken('token')}'
    };
    var response =
        await http.post(url, body: jsonEncode(json), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );

    return response;
  }

  static Future<http.Response> viewtravelduty() async {
    var url =
        Uri.parse(AppConstants.apiBaseUrl + ApiDetails.viewdutytraveldetails);

    Map<String, String> headers = {
      "Content-Type": "application/json",
      //'Authorization': 'Bearer ${Prefs.getToken('token')}'
    };
    var body = {
      "nsid": int.parse(Prefs.getNsID('nsid').toString()),
    };
    print(jsonEncode(body));
    var response =
        await http.post(url, body: jsonEncode(body), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );

    return response;
  }

  // START REIM

  static Future<http.Response> postreimbursementrequest(dynamic json) async {
    var url =
        Uri.parse(AppConstants.apiBaseUrl + ApiDetails.applyreimrequestrequest);

    Map<String, String> headers = {
      "Content-Type": "application/json",
      //'Authorization': 'Bearer ${Prefs.getToken('token')}'
    };
    var response =
        await http.post(url, body: jsonEncode(json), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );

    return response;
  }

  static Future<http.Response> viewreimbursementrequest() async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.viewreimdetails);

    Map<String, String> headers = {
      "Content-Type": "application/json",
      //'Authorization': 'Bearer ${Prefs.getToken('token')}'
    };
    var body = {
      "nsid": Prefs.getNsID('nsid'),
    };
    var response =
        await http.post(url, body: jsonEncode(body), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );

    return response;
  }

//END REIM

  static Future<http.Response> updatepassword(
      String oldpass, String newpass) async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.updatepassword);

    Map<String, String> headers = {
      "Content-Type": "application/json",
      //'Authorization': 'Bearer ${Prefs.getToken('token')}'
    };
    var body = {
      "nsId": Prefs.getNsID('nsid'),
      "oldpassword": oldpass,
      "newpassword": newpass,
    };
    var response =
        await http.post(url, body: jsonEncode(body), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );

    return response;
  }

  static Future<http.Response> viewholiday() async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.viewholidaymaster);

    Map<String, String> headers = {
      "Content-Type": "application/json",
      //'Authorization': 'Bearer ${Prefs.getToken('token')}'
    };

    var response = await http.get(url).timeout(
          const Duration(seconds: timeOutDuration),
        );

    return response;
  }

  static Future<http.Response> postgrievance(dynamic json) async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.addgrievance);

    Map<String, String> headers = {
      "Content-Type": "application/json",
      //'Authorization': 'Bearer ${Prefs.getToken('token')}'
    };
    var response =
        await http.post(url, body: jsonEncode(json), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );

    return response;
  }

  static Future<http.Response> postattachment(dynamic json) async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.uploadfiles);

    Map<String, String> headers = {
      "Content-Type": "application/json",
      //'Authorization': 'Bearer ${Prefs.getToken('token')}'
    };
    var response =
        await http.post(url, body: jsonEncode(json), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );

    return response;
  }

  static Future<http.Response> postreqularization(dynamic json) async {
    var url =
        Uri.parse(AppConstants.apiBaseUrl + ApiDetails.applyreqularization);

    Map<String, String> headers = {"Content-Type": "application/json"};

    var response =
        await http.post(url, body: jsonEncode(json), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );

    return response;
  }

  static Future<http.Response> yearlist() async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.getyearlist);

    Map<String, String> headers = {"Content-Type": "application/json"};

    var response = await http.get(url, headers: headers).timeout(
          const Duration(seconds: timeOutDuration),
        );

    return response;
  }

  static Future<http.Response> sendforgeotpassword(String emailid) async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.forgetpassword);
    Map<String, String> headers = {"Content-Type": "application/json"};
    var body = {"mobileemail": emailid};

    var response =
        await http.post(url, headers: headers, body: jsonEncode(body)).timeout(
              const Duration(seconds: timeOutDuration),
            );
    return response;
  }

  static Future<http.Response> viewapprovedleave() async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.viewapprovedleave);
    Map<String, String> headers = {"Content-Type": "application/json"};
    var body = {
      "currentDate": mobilecurrentdate,
      "nsid": int.parse(Prefs.getNsID('nsid').toString()),
    };

    var response =
        await http.post(url, headers: headers, body: jsonEncode(body)).timeout(
              const Duration(seconds: timeOutDuration),
            );
    print(jsonEncode(body));
    return response;
  }

  static Future<http.Response> viewrejoin() async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.viewrejoin);
    Map<String, String> headers = {"Content-Type": "application/json"};
    var body = {
      "nsid": int.parse(Prefs.getNsID('nsid').toString()),
    };

    var response =
        await http.post(url, headers: headers, body: jsonEncode(body)).timeout(
              const Duration(seconds: timeOutDuration),
            );
    print(jsonEncode(body));
    return response;
  }

  static Future<http.Response> getpayslip(dynamic json) async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.viewpayslip);
    Map<String, String> headers = {"Content-Type": "application/json"};
    var response = await http
        .post(url, body: jsonEncode(json), headers: headers)
        .timeout(const Duration(seconds: timeOutDuration));
    return response;
  }

  static Future<http.Response> requestpayslip(dynamic json) async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.requestpayslip);
    Map<String, String> headers = {"Content-Type": "application/json"};
    var response = await http
        .post(url, body: jsonEncode(json), headers: headers)
        .timeout(const Duration(seconds: timeOutDuration));
    return response;
  }

  static Future<http.Response> deletepayslip(dynamic json) async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.deletepayslip);
    Map<String, String> headers = {"Content-Type": "application/json"};
    var response = await http
        .post(url, body: jsonEncode(json), headers: headers)
        .timeout(const Duration(seconds: timeOutDuration));
    return response;
  }
}
