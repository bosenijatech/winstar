import 'dart:math';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:powergroupess/models/error_model.dart';
import 'package:powergroupess/models/filemodel.dart';
import 'package:powergroupess/models/netsuiteLeavetypeModel.dart';
import 'package:powergroupess/services/apiservice.dart';
import 'package:powergroupess/services/pref.dart';
import 'package:powergroupess/utils/api_details.dart';
import 'package:powergroupess/utils/app_utils.dart';
import 'package:powergroupess/utils/appcolor.dart';
import 'package:powergroupess/utils/constants.dart';
import 'package:powergroupess/utils/netsuite/netsuiteservice.dart';
import 'package:powergroupess/utils/sharedprefconstants.dart';
import 'package:powergroupess/views/widgets/assets_image_widget.dart';
import 'package:powergroupess/views/widgets/custom_button.dart';
import 'package:powergroupess/views/widgets/custom_daterange_picker.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer' as log;

class LeaveApplyPage extends StatefulWidget {
  const LeaveApplyPage({super.key});

  @override
  State<LeaveApplyPage> createState() => _LeaveApplyPageState();
}

class _LeaveApplyPageState extends State<LeaveApplyPage> {
  //late List<String> listvalue = <String>['One', 'Two', 'Three', 'Four'];
  //LeaveTypeModel leaveTypeModel = LeaveTypeModel();

  NetSuiteLeaveTypeModel netSuiteLeaveTypeModel = NetSuiteLeaveTypeModel();
  int? noofdays = 0;
  bool? check1 = false;
  bool loading = false;
  ErrorModelNetSuite errormodel = ErrorModelNetSuite();

  List<String> leavetypelist = [];

  String? alterleavetypecode = "";
  String? alterleavetypename = "";
  double? balancetakenleave = 0;
  String? isairticketrequired = "No";

  DateFormat customdateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  TextEditingController frmdatecontroller = TextEditingController();
  TextEditingController todatecontroller = TextEditingController();

  TextEditingController subfrmdatecontroller = TextEditingController();
  TextEditingController subtodatecontroller = TextEditingController();

  TextEditingController attachcontroller = TextEditingController();
  TextEditingController airticketamountcontroller = TextEditingController();
  TextEditingController reasoncontroller = TextEditingController();
  TextEditingController airticketattachmentcontroller = TextEditingController();

  String? selectedValue;
  final TextEditingController textEditingController = TextEditingController();
  final picker = ImagePicker();
  File? imagefile;
  int? selection = 0;

  DateTime? startDate;
  DateTime? endDate;
  List<AttachModel> attachlist = [];

  String attachmentID = "";
  String attachmentURL = "";

  @override
  void initState() {
    getdetailsdata();
    // fetchWooProducts();
    //getToken();
    super.initState();
  }

  @override
  void dispose() {
    frmdatecontroller.clear();
    textEditingController.clear();
    todatecontroller.clear();
    attachcontroller.clear();
    subfrmdatecontroller.clear();
    subtodatecontroller.clear();
    airticketamountcontroller.clear();
    airticketattachmentcontroller.clear();
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
            text: "Leave Application", color: Colors.black, fontSize: 16),
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
                  radius: 30.0, color: Appcolor.black),
            ),
    );
  }

  Widget selectiondateWidget() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () {
              setState(() {
                selection = 1;
                getcurrentdate();
              });
            },
            style: ButtonStyle(
              backgroundColor: selection == 1
                  ? WidgetStateProperty.all<Color>(Appcolor.black)
                  : WidgetStateProperty.all<Color>(Colors.grey),
              foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
            ),
            child: const Text("Today"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                selection = 2;
                getcurrentdate();
              });
            },
            style: ButtonStyle(
              backgroundColor: selection == 2
                  ? WidgetStateProperty.all<Color>(Appcolor.black)
                  : WidgetStateProperty.all<Color>(Colors.grey),
              foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
            ),
            child: const Text("Tomorrow"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                selection = 3;
                frmdatecontroller.text = "";
                todatecontroller.text = "";
                subfrmdatecontroller.text = "";
                subtodatecontroller.text = "";
                noofdays = 0;
                showdaterange();
              });
            },
            style: ButtonStyle(
              backgroundColor: selection == 3
                  ? WidgetStateProperty.all<Color>(Appcolor.black)
                  : WidgetStateProperty.all<Color>(Colors.grey),
              foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
            ),
            child: const Text("Select Dates"),
          ),
        ],
      ),
    );
  }

  getcurrentdate() {
    if (selection == 1) {
      frmdatecontroller.text = "";
      todatecontroller.text = "";
      subfrmdatecontroller.text = "";
      subtodatecontroller.text = "";

      String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      var dateFormate =
          DateFormat("dd-MM-yyyy").format(DateTime.parse(formattedDate));
      frmdatecontroller.text = dateFormate;
      subfrmdatecontroller.text = formattedDate;

      todatecontroller.text = dateFormate;
      subtodatecontroller.text = formattedDate;

      print(frmdatecontroller.text);
      validatedate(subfrmdatecontroller.text, subtodatecontroller.text);
    } else if (selection == 2) {
      frmdatecontroller.text = "";
      todatecontroller.text = "";
      subfrmdatecontroller.text = "";
      subtodatecontroller.text = "";
      String formattedDate = DateFormat('yyyy-MM-dd')
          .format(DateTime.now().add(const Duration(days: 1)));
      var dateFormate =
          DateFormat("dd-MM-yyyy").format(DateTime.parse(formattedDate));

      frmdatecontroller.text = dateFormate;
      subfrmdatecontroller.text = formattedDate;

      todatecontroller.text = dateFormate;
      subtodatecontroller.text = formattedDate;
      validatedate(subfrmdatecontroller.text, subtodatecontroller.text);
    } else {
      frmdatecontroller.text = "";
      todatecontroller.text = "";
      subfrmdatecontroller.text = "";
      subtodatecontroller.text = "";
    }
  }

  Widget getdetails() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          selectiondateWidget(),
          const SizedBox(
            height: 10,
          ),
          AppUtils.buildNormalText(text: "LEAVE TYPE"),
          const SizedBox(height: 5),
          DropdownSearch<String>(
            popupProps: const PopupProps.menu(
              showSearchBox: true,
              showSelectedItems: true,
            ),
            items: leavetypelist,
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                labelText: '',
                hintText: 'Select leave *',
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
              for (int kk = 0;
                  kk < netSuiteLeaveTypeModel.records!.length;
                  kk++) {
                if (netSuiteLeaveTypeModel.records![kk].leaveType.toString() ==
                    val) {
                  alterleavetypecode = netSuiteLeaveTypeModel
                      .records![kk].leaveTypeId
                      .toString();
                  alterleavetypename =
                      netSuiteLeaveTypeModel.records![kk].leaveType.toString();
                  balancetakenleave = netSuiteLeaveTypeModel
                          .records![kk].availableLeaveBalance
                          .toString()
                          .isNotEmpty
                      ? double.parse(netSuiteLeaveTypeModel
                          .records![kk].availableLeaveBalance
                          .toString())
                      : 0;
                  isairticketrequired = "N";
                  setState(() {});
                }
              }
            },
            selectedItem: selectedValue,
          ),
          const SizedBox(
            height: 10,
          ),
          Align(
              alignment: Alignment.centerRight,
              child: AppUtils.buildNormalText(
                  text:
                      '${balancetakenleave!.toStringAsFixed(2).toString()} days Available',
                  fontSize: 14,
                  color:
                      balancetakenleave! > 0 ? Colors.green : Colors.redAccent,
                  fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 10,
          ),
          Visibility(
            visible: selection == 0 ? false : true,
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: TextField(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate:
                              DateTime.now(), //.subtract(Duration(days: 1)),
                          lastDate: DateTime(2100));

                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);

                        var dateFormate = DateFormat("dd-MM-yyyy")
                            .format(DateTime.parse(formattedDate));

                        frmdatecontroller.text = dateFormate;

                        subfrmdatecontroller.text = formattedDate;
                        validatedate(subfrmdatecontroller.text,
                            subtodatecontroller.text);
                      }
                    },
                    controller: frmdatecontroller,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'START DATE ',
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                    flex: 2,
                    child: Container(
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          color: Appcolor.primarycolor,
                          border: Border.all(),
                        ),
                        child: Center(
                          child: AppUtils.buildNormalText(
                              text: '${noofdays.toString()} Days',
                              fontSize: 14,
                              color: Colors.white),
                        ))),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 4,
                  child: TextField(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate:
                              DateTime.now(), //.subtract(Duration(days: 1)),
                          lastDate: DateTime(2100));

                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        var dateFormate = DateFormat("dd-MM-yyyy")
                            .format(DateTime.parse(formattedDate));
                        todatecontroller.text = dateFormate;
                        subtodatecontroller.text = formattedDate;
                        validatedate(subfrmdatecontroller.text,
                            subtodatecontroller.text);
                      }
                    },
                    readOnly: true,
                    controller: todatecontroller,
                    decoration: const InputDecoration(
                      labelText: 'END DATE',
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          AppUtils.buildNormalText(text: "Leave Reason", fontSize: 15),
          const SizedBox(
            height: 10,
          ),
          Container(
              //padding: EdgeInsets.all(20),
              child: TextField(
            controller: reasoncontroller,
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Enter Reason",
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.grey)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.black26, width: 1),
              ),
            ),
          )),
          const SizedBox(height: 20),
          AppUtils.buildNormalText(text: "Attachment", fontSize: 15),
          const SizedBox(
            height: 10,
          ),
          TextField(
            readOnly: true,
            controller: attachcontroller,
            decoration: InputDecoration(
              border: const UnderlineInputBorder(),
              hintText: "Click here to Attach file (file Size Max 2 MB)",
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.attach_file,
                  color: Colors.black,
                ),
                onPressed: () async {
                  Map<Permission, PermissionStatus> statuses = await [
                    Permission.camera,
                  ].request();
                  statuses.values.forEach((element) async {
                    if (element.isDenied || element.isPermanentlyDenied) {
                      await openAppSettings();
                    }
                  });
                  AppUtils.showBottomCupertinoDialog(context,
                      title: "Choose any one option", btn1function: () async {
                    AppUtils.pop(context);
                    //getImageFromCamera(attachcontroller);
                    getImageFromCamera();
                  }, btn2function: () {
                    AppUtils.pop(context);
                    _pickFile();
                  });
                },
              ),
            ),
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(
            height: 30,
          ),
          Visibility(
            visible: isairticketrequired.toString() == "Yes" ? true : false,
            child: Column(
              children: [
                AppUtils.buildNormalText(
                    text: "AirTicket Details",
                    fontSize: 20,
                    color: Appcolor.twitterBlue),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Transform.scale(
                        scale: 1.5,
                        child: Checkbox(
                          fillColor:
                              WidgetStateProperty.all(Appcolor.twitterBlue),
                          checkColor: Colors.white,
                          value: check1,
                          shape: const CircleBorder(),
                          onChanged: (bool? value) {
                            setState(() {
                              check1 = value!;
                            });
                          },
                        )),
                    AppUtils.buildNormalText(
                        text: "Air Ticket Required", fontSize: 15),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                    controller: airticketamountcontroller,
                    decoration: const InputDecoration(
                      labelText: 'Air Ticket Amount ',
                    ),
                    keyboardType: TextInputType.number),
                const SizedBox(height: 20),
                TextField(
                  readOnly: true,
                  controller: airticketattachmentcontroller,
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    hintText:
                        "Click here to Air Ticket Attach file(file Size Max 2 MB)",
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.attach_file_sharp,
                        color: Colors.black,
                      ),
                      onPressed: () async {
                        Map<Permission, PermissionStatus> statuses = await [
                          Permission.camera,
                        ].request();
                        statuses.values.forEach((element) async {
                          if (element.isDenied || element.isPermanentlyDenied) {
                            await openAppSettings();
                          }
                        });
                        AppUtils.showBottomCupertinoDialog(context,
                            title: "Choose any one option",
                            btn1function: () async {
                          AppUtils.pop(context);
                          // getImageFromCameraAirticket(
                          //     airticketattachmentcontroller);
                        }, btn2function: () {
                          AppUtils.pop(context);
                          // pickFilesairticket(airticketattachmentcontroller);
                        });
                      },
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          CustomButton(
            onPressed: () {
              if (alterleavetypecode!.isEmpty) {
                AppUtils.showSingleDialogPopup(
                    context,
                    "Please Select Leave Type",
                    "Ok",
                    onexitpopup,
                    AssetsImageWidget.warningimage);
              } else if (alterleavetypename.toString() == "Sick Leave" &&
                  noofdays! >= 2 &&
                  attachlist.isEmpty) {
                AppUtils.showSingleDialogPopup(
                    context,
                    "While apply Sick Leave More than 2 two days Attchment is Mandatory!",
                    "Ok",
                    onexitpopup,
                    AssetsImageWidget.warningimage);
              } else if (attachlist.isEmpty) {
                attachlist.clear();
                onpostleave();
              } else {
                onupload();
              }
            },
            name: "Submit",
            circularvalue: 30,
            fontSize: 14,
          )
        ],
      ),
    );
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      imagefile = File(pickedFile.path);

      final bytes = imagefile!.readAsBytesSync().lengthInBytes;
      final kb = bytes / 1024;
      final mb = kb / 1024;

      Random random = Random();
      int randomnumber = random.nextInt(100);

      File imageFile = File(pickedFile.path);

      Uint8List bytes0 = await imageFile.readAsBytes();
      String base64String = base64Encode(bytes0);
      attachcontroller.text = pickedFile.path.toString().split("/").last;
      attachlist.clear();
      print(AppConstants.getFileTypeExtension(pickedFile.path.toString()));
      attachlist.add(AttachModel(
          randomnumber.toString(),
          base64String,
          AppConstants.getFileTypeExtension(pickedFile.path.toString()) ==
                  ".jpg"
              ? "jpg"
              : AppConstants.getFileTypeExtension(pickedFile.path.toString()) ==
                      ".jpeg"
                  ? "jpeg"
                  : AppConstants.getFileTypeExtension(
                      pickedFile.path.toString()),
          pickedFile.path.toString().split("/").last,
          mb.toStringAsFixed(3).toString()));

      setState(() {});
    } else {
      attachlist.clear();
      print('No image selected.');
    }
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      withData: true,
      allowMultiple: false,
      allowCompression: true,
      allowedExtensions: [
        'png',
        'jpg',
        'jpeg',
        'pdf',
        // 'doc',
        // 'docx',
        // 'xls',
      ],
    );
    Random random = Random();
    int randomnumber = random.nextInt(100);
    if (result != null && result.files.single.path != null) {
      PlatformFile file = result.files.first;

      File file0 = File(result.files.single.path!);
      String file64 = "";
      setState(() async {
        if (file.extension.toString() == "pdf") {
          attachcontroller.text = file0.path;
          final bytes = File(file0.path).readAsBytesSync();
          file64 = base64Encode(bytes);
        } else {
          //Image
          attachcontroller.text = file0.path.toString();
          Uint8List bytes0 = await file0.readAsBytes();
          file64 = base64Encode(bytes0);
        }

        attachlist.clear();
        // print(file.name);
        // print(file64);
        // print(file.size);
        // print(file.extension);
        // print(file.path);

        attachlist.add(AttachModel(randomnumber.toString(), file64,
            file.extension, file.name, file.size.toString()));
      });
    } else {
      /// User canceled the picker
    }
  }

  void showdaterange() {
    showCustomDateRangePicker(
      context,
      dismissible: true,
      minimumDate: DateTime.now(),
      maximumDate: DateTime.now().add(const Duration(days: 90)),
      endDate: endDate,
      startDate: startDate,
      backgroundColor: Colors.white,
      primaryColor: Appcolor.black,
      onApplyClick: (start, end) {
        setState(() {
          endDate = end;
          startDate = start;
          frmdatecontroller.text = "";
          todatecontroller.text = "";
          subfrmdatecontroller.text = "";
          subtodatecontroller.text = "";

          String formattedDate = DateFormat('yyyy-MM-dd').format(start);
          var dateFormate =
              DateFormat("dd-MM-yyyy").format(DateTime.parse(formattedDate));
          frmdatecontroller.text = dateFormate;
          subfrmdatecontroller.text = formattedDate;

          String formattedDate1 = DateFormat('yyyy-MM-dd').format(end);
          var dateFormate1 =
              DateFormat("dd-MM-yyyy").format(DateTime.parse(formattedDate1));
          todatecontroller.text = dateFormate1;
          subtodatecontroller.text = formattedDate1;
          validatedate(subfrmdatecontroller.text, subtodatecontroller.text);
          setState(() {
            selection = 3;
          });
        });
      },
      onCancelClick: () {
        setState(() {
          endDate = null;
          startDate = null;
        });
      },
    );
  }

  void validatedate(from, to) {
    if (from.toString().isNotEmpty && to.toString().isNotEmpty) {
      String concatefrom = '${subfrmdatecontroller.text} 00:00:00';
      String concateto = '${subtodatecontroller.text} 00:00:00';

      DateTime dt1 = DateTime.parse(concatefrom);
      DateTime dt2 = DateTime.parse(concateto);

      Duration diff = dt2.difference(dt1);

      if (diff.inDays >= 0) {
        setState(() {
          noofdays = diff.inDays + 1;
        });
      } else {
        frmdatecontroller.clear();
        todatecontroller.clear();
        AppUtils.showSingleDialogPopup(
            context,
            'From date and To Date is Mismatched!',
            "Ok",
            onexitpopup,
            AssetsImageWidget.errorimage);
      }
    } else {}
  }

  getdetailsdata() async {
    setState(() {
      loading = true;
    });
    try {
      Uri baseUri = Uri.parse(
          '${AppConstants.netSuiteapiBaseUrl}script=${AppConstants.leavescriptid}&deploy=${AppConstants.leavedeployid}&empId=${Prefs.getNsID(SharefprefConstants.sharednsid)}');
      await NetSuiteApiService.client.get(baseUri).then((response) {
        setState(() {
          loading = false;
        });
        leavetypelist.clear();

        if (response.statusCode == 200) {
          netSuiteLeaveTypeModel = NetSuiteLeaveTypeModel.fromJson(
              jsonDecode(json.decode(response.body)));

          for (var element in netSuiteLeaveTypeModel.records!) {
            leavetypelist.add(element.leaveType.toString());
          }
        } else {
          errormodel = ErrorModelNetSuite.fromJson(jsonDecode(response.body));
          throw Exception(errormodel.error!.message);
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

  void onupload() async {
    var body = {
      "attachment": [
        {
          "FileData": attachlist[0].fileData.toString(),
          "FileType": attachlist[0].fileType.toString(),
          "FileName": attachlist[0].fileName.toString()
        }
      ]
    };
    setState(() {
      loading = true;
    });
    log.log(jsonEncode(body));
    ApiService.postattachment(body).then((response) {
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString() == "true") {
          attachmentID = jsonDecode(response.body)['fileId'].toString();
          attachmentURL = jsonDecode(response.body)['url'].toString();
          attachlist[0].fileData = attachmentID;
          onpostleave();
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

  void onpostleave() async {
    DateTime now = DateTime.now();
    //DateTime currentyear = DateTime(now.year);
    var currentyear = DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now());
    var json = {
      "leaveapplicationno":
          "${"Mob"}-Leave-${Prefs.getEmpID('empID').toString()}-$currentyear",
      "date": ApiService.mobilecurrentdate,
      "leavetypecode": alterleavetypecode,
      "leavetypename": alterleavetypename,
      "leavebalance": balancetakenleave,
      "fromdate": subfrmdatecontroller.text,
      "todate": subtodatecontroller.text,
      "total_no_of_days": noofdays ?? 0,
      "attachment": attachlist.isEmpty ? "" : attachlist,
      "reason": reasoncontroller.text,
      "airticketrequired": isairticketrequired,
      "airticketamount": airticketamountcontroller.text.isEmpty
          ? 0
          : airticketamountcontroller.text,
      "airticketattachment": airticketattachmentcontroller.text.isEmpty
          ? ""
          : 'public/${attachcontroller.text.toString()}',
      "iscancelled": "N",
      "iscancelledreason": "",
      "iscancelleddate": "",
      "isstatus": "Pending",
      "createdby": Prefs.getNsID('nsid'),
      "createdByEmpName": Prefs.getFullName('Name'),
      "createdDate": ApiService.mobilecurrentdate,
      "toEmpID": Prefs.getNsID('nsid'),
      "toEmpCode": Prefs.getEmpID(
        SharefprefConstants.sharedempId,
      ),
      "toEmpName": Prefs.getFullName('Name'),
      "isSync": 0,
      "NetsuiteRefNo": "",
      "NetsuiteRemarks": "",
      "Source": "Mob",
      "attachDocument": attachlist.isEmpty ? "F" : "T",
      "imageUrl": attachmentURL
    };
    log.log('data: ${jsonEncode(json)}');
    setState(() {
      loading = true;
    });
    ApiService.postleave(json).then((response) {
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
}
