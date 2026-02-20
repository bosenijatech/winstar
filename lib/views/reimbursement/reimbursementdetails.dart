import 'dart:convert';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:powergroupess/models/viewreimmodel.dart';
import 'package:powergroupess/routenames.dart';
import 'package:powergroupess/services/apiservice.dart';
import 'package:powergroupess/utils/app_utils.dart';
import 'package:powergroupess/utils/constants.dart';
import 'package:powergroupess/utils/custom_indicatoronly.dart';
import 'package:powergroupess/views/widgets/assets_image_widget.dart';
import 'package:powergroupess/views/widgets/colorstatus.dart';
import 'package:powergroupess/views/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

class ReimbursementDetails extends StatefulWidget {
  const ReimbursementDetails({super.key});

  @override
  State<ReimbursementDetails> createState() => _ReimbursementDetailsState();
}

class _ReimbursementDetailsState extends State<ReimbursementDetails> {
  bool loading = false;
  ViewReimModel reimmodel = ViewReimModel();
  @override
  void initState() {
    getdetailsdata();
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
            text: "Reimbursement Details", color: Colors.white, fontSize: 20),
        centerTitle: true,
      ),
      body: !loading
          ? reimmodel.message != null
              ? SingleChildScrollView(
                  child: Column(
                    children: [builderwidget()],
                  ),
                )
              : Center(
                  child: Image.asset(
                  'assets/images/nodata1.png',
                  height: 200,
                  width: 200,
                ))
          : const CustomIndicator(),
      persistentFooterButtons: [
        CustomButton(
            onPressed: () {
              Navigator.pushNamed(context, RouteNames.reimapply).then((_) {
                setState(() {
                  getdetailsdata();
                });
              });
            },
            name: "Click to Apply Expense",
            fontSize: 14,
            circularvalue: 30),
      ],
    );
  }

  Widget builderwidget() {
    return reimmodel.message != null
        ? ListView.builder(
            itemCount: reimmodel.message!.length ?? 0,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
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
                                Icon(CupertinoIcons.person_circle,
                                    color: AppConstants.containercolorArray[
                                        index.remainder(AppConstants
                                            .containercolorArray.length)]),
                                const SizedBox(width: 15),
                                AppUtils.buildNormalText(
                                    text: reimmodel.message![index].toEmpName
                                        .toString(),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(CupertinoIcons.time,
                                    color: AppConstants.containercolorArray[
                                        index.remainder(AppConstants
                                            .containercolorArray.length)]),
                                const SizedBox(width: 15),
                                RichText(
                                  text: TextSpan(
                                    text: AppConstants.convertdateformat(
                                        reimmodel.message![index].createdDate
                                            .toString()
                                            .substring(0, 10)),
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black),
                                    children: <InlineSpan>[
                                      const WidgetSpan(
                                          alignment:
                                              PlaceholderAlignment.baseline,
                                          baseline: TextBaseline.alphabetic,
                                          child: SizedBox(width: 10)),
                                      TextSpan(
                                          text: reimmodel
                                              .message![index].internalid
                                              .toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue)),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        statuspendingColor(
                            text: reimmodel.message![index].isstatus.toString())
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppUtils.buildNormalText(
                                text: "EXPENSE CATEGORY",
                                color: Colors.black54),
                            const SizedBox(height: 5),
                            Text(
                                reimmodel.message![index].expensecategoryname
                                    .toString(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppUtils.buildNormalText(
                                text: "AMOUNT", color: Colors.black54),
                            const SizedBox(height: 5),
                            Text(reimmodel.message![index].amount.toString(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppUtils.buildNormalText(
                                text: "ATTACHMENT", color: Colors.black54),
                            const SizedBox(height: 5),
                            reimmodel.message![index].attachment
                                        .toString()
                                        .isEmpty ||
                                    reimmodel.message![index].attachment
                                            .toString() ==
                                        "null"
                                ? AppUtils.buildNormalText(
                                    text: "-", color: Colors.black54)
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      (reimmodel.message![index].attachment
                                                  .toString()
                                                  .isEmpty ||
                                              reimmodel.message![index]
                                                      .attachment
                                                      .toString() ==
                                                  "null")
                                          ? Container()
                                          : RichText(
                                              text: TextSpan(
                                                text: "",
                                                style: const TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.black,
                                                ),
                                                children: [
                                                  TextSpan(
                                                      text: "View Attachment",
                                                      style: const TextStyle(
                                                        fontSize: 12.0,
                                                        color:
                                                            Colors.blueAccent,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                      recognizer:
                                                          TapGestureRecognizer()
                                                            ..onTap = () {
                                                              _launchUrl(
                                                                  reimmodel
                                                                      .message![
                                                                          index]
                                                                      .attachment
                                                                      .toString(),
                                                                  isNewTab:
                                                                      true);
                                                            })
                                                ],
                                              ),
                                            )
                                    ],
                                  ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Divider(
                      color: Colors.grey.shade200,
                    ),
                    AppUtils.buildNormalText(
                        text: reimmodel.message![index].description.toString(),
                        fontSize: 16,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 5),
                    reimmodel.message![index].approvalHistory!.isNotEmpty
                        ? ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 0.0),
                            dense: true,
                            onTap: () {
                              showSheet(context, index);
                            },
                            trailing: const Icon(Icons.remove_red_eye),
                            title: const Text("Approved History",
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w500)),
                          )
                        : Container(),
                  ],
                ),
              );
            })
        : Center(child: Image.asset('assets/images/nodata.png'));
  }

  void showSheet(context, index) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                AppUtils.gethanger(context),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        reimmodel.message![index].approvalHistory!.length,
                    itemBuilder: (BuildContext context, int index1) {
                      return Container(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 3),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade50,
                            width: 0.5,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                appovalpending(
                                    text: reimmodel.message![index]
                                        .approvalHistory![index1].status
                                        .toString()),
                                const SizedBox(width: 10),
                                AppUtils.buildNormalText(
                                    text: reimmodel.message![index]
                                                .approvalHistory![index1].status
                                                .toString() ==
                                            "Approved"
                                        ? "Approved By"
                                        : reimmodel
                                                    .message![index]
                                                    .approvalHistory![index1]
                                                    .status
                                                    .toString() ==
                                                "Rejected"
                                            ? "Rejected"
                                            : "Pending"),
                                const SizedBox(width: 10),
                                AppUtils.buildNormalText(
                                    text: reimmodel.message![index]
                                        .approvalHistory![index1].approvername
                                        .toString(),
                                    fontSize: 14),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            AppUtils.buildNormalText(
                                text: reimmodel.message![index]
                                    .approvalHistory![index1].approveddate
                                    .toString()),
                            const SizedBox(
                              height: 10,
                            ),
                            AppUtils.buildNormalText(
                                text: reimmodel.message![index]
                                    .approvalHistory![index1].remarks
                                    .toString()),
                          ],
                        ),
                      );
                    }),
              ],
            ),
          );
        });
  }

  Future<void> _launchUrl(url, {bool isNewTab = true}) async {
    if (kIsWeb) {
      if (!await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: isNewTab ? '_blank' : '_self',
      )) {
        throw Exception('Could not launch $url');
      }
    } else if (Platform.isAndroid) {
      if (!await launchUrl(Uri.parse(url),
          mode: LaunchMode.externalNonBrowserApplication)) {
        throw Exception('Could not launch $url');
      }
    } else if (Platform.isIOS) {
      if (!await launchUrl(Uri.parse(url),
          mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    }
  }

  void getdetailsdata() async {
    setState(() {
      loading = true;
    });
    ApiService.viewreimbursementrequest().then((response) {
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString() == "true") {
          reimmodel = ViewReimModel.fromJson(jsonDecode(response.body));
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
