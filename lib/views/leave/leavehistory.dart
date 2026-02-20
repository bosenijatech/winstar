import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:powergroupess/models/approveleavemodel.dart';
import 'package:powergroupess/models/error_model.dart';
import 'package:powergroupess/models/viewleavemodel.dart';
import 'package:powergroupess/services/apiservice.dart';
import 'package:powergroupess/utils/app_utils.dart';
import 'package:powergroupess/utils/constants.dart';
import 'package:powergroupess/utils/custom_indicatoronly.dart';
import 'package:powergroupess/views/rejoin/dutyresumptionapply.dart';
import 'package:powergroupess/views/widgets/assets_image_widget.dart';
import 'package:powergroupess/views/widgets/colorstatus.dart';

class LeaveandHistoryPage extends StatefulWidget {
  const LeaveandHistoryPage({super.key});

  @override
  State<LeaveandHistoryPage> createState() => _LeaveandHistoryPageState();
}

class _LeaveandHistoryPageState extends State<LeaveandHistoryPage> {
  ViewLeaveApproveModel historymodel = ViewLeaveApproveModel();
  ErrorModelNetSuite errormodel = ErrorModelNetSuite();
  bool loading = true;
  @override
  void initState() {
    getdetailsdata();
    super.initState();
  }

  @override
  void dispose() {
    loading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !loading
          ? historymodel.message != null
              ? SingleChildScrollView(
                  child: Column(children: [getdetails()]),
                )
              : const Center(child: Text('No Data!'))
          : const CustomIndicator(),
    );
  }

  Widget getdetails() {
    return historymodel.message != null
        ? ListView.builder(
            itemCount: historymodel.message!.length ?? 0,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 3),
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.numbers,
                                  color: AppConstants.colorArray[
                                      index.remainder(
                                          AppConstants.colorArray.length)],
                                ),
                                const SizedBox(width: 15),
                                AppUtils.buildNormalText(
                                  text:
                                      "Internal ID : ${historymodel.message![index].intenalId.toString()}",
                                  fontSize: 14,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.date_range,
                                  color: AppConstants.colorArray[
                                      index.remainder(
                                          AppConstants.colorArray.length)],
                                ),
                                const SizedBox(width: 15),
                                AppUtils.buildNormalText(
                                  text: AppConstants.convertdateformat(
                                      historymodel.message![index].date
                                          .toString()
                                          .substring(0, 10)),
                                  fontSize: 12,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time_filled_sharp,
                                  color: AppConstants.colorArray[
                                      index.remainder(
                                          AppConstants.colorArray.length)],
                                ),
                                const SizedBox(width: 15),
                                Row(
                                  children: [
                                    AppUtils.buildNormalText(
                                        text:
                                            '(${AppConstants.changeddmmyyformat(historymodel.message![index].fromdate.toString())}  to ${AppConstants.changeddmmyyformat(historymodel.message![index].todate.toString())})',
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      '${historymodel.message![index].totalNoOfDays.toString()} ${historymodel.message![index].totalNoOfDays == 1 ? "day" : "days"}',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        statuspendingColor(
                            text: historymodel.message![index].isstatus
                                .toString()),
                        GestureDetector(
                          onTap: () {
                            showCancel(
                              context,
                              index,
                            );
                          },
                          child: Icon(
                            Icons.more_vert,
                            color: Colors.grey.shade500,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey.shade200,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    AppUtils.buildNormalText(
                        text: historymodel.message![index].leavetypename
                            .toString(),
                        fontSize: 16,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(
                      height: 5,
                    ),
                    // historymodel.message![index].approvalHistory!.isNotEmpty
                    //     ? ListView.builder(
                    //         shrinkWrap: true,
                    //         physics: const NeverScrollableScrollPhysics(),
                    //         itemCount: historymodel
                    //             .message![index].approvalHistory!.length,
                    //         itemBuilder: (BuildContext context, int index1) {
                    //           return Row(
                    //             children: [
                    //               const SizedBox(
                    //                 width: 10,
                    //               ),
                    //               appovalpending(
                    //                   text: historymodel
                    //                       .message![index]
                    //                       .approvalHistory![index1]
                    //                       .status
                    //                       .toString),
                    //               const SizedBox(width: 10),
                    //               AppUtils.buildNormalText(
                    //                   text: historymodel.message![index]
                    //                       .approvalHistory![index1].approvername
                    //                       .toString(),
                    //                   fontSize: 14),
                    //             ],
                    //           );
                    //         })
                    //     : Container(),
                  ],
                ),
              );
            },
          )
        : const Center(child: Text('No Data!'));
  }

  void showCancel(context, index) {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('Apply Rejoin Request'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DutyResumption(
                            model: historymodel, position: index)),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Cancel Dialog'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void getdetailsdata() async {
    setState(() {
      loading = true;
    });
    ApiService.viewapprovedleave().then((response) {
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString() == "true") {
          historymodel =
              ViewLeaveApproveModel.fromJson(jsonDecode(response.body));
        } else {
          // AppUtils.showSingleDialogPopup(
          //     context, jsonDecode(response.body)['message'], "Ok", onexitpopup);
        }
      } else {
        throw Exception(jsonDecode(response.body).toString()).toString();
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
}
