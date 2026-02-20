import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:winstar/models/payslipmodel.dart';
import 'package:winstar/models/yearmodel.dart';
import 'package:winstar/services/apiservice.dart';
import 'package:winstar/services/pref.dart';
import 'package:winstar/utils/Appcolor.dart';
import 'package:winstar/utils/app_utils.dart';
import 'package:winstar/utils/constants.dart';
import 'package:winstar/utils/netsuite/netsuiteservice.dart';
import 'package:winstar/utils/numbertowords.dart';
import 'package:winstar/utils/sharedprefconstants.dart';
import 'package:winstar/views/widgets/assets_image_widget.dart';
import 'package:winstar/views/widgets/custom_button.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewPaySlipPage extends StatefulWidget {
  const ViewPaySlipPage({super.key});

  @override
  State<ViewPaySlipPage> createState() => _ViewPaySlipPageState();
}

class _ViewPaySlipPageState extends State<ViewPaySlipPage> {
  int monthid = 0;
  String monthname = "";
  String yearname = "";
  String yearid = "";
  final dropDownKey = GlobalKey<DropdownSearchState>();
  YearModel yearModel = YearModel();
  PaySlipModel paymodel = PaySlipModel();
  bool loading = false;
  bool visible = false;
  String fileUrl = "";
  String fromdate = "";
  String todate = "";
  List<String> yearlist = [];
  bool permissionGranted = false;
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  Timer? timer;
  List<String> monthlist = [
    "January",
    "Febrauary",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  @override
  void initState() {
    getyearlist();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
            text: "Payslip", color: Colors.black, fontSize: 16),
        centerTitle: false,
        actions: [
          visible
              ? IconButton(
                  onPressed: () async {
                    _launchUrl(
                        Uri.parse(paymodel.message!.payslipurl.toString()));
                  },
                  icon: const Icon(
                    Icons.download,
                    color: Colors.white,
                  ))
              : Container()
        ],

        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 30),
        //     child: InkWell(
        //         onTap: () async {
        //           if (await _requestPermission(Permission.storage) == true) {
        //             print("Permission is granted");
        //             base64ToPdf(base64String, monthname);
        //           } else {
        //             print("permission is not granted");
        //           }
        //         },
        //         child: const Icon(Icons.download)),
        //   )
        // ],
      ),
      body: !loading
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: getwidgetdetails(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
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

  Widget getwidgetdetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        DropdownSearch<String>(
          popupProps: const PopupProps.menu(
            showSearchBox: true,
            showSelectedItems: true,
          ),
          items: monthlist,
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              labelText: 'Select Month',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Appcolor.primarycolor, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Appcolor.primarycolor, width: 1),
              ),
            ),
          ),
          onChanged: (val) {
            monthid = monthlist.indexWhere((item) => item == val) + 1;
            print(val);
            // if (monthid > 0) {
            //   getyearlist();
            // }
            setState(() {
              paymodel.message == null;
            });
            monthname = val.toString();
          },
          selectedItem: monthname,
        ),
        const SizedBox(
          height: 20,
        ),
        DropdownSearch<String>(
          popupProps: const PopupProps.menu(
            showSearchBox: true,
            showSelectedItems: true,
          ),
          items: yearlist,
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              labelText: 'Select Year',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Appcolor.primarycolor, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Appcolor.primarycolor, width: 1),
              ),
            ),
          ),
          onChanged: (val) {
            for (int kk = 0; kk < yearModel.records!.length; kk++) {
              if (yearModel.records![kk].name.toString() == val) {
                yearname = yearModel.records![kk].name.toString();
                yearid = yearModel.records![kk].id.toString();
                print(yearid);
                print(yearname);
                print(monthname);
                if (monthname.isEmpty && yearname.isEmpty) {
                } else {
                  paymodel.message == null;
                  getFirstAndLastDayOfMonth1(
                      monthname, int.parse(yearname), "dd/MM/yyyy");
                }
                setState(() {});
              }
            }
          },
          selectedItem: yearname,
        ),
        const SizedBox(
          height: 30,
        ),
        CustomButton(
            onPressed: () {
              if (monthname.isEmpty) {
                AppUtils.showSingleDialogPopup(context, "Choose Month", "Ok",
                    onexitpopup, AssetsImageWidget.warningimage);
              } else if (yearname.isEmpty) {
                AppUtils.showSingleDialogPopup(context, "Choose Year", "Ok",
                    onexitpopup, AssetsImageWidget.warningimage);
              } else {
                deleteexistingpayslip();
              }
            },
            name: "Generate PaySlip",
            circularvalue: 30),
        Expanded(
            flex: 7,
            child: paymodel.message != null
                ? Container(
                    color: Colors.grey,
                    key: _pdfViewerKey,
                    child: SfPdfViewer.network(
                        paymodel.message!.payslipurl.toString()),
                  )
                : Container())
      ],
    );
  }

  String getFirstAndLastDayOfMonth1(
      String monthName, int year, String customFormat) {
    var month = DateFormat('MMMM').parse(monthName).month;
    var firstDay = DateTime(year, month, 1);
    var lastDay = DateTime(year, month + 1, 0);
    var formatter = DateFormat(customFormat);
    print(
        'First Day: ${formatter.format(firstDay)}, Last Day: ${formatter.format(lastDay)}');
    fromdate = formatter.format(firstDay);
    fromdate = formatter.format(firstDay);
    todate = formatter.format(lastDay);
    return 'First Day: ${formatter.format(firstDay)}, Last Day: ${formatter.format(lastDay)}';
  }

  void deleteexistingpayslip() {
    var json = {
      "createdby": Prefs.getNsID("nsid").toString(),
    };
    print(jsonEncode(json));
    setState(() {
      loading = true;
    });
    ApiService.deletepayslip(json).then((response) {
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString() == "true") {
          print(jsonDecode(response.body));
          getFirstAndLastDayOfMonth1(
              monthname, int.parse(yearname), "dd/MM/yyyy");
          requestpayslip();
        } else {
          print(jsonDecode(response.body));
          getFirstAndLastDayOfMonth1(
              monthname, int.parse(yearname), "dd/MM/yyyy");
          requestpayslip();
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

  void requestpayslip() async {
    var now = DateTime.now();
    var formatter = DateFormat('dd/MM/yyyy');
    String formattedDate = formatter.format(now);

    var body = [
      {
        "requestDate": formattedDate,
        "employeeId": Prefs.getNsID('nsid').toString(),
        "employeeName": SharefprefConstants.shareFirstName,
        "startDate": fromdate,
        "endDate": todate,
        "payGroup": Prefs.getPayGroupId(SharefprefConstants.sharedpaygroupid)
            .toString(),
        "payGroupName":
            Prefs.getPayGroupName(SharefprefConstants.sharedpaygroupname)
                .toString(),
        "emailId": Prefs.getEmailid(SharefprefConstants.sharedemailid),
        "Status": "Open",
        "notes": "payslip",
        "hrComments": "Slip",
        "essReference": Prefs.getNsID('nsid').toString(),
      }
    ];
    print(jsonEncode(body));
    setState(() {
      loading = true;
    });
    try {
      Uri baseUri = Uri.parse(
          '${AppConstants.netSuiteapiBaseUrl}script=${AppConstants.getpayslipscriptid}&deploy=${AppConstants.getpayslipdeployid}');
      await NetSuiteApiService.client
          .post(baseUri, body: body)
          .then((response) {
        setState(() {
          loading = false;
        });
        if (response.statusCode == 200) {
          print(jsonDecode(response.body)[0]['Status']);
          if (jsonDecode(response.body)[0]['Status'].toString() == "true") {
            // //deleteexistingpayslip();
            // //getpayslip();
            // timer = Timer.periodic(
            //     const Duration(seconds: 30), (Timer t) => getpayslip());
            _startLoadingAndCallApi();
          }
        } else {
          AppUtils.showSingleDialogPopup(context,
              json.decode(json.decode(response.body)), "Ok", onexitpopup, null);
        }
      });
    } on Exception catch (e) {
      print(e);
      setState(() {
        loading = false;
      });
      rethrow;
    }
  }

  Future<void> _startLoadingAndCallApi() async {
    setState(() {
      loading = true;
    });
    Future.delayed(const Duration(seconds: 15), () {
      setState(() {
        loading = false;
      });
      getpayslip();
    });
  }

  getpayslip() async {
    var json = {
      "createdby": Prefs.getNsID("nsid").toString(),
    };
    print(jsonEncode(json));
    setState(() {
      loading = true;
    });
    ApiService.getpayslip(json).then((response) {
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString() == "true") {
          paymodel = PaySlipModel.fromJson(jsonDecode(response.body));
          setState(() {
            visible = true;
            // fileUrl = "";
            // fileUrl = paymodel.message!.payslipurl.toString();
          });
        } else {
          paymodel.message = null;
          AppUtils.showSingleDialogPopup(
              context,
              jsonDecode(response.body)['message'],
              "Ok",
              onexitpopup,
              AssetsImageWidget.errorimage);
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

  Widget callview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppUtils.buildNormalText(
            text: "Salary Details ", fontSize: 15, fontWeight: FontWeight.bold),
        const SizedBox(
          height: 5,
        ),
        getactualdays(),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppUtils.buildNormalText(text: "Earnings"),
            AppUtils.buildNormalText(text: "Amount(INR)")
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        earnings(),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppUtils.buildNormalText(text: "Contribution"),
            AppUtils.buildNormalText(text: "Amount(INR)")
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        contribution(),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppUtils.buildNormalText(text: "Taxes & Deductions"),
            AppUtils.buildNormalText(text: "Amount(INR)")
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        taxeswidget(),
        const SizedBox(
          height: 5,
        ),
        nepaywidget(),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }

  Widget getactualdays() {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          border: Border.all(
        color: Colors.grey.shade300,
        width: 1,
      )),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: AppUtils.buildNormalText(
                      text: "ACTUAl PAYABLE DAYS",
                      fontSize: 14,
                      color: Colors.grey.shade600)),
              Expanded(
                  child: AppUtils.buildNormalText(
                      text: "TOTAL WORKING DAYS",
                      fontSize: 14,
                      color: Colors.grey.shade600)),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: AppUtils.buildNormalText(
                      text: "30", fontSize: 14, color: Colors.grey.shade600)),
              Expanded(
                  child: AppUtils.buildNormalText(
                      text: "30", fontSize: 14, color: Colors.grey.shade600)),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: AppUtils.buildNormalText(
                      text: "LOSS OF PAY DAYS",
                      fontSize: 14,
                      color: Colors.grey.shade600)),
              Expanded(
                  child: AppUtils.buildNormalText(
                      text: "0", fontSize: 14, color: Colors.grey.shade600)),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: AppUtils.buildNormalText(
                      text: "DAYS PAYABLE",
                      fontSize: 14,
                      color: Colors.grey.shade600)),
              Expanded(
                  child: AppUtils.buildNormalText(
                      text: "30", fontSize: 14, color: Colors.grey.shade600)),
            ],
          ),
        ],
      ),
    );
  }

  Widget earnings() {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          border: Border.all(
        color: Colors.grey.shade300,
        width: 1,
      )),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppUtils.buildNormalText(
                  text: "Basic", fontSize: 13, color: Colors.grey.shade600),
              AppUtils.buildNormalText(
                text: "1000",
                fontSize: 13,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppUtils.buildNormalText(
                  text: "HRA", fontSize: 13, color: Colors.grey.shade600),
              AppUtils.buildNormalText(text: "1000", fontSize: 13),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppUtils.buildNormalText(
                  text: "Medical Allowance",
                  fontSize: 13,
                  color: Colors.grey.shade600),
              AppUtils.buildNormalText(text: "1000", fontSize: 13),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppUtils.buildNormalText(
                  text: "Conveyance Allowance",
                  fontSize: 13,
                  color: Colors.grey.shade600),
              AppUtils.buildNormalText(text: "1000", fontSize: 13),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppUtils.buildNormalText(
                  text: "Special Allowance",
                  fontSize: 13,
                  color: Colors.grey.shade600),
              AppUtils.buildNormalText(text: "1000", fontSize: 13),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppUtils.buildNormalText(
                  text: "Dearness Allowance",
                  fontSize: 13,
                  color: Colors.grey.shade600),
              AppUtils.buildNormalText(text: "1000", fontSize: 13),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppUtils.buildNormalText(
                  text: "Total(A)", fontSize: 14, fontWeight: FontWeight.bold),
              AppUtils.buildNormalText(
                  text: "90000", fontSize: 14, fontWeight: FontWeight.bold),
            ],
          ),
        ],
      ),
    );
  }

  Widget contribution() {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          border: Border.all(
        color: Colors.grey.shade300,
        width: 1,
      )),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppUtils.buildNormalText(
                  text: "PF Employee",
                  fontSize: 13,
                  color: Colors.grey.shade600),
              AppUtils.buildNormalText(text: "1800", fontSize: 13),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppUtils.buildNormalText(
                  text: "Total(B)", fontSize: 14, fontWeight: FontWeight.bold),
              AppUtils.buildNormalText(
                  text: "1000", fontSize: 14, fontWeight: FontWeight.bold),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget taxeswidget() {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          border: Border.all(
        color: Colors.grey.shade300,
        width: 1,
      )),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppUtils.buildNormalText(
                  text: "Professtionl Tax",
                  fontSize: 13,
                  color: Colors.grey.shade600),
              AppUtils.buildNormalText(text: "800", fontSize: 13),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppUtils.buildNormalText(
                  text: "Total(B)", fontSize: 14, fontWeight: FontWeight.bold),
              AppUtils.buildNormalText(
                  text: "1000", fontSize: 14, fontWeight: FontWeight.bold),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget nepaywidget() {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          border: Border.all(
        color: Colors.grey.shade300,
        width: 1,
      )),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppUtils.buildNormalText(
                  text: "Net Pay (A-B-C)", fontSize: 13, color: Colors.black),
              AppUtils.buildNormalText(
                  text: "10902", fontSize: 14, fontWeight: FontWeight.bold),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          AppUtils.buildNormalText(
              text:
                  "Net Pay (A-B-C) ${NumberToWordsEnglish.convert(96911)} only \n',",
              fontSize: 13),
        ],
      ),
    );
  }

  void getyearlist() async {
    setState(() {
      loading = true;
    });
    try {
      Uri baseUri = Uri.parse(
          '${AppConstants.netSuiteapiBaseUrl}script=${AppConstants.yearlistscriptid}&deploy=${AppConstants.yearlistdeployid}');
      await NetSuiteApiService.client.get(baseUri).then((response) {
        setState(() {
          loading = false;
        });
        if (response.statusCode == 200) {
          yearModel =
              YearModel.fromJson(json.decode(json.decode(response.body)));
          yearlist.clear();
          for (int i = 0; i < yearModel.records!.length; i++) {
            if (yearModel.records![i].inactive.toString() == "false") {
              yearlist.add(yearModel.records![i].name.toString());
            }
          }
        } else {
          AppUtils.showSingleDialogPopup(
              context,
              json.decode(json.decode(response.body)),
              "Ok",
              onexitpopup,
              AssetsImageWidget.warningimage);
        }
      });
    } on Exception catch (_) {
      setState(() {
        loading = false;
      });
      rethrow;
    }
  }

  void onrefreshscreen() {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  Future<bool> _requestPermission(Permission permission) async {
    AndroidDeviceInfo build = await DeviceInfoPlugin().androidInfo;
    print(build.version.sdkInt);
    if (build.version.sdkInt >= 30) {
      var re = await Permission.manageExternalStorage.request();
      if (re.isGranted) {
        return true;
      } else {
        return false;
      }
    } else {
      if (await permission.isGranted) {
        return true;
      } else {
        var result = await permission.request();
        if (result.isGranted) {
          return true;
        } else {
          return false;
        }
      }
    }
  }

  base64ToPdf(String base64String, String fileName) async {
    const folderName = "HalaEss";
    late Directory dir;
    if (Platform.isAndroid) {
      dir = Directory("storage/emulated/0/$folderName");
    } else if (Platform.isIOS) {
      var iosdir = await getExternalStorageDirectory();
      dir = Directory('${iosdir!.path}/$folderName/');
    }
    if ((await dir.exists())) {
      var bytes = base64Decode(base64String);
      final file = File("${dir.path}/$fileName.pdf");
      await file.writeAsBytes(bytes.buffer.asUint8List());
      AppUtils.showSingleDialogPopup(
          context,
          "Pdf Saved Successfully!.Internal Storage Hala Ess Folder!",
          "Ok",
          onexitpopup,
          AssetsImageWidget.successimage);
      return dir.path;
    } else {
      dir.create();
      var bytes = base64Decode(base64String);
      final file = File("${dir.path}/$fileName.pdf");
      await file.writeAsBytes(bytes.buffer.asUint8List());
      AppUtils.showSingleDialogPopup(
          context,
          "Pdf Saved Successfully ${dir.path}",
          "Ok",
          onexitpopup,
          AssetsImageWidget.successimage);
      return dir.path;
    }

    // var bytes = base64Decode(base64String);
    // final output = await getExternalStorageDirectory();
    // final file = File("${output?.path}/HalaEss/$fileName.pdf");
    // await Directory(dirPath).create();
    // print(file);
    // await file.writeAsBytes(bytes.buffer.asUint8List());
    // await OpenFilex.open("${output.path}/$fileName.pdf");
  }

  Future<void> saveFile(
    String fileName,
  ) async {
    var file = File(fileUrl);

    // Platform.isIOS comes from dart:io
    if (Platform.isIOS) {
      final dir = await getApplicationDocumentsDirectory();
      file = File('${dir.path}/$fileName');
    }
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        status = await Permission.storage.request();
      }
      if (status.isGranted) {
        print('Downloaded');
        const downloadsFolderPath = '/storage/emulated/0/Download/';
        Directory dir = Directory(downloadsFolderPath);
        file = File('${dir.path}/$fileName');
      }
    }
  }
}
