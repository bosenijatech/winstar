import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:powergroupess/models/assetnamemodel.dart';
import 'package:powergroupess/models/assettypemodel.dart';
import 'package:powergroupess/services/apiservice.dart';
import 'package:powergroupess/services/pref.dart';
import 'package:powergroupess/utils/app_utils.dart';
import 'package:powergroupess/utils/appcolor.dart';
import 'package:powergroupess/utils/constants.dart';
import 'package:powergroupess/utils/netsuite/netsuiteservice.dart';
import 'package:powergroupess/views/widgets/assets_image_widget.dart';
import 'package:powergroupess/views/widgets/custom_button.dart';
import 'package:intl/intl.dart';

class AssetApplyPage extends StatefulWidget {
  const AssetApplyPage({super.key});

  @override
  State<AssetApplyPage> createState() => _AssetApplyPageState();
}

class _AssetApplyPageState extends State<AssetApplyPage> {
  late List<String> assettypelist = [];

  late List<String> assetnamelist = [];

  AssetTypeModel assetTypeModel = AssetTypeModel();
  AssetNameListModel assetNameListModel = AssetNameListModel();

  String? alterassetcode = "";
  String? alterassetname = "";

  String? alterassettypecode = "";
  String? alterassettypename = "";

  bool? check1 = false;
  bool loading = false;
  TextEditingController remarkscontroller = TextEditingController();

  @override
  void initState() {
    getassettypelist();
    getassetnamelist();
    super.initState();
  }

  @override
  void dispose() {
    remarkscontroller.clear();
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
            text: "Asset Request Application",
            color: Colors.black,
            fontSize: 16),
        centerTitle: false,
      ),
      body: !loading
          ? SingleChildScrollView(
              child: Column(
                children: [getdetails()],
              ),
            )
          : const Center(
              child: CupertinoActivityIndicator(
                  radius: 30.0, color: Appcolor.twitterBlue),
            ),
    );
  }

  Widget getdetails() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppUtils.buildNormalText(text: "ASSET TYPE"),
          const SizedBox(
            height: 5,
          ),
          DropdownSearch<String>(
            popupProps: const PopupProps.menu(
              showSearchBox: true,
              showSelectedItems: true,
            ),
            items: assettypelist,
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                hintText: 'Asset Type * ',
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
            onChanged: (val) {
              for (int kk = 0; kk < assetTypeModel.records!.length; kk++) {
                if (assetTypeModel.records![kk].name.toString() == val) {
                  alterassettypecode =
                      assetTypeModel.records![kk].id.toString();
                  alterassettypename =
                      assetTypeModel.records![kk].name.toString();

                  setState(() {});
                }
              }
            },
          ),
          const SizedBox(height: 10),
          AppUtils.buildNormalText(text: "ASSET NAME"),
          const SizedBox(height: 10),
          DropdownSearch<String>(
            popupProps: const PopupProps.menu(
              showSearchBox: true,
              showSelectedItems: true,
            ),
            items: assetnamelist,
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                hintText: 'Asset Name * ',
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
            onChanged: (val) {
              for (int kk = 0; kk < assetNameListModel.records!.length; kk++) {
                if (assetNameListModel.records![kk].name.toString() == val) {
                  alterassetcode =
                      assetNameListModel.records![kk].id.toString();
                  alterassetname =
                      assetNameListModel.records![kk].name.toString();
                  setState(() {});
                }
              }
            },
          ),
          const SizedBox(
            height: 10,
          ),
          AppUtils.buildNormalText(text: "REMARKS", fontSize: 15),
          const SizedBox(
            height: 20,
          ),
          Container(
              //padding: EdgeInsets.all(20),
              child: TextField(
            controller: remarkscontroller,
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Enter Remarks",
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.grey)),
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
              onpostletterrequest();
            },
            name: "Apply Asset Request",
            circularvalue: 30,
            fontSize: 16,
          )
        ],
      ),
    );
  }

  getassettypelist() async {
    setState(() {
      loading = true;
    });
    try {
      Uri baseUri = Uri.parse(
          '${AppConstants.netSuiteapiBaseUrl}script=${AppConstants.assettypescriptid}&deploy=${AppConstants.assettypedeployid}');

      await NetSuiteApiService.client.get(baseUri).then((response) {
        setState(() {
          loading = false;
        });
        if (response.statusCode == 200) {
          assetTypeModel =
              AssetTypeModel.fromJson(json.decode(json.decode(response.body)));
          assettypelist.clear();
          for (int i = 0; i < assetTypeModel.records!.length; i++) {
            assettypelist.add(assetTypeModel.records![i].name.toString());
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

  getassetnamelist() async {
    setState(() {
      loading = true;
    });
    try {
      Uri baseUri = Uri.parse(
          '${AppConstants.netSuiteapiBaseUrl}script=${AppConstants.assetnamescriptid}&deploy=${AppConstants.assetnamedeployid}');
      await NetSuiteApiService.client.get(baseUri).then((response) {
        setState(() {
          loading = false;
        });
        if (response.statusCode == 200) {
          assetNameListModel = AssetNameListModel.fromJson(
              json.decode(json.decode(response.body)));
          assetnamelist.clear();
          for (int i = 0; i < assetNameListModel.records!.length; i++) {
            assetnamelist.add(assetNameListModel.records![i].name.toString());
          }
        } else {
          AppUtils.showSingleDialogPopup(context, jsonDecode(response.body),
              "Ok", onexitpopup, AssetsImageWidget.warningimage);
        }
      });
    } on Exception catch (_) {
      setState(() {
        loading = false;
      });
      rethrow;
    }
  }

  void onpostletterrequest() async {
    DateTime now = DateTime.now();
    DateTime currentyear = DateTime(now.year);
    var currentdate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    var json = {
      "assetrequestapplicationno":
          "MASSET-${Prefs.getEmpID('empID').toString()}-${Prefs.getUserName('username').toString()}-${currentyear.year}",
      "date": ApiService.mobilecurrentdate,
      "assettypecode": alterassettypecode,
      "assettypename": alterassettypename,
      "assetcode": alterassetcode,
      "assetname": alterassetname,
      "remarks": remarkscontroller.text,
      "attachment": "",
      "iscancelled": "N",
      "iscancelledreason": "",
      "iscancelleddate": "",
      "isstatus": "Pending",
      "createdby": Prefs.getNsID('nsid'),
      "createdByEmpName": Prefs.getFullName('Name'),
      "createdDate": ApiService.mobilecurrentdate,
      "toEmpID": Prefs.getNsID('nsid'),
      "toEmpName": Prefs.getFullName('Name'),
      "isSync": 0,
    };
    print(jsonEncode(json));
    setState(() {
      loading = true;
    });
    ApiService.postassetrequest(json).then((response) {
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

  void onexitpopup() {
    Navigator.of(context).pop();
  }

  void onrefreshscreen() {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }
}
