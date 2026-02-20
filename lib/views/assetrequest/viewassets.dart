import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:powergroupess/models/viewassetmodel.dart';
import 'package:powergroupess/routenames.dart';
import 'package:powergroupess/routes.dart';
import 'package:powergroupess/services/apiservice.dart';
import 'package:powergroupess/utils/app_utils.dart';
import 'package:powergroupess/utils/constants.dart';
import 'package:powergroupess/utils/custom_indicatoronly.dart';
import 'package:powergroupess/views/widgets/assets_image_widget.dart';
import 'package:powergroupess/views/widgets/colorstatus.dart';
import 'package:powergroupess/views/widgets/custom_button.dart';

class AssetDetailPage extends StatefulWidget {
  const AssetDetailPage({super.key});

  @override
  State<AssetDetailPage> createState() => _AssetDetailPageState();
}

class _AssetDetailPageState extends State<AssetDetailPage> {
  bool loading = false;
  ViewAssetModel assetModel = ViewAssetModel();
  bool _searchBoolean = false;
  String? filter;
  TextEditingController searchcontroller = TextEditingController();
  @override
  void initState() {
    getdetailsdata();
    super.initState();
  }

  @override
  void dispose() {
    searchcontroller.dispose();
    super.dispose();
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
          title: !_searchBoolean
              ? AppUtils.buildNormalText(
                  text: "Asset Details",
                  fontSize: 16,
                  color: Colors.black,
                )
              : _searchTextField(),
          actions: !_searchBoolean
              ? [
                  IconButton(
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _searchBoolean = true;
                        });
                      }),
                ]
              : [
                  IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchBoolean = false;
                          filter = "";
                          searchcontroller.text = "";
                        });
                      })
                ]),
      body: !loading
          ? assetModel.message != null
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
            Navigator.pushNamed(context, RouteNames.applyasset).then((_) {
              getdetailsdata();
            });
          },
          name: "Click to Apply Asset Request",
          fontSize: 14,
          circularvalue: 30,
        ),
      ),
   
    );
  }
Widget leavedetailes() {
  return (assetModel.message != null && assetModel.message!.isNotEmpty)
      ? ListView.builder(
          itemCount: assetModel.message!.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final asset = assetModel.message![index];
            final color = AppConstants.containercolorArray[
                index % AppConstants.containercolorArray.length];

            // Status Badge Color
            String statusText = asset.isstatus.toString();
            Color statusColor = Colors.blueAccent;
            if (statusText.toLowerCase().contains("pending")) {
              statusText = "Pending";
              statusColor = Colors.orange.shade400;
            } else if (statusText.toLowerCase().contains("approved")) {
              statusText = "Approved";
              statusColor = Colors.green.shade400;
            } else if (statusText.toLowerCase().contains("rejected")) {
              statusText = "Rejected";
              statusColor = Colors.red.shade400;
            }

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Header: Avatar + Name + Date + Status
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: color,
                        child: const Icon(CupertinoIcons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              asset.toEmpName.toString(),
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(CupertinoIcons.time, size: 14, color: Colors.grey),
                                const SizedBox(width: 6),
                                Text(
                                  AppConstants.convertdateformat(
                                      asset.createdDate.toString().substring(0, 10)),
                                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "ID: ${asset.internalid}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      /// Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          statusText,
                          style: const TextStyle(
                              fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: Colors.grey, height: 1),
                  const SizedBox(height: 10),

                  /// Asset Type & Name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("ASSET TYPE",
                              style: TextStyle(fontSize: 11, color: Colors.black54)),
                          const SizedBox(height: 4),
                          Text(asset.assettypename.toString(),
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text("ASSET NAME",
                              style: TextStyle(fontSize: 11, color: Colors.black54)),
                          const SizedBox(height: 4),
                          Text(asset.assetname.toString(),
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: Colors.grey, height: 1),
                  const SizedBox(height: 10),

                  /// Remarks
                  if (asset.remarks.toString().isNotEmpty)
                    Text(
                      asset.remarks.toString().toUpperCase(),
                      style: const TextStyle(fontSize: 12, color: Colors.black87),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 10),

                  /// Approval History
                  if (asset.approvalHistory != null && asset.approvalHistory!.isNotEmpty)
                    GestureDetector(
                      onTap: () => showSheet(context, index),
                      child: const Row(
                        children:  [
                          Icon(Icons.remove_red_eye, size: 18, color: Colors.blue),
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
            'No Data!',
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
                        assetModel.message![index].approvalHistory!.length,
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
                                    text: assetModel.message![index]
                                        .approvalHistory![index1].status
                                        .toString()),
                                const SizedBox(width: 10),
                                AppUtils.buildNormalText(
                                    text: assetModel.message![index]
                                                .approvalHistory![index1].status
                                                .toString() ==
                                            "Approved"
                                        ? "Approved By"
                                        : assetModel
                                                    .message![index]
                                                    .approvalHistory![index1]
                                                    .status
                                                    .toString() ==
                                                "Rejected"
                                            ? "Rejected"
                                            : "Pending"),
                                const SizedBox(width: 10),
                                AppUtils.buildNormalText(
                                    text: assetModel.message![index]
                                        .approvalHistory![index1].approvername
                                        .toString(),
                                    fontSize: 14),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            AppUtils.buildNormalText(
                                text: assetModel.message![index]
                                    .approvalHistory![index1].approveddate
                                    .toString()),
                            const SizedBox(
                              height: 10,
                            ),
                            AppUtils.buildNormalText(
                                text: assetModel.message![index]
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
    ApiService.viewpostassetrequest().then((response) {
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString() == "true") {
          assetModel = ViewAssetModel.fromJson(jsonDecode(response.body));
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

  Widget _searchTextField() {
    return TextField(
      controller: searchcontroller,
      onChanged: (String s) {
        setState(() {
          filter = s;
          filter = searchcontroller.text;
        });
      },
      autofocus: true,
      cursorColor: Colors.white,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 20,
      ),
      textInputAction: TextInputAction.search,
      decoration: const InputDecoration(
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        hintText: 'Search',
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      ),
    );
  }
}
