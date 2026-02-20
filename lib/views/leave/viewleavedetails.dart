// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:powergroupess/models/viewleavemodel.dart';
// import 'package:powergroupess/routenames.dart';
// import 'package:powergroupess/services/apiservice.dart';
// import 'package:powergroupess/utils/app_utils.dart';
// import 'package:powergroupess/utils/constants.dart';
// import 'package:powergroupess/utils/custom_indicatoronly.dart';
// import 'package:powergroupess/views/widgets/assets_image_widget.dart';
// import 'package:powergroupess/views/widgets/colorstatus.dart';
// import 'package:powergroupess/views/widgets/custom_button.dart';
// import 'package:url_launcher/url_launcher.dart';

// class ViewLeavePage extends StatefulWidget {
//   const ViewLeavePage({super.key});

//   @override
//   State<ViewLeavePage> createState() => _ViewLeavePageState();
// }

// class _ViewLeavePageState extends State<ViewLeavePage> {
//   bool loading = false;
//   ViewLeaveModel leavemodel = ViewLeaveModel();
//   List<dynamic> jsonList = [];
//   String uniqId = "";
//   TextEditingController searchcontroller = TextEditingController();
//   TextEditingController cancelleavecontroller = TextEditingController();
//   TextEditingController cancelpullleavecontroller = TextEditingController();
//   String search = "";
//   String cancelleavetxt = "";
//   String pullbacktext = "";
//   String internalId = "";
//   final formKey = GlobalKey<FormState>();

//   bool _searchBoolean = false;
//   String? filter;
//   var totalcount = 0;
//   //final List<Map<String, dynamic>> _foundresult = [];
//   Map<String, dynamic> data = <String, dynamic>{};
//   @override
//   void initState() {
//     super.initState();
//     if (mounted) {
//       getdetailsdata();
//     }
//   }

//   @override
//   void dispose() {
//     searchcontroller.dispose();
//     cancelleavecontroller.dispose();
//     cancelpullleavecontroller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           elevation: 0,
//           leading: IconButton(
//             icon: const Icon(CupertinoIcons.back, color: Colors.black),
//             onPressed: () => Navigator.of(context).pop(),
//           ),
//           title: !_searchBoolean
//               ? AppUtils.buildNormalText(

//                   text: "Leave Details ($totalcount)",
//                   fontSize: 16,
//                   color: Colors.black)
//               : _searchTextField(),
//           actions: !_searchBoolean
//               ? [
//                   IconButton(
//                       icon: const Icon(
//                         Icons.search,
//                         color: Colors.white,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _searchBoolean = true;
//                         });
//                       }),
//                 ]
//               : [
//                   IconButton(
//                       icon: const Icon(
//                         Icons.clear,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _searchBoolean = false;
//                           filter = "";
//                           searchcontroller.text = "";
//                         });
//                       })
//                 ]),
//       body: !loading
//           ? leavemodel.message != null
//               ? SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       // ExpansionTile(
//                       //   title: AppUtils.buildNormalText(
//                       //       text: "Search", fontSize: 16),
//                       //   children: [searchdetails()],
//                       // ),
//                       leavedetailes()
//                     ],
//                   ),
//                 )
//               : Center(
//                   child: Image.asset(
//                   'assets/images/nodata1.png',
//                   height: 200,
//                   width: 200,
//                 ))
//           : const CustomIndicator(),
//       persistentFooterButtons: [
//         CustomButton(
//             onPressed: () {
//               Navigator.pushNamed(context, RouteNames.applyleave).then((_) {
//                 setState(() {
//                   getdetailsdata();
//                 });
//               });
//             },
//             name: "Click to Apply Leave",
//             fontSize: 14,
//             circularvalue: 30)
//       ],
//     );
//   }

//   Widget _searchTextField() {
//     return TextField(
//       controller: searchcontroller,
//       onChanged: (String s) {
//         setState(() {
//           filter = s;
//           filter = searchcontroller.text;
//         });
//       },
//       autofocus: true,
//       cursorColor: Colors.white,
//       style: const TextStyle(
//         color: Colors.black,
//         fontSize: 20,
//       ),
//       textInputAction: TextInputAction.search,
//       decoration: const InputDecoration(
//         enabledBorder:
//             UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
//         focusedBorder:
//             UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
//         hintText: 'Search',
//         hintStyle: TextStyle(
//           color: Colors.black,
//           fontSize: 20,
//         ),
//       ),
//     );
//   }

//   Widget searchdetails() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: TextField(
//         controller: searchcontroller,
//         onChanged: (val) {
//           setState(() {
//             filter = val;
//             filter = searchcontroller.text;
//           });
//         },
//         decoration: InputDecoration(
//           hintText: 'Search...',
//           contentPadding: const EdgeInsets.fromLTRB(15.0, 15.0, 20.0, 15.0),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
//           suffixIcon: InkWell(
//               onTap: () {
//                 setState(() {
//                   filter = "";
//                   searchcontroller.text = "";
//                   searchcontroller.clear();
//                 });
//               },
//               child: const Icon(Icons.clear)),
//         ),
//       ),
//     );
//   }

//   Widget leavedetailes() {
//     return leavemodel.message != null
//         ? ListView.builder(
//             itemCount: leavemodel.message!.length ?? 0,
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemBuilder: (BuildContext context, int index) {
//               return filter.toString() == "null" || filter.toString() == ""
//                   ? GestureDetector(
//                       onTap: () async {
//                         if (leavemodel.message![index].imageUrl
//                                 .toString()
//                                 .isEmpty ||
//                             leavemodel.message![index].imageUrl.toString() ==
//                                 "null") {
//                         } else {
//                           _launchUrl(
//                               leavemodel.message![index].imageUrl.toString());
//                         }
//                       },
//                       child: Card(
//                         elevation: 2,
//                         color:
//                             leavemodel.message![index].iscancelled.toString() ==
//                                     "Y"
//                                 ? Colors.red.shade50
//                                 : leavemodel.message![index].ispullbackcancelled
//                                             .toString() ==
//                                         "Y"
//                                     ? Colors.blue.shade50
//                                     : Colors.white,
//                         child: Container(
//                           margin: const EdgeInsets.all(5),
//                           padding: const EdgeInsets.only(
//                               left: 10, right: 10, bottom: 3),

//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const SizedBox(
//                                 height: 5,
//                               ),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Row(
//                                         children: [
//                                           Icon(
//                                             CupertinoIcons.person_circle,
//                                               color: AppConstants
//                                                       .containercolorArray[
//                                                   index.remainder(AppConstants
//                                                       .containercolorArray
//                                                       .length)]),
//                                           const SizedBox(width: 15),
//                                           AppUtils.buildNormalText(
//                                               text: leavemodel
//                                                   .message![index].toEmpName
//                                                   .toString(),
//                                               fontSize: 14,
//                                               fontWeight: FontWeight.bold),
//                                         ],
//                                       ),
//                                             SizedBox(height: 10,),
//                                       Row(
//                                         children: [
//                                           Icon(CupertinoIcons.time,
//                                               color: AppConstants
//                                                       .containercolorArray[
//                                                   index.remainder(AppConstants
//                                                       .containercolorArray
//                                                       .length)]),
//                                           const SizedBox(width: 15),
//                                           RichText(
//                                             text: TextSpan(
//                                               text: AppConstants
//                                                   .convertdateformat(leavemodel
//                                                       .message![index]
//                                                       .createdDate
//                                                       .toString()
//                                                       .substring(0, 10)),
//                                               style: const TextStyle(
//                                                   fontSize: 12,
//                                                   fontWeight: FontWeight.normal,
//                                                   color: Colors.black),
//                                               children: <InlineSpan>[
//                                                 const WidgetSpan(
//                                                     alignment:
//                                                         PlaceholderAlignment
//                                                             .baseline,
//                                                     baseline:
//                                                         TextBaseline.alphabetic,
//                                                     child: SizedBox(width: 10)),
//                                                 TextSpan(
//                                                     text: leavemodel
//                                                         .message![index]
//                                                         .intenalId
//                                                         .toString(),
//                                                     style: const TextStyle(
//                                                         fontWeight:
//                                                             FontWeight.bold,
//                                                         color: Colors.blue)),
//                                               ],
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                   statuspendingColor(
//                                       text: leavemodel
//                                                   .message![index].iscancelled
//                                                   .toString() ==
//                                               "Y"
//                                           ? "Cancelled"
//                                           : leavemodel.message![index]
//                                                       .ispullbackcancelled
//                                                       .toString() ==
//                                                   "Y"
//                                               ? "Cancelled"
//                                               : leavemodel
//                                                   .message![index].isstatus
//                                                   .toString()),
//                                   leavemodel.message![index].ispullbackcancelled
//                                               .toString() ==
//                                           "N"
//                                       ? leavemodel.message![index].iscancelled
//                                                   .toString() ==
//                                               "N"
//                                           ? GestureDetector(
//                                               onTap: leavemodel.message![index]
//                                                           .isstatus
//                                                           .toString() ==
//                                                       "Rejected"
//                                                   ? null
//                                                   : () {
//                                                       uniqId = leavemodel
//                                                           .message![index].sId
//                                                           .toString();
//                                                       internalId = leavemodel
//                                                           .message![index]
//                                                           .intenalId
//                                                           .toString();

//                                                       showCancel(
//                                                         context,
//                                                         index,
//                                                       );
//                                                     },
//                                               child: Icon(
//                                                 Icons.more_vert,
//                                                 color: Colors.grey.shade500,
//                                               ),
//                                             )
//                                           : Container()
//                                       : Container(),
//                                 ],
//                               ),
//                               const SizedBox(
//                                 height: 6,
//                               ),
//                               Divider(
//                                 height: 1,
//                                 color: Colors.grey.shade300,
//                               ),
//                               const SizedBox(
//                                 height: 6,
//                               ),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       AppUtils.buildNormalText(
//                                           text: "Leave Type",
//                                           color: Colors.black54),
//                                       const SizedBox(height: 5),
//                                       AppUtils.buildNormalText(
//                                           text: leavemodel
//                                               .message![index].leavetypename
//                                               .toString(),
//                                           color: Colors.black),
//                                     ],
//                                   ),
//                                   Column(
//                                     crossAxisAlignment: CrossAxisAlignment.end,
//                                     children: [
//                                       AppUtils.buildNormalText(
//                                           text: "Total No Of days leave",
//                                           color: Colors.black54),
//                                       const SizedBox(height: 5),
//                                       Row(
//                                         children: [
//                                           AppUtils.buildNormalText(
//                                               text:
//                                                   '(${AppConstants.changeddmmyyformat(leavemodel.message![index].fromdate.toString())}  to ${AppConstants.changeddmmyyformat(leavemodel.message![index].todate.toString())})',
//                                               fontSize: 10,
//                                               fontWeight: FontWeight.w600),
//                                           const SizedBox(
//                                             width: 10,
//                                           ),
//                                           Text(
//                                             '${leavemodel.message![index].totalNoOfDays.toString()} ${leavemodel.message![index].totalNoOfDays == 1 ? "day" : "days"}',
//                                             style: const TextStyle(
//                                                 color: Colors.black,
//                                                 overflow: TextOverflow.ellipsis,
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 12),
//                                             maxLines: 2,
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 5),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       AppUtils.buildNormalText(
//                                           text: "Request by",
//                                           color: Colors.black54),
//                                       Text(
//                                         leavemodel
//                                             .message![index].createdByEmpName
//                                             .toString(),
//                                         style: const TextStyle(
//                                             color: Colors.black, fontSize: 12),
//                                       ),
//                                     ],
//                                   ),
//                                   Column(
//                                     crossAxisAlignment: CrossAxisAlignment.end,
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     children: [
//                                       AppUtils.buildNormalText(
//                                           text: "Attachment",
//                                           color: Colors.black54),
//                                       (leavemodel.message![index].imageUrl
//                                                   .toString()
//                                                   .isEmpty ||
//                                               leavemodel
//                                                       .message![index].imageUrl
//                                                       .toString() ==
//                                                   "null")
//                                           ? Container()
//                                           : RichText(
//                                               text: TextSpan(
//                                                 text: "",
//                                                 style: const TextStyle(
//                                                   fontSize: 12.0,
//                                                   color: Colors.black,
//                                                 ),
//                                                 children: [
//                                                   TextSpan(
//                                                       text: "View Attachment",
//                                                       style: const TextStyle(
//                                                         fontSize: 12.0,
//                                                         color:
//                                                             Colors.blueAccent,
//                                                         fontWeight:
//                                                             FontWeight.w500,
//                                                       ),
//                                                       recognizer:
//                                                           TapGestureRecognizer()
//                                                             ..onTap = () {
//                                                               _launchUrl(
//                                                                   leavemodel
//                                                                       .message![
//                                                                           index]
//                                                                       .imageUrl
//                                                                       .toString(),
//                                                                   isNewTab:
//                                                                       true);
//                                                             })
//                                                 ],
//                                               ),
//                                             ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 5),
//                               Divider(
//                                 color: Colors.grey.shade300,
//                               ),
//                               const SizedBox(height: 5),
//                               AppUtils.buildNormalText(
//                                   text: leavemodel.message![index].reason ?? "",
//                                   fontSize: 12,
//                                   maxLines: 3,
//                                   overflow: TextOverflow.ellipsis),
//                               const SizedBox(height: 5),
//                               leavemodel.message![index].approvalHistory!
//                                       .isNotEmpty
//                                   ? Divider(
//                                       color: Colors.grey.shade300,
//                                       height: 1,
//                                     )
//                                   : Container(),
//                               leavemodel.message![index].approvalHistory!
//                                       .isNotEmpty
//                                   ? ListTile(
//                                       contentPadding:
//                                           const EdgeInsets.symmetric(
//                                               vertical: 0.0, horizontal: 0.0),
//                                       dense: true,
//                                       onTap: () {
//                                         showSheet(context, index);
//                                       },
//                                       trailing:
//                                           const Icon(Icons.remove_red_eye),
//                                       title: const Text("Approved History",
//                                           style: TextStyle(
//                                               fontSize: 12.0,
//                                               fontWeight: FontWeight.w500)),
//                                     )
//                                   : Container(),
//                             ],
//                           ),
//                         ),
//                       ),
//                     )
//                   : leavemodel.message![index].leaveapplicationno.toString().toLowerCase().contains(filter.toString().toLowerCase()) ||
//                           leavemodel.message![index].date
//                               .toString()
//                               .toLowerCase()
//                               .contains(filter.toString().toLowerCase()) ||
//                           leavemodel.message![index].fromdate
//                               .toString()
//                               .toLowerCase()
//                               .contains(filter.toString().toLowerCase()) ||
//                           leavemodel.message![index].todate
//                               .toString()
//                               .toLowerCase()
//                               .contains(filter.toString().toLowerCase()) ||
//                           leavemodel.message![index].totalNoOfDays
//                               .toString()
//                               .toLowerCase()
//                               .contains(filter.toString().toLowerCase()) ||
//                           leavemodel.message![index].createdby
//                               .toString()
//                               .toLowerCase()
//                               .contains(filter.toString().toLowerCase()) ||
//                           leavemodel.message![index].createdByEmpName
//                               .toString()
//                               .toLowerCase()
//                               .contains(filter.toString().toLowerCase()) ||
//                           leavemodel.message![index].toEmpCode
//                               .toString()
//                               .toLowerCase()
//                               .contains(filter.toString().toLowerCase()) ||
//                           leavemodel.message![index].toEmpName
//                               .toString()
//                               .toLowerCase()
//                               .contains(filter.toString().toLowerCase()) ||
//                           leavemodel.message![index].iscancelled
//                               .toString()
//                               .toLowerCase()
//                               .contains(filter.toString().toLowerCase()) ||
//                           leavemodel.message![index].createdDate
//                               .toString()
//                               .toLowerCase()
//                               .contains(filter.toString().toLowerCase()) ||
//                           leavemodel.message![index].ispullbackcancelled
//                               .toString()
//                               .toLowerCase()
//                               .contains(filter.toString().toLowerCase()) ||
//                           leavemodel.message![index].reason.toString().toLowerCase().contains(filter.toString().toLowerCase())
//                       ? GestureDetector(
//                           onTap: () async {
//                             _launchUrl(
//                                 leavemodel.message![index].imageUrl.toString());
//                           },
//                           child: Card(
//                             elevation: 2,
//                             color: leavemodel.message![index].iscancelled
//                                         .toString() ==
//                                     "Y"
//                                 ? Colors.red.shade50
//                                 : leavemodel.message![index].ispullbackcancelled
//                                             .toString() ==
//                                         "Y"
//                                     ? Colors.blue.shade50
//                                     : Colors.white,
//                             child: Container(
//                               margin: const EdgeInsets.all(5),
//                               padding: const EdgeInsets.only(
//                                   left: 10, right: 10, bottom: 3),

//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const SizedBox(
//                                     height: 5,
//                                   ),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Row(
//                                             children: [
//                                               Icon(CupertinoIcons.person_circle,
//                                                   color: AppConstants
//                                                           .containercolorArray[
//                                                       index.remainder(AppConstants
//                                                           .containercolorArray
//                                                           .length)]),
//                                               const SizedBox(width: 15),
//                                               AppUtils.buildNormalText(
//                                                   text: leavemodel
//                                                       .message![index].toEmpName
//                                                       .toString(),
//                                                   fontSize: 14,
//                                                   fontWeight: FontWeight.bold),
//                                             ],
//                                           ),

//                                           Row(
//                                             children: [
//                                               Icon(CupertinoIcons.time,
//                                                   color: AppConstants
//                                                           .containercolorArray[
//                                                       index.remainder(AppConstants
//                                                           .containercolorArray
//                                                           .length)]),
//                                               const SizedBox(width: 15),
//                                               RichText(
//                                                 text: TextSpan(
//                                                   text: AppConstants
//                                                       .convertdateformat(
//                                                           leavemodel
//                                                               .message![index]
//                                                               .createdDate
//                                                               .toString()
//                                                               .substring(
//                                                                   0, 10)),
//                                                   style: const TextStyle(
//                                                       fontSize: 12,
//                                                       fontWeight:
//                                                           FontWeight.normal,
//                                                       color: Colors.black),
//                                                   children: <InlineSpan>[
//                                                     const WidgetSpan(
//                                                         alignment:
//                                                             PlaceholderAlignment
//                                                                 .baseline,
//                                                         baseline: TextBaseline
//                                                             .alphabetic,
//                                                         child: SizedBox(
//                                                             width: 10)),
//                                                     TextSpan(
//                                                         text: leavemodel
//                                                             .message![index]
//                                                             .intenalId
//                                                             .toString(),
//                                                         style: const TextStyle(
//                                                             fontWeight:
//                                                                 FontWeight.bold,
//                                                             color:
//                                                                 Colors.blue)),
//                                                   ],
//                                                 ),
//                                               )
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                       statuspendingColor(
//                                           text: leavemodel.message![index]
//                                                       .iscancelled
//                                                       .toString() ==
//                                                   "Y"
//                                               ? "Cancelled"
//                                               : leavemodel.message![index]
//                                                           .ispullbackcancelled
//                                                           .toString() ==
//                                                       "Y"
//                                                   ? "Cancelled"
//                                                   : leavemodel
//                                                       .message![index].isstatus
//                                                       .toString()),
//                                       leavemodel.message![index]
//                                                   .ispullbackcancelled
//                                                   .toString() ==
//                                               "N"
//                                           ? leavemodel.message![index]
//                                                       .iscancelled
//                                                       .toString() ==
//                                                   "N"
//                                               ? GestureDetector(
//                                                   onTap: leavemodel
//                                                               .message![index]
//                                                               .isstatus
//                                                               .toString() ==
//                                                           "Rejected"
//                                                       ? null
//                                                       : () {
//                                                           uniqId = leavemodel
//                                                               .message![index]
//                                                               .sId
//                                                               .toString();
//                                                           internalId =
//                                                               leavemodel
//                                                                   .message![
//                                                                       index]
//                                                                   .intenalId
//                                                                   .toString();
//                                                           print(internalId);
//                                                           showCancel(
//                                                               context, index);
//                                                         },
//                                                   child: Icon(
//                                                     Icons.more_vert,
//                                                     color: Colors.grey.shade500,
//                                                   ),
//                                                 )
//                                               : Container()
//                                           : Container()
//                                     ],
//                                   ),
//                                   const SizedBox(
//                                     height: 5,
//                                   ),
//                                   Divider(
//                                     height: 1,
//                                     color: Colors.grey.shade300,
//                                   ),
//                                   const SizedBox(
//                                     height: 5,
//                                   ),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           AppUtils.buildNormalText(
//                                               text: "Leave Type",
//                                               color: Colors.black54),
//                                           const SizedBox(height: 5),
//                                           AppUtils.buildNormalText(
//                                               text: leavemodel
//                                                   .message![index].leavetypename
//                                                   .toString(),
//                                               color: Colors.black),
//                                         ],
//                                       ),
//                                       Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.end,
//                                         children: [
//                                           AppUtils.buildNormalText(
//                                               text: "Total No Of days leave",
//                                               color: Colors.black54),
//                                           const SizedBox(height: 5),
//                                           Row(
//                                             children: [
//                                               AppUtils.buildNormalText(
//                                                   text:
//                                                       '(${AppConstants.changeddmmyyformat(leavemodel.message![index].fromdate.toString())}  to ${AppConstants.changeddmmyyformat(leavemodel.message![index].todate.toString())})'),
//                                               const SizedBox(
//                                                 width: 10,
//                                               ),
//                                               Text(
//                                                   '${leavemodel.message![index].totalNoOfDays.toString()} ${leavemodel.message![index].totalNoOfDays == 1 ? "day" : "days"}',
//                                                   style: const TextStyle(
//                                                       color: Colors.black,
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                       fontSize: 12)),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 5),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           AppUtils.buildNormalText(
//                                               text: "Request by",
//                                               color: Colors.black54),
//                                           Text(
//                                             leavemodel.message![index]
//                                                 .createdByEmpName
//                                                 .toString(),
//                                             style: const TextStyle(
//                                                 color: Colors.black,
//                                                 fontSize: 12),
//                                           ),
//                                         ],
//                                       ),
//                                       Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.end,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.end,
//                                         children: [
//                                           AppUtils.buildNormalText(
//                                               text: "Attachment",
//                                               color: Colors.black54),
//                                           (leavemodel.message![index].imageUrl
//                                                       .toString()
//                                                       .isEmpty ||
//                                                   leavemodel.message![index]
//                                                           .imageUrl
//                                                           .toString() ==
//                                                       "null")
//                                               ? Container()
//                                               : RichText(
//                                                   text: TextSpan(
//                                                     text: "",
//                                                     style: const TextStyle(
//                                                       fontSize: 15.0,
//                                                       color: Colors.black,
//                                                     ),
//                                                     children: [
//                                                       TextSpan(
//                                                           text:
//                                                               "View Attachment",
//                                                           style:
//                                                               const TextStyle(
//                                                             fontSize: 12.0,
//                                                             color: Colors
//                                                                 .blueAccent,
//                                                             fontWeight:
//                                                                 FontWeight.w500,
//                                                           ),
//                                                           recognizer:
//                                                               TapGestureRecognizer()
//                                                                 ..onTap = () {
//                                                                   _launchUrl(
//                                                                       Uri.parse(leavemodel
//                                                                           .message![
//                                                                               index]
//                                                                           .imageUrl
//                                                                           .toString()),
//                                                                       isNewTab:
//                                                                           true);
//                                                                 })
//                                                     ],
//                                                   ),
//                                                 ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 5),
//                                   Divider(
//                                     color: Colors.grey.shade300,
//                                   ),
//                                   const SizedBox(height: 5),
//                                   AppUtils.buildNormalText(
//                                       text: leavemodel.message![index].reason ??
//                                           "",
//                                       fontSize: 12,
//                                       maxLines: 3,
//                                       overflow: TextOverflow.ellipsis),
//                                   const SizedBox(height: 5),
//                                   leavemodel.message![index].approvalHistory!
//                                           .isNotEmpty
//                                       ? Divider(
//                                           color: Colors.grey.shade300,
//                                           height: 1,
//                                         )
//                                       : Container(),
//                                   leavemodel.message![index].approvalHistory!
//                                           .isNotEmpty
//                                       ? ListTile(
//                                           contentPadding:
//                                               const EdgeInsets.symmetric(
//                                                   vertical: 0.0,
//                                                   horizontal: 0.0),
//                                           dense: true,
//                                           onTap: () {
//                                             showSheet(context, index);
//                                           },
//                                           trailing:
//                                               const Icon(Icons.remove_red_eye),
//                                           title: const Text("Approved History",
//                                               style: TextStyle(
//                                                   fontSize: 12.0,
//                                                   fontWeight: FontWeight.w500)),
//                                         )
//                                       : Container(),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         )
//                       : Center(
//                           child: Container(),
//                         );
//             })
//         : const Center(child: Text('No Data'));
//   }

//   void showSheet(context, index) {
//     showModalBottomSheet(
//         context: context,
//         builder: (BuildContext bc) {
//           return SingleChildScrollView(
//             child: Column(
//               children: [
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 AppUtils.gethanger(context),
//                 ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount:
//                         leavemodel.message![index].approvalHistory!.length,
//                     itemBuilder: (BuildContext context, int index1) {
//                       return Container(
//                         padding: const EdgeInsets.only(
//                             left: 10, right: 10, bottom: 3),
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                             color: Colors.grey.shade50,
//                             width: 0.5,
//                           ),
//                           borderRadius: const BorderRadius.all(
//                             Radius.circular(10),
//                           ),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             Row(
//                               children: [
//                                 appovalpending(
//                                     text: leavemodel.message![index]
//                                         .approvalHistory![index1].status
//                                         .toString()),
//                                 const SizedBox(width: 10),
//                                 AppUtils.buildNormalText(
//                                     text: leavemodel.message![index]
//                                                 .approvalHistory![index1].status
//                                                 .toString() ==
//                                             "Approved"
//                                         ? "Approved By"
//                                         : leavemodel
//                                                     .message![index]
//                                                     .approvalHistory![index1]
//                                                     .status
//                                                     .toString() ==
//                                                 "Rejected"
//                                             ? "Rejected"
//                                             : "Pending"),
//                                 const SizedBox(width: 10),
//                                 AppUtils.buildNormalText(
//                                     text: leavemodel.message![index]
//                                         .approvalHistory![index1].approvername
//                                         .toString(),
//                                     fontSize: 14),
//                               ],
//                             ),
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             AppUtils.buildNormalText(
//                                 text: leavemodel.message![index]
//                                     .approvalHistory![index1].approveddate
//                                     .toString()),
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             AppUtils.buildNormalText(
//                                 text: leavemodel.message![index]
//                                     .approvalHistory![index1].remarks
//                                     .toString()),
//                           ],
//                         ),
//                       );
//                     }),

//               ],
//             ),
//           );
//         });
//   }

//   void showCancel(context, index) {
//     showModalBottomSheet(
//         context: context,
//         isDismissible: false,
//         builder: (context) {
//           return Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.cancel),
//                 title: const Text('Cancel Leave'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _canceldialog(
//                     context,
//                     cancelleavecontroller,
//                   );
//                 },
//               ),
//               leavemodel.message![index].isstatus.toString() != "Approved"
//                   ? ListTile(
//                       leading: const Icon(Icons.rotate_right),
//                       title: const Text('Pull Back Leave'),
//                       onTap: () {
//                         Navigator.pop(context);
//                         _pullbackdialog(context, cancelpullleavecontroller);
//                       },
//                     )
//                   : const SizedBox(),
//               ListTile(
//                 leading: const Icon(Icons.exit_to_app),
//                 title: const Text('Cancel Dialog'),
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//               ),
//             ],
//           );
//         });
//   }

//   Future<void> _canceldialog(
//       BuildContext context, cancelleavecontroller) async {
//     cancelleavetxt = "";
//     cancelleavecontroller.text = "";
//     return showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) {
//           return AlertDialog(
//             title: const Text('Please Enter Remarks'),
//             content: Form(
//               key: formKey,
//               child: TextFormField(
//                 onChanged: (value) {
//                   setState(() {
//                     cancelleavetxt = value.toString();
//                     cancelleavecontroller = value.toString();
//                   });
//                 },
//                 validator: (value) =>
//                     value!.isEmpty ? 'Remarks should not empty!' : null,
//                 controller: cancelleavecontroller,
//                 decoration:
//                     const InputDecoration(hintText: "Please Cancel Remarks"),
//               ),
//             ),
//             actions: [
//               MaterialButton(
//                 color: Colors.red,
//                 textColor: Colors.white,
//                 child: const Text('Cancel'),
//                 onPressed: () {
//                   setState(() {
//                     Navigator.pop(context);
//                   });
//                 },
//               ),
//               MaterialButton(
//                 color: Colors.green,
//                 textColor: Colors.white,
//                 child: const Text('OK'),
//                 onPressed: () {
//                   setState(() {
//                     final FormState form = formKey.currentState!;
//                     if (form.validate()) {
//                       Navigator.pop(context);
//                       postcancelleave();
//                     } else {
//                       AppUtils.showSingleDialogPopup(
//                           context,
//                           "Please Enter Remarks",
//                           "ok",
//                           exitpopup,
//                           AssetsImageWidget.warningimage);
//                     }
//                   });
//                 },
//               ),
//             ],
//           );
//         });
//   }

//   Future<void> _pullbackdialog(
//       BuildContext context, cancelpullleavecontroller) async {
//     pullbacktext = "";
//     cancelpullleavecontroller.text = "";
//     return showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) {
//           return AlertDialog(
//             title: const Text('Please Enter Remarks'),
//             content: Form(
//               key: formKey,
//               child: TextFormField(
//                 onChanged: (value) {
//                   setState(() {
//                     pullbacktext = value.toString();
//                     cancelpullleavecontroller = value.toString();
//                   });
//                 },
//                 validator: (value) =>
//                     value!.isEmpty ? 'Remarks should not empty!' : null,
//                 controller: cancelpullleavecontroller,
//                 decoration:
//                     const InputDecoration(hintText: "Please Enter Remarks"),
//               ),
//             ),
//             actions: [
//               MaterialButton(
//                 color: Colors.red,
//                 textColor: Colors.white,
//                 child: const Text('Cancel'),
//                 onPressed: () {
//                   setState(() {
//                     Navigator.pop(context);
//                   });
//                 },
//               ),
//               MaterialButton(
//                 color: Colors.green,
//                 textColor: Colors.white,
//                 child: const Text('OK'),
//                 onPressed: () {
//                   setState(() {
//                     final FormState form = formKey.currentState!;
//                     if (form.validate()) {
//                       Navigator.pop(context);
//                       postpullbackleave();
//                     } else {
//                       AppUtils.showSingleDialogPopup(
//                           context,
//                           "Please Enter Remarks",
//                           "ok",
//                           exitpopup,
//                           AssetsImageWidget.warningimage);
//                     }
//                   });
//                 },
//               ),
//             ],
//           );
//         });
//   }

//   void exitpopup() {
//     Navigator.pop(context);
//   }

//   void exitwithrefresh() {
//     Navigator.of(context).pop();
//     getdetailsdata();
//   }

//   Future<void> _launchUrl(url, {bool isNewTab = true}) async {
//     if (Platform.isAndroid) {
//       if (!await launchUrl(Uri.parse(url),
//           mode: LaunchMode.externalNonBrowserApplication)) {
//         throw Exception('Could not launch $url');
//       }
//     } else if (Platform.isIOS) {
//       if (!await launchUrl(Uri.parse(url),
//           mode: LaunchMode.externalApplication)) {
//         throw Exception('Could not launch $url');
//       }
//     }
//   }

//   void postcancelleave() async {
//     setState(() {
//       loading = true;
//     });
//     ApiService.cancelleave(internalId, cancelleavetxt, uniqId).then((response) {
//       setState(() {
//         loading = false;
//       });
//       if (response.statusCode == 200) {
//         if (jsonDecode(response.body)['status'].toString() == "true") {
//           AppUtils.showSingleDialogPopup(
//               context,
//               jsonDecode(response.body)['message'],
//               "Ok",
//               exitwithrefresh,
//               AssetsImageWidget.successimage);
//         } else {
//           AppUtils.showSingleDialogPopup(
//               context,
//               jsonDecode(response.body)['message'],
//               "Ok",
//               onexitpopup,
//               AssetsImageWidget.warningimage);
//         }
//       } else {
//         throw Exception(jsonDecode(response.body).toString()).toString();
//       }
//     }).catchError((e) {
//       setState(() {
//         loading = false;
//       });
//       AppUtils.showSingleDialogPopup(context, e.toString(), "Ok", onexitpopup,
//           AssetsImageWidget.errorimage);
//     });
//   }

//   void postpullbackleave() async {
//     setState(() {
//       loading = true;
//     });
//     ApiService.pullbackleave(internalId, cancelleavetxt, uniqId)
//         .then((response) {
//       setState(() {
//         loading = false;
//       });
//       if (response.statusCode == 200) {
//         if (jsonDecode(response.body)['status'].toString() == "true") {
//           AppUtils.showSingleDialogPopup(
//               context,
//               jsonDecode(response.body)['message'],
//               "Ok",
//               exitwithrefresh,
//               AssetsImageWidget.successimage);
//         } else {
//           AppUtils.showSingleDialogPopup(
//               context,
//               jsonDecode(response.body)['message'],
//               "Ok",
//               onexitpopup,
//               AssetsImageWidget.warningimage);
//         }
//       } else {
//         throw Exception(jsonDecode(response.body).toString()).toString();
//       }
//     }).catchError((e) {
//       setState(() {
//         loading = false;
//       });
//       AppUtils.showSingleDialogPopup(context, e.toString(), "Ok", onexitpopup,
//           AssetsImageWidget.errorimage);
//     });
//   }

//   void getdetailsdata() async {
//     setState(() {
//       loading = true;
//     });
//     ApiService.viewleave().then((response) {
//       setState(() {
//         loading = false;
//       });
//       if (response.statusCode == 200) {
//         if (jsonDecode(response.body)['status'].toString() == "true") {
//           leavemodel = ViewLeaveModel.fromJson(jsonDecode(response.body));
//           setState(() {
//             totalcount = leavemodel.message!.length;
//           });
//           // jsonList =
//           //     leavemodel.message!.map((player) => player.toJson()).toList();
//           // print("jsonList: $jsonList");
//         } else {
//           // AppUtils.showSingleDialogPopup(
//           //     context, jsonDecode(response.body)['message'], "Ok", onexitpopup);
//           leavemodel.message = null;
//         }
//       } else {
//         throw Exception(jsonDecode(response.body).toString()).toString();
//       }
//     }).catchError((e) {
//       //print(e);
//       setState(() {
//         loading = false;
//       });
//       AppUtils.showSingleDialogPopup(context, e.toString(), "Ok", onexitpopup,
//           AssetsImageWidget.errorimage);
//     });
//   }

//   void onexitpopup() {
//     Navigator.of(context).pop();
//   }
// }

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:powergroupess/models/viewleavemodel.dart';
import 'package:powergroupess/routenames.dart';
import 'package:powergroupess/services/apiservice.dart';
import 'package:powergroupess/utils/app_utils.dart';
import 'package:powergroupess/utils/constants.dart';
import 'package:powergroupess/utils/custom_indicatoronly.dart';
import 'package:powergroupess/views/widgets/assets_image_widget.dart';
import 'package:powergroupess/views/widgets/colorstatus.dart';
import 'package:powergroupess/views/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewLeavePage extends StatefulWidget {
  const ViewLeavePage({super.key});

  @override
  State<ViewLeavePage> createState() => _ViewLeavePageState();
}

class _ViewLeavePageState extends State<ViewLeavePage> {
  bool loading = false;
  ViewLeaveModel leavemodel = ViewLeaveModel();

  String uniqId = "";
  String internalId = "";

  TextEditingController searchcontroller = TextEditingController();
  TextEditingController cancelleavecontroller = TextEditingController();
  TextEditingController cancelpullleavecontroller = TextEditingController();

  String cancelleavetxt = "";
  String pullbacktext = "";

  final formKey = GlobalKey<FormState>();

  bool _searchBoolean = false;
  String? filter;
  int totalcount = 0;

  @override
  void initState() {
    super.initState();
    getdetailsdata();
  }

  @override
  void dispose() {
    searchcontroller.dispose();
    cancelleavecontroller.dispose();
    cancelpullleavecontroller.dispose();
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
                text: "Leave Details ($totalcount)",
                fontSize: 16,
                color: Colors.black,
              )
            : _searchTextField(),
        actions: !_searchBoolean
            ? [
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _searchBoolean = true;
                    });
                  },
                ),
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
                  },
                ),
              ],
      ),
      body: !loading
          ? leavemodel.message != null
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      leavedetailes(),
                    ],
                  ),
                )
              : Center(
                  child: Image.asset(
                    'assets/images/nodata1.png',
                    height: 200,
                    width: 200,
                  ),
                )
          : const CustomIndicator(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0), // optional padding
        child: CustomButton(
          onPressed: () {
            Navigator.pushNamed(context, RouteNames.applyleave).then((_) {
              getdetailsdata();
            });
          },
          name: "Click to Apply Leave",
          fontSize: 14,
          circularvalue: 30,
        ),
      ),
    );
  }

  Widget _searchTextField() {
    return TextField(
      controller: searchcontroller,
      onChanged: (String s) {
        setState(() {
          filter = s;
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
  
Widget leavedetailes() {
  return leavemodel.message != null && leavemodel.message!.isNotEmpty
      ? ListView.builder(
          itemCount: leavemodel.message!.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final item = leavemodel.message![index];
            final isCancelled = item.iscancelled.toString() == "Y";
            final isPullback = item.ispullbackcancelled.toString() == "Y";
            final hasAttachment = item.imageUrl != null &&
                item.imageUrl!.isNotEmpty &&
                item.imageUrl!.toLowerCase() != "null";

    String statusText;
Color statusColor;

if (isCancelled || isPullback) {
  statusText = "Cancelled";
  statusColor = Colors.red.shade400;
} else {
  // simplify pending approval to just "Pending"
  String rawStatus = item.isstatus.toString().toLowerCase();
  if (rawStatus.contains("pending")) {
    statusText = "Pending";
    statusColor = Colors.orange.shade400;
  } else if (rawStatus.contains("rejected")) {
    statusText = "Rejected";
    statusColor = Colors.red.shade400;
  } else if (rawStatus.contains("approved")) {
    statusText = "Approved";
    statusColor = Colors.green.shade400;
  } else {
    statusText = item.isstatus.toString();
    statusColor = Colors.blue.shade400;
  }
}

            Color cardColor = isCancelled
                ? Colors.red.shade50
                : isPullback
                    ? Colors.blue.shade50
                    : Colors.white;

            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              color: cardColor,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Header Row ---
                 Row(
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    // --- Avatar ---
    CircleAvatar(
      radius: 22,
      backgroundColor: AppConstants.containercolorArray[
          index % AppConstants.containercolorArray.length],
      child: const Icon(
        CupertinoIcons.person,
        color: Colors.white,
      ),
    ),
    const SizedBox(width: 12),

    // --- Name + Date + ID ---
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Employee Name
          Text(
            item.toEmpName.toString(),
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 15),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),

          // Date & ID in a row
          Row(
            children: [
           
              Text(
                AppConstants.convertdateformat(
                    item.createdDate.toString().substring(0, 10)),
                style: const TextStyle(
                    fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  "ID: ${item.intenalId.toString()}",
                  style: const TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    ),

    const SizedBox(width: 6),

    // --- Status Tag ---
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

    const SizedBox(width: 6),

    // --- More Menu Icon ---
    if (!isCancelled && !isPullback)
      GestureDetector(
        onTap: statusText.toLowerCase() == "rejected"
            ? null
            : () {
                uniqId = item.sId.toString();
                internalId = item.intenalId.toString();
                showCancel(context, index);
              },
        child: Icon(Icons.more_vert, color: Colors.grey.shade600),
      ),
  ],
)
,
                    const SizedBox(height: 12),
                    Divider(color: Colors.grey.shade300),
                    const SizedBox(height: 12),

                    // --- Leave Type & Total Days ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Leave Type",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black54)),
                              const SizedBox(height: 4),
                              Text(item.leavetypename.toString(),
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text("Total Days",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black54)),
                              const SizedBox(height: 4),
                              Text(
                                  '${AppConstants.changeddmmyyformat(item.fromdate.toString())} to ${AppConstants.changeddmmyyformat(item.todate.toString())} (${item.totalNoOfDays} ${item.totalNoOfDays == 1 ? "day" : "days"})',
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // --- Request By & Attachment ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Request By: ${item.createdByEmpName}",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black)),
                        if (hasAttachment)
                          GestureDetector(
                            onTap: () =>
                                _launchUrl(item.imageUrl.toString(), isNewTab: true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(20)),
                              child: const Text(
                                "View Attachment",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // --- Reason ---
                    if (item.reason != null && item.reason!.isNotEmpty)
                      Text("Reason: ${item.reason}",
                          style:
                              const TextStyle(fontSize: 12, color: Colors.black),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 12),

                    // --- Approval History ---
                    if (item.approvalHistory != null &&
                        item.approvalHistory!.isNotEmpty)
                      GestureDetector(
                        onTap: () => showSheet(context, index),
                        child: Row(
                          children: const [
                            Icon(Icons.remove_red_eye, size: 18),
                            SizedBox(width: 6),
                            Text("Approval History",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blue)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        )
      : const Center(child: Text('No Data'));
}

void showSheet(BuildContext context, int index) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.white,
    builder: (BuildContext bc) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Top draggable indicator
              Container(
                width: 50,
                height: 5,
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: leavemodel.message![index].approvalHistory!.length,
                itemBuilder: (BuildContext context, int idx) {
                  final history =
                      leavemodel.message![index].approvalHistory![idx];

                  // Status color
                  Color statusColor;
                  switch (history.status.toString()) {
                    case "Approved":
                      statusColor = Colors.green;
                      break;
                    case "Rejected":
                      statusColor = Colors.red;
                      break;
                    default:
                      statusColor = Colors.orange;
                  }

                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Status row
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  history.status.toString(),
                                  style: TextStyle(
                                      color: statusColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                history.status.toString() == "Approved"
                                    ? "Approved By"
                                    : history.status.toString() == "Rejected"
                                        ? "Rejected By"
                                        : "Pending",
                                style:
                                    const TextStyle(fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  history.approvername.toString(),
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Approved date
                          Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  size: 14, color: Colors.grey),
                              const SizedBox(width: 5),
                              Text(
                                history.approveddate.toString(),
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Remarks
                          if (history.remarks.toString().isNotEmpty)
                            Text(
                              "Remarks: ${history.remarks}",
                              style: const TextStyle(fontSize: 14),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    },
  );
}

  void showCancel(context, index) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('Cancel Leave'),
              onTap: () {
                Navigator.pop(context);
                _canceldialog(context, cancelleavecontroller);
              },
            ),
            leavemodel.message![index].isstatus.toString() != "Approved"
                ? ListTile(
                    leading: const Icon(Icons.rotate_right),
                    title: const Text('Pull Back Leave'),
                    onTap: () {
                      Navigator.pop(context);
                      _pullbackdialog(context, cancelpullleavecontroller);
                    },
                  )
                : const SizedBox(),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Cancel Dialog'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _canceldialog(
      BuildContext context, TextEditingController controller) async {
    cancelleavetxt = "";
    controller.text = "";

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Please Enter Remarks'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              onChanged: (value) {
                cancelleavetxt = value;
              },
              validator: (value) =>
                  value!.isEmpty ? 'Remarks should not empty!' : null,
              decoration:
                  const InputDecoration(hintText: "Please Cancel Remarks"),
            ),
          ),
          actions: [
            MaterialButton(
              color: Colors.red,
              textColor: Colors.white,
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            MaterialButton(
              color: Colors.green,
              textColor: Colors.white,
              child: const Text('OK'),
              onPressed: () {
                final FormState form = formKey.currentState!;
                if (form.validate()) {
                  Navigator.pop(context);
                  postcancelleave();
                } else {
                  AppUtils.showSingleDialogPopup(
                    context,
                    "Please Enter Remarks",
                    "ok",
                    exitpopup,
                    AssetsImageWidget.warningimage,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _pullbackdialog(
      BuildContext context, TextEditingController controller) async {
    pullbacktext = "";
    controller.text = "";

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Please Enter Remarks'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              onChanged: (value) {
                pullbacktext = value;
              },
              validator: (value) =>
                  value!.isEmpty ? 'Remarks should not empty!' : null,
              decoration:
                  const InputDecoration(hintText: "Please Enter Remarks"),
            ),
          ),
          actions: [
            MaterialButton(
              color: Colors.red,
              textColor: Colors.white,
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            MaterialButton(
              color: Colors.green,
              textColor: Colors.white,
              child: const Text('OK'),
              onPressed: () {
                final FormState form = formKey.currentState!;
                if (form.validate()) {
                  Navigator.pop(context);
                  postpullbackleave();
                } else {
                  AppUtils.showSingleDialogPopup(
                    context,
                    "Please Enter Remarks",
                    "ok",
                    exitpopup,
                    AssetsImageWidget.warningimage,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void exitpopup() {
    Navigator.pop(context);
  }

  void exitwithrefresh() {
    Navigator.of(context).pop();
    getdetailsdata();
  }

  Future<void> _launchUrl(dynamic url, {bool isNewTab = true}) async {
    final Uri uri = url is Uri ? url : Uri.parse(url.toString());

    if (Platform.isAndroid) {
      if (!await launchUrl(
        uri,
        mode: LaunchMode.externalNonBrowserApplication,
      )) {
        throw Exception('Could not launch $uri');
      }
    } else if (Platform.isIOS) {
      if (!await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      )) {
        throw Exception('Could not launch $uri');
      }
    } else {
      if (!await launchUrl(uri, mode: LaunchMode.platformDefault)) {
        throw Exception('Could not launch $uri');
      }
    }
  }

  void postcancelleave() async {
    setState(() {
      loading = true;
    });

    ApiService.cancelleave(internalId, cancelleavetxt, uniqId).then((response) {
      setState(() {
        loading = false;
      });

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString() == "true") {
          AppUtils.showSingleDialogPopup(
            context,
            jsonDecode(response.body)['message'],
            "Ok",
            exitwithrefresh,
            AssetsImageWidget.successimage,
          );
        } else {
          AppUtils.showSingleDialogPopup(
            context,
            jsonDecode(response.body)['message'],
            "Ok",
            onexitpopup,
            AssetsImageWidget.warningimage,
          );
        }
      } else {
        throw Exception(jsonDecode(response.body).toString()).toString();
      }
    }).catchError((e) {
      setState(() {
        loading = false;
      });

      AppUtils.showSingleDialogPopup(
        context,
        e.toString(),
        "Ok",
        onexitpopup,
        AssetsImageWidget.errorimage,
      );
    });
  }

  void postpullbackleave() async {
    setState(() {
      loading = true;
    });

    /// FIXED: sending pullbacktext (not cancelleavetxt)
    ApiService.pullbackleave(internalId, pullbacktext, uniqId).then((response) {
      setState(() {
        loading = false;
      });

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString() == "true") {
          AppUtils.showSingleDialogPopup(
            context,
            jsonDecode(response.body)['message'],
            "Ok",
            exitwithrefresh,
            AssetsImageWidget.successimage,
          );
        } else {
          AppUtils.showSingleDialogPopup(
            context,
            jsonDecode(response.body)['message'],
            "Ok",
            onexitpopup,
            AssetsImageWidget.warningimage,
          );
        }
      } else {
        throw Exception(jsonDecode(response.body).toString()).toString();
      }
    }).catchError((e) {
      setState(() {
        loading = false;
      });

      AppUtils.showSingleDialogPopup(
        context,
        e.toString(),
        "Ok",
        onexitpopup,
        AssetsImageWidget.errorimage,
      );
    });
  }

  void getdetailsdata() async {
    setState(() {
      loading = true;
    });

    ApiService.viewleave().then((response) {
      setState(() {
        loading = false;
      });

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString() == "true") {
          leavemodel = ViewLeaveModel.fromJson(jsonDecode(response.body));
          setState(() {
            totalcount = leavemodel.message!.length;
          });
        } else {
          leavemodel.message = null;
        }
      } else {
        throw Exception(jsonDecode(response.body).toString()).toString();
      }
    }).catchError((e) {
      setState(() {
        loading = false;
      });

      AppUtils.showSingleDialogPopup(
        context,
        e.toString(),
        "Ok",
        onexitpopup,
        AssetsImageWidget.errorimage,
      );
    });
  }

  void onexitpopup() {
    Navigator.of(context).pop();
  }
}
