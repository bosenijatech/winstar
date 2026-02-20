import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:powergroupess/models/viewattendancemodelnew.dart';
import 'package:powergroupess/services/apiservice.dart';
import 'package:powergroupess/services/pref.dart';
import 'package:powergroupess/utils/app_utils.dart';
import 'package:powergroupess/utils/constants.dart';
import 'package:powergroupess/utils/custom_indicatoronly.dart';
import 'package:powergroupess/utils/sharedprefconstants.dart';
import 'package:powergroupess/views/attendance/regualrization.dart';
import 'package:powergroupess/views/widgets/assets_image_widget.dart';
import 'package:intl/intl.dart';

class ViewAttendance extends StatefulWidget {
  const ViewAttendance({super.key});

  @override
  State<ViewAttendance> createState() => _ViewAttendanceState();
}

class _ViewAttendanceState extends State<ViewAttendance> {
  //ViewAttendanceModel viewModel = ViewAttendanceModel();
  ViewAttendanceModelNew viewModel = ViewAttendanceModelNew();
  bool loading = false;
  @override
  void initState() {
    getattendancecheckdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: const Icon(CupertinoIcons.back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: AppUtils.buildNormalText(
              text: "View Attendance - Logs ",
              color: Colors.white,
              fontSize: 16),
          actions: const [
            // Padding(
            //     padding:
            //         const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
            //     child: GestureDetector(
            //         child: const Icon(Icons.more_vert),
            //         onTapDown: (details) {
            //           _showPopUpMenu(details.globalPosition);
            //         }))
          ],
        ),
        body: !loading
            ? SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      informationdetails(),
                      detailpage(),
                    ]),
              )
            : const Center(
                child: CustomIndicator(),
              ));
  }

  Widget informationdetails() {
    return Center(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(5.0),
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                border: Border.all(color: const Color(0xffFFB74D))),
            child: AppUtils.buildNormalText(
                text:
                    "You're at the start of the page! only 1 months of data can be viewed.",
                fontSize: 12,
                lineSpacing: 2,
                color: const Color(0xffFF9800)),
          ),
        ],
      ),
    );
  }

  Widget detailpage() {
    return viewModel.message != null
        ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: viewModel.message!.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  var uniqid = "";

                  uniqid = viewModel.message![index].log!.first.detailuniqid
                      .toString();
                  print(uniqid);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ApplyReqularization(
                              id: uniqid,
                              fromtime: viewModel
                                  .message![index].log!.first.checkintime
                                  .toString()
                                  .substring(11),
                              totime: "",
                              docdate: viewModel.message![index].sId.toString(),
                            )),
                  ).then((_) => getattendancecheckdata());
                },
                child: Container(
                  margin: const EdgeInsets.all(10),
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 3),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade400,
                        width: 0.5,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      color: Colors.white),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppUtils.buildNormalText(
                                text: AppConstants.changeddmmyyformat(
                                    viewModel.message![index].sId.toString()),
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                            Container(
                              margin: const EdgeInsets.all(5.0),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 5.0),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                border: Border.all(color: Colors.green),
                              ),
                              child: AppUtils.buildNormalText(
                                  text: "On Time",
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        AppUtils.buildNormalText(
                            text: Prefs.getShiftName(
                              SharefprefConstants.sharedshiftName,
                            ),
                            fontSize: 12),
                        const SizedBox(
                          height: 10,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Check In",
                                style: TextStyle(color: Colors.black54)),
                            Text("Check out",
                                style: TextStyle(color: Colors.black54)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            viewModel.message![index].log!.last.checkouttime!
                                    .toString()
                                    .isEmpty
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 3.0, vertical: 2.0),
                                    decoration: BoxDecoration(
                                        color: Colors.red.shade50,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5)),
                                        border: Border.all(color: Colors.red)),
                                    child: AppUtils.buildNormalText(
                                        text: "SWIPE(S) MISSING!",
                                        color: Colors.red))
                                : Container(),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                viewModel.message![index].log!.first.checkintime
                                    .toString()
                                    .substring(11),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            Text(
                                viewModel.message![index].log!.last
                                        .checkouttime!.isNotEmpty
                                    ? viewModel
                                        .message![index].log!.last.checkouttime!
                                        .toString()
                                        .substring(11)
                                    : "--:--",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 5),
                        viewModel.message![index].purpose!.isNotEmpty
                            ? Center(
                                child: Container(
                                  margin: const EdgeInsets.all(3.0),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0, vertical: 5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(3)),
                                    border: Border.all(color: Colors.green),
                                  ),
                                  child: AppUtils.buildNormalText(
                                      text: viewModel.message![index].purpose
                                          .toString(),
                                      fontSize: 10,
                                      fontWeight: FontWeight.normal),
                                ),
                              )
                            : Container(),
                        Divider(
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 5),
                        viewModel.message![index].log!.last.checkouttime!
                                .toString()
                                .isEmpty
                            ? Center(
                                child: AppUtils.buildNormalText(
                                    text:
                                        "Please click to Checkout to apply regularization!",
                                    color: Colors.grey.shade500),
                              )
                            : Container(),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: (viewModel.message![index].log!.first
                                          .checkintime!.isNotEmpty &&
                                      viewModel.message![index].log!.last
                                          .checkouttime!.isNotEmpty)
                                  ? AppUtils.buildNormalText(
                                      text: checkeffectivehours(
                                        viewModel.message![index].log!.first
                                            .checkintime!
                                            .substring(11)
                                            .toString(),
                                        viewModel.message![index].log!.last
                                            .checkouttime!
                                            .substring(11)
                                            .toString(),
                                        0,
                                      ),
                                      fontSize: 10,
                                    )
                                  : Container(),
                            ),
                            Expanded(
                              child: (viewModel.message![index].log!.first
                                          .checkintime!.isNotEmpty &&
                                      viewModel.message![index].log!.last
                                          .checkouttime!.isNotEmpty)
                                  ? AppUtils.buildNormalText(
                                      text: checkeffectivehours(
                                        viewModel.message![index].log!.first
                                            .checkintime!
                                            .substring(11)
                                            .toString(),
                                        viewModel.message![index].log!.last
                                            .checkouttime!
                                            .substring(11)
                                            .toString(),
                                        0,
                                      ),
                                      fontSize: 10,
                                    )
                                  : Container(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                      ]),
                ),
              );
            },
          )
        : const Center(
            child: Text('No Data'),
          );
  }

  void changedatetime(fromdate) {
    var parsedDate = DateTime.parse('$fromdate 00:00:00');
  }

  void getattendancecheckdata() async {
    setState(() {
      loading = true;
    });
    ApiService.viewattendancehistorylog().then((response) {
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString() == "true") {
          viewModel =
              ViewAttendanceModelNew.fromJson(jsonDecode(response.body));
        } else {
          viewModel.message = null;
        }
      } else {
        throw Exception(jsonDecode(response.body)['message'].toString());
      }
    }).catchError((e) {
      setState(() {
        loading = false;
      });
      AppUtils.showSingleDialogPopup(context, e.toString(), "Ok", onexitpopup,
          AssetsImageWidget.errorimage);
    });
  }

  void onexitpopup() {
    Navigator.of(context).pop();
  }

  void onrefreshscreen() {
    Navigator.of(context).pop();
    // Navigator.of(context).pop();
  }

  getTime(startTime, endTime) {
    String value = "";
    var result = startTime.compareTo(endTime);

    if (result < 0) {
      print('"$startTime" is less than "$endTime".');
    } else if (result > 0) {
      print('"$startTime" is greater than "$endTime".');
    } else {
      print('"$startTime" is equal to "$endTime".');
    }

    return value;
  }

  validatetiming(String starttime) {
    var shiftstarttime = "10:00:00";
    //var shiftendtime= "06:30 PM";
    var format = DateFormat("hh:mm:ss");
    var start = format.parse(starttime);
    // var end = format.parse(endtime);
    var begin = format.parse(shiftstarttime);

    if (starttime.isNotEmpty) {
      if (start.isBefore(begin)) {
        print('ONTIME');
        return 'ON TIME';
      } else if (start.isAfter(begin)) {
        Duration diff = start.difference(begin);
        final hours = diff.inHours;
        final minutes = diff.inMinutes % 60;
        return '$hours hours $minutes minutes LATE';
      } else if (start.isAtSameMomentAs(begin)) {
        return 'ON TIME';
      }
      // if (start.isBefore(end)) {
      //   //end = end.add(Duration(days: 1));
      //   Duration diff = end.difference(start);
      //   final hours = diff.inHours;
      //   final minutes = diff.inMinutes % 60;
      //   print('$hours hours $minutes minutes');
      // } else {}
    }
  }

  checkeffectivehours(String starttime, String endtime, int status) {
    if (starttime.isNotEmpty && endtime.isNotEmpty) {
      var format = DateFormat("HH:mm:ss");

      var start = format.parse(starttime);
      var end = format.parse(endtime);
      //end = end.add(Duration(days: 1));
      Duration diff = end.difference(start);
      final hours = diff.inHours;
      final minutes = diff.inMinutes % 60;
      if (status == 0) {
        return 'Effective Hours $hours hours $minutes minutes';
      }
      return 'Gross Hours $hours hours $minutes minutes';
    } else {
      return '';
    }
  }
}
