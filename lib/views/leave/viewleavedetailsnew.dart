import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:powergroupess/models/leavecontroller.dart';
import 'package:powergroupess/utils/app_utils.dart';
import 'package:powergroupess/utils/appcolor.dart';
import 'package:powergroupess/utils/constants.dart';
import 'package:powergroupess/views/widgets/colorstatus.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewLeavePageNew extends StatefulWidget {
  const ViewLeavePageNew({super.key});

  @override
  State<ViewLeavePageNew> createState() => _ViewLeavePageNewState();
}

class _ViewLeavePageNewState extends State<ViewLeavePageNew> {
  // ViewLeaveModel leavemodel = ViewLeaveModel();
  late LeaveController leavecontroller = LeaveController();
  late Future<void> fetchDataFuture;
  TextEditingController searchcontroller = TextEditingController();

  String? filter;
  @override
  void initState() {
    if (mounted) {
      fetchDataFuture = leavecontroller.fetchData();
    }
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
            icon: const Icon(CupertinoIcons.back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: AppUtils.buildNormalText(
              text: "Leave Details", color: Colors.black, fontSize: 20),
          centerTitle: false,
          actions: [
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/leaveapply').then((_) {
                  setState(() {
                    fetchDataFuture = leavecontroller.fetchData();
                  });
                });
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.add,
                    size: 24,
                    color: Colors.white,
                  ),
                  Container(
                      padding: const EdgeInsets.all(8.0),
                      child: AppUtils.buildNormalText(
                          text: "Add Leave",
                          fontSize: 14,
                          color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
        body: Center(
          child: FutureBuilder(
            future: fetchDataFuture = leavecontroller.fetchData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CupertinoActivityIndicator(
                      radius: 30.0, color: Appcolor.primarySoft),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              return Text('Result: ${snapshot.hasData}');
              // return leavedetailes(leavecontroller.getCurrentPageData(),
              //     leavecontroller.getCurrentPageData().length);
            },
          ),
        ),
        bottomNavigationBar: leavecontroller.getCurrentPageData().isNotEmpty
            ? Container(
                color: Colors.white,
                child: OverflowBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: leavecontroller.currentPage > 1
                            ? Colors.blueAccent
                            : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          if (leavecontroller.currentPage > 1) {
                            fetchDataFuture = leavecontroller.previousPage();
                          }
                        });
                      },
                    ),
                    DropdownButton<int>(
                      value: leavecontroller.currentPage,
                      onChanged: (value) {
                        setState(() {
                          leavecontroller.currentPage = value!;
                        });
                      },
                      items: List.generate(
                          leavecontroller.data.length ~/
                              leavecontroller.itemsPerPage, (index) {
                        return DropdownMenuItem<int>(
                          value: index + 1,
                          child: Text('${index + 1}'),
                        );
                      }),
                    ),
                    Text("Total Records to ${leavecontroller.data.length}"),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward,
                          color: Colors.blueAccent),
                      onPressed: () {
                        setState(() {
                          fetchDataFuture = leavecontroller.nextPage();
                        });
                      },
                    )
                  ],
                ),
              )
            : Container());
  }

  Widget searchdetails() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: searchcontroller,
        onChanged: (val) {
          setState(() {
            filter = val;
            filter = searchcontroller.text;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search...',
          contentPadding: const EdgeInsets.fromLTRB(15.0, 15.0, 20.0, 15.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          suffixIcon: InkWell(
              onTap: () {
                setState(() {
                  filter = "";
                  searchcontroller.text = "";
                  searchcontroller.clear();
                });
              },
              child: const Icon(Icons.clear)),
        ),
      ),
    );
  }

  Widget leavedetailes(leaverecord, int count) {
    return count > 0
        ? Center(
            child: ListView.builder(
                itemCount: count,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: const EdgeInsets.all(5),
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
                          height: 5,
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
                                        text: leaverecord[index]
                                            .toEmpName
                                            .toString(),
                                        fontSize: 14,
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
                                    AppUtils.buildNormalText(
                                        text: AppConstants.convertdateformat(
                                                leaverecord[index]
                                                    .createdDate
                                                    .toString()
                                                    .substring(0, 10))
                                            .toString(),
                                        fontSize: 10,
                                        fontWeight: FontWeight.normal),
                                  ],
                                ),
                              ],
                            ),
                            statuspendingColor(
                                text: leaverecord[index].isstatus.toString())
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Divider(
                          height: 1,
                          color: Colors.grey.shade300,
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
                                    text: "Leave Type", color: Colors.black54),
                                const SizedBox(height: 5),
                                Text(
                                    leaverecord[index].leavetypename.toString(),
                                    style: const TextStyle(
                                      color: Colors.black,
                                    )),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                AppUtils.buildNormalText(
                                    text: "Total No Of days leave",
                                    color: Colors.black54),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    AppUtils.buildNormalText(
                                        text:
                                            '(${AppConstants.changeddmmyyformat(leaverecord[index].fromdate.toString())}  to ${AppConstants.changeddmmyyformat(leaverecord[index].todate.toString())})'),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                        '${leaverecord[index].totalNoOfDays.toString()} ${leaverecord[index].totalNoOfDays == 1 ? "day" : "days"}',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppUtils.buildNormalText(
                                    text: "Request by", color: Colors.black54),
                                Text(
                                  leaverecord[index]
                                      .createdbyEmpName
                                      .toString(),
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 12),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                AppUtils.buildNormalText(
                                    text: "Attachment", color: Colors.black54),
                                leaverecord[index]
                                        .attachment
                                        .toString()
                                        .isNotEmpty
                                    ? InkWell(
                                        onTap: () {
                                          _launchUrl(Uri.parse(
                                              AppConstants.apiBaseUrl +
                                                  leaverecord[index]
                                                      .attachment
                                                      .toString()));
                                        },
                                        child: Transform.rotate(
                                            angle: 90,
                                            child: const Icon(
                                                Icons.attachment_sharp)),
                                      )
                                    : Container()
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Divider(
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 5),
                        AppUtils.buildNormalText(
                            text: leaverecord[index].reason.toString(),
                            fontSize: 12,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 5),
                        leaverecord[index].approvalHistory!.isNotEmpty
                            ? Divider(
                                color: Colors.grey.shade300,
                                height: 1,
                              )
                            : Container(),
                        leaverecord[index].approvalHistory!.isNotEmpty
                            ? ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 0.0),
                                dense: true,
                                onTap: () {
                                  showSheet(context, index, leaverecord);
                                },
                                trailing: const Icon(Icons.description),
                                title: const Text("Approved History",
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500)),
                              )
                            : Container(),
                      ],
                    ),
                  );
                }),
          )
        : const Center(child: Text('No Data!'));
  }

  void showSheet(context, index, leaverecord) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              AppUtils.gethanger(context),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: leaverecord[index].approvalHistory!.length,
                  itemBuilder: (BuildContext context, int index1) {
                    return Container(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, bottom: 3),
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
                                  text: leaverecord[index]
                                      .approvalHistory![index1]
                                      .status
                                      .toString()),
                              const SizedBox(width: 10),
                              AppUtils.buildNormalText(
                                  text: leaverecord[index]
                                              .approvalHistory![index1]
                                              .status
                                              .toString() ==
                                          "Approved"
                                      ? "Approved By"
                                      : leaverecord[index]
                                                  .approvalHistory![index1]
                                                  .status
                                                  .toString() ==
                                              "Rejected"
                                          ? "Rejected"
                                          : "Pending"),
                              const SizedBox(width: 10),
                              AppUtils.buildNormalText(
                                  text: leaverecord[index]
                                      .approvalHistory![index1]
                                      .approvername
                                      .toString(),
                                  fontSize: 14),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          AppUtils.buildNormalText(
                              text: leaverecord[index]
                                  .approvalHistory![index1]
                                  .approveddate
                                  .toString()),
                          AppUtils.buildNormalText(
                              text: leaverecord[index]
                                  .approvalHistory![index1]
                                  .remarks
                                  .toString()),
                        ],
                      ),
                    );
                  }),
            ],
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
      if (!await launchUrl(url,
          mode: LaunchMode.externalNonBrowserApplication)) {
        throw Exception('Could not launch $url');
      }
    } else if (Platform.isIOS) {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    }
  }

  void onexitpopup() {
    Navigator.of(context).pop();
  }
}
