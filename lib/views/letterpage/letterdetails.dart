import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:winstar/models/viewlettermodel.dart';
import 'package:winstar/routenames.dart';
import 'package:winstar/services/apiservice.dart';
import 'package:winstar/utils/app_utils.dart';
import 'package:winstar/utils/constants.dart';
import 'package:winstar/utils/custom_indicatoronly.dart';
import 'package:winstar/views/widgets/assets_image_widget.dart';
import 'package:winstar/views/widgets/colorstatus.dart';
import 'package:winstar/views/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

class LetterDetailPage extends StatefulWidget {
  const LetterDetailPage({super.key});

  @override
  State<LetterDetailPage> createState() => _LetterDetailPageState();
}

class _LetterDetailPageState extends State<LetterDetailPage> {
  bool loading = false;
  ViewletterModel lettermodel = ViewletterModel();
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
          icon: const Icon(CupertinoIcons.back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: AppUtils.buildNormalText(
         
            text: "Letter Details", color: Colors.black, fontSize: 16),
        centerTitle: false,
      ),
      body: !loading
          ? lettermodel.message!.isNotEmpty
              ? SingleChildScrollView(
                  child: Column(
                    children: [leavedetailes()],
                  ),
                )
              : Center(
                  child: Image.asset(
                  'assets/images/nodata1.png',
                  height: 200,
                  width: 200,
                ))
          : const CustomIndicator(),

             bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0), // optional padding
        child: CustomButton(
          onPressed: () {
            Navigator.pushNamed(context, RouteNames.addletter).then((_) {
              getdetailsdata();
            });
          },
          name: "Click to Apply Letter Request",
          fontSize: 14,
          circularvalue: 30,
        ),
      ),
     
    );
  }


Widget leavedetailes() {
  return (lettermodel.message != null && lettermodel.message!.isNotEmpty)
      ? ListView.builder(
          itemCount: lettermodel.message!.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final msg = lettermodel.message![index];
            final color = AppConstants.containercolorArray[
                index.remainder(AppConstants.containercolorArray.length)];

            // Status
            String statusText = msg.isstatus.toString();
            Color statusColor = Colors.blueAccent;
            if (statusText.toLowerCase().contains("pending")) {
              statusColor = Colors.orange.shade400;
              statusText = "Pending";
            } else if (statusText.toLowerCase().contains("approved")) {
              statusColor = Colors.green.shade400;
              statusText = "Approved";
            } else if (statusText.toLowerCase().contains("rejected")) {
              statusColor = Colors.red.shade400;
              statusText = "Rejected";
            }

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Header Row: Person + Name + Date + Status
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: color,
                        child: const Icon(
                          CupertinoIcons.person,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Name + Date + ID
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              msg.toEmpName.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today,
                                    size: 14, color: Colors.grey),
                                const SizedBox(width: 6),
                                Text(
                                  AppConstants.convertdateformat(
                                      msg.createdDate.toString().substring(0, 10)),
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.black54),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    "ID: ${msg.internalid}",
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Status Tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                            color: statusColor,
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          statusText,
                          style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: Colors.grey, height: 1),
                  const SizedBox(height: 10),

                  /// Letter Type & Letter To
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "LETTER TYPE",
                            style: TextStyle(
                                fontSize: 11, color: Colors.black54),
                          ),
                          const SizedBox(height: 4),
                          Text(msg.lettertypename.toString(),
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.black87)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "LETTER TO",
                            style: TextStyle(
                                fontSize: 11, color: Colors.black54),
                          ),
                          const SizedBox(height: 4),
                          Text(msg.letteraddresstoname.toString(),
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.black87)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  /// Attachment
                  if (msg.attachment.toString().isNotEmpty &&
                      msg.attachment.toString() != "null")
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () =>
                            _launchUrl(msg.attachment.toString(), isNewTab: true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(16)),
                          child: const Text(
                            "View Attachment",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue),
                          ),
                        ),
                      ),
                    ),
                  if (msg.attachment.toString().isNotEmpty &&
                      msg.attachment.toString() != "null")
                    const SizedBox(height: 10),
                  const Divider(color: Colors.grey, height: 1),
                  const SizedBox(height: 10),

                  /// Purpose / Reason
                  if (msg.purpose.toString().isNotEmpty)
                    Text(
                      msg.purpose.toString(),
                      style: const TextStyle(fontSize: 13, color: Colors.black87),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 12),

                  /// Approval History
                  if (msg.approvalHistory != null &&
                      msg.approvalHistory!.isNotEmpty)
                    GestureDetector(
                      onTap: () => showSheet(context, index),
                      child: Row(
                        children: const [
                          Icon(Icons.remove_red_eye, size: 18),
                          SizedBox(width: 6),
                          Text(
                            "Approval History",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue),
                          )
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
        )
      : const Center(
          child: Text(
            'No Data',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        );
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
                        lettermodel.message![index].approvalHistory!.length,
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
                                    text: lettermodel.message![index]
                                        .approvalHistory![index1].status
                                        .toString()),
                                const SizedBox(width: 10),
                                AppUtils.buildNormalText(
                                    text: lettermodel.message![index]
                                                .approvalHistory![index1].status
                                                .toString() ==
                                            "Approved"
                                        ? "Approved By"
                                        : lettermodel
                                                    .message![index]
                                                    .approvalHistory![index1]
                                                    .status
                                                    .toString() ==
                                                "Rejected"
                                            ? "Rejected"
                                            : "Pending"),
                                const SizedBox(width: 10),
                                AppUtils.buildNormalText(
                                    text: lettermodel.message![index]
                                        .approvalHistory![index1].approvername
                                        .toString(),
                                    fontSize: 14),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            AppUtils.buildNormalText(
                                text: lettermodel.message![index]
                                    .approvalHistory![index1].approveddate
                                    .toString()),
                            const SizedBox(
                              height: 10,
                            ),
                            AppUtils.buildNormalText(
                                text: lettermodel.message![index]
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

  void getdetailsdata() async {
    setState(() {
      loading = true;
    });
    ApiService.viewpostletterrequest().then((response) {
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString() == "true") {
          lettermodel = ViewletterModel.fromJson(jsonDecode(response.body));
        } else {
          lettermodel.message = [];
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

  Future<void> _launchUrl(url, {bool isNewTab = true}) async {
    if (Platform.isAndroid) {
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
}
