import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:winstar/models/viewallemployeeModel.dart';
import 'package:winstar/services/apiservice.dart';
import 'package:winstar/services/pref.dart';
import 'package:winstar/utils/app_utils.dart';
import 'package:winstar/utils/appcolor.dart';
import 'package:winstar/utils/constants.dart';
import 'package:winstar/utils/netsuite/netsuiteservice.dart';
import 'package:winstar/views/letterpage/lettertypemodel.dart';
import 'package:winstar/views/widgets/assets_image_widget.dart';
import 'package:winstar/views/widgets/custom_button.dart';
import 'package:intl/intl.dart';

class LetterApplyPage extends StatefulWidget {
  const LetterApplyPage({super.key});

  @override
  State<LetterApplyPage> createState() => _LetterApplyPageState();
}

class _LetterApplyPageState extends State<LetterApplyPage> {
  String lettertypeid = "";
  String lettertypename = "";
  LetterTypeModel letterTypeModel = LetterTypeModel();
  TextEditingController reasoncontroller = TextEditingController();

  bool? check1 = false;
  bool loading = false;

  List<String> allemplist = [];
  List<String> lettertypelist = [];
  ViewAllEmployeeModel employeeModel = ViewAllEmployeeModel();

  String? alternsid;
  String? selectedemployee;
  @override
  void initState() {
    super.initState();
    if (mounted) {
      getlettertypelist();
      getallemployeedetails();
    }
  }

  @override
  void dispose() {
    reasoncontroller.clear();
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
        title: AppUtils.buildNormalText(
            text: "Letter Request Application",
            color: Colors.black,
            fontSize: 16),
        centerTitle: false,
      ),
      body: !loading
          ? SingleChildScrollView(
              child: Column(
                children: [getwidget()],
              ),
            )
          : const Center(
              child: CupertinoActivityIndicator(
                  radius: 30.0, color: Appcolor.black),
            ),
    );
  }

  Widget getwidget() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppUtils.buildNormalText(text: "LETTER TYPE"),
          const SizedBox(height: 5),
          SizedBox(
              width: MediaQuery.of(context).size.width,
              child: DropdownSearch<String>(
                popupProps: const PopupProps.menu(
                  showSearchBox: true,
                  showSelectedItems: true,
                ),
                items: lettertypelist,
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    hintText: 'Letter Type *',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: Appcolor.primarycolor, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: Appcolor.primarycolor, width: 1),
                    ),
                  ),
                ),
                // validator: (value) =>
                //     value!.isEmpty ? 'Letter Type should not empty!' : null,
                onChanged: (val) {
                  for (int kk = 0; kk < letterTypeModel.records!.length; kk++) {
                    if (letterTypeModel.records![kk].name.toString() == val) {
                      lettertypeid = letterTypeModel.records![kk].id.toString();
                      lettertypename =
                          letterTypeModel.records![kk].name.toString();
                      setState(() {});
                    }
                  }
                },
              )),
          const SizedBox(height: 10),
          AppUtils.buildNormalText(text: "To Whomsoever Concern * "),
          const SizedBox(height: 5),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: DropdownSearch<String>(
              popupProps: const PopupProps.menu(
                showSearchBox: true,
                showSelectedItems: true,
              ),
              items: allemplist,
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  hintText: 'To Whomsoever Concern *',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Appcolor.primarycolor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Appcolor.primarycolor, width: 1),
                  ),
                ),
              ),
              // validator: (value) =>
              //     value!.isEmpty ? 'Assigned to should not empty!' : null,
              onChanged: (val) {
                for (int kk = 0; kk < employeeModel.message!.length; kk++) {
                  if (employeeModel.message![kk].firstName.toString() == val) {
                    alternsid = employeeModel.message![kk].nsId.toString();
                    selectedemployee =
                        employeeModel.message![kk].firstName.toString();

                    setState(() {});
                  }
                }
              },
            ),
          ),
          const SizedBox(height: 10),
          AppUtils.buildNormalText(text: "Reason", fontSize: 15),
          const SizedBox(
            height: 20,
          ),
          Container(
              //padding: EdgeInsets.all(20),
              child: TextField(
            controller: reasoncontroller,
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Enter Remarks",
              focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(width: 1, color: Appcolor.primarycolor)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.black26, width: 1),
              ),
            ),
          )),
          const SizedBox(
            height: 20,
          ),
          CustomButton(
            onPressed: () {
              if (lettertypeid.isEmpty) {
                AppUtils.buildNormalText(text: "Please Choose Letter type");
              } else if (alternsid.toString().isEmpty) {
                AppUtils.buildNormalText(text: "Please Choose Assigned to!");
              } else {
                onpostletterrequest();
              }
            },
            name: "Apply Letter Request",
            circularvalue: 30,
            fontSize: 14,
          )
        ],
      ),
    );
  }

  void getallemployeedetails() async {
    setState(() {
      loading = true;
    });
    ApiService.getallemployee().then((response) {
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString() == "true") {
          employeeModel =
              ViewAllEmployeeModel.fromJson(jsonDecode(response.body));
          for (int i = 0; i < employeeModel.message!.length; i++) {
            allemplist.add(employeeModel.message![i].firstName.toString());
          }
        } else {
          print(jsonDecode(response.body)['message']);
          AppUtils.showSingleDialogPopup(
              context,
              jsonDecode(response.body)['message'],
              "Ok",
              onexitpopup,
              AssetsImageWidget.warningimage);
        }
      } else {
        throw Exception(jsonDecode(response.body)['message']);
      }
    }).catchError((e) {
      setState(() {
        loading = false;
      });
      print(e.toString());
      AppUtils.showSingleDialogPopup(context, e.toString(), "Ok", onexitpopup,
          AssetsImageWidget.errorimage);
    });
  }

  void onpostletterrequest() async {
    DateTime now = DateTime.now();

    var currentyear = DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now());
    var currentdate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    var json = {
      "requestapplicationno":
          "Mob-Letter ${Prefs.getEmpID('empID').toString()}-$currentyear",
      "date": currentdate,
      "lettertypecode": lettertypeid,
      "lettertypename": lettertypename,
      "letteraddresstocode": alternsid,
      "letteraddresstoname": selectedemployee,
      "purpose": reasoncontroller.text,
      "attachment": "",
      "iscancelled": "N",
      "iscancelledreason": "",
      "iscancelleddate": "",
      "isstatus": "Pending",
      "createdby": Prefs.getNsID('nsid'),
      "createdDate": ApiService.mobilecurrentdate,
      "toEmpID": Prefs.getNsID('nsid'),
      "toEmpName": Prefs.getFullName('Name'),
      "isSync": 0,
      "NetsuiteRefNo": "",
      "NetsuiteRemarks": ""
      // "approval_history": [
      //   {
      //     "approverid": "",
      //     "approvername": "",
      //     "department": "",
      //     "status": "",
      //     "remarks": "",
      //     "approveddate": ""
      //   }
      // ]
    };
    print(jsonEncode(json));
    setState(() {
      loading = true;
    });
    ApiService.postletterrequest(json).then((response) {
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString() == "true") {
          AppUtils.showSingleDialogPopup(
              context,
              jsonDecode(response.body)['message'],
              "Ok",
              onrefreshscreen,
              AssetsImageWidget.successimage);

          setState(() {});
        } else {
          AppUtils.showSingleDialogPopup(
              context,
              jsonDecode(response.body)['message'],
              "Ok",
              onexitpopup,
              AssetsImageWidget.warningimage);
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

  getlettertypelist() async {
    setState(() {
      loading = true;
    });
    try {
      Uri baseUri = Uri.parse(
          '${AppConstants.netSuiteapiBaseUrl}script=${AppConstants.letterscriptid}&deploy=${AppConstants.lettereployid}');
      await NetSuiteApiService.client.get(baseUri).then((response) {
        setState(() {
          loading = false;
        });
        if (response.statusCode == 200) {
          letterTypeModel =
              LetterTypeModel.fromJson(json.decode(json.decode(response.body)));
          lettertypelist.clear();
          for (int i = 0; i < letterTypeModel.records!.length; i++) {
            lettertypelist.add(letterTypeModel.records![i].name.toString());
          }
          //log(b['currentPage'].toString());
        } else {
          AppUtils.showSingleDialogPopup(context, jsonDecode(response.body),
              "Ok", onexitpopup, AssetsImageWidget.errorimage);
        }
      });
    } on Exception catch (_) {
      setState(() {
        loading = false;
      });
      rethrow;
    }
  }

  void onexitpopup() {
    Navigator.of(context).pop();
  }

  void onrefreshscreen() {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }
}
