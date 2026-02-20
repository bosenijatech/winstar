import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:powergroupess/models/approveleavemodel.dart';
import 'package:powergroupess/models/filemodel.dart';
import 'package:powergroupess/services/apiservice.dart';
import 'package:powergroupess/services/pref.dart';
import 'package:powergroupess/utils/app_utils.dart';
import 'package:powergroupess/utils/appcolor.dart';
import 'package:powergroupess/utils/constants.dart';
import 'package:powergroupess/utils/sharedprefconstants.dart';
import 'package:powergroupess/views/widgets/assets_image_widget.dart';
import 'package:powergroupess/views/widgets/custom_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class DutyResumption extends StatefulWidget {
  ViewLeaveApproveModel model;
  int position = 0;
  DutyResumption({super.key, required this.model, required this.position});

  @override
  State<DutyResumption> createState() => _DutyResumptionState();
}

TextEditingController _resumptiondatecontroller = TextEditingController();
TextEditingController _actualresumptiondatecontroller = TextEditingController();
TextEditingController _tempresumptiondatecontroller = TextEditingController();
TextEditingController _tempactualresumptiondatecontroller =
    TextEditingController();
TextEditingController _reasoncontroller = TextEditingController();
TextEditingController _totalnoofdayscontroller = TextEditingController();
TextEditingController _attachcontroller = TextEditingController();
int noofdays = 0;
String isLeaveExtended = "No";

class _DutyResumptionState extends State<DutyResumption>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 4));
  bool loading = false;
  bool isworkResume = false;
  bool isresumptionisdone = false;
  List<AttachModel> attachlist = [];
  final picker = ImagePicker();
  File? imagefile;

  String attachmentID = "";
  String attachmentURL = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            icon: const Icon(CupertinoIcons.back, color: Colors.black),
            onPressed: () {
              clearvalus();
              Navigator.of(context).pop();
            }),
        title: AppUtils.buildNormalText(
            text: "Duty Resumption", color: Colors.black, fontSize: 20),
        centerTitle: true,
      ),
      body: !loading
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [headerLayout(), buildlayout()],
              ),
            )
          : const Center(
              child: CupertinoActivityIndicator(
                  radius: 30.0, color: Color.fromARGB(255, 14, 14, 17)),
            ),
      persistentFooterButtons: [
        CustomButton(
          onPressed: () {
            if (_resumptiondatecontroller.text.isEmpty) {
              AppUtils.showSingleDialogPopup(
                  context,
                  "Date Should not Left Empty!",
                  "OK",
                  onexitpopup,
                  AssetsImageWidget.warningimage);
            } else if (_actualresumptiondatecontroller.text.isEmpty) {
              AppUtils.showSingleDialogPopup(
                  context,
                  "Actual Date Should not Left Empty!",
                  "OK",
                  onexitpopup,
                  AssetsImageWidget.warningimage);
            } else if (attachmentID.isNotEmpty && attachmentURL.isNotEmpty) {
              onpostdutyresumption();
            } else if (attachlist.isEmpty) {
              onpostdutyresumption();
            } else {
              onupload();
            }
          },
          name: "Submit",
          circularvalue: 30,
          fontSize: 16,
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    _resumptiondatecontroller.dispose();
    _actualresumptiondatecontroller.dispose();
    _tempresumptiondatecontroller.dispose();
    _tempactualresumptiondatecontroller.dispose();
    _reasoncontroller.dispose();
    _totalnoofdayscontroller.dispose();
    _attachcontroller.dispose();
    loading = false;
  }

  clearvalus() {
    _resumptiondatecontroller.dispose();
    _actualresumptiondatecontroller.dispose();
  }

  void pickerdate(controller, type) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.parse(
            "${widget.model.message![widget.position].todate.toString()} 00:00:00"),
        // firstDate: DateTime.parse(
        //     "${widget.model.message![widget.position].todate.toString()} 00:00:00"), //.subtract(Duration(days: 1)),
        firstDate: DateTime.parse(
            "${widget.model.message![widget.position].todate.toString()} 00:00:00"),
        lastDate: DateTime(2100));

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

      var dateFormate =
          DateFormat("dd/MM/yyyy").format(DateTime.parse(formattedDate));

      controller.text = dateFormate;

      if (type == "1") {
        _tempresumptiondatecontroller.text = formattedDate;
      } else {
        _tempactualresumptiondatecontroller.text = formattedDate;
      }
      if (_tempresumptiondatecontroller.text.isNotEmpty &&
          _tempactualresumptiondatecontroller.text.isNotEmpty) {
        validatedate(_tempresumptiondatecontroller.text.isNotEmpty,
            _tempactualresumptiondatecontroller.text);
      }
    }
  }

  Widget headerLayout() {
    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppUtils.buildNormalText(text: "Internal ID ", fontSize: 14),
                AppUtils.buildNormalText(
                    text: widget.model.message![widget.position].intenalId,
                    fontSize: 14),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppUtils.buildNormalText(text: "Leave Type", fontSize: 14),
                AppUtils.buildNormalText(
                    text: widget.model.message![widget.position].leavetypename,
                    fontSize: 14),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppUtils.buildNormalText(
                    text: "Total No.of.Days", fontSize: 14),
                AppUtils.buildNormalText(
                    text: widget.model.message![widget.position].totalNoOfDays
                        .toString(),
                    fontSize: 14)
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppUtils.buildNormalText(text: "Leave Balance", fontSize: 14),
                AppUtils.buildNormalText(
                    text: widget.model.message![widget.position].leavebalance
                        .toString(),
                    fontSize: 14)
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppUtils.buildNormalText(text: "From Date", fontSize: 14),
                AppUtils.buildNormalText(text: "To Date", fontSize: 14)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppUtils.buildNormalText(
                    text: widget.model.message![widget.position].fromdate
                        .toString(),
                    fontSize: 14),
                AppUtils.buildNormalText(
                    text: widget.model.message![widget.position].todate
                        .toString(),
                    fontSize: 14)
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppUtils.buildNormalText(text: "Leave Reason", fontSize: 14),
                AppUtils.buildNormalText(
                    text: widget.model.message![widget.position].reason
                        .toString(),
                    fontSize: 14)
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildlayout() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          AppUtils.buildNormalText(text: "Expected Resume Back Date"),
          const SizedBox(height: 5),
          TextFormField(
            readOnly: true,
            controller: _resumptiondatecontroller,
            keyboardType: TextInputType.multiline,
            maxLines: 1,
            onTap: () {
              // FocusScope.of(context).requestFocus(FocusNode());
              // showDemoDialog(context: context);
              pickerdate(_resumptiondatecontroller, "1");
            },
            decoration: InputDecoration(
              hintText: "Date",
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.grey)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide:
                      const BorderSide(color: Colors.black26, width: 1)),
            ),
          ),
          const SizedBox(height: 10),
          CheckboxListTile(
              dense: true,
              contentPadding: const EdgeInsets.all(0),
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('Work Resume?'),
              autofocus: false,
              activeColor: Colors.black,
              checkColor: Colors.white,
              selected: isworkResume,
              value: isworkResume,
              onChanged: (value) {
                setState(() {
                  isworkResume = value!;
                  print(isworkResume);
                });
              }),
          AppUtils.buildNormalText(text: "Is Leave Extended?", fontSize: 14),
          const SizedBox(
            height: 10,
          ),
          DropdownSearch<String>(
            popupProps: const PopupProps.menu(
              showSearchBox: true,
              showSelectedItems: true,
            ),
            items: const ['Yes', 'No'],
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                hintText: '',
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
              setState(() {
                isLeaveExtended = val.toString();
              });
            },
            selectedItem: isLeaveExtended,
          ),
          const SizedBox(
            height: 10,
          ),
          Visibility(
              visible: isLeaveExtended.toString() == "Yes" ? true : false,
              child:
                  AppUtils.buildNormalText(text: "Actual Work Resume date?")),
          const SizedBox(height: 5),
          Visibility(
            visible: isLeaveExtended.toString() == "Yes" ? true : false,
            child: TextFormField(
              readOnly: true,
              controller: _actualresumptiondatecontroller,
              keyboardType: TextInputType.multiline,
              maxLines: 1,
              onTap: () {
                // FocusScope.of(context).requestFocus(FocusNode());
                // showDemoDialog(context: context);
                pickerdate(_actualresumptiondatecontroller, "2");
              },
              decoration: InputDecoration(
                hintText: "Date",
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.grey)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.black26, width: 1),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Visibility(
              visible: isLeaveExtended.toString() == "Yes" ? true : false,
              child: AppUtils.buildNormalText(text: "No of Days")),
          const SizedBox(height: 5),
          Visibility(
            visible: isLeaveExtended.toString() == "Yes" ? true : false,
            child: TextFormField(
              readOnly: true,
              controller: _totalnoofdayscontroller,
              keyboardType: TextInputType.multiline,
              maxLines: 1,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                hintText: "No Of Days",
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.grey)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.black26, width: 1),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          CheckboxListTile(
              dense: true,
              contentPadding: const EdgeInsets.all(0),
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('Work Resumption Done?'),
              autofocus: false,
              activeColor: Colors.black,
              checkColor: Colors.white,
              selected: isresumptionisdone,
              value: isresumptionisdone,
              onChanged: (value) {
                setState(() {
                  isresumptionisdone = value!;
                  print(isresumptionisdone);
                });
              }),
          const SizedBox(
            height: 10,
          ),
          AppUtils.buildNormalText(text: "Attachment", fontSize: 14),
          const SizedBox(
            height: 5,
          ),
          TextField(
            readOnly: true,
            controller: _attachcontroller,
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
      _attachcontroller.text = pickedFile.path.toString().split("/").last;
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
          _attachcontroller.text = file0.path;
          final bytes = File(file0.path).readAsBytesSync();
          file64 = base64Encode(bytes);
        } else {
          //Image
          _attachcontroller.text = file0.path.toString();
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

  void validatedate(from, to) {
    if (from.toString().isNotEmpty && to.toString().isNotEmpty) {
      String concatefrom = '${_tempresumptiondatecontroller.text} 00:00:00';
      String concateto = '${_tempactualresumptiondatecontroller.text} 00:00:00';

      DateTime dt1 = DateTime.parse(concatefrom);
      DateTime dt2 = DateTime.parse(concateto);

      Duration diff = dt2.difference(dt1);

      if (diff.inDays >= 0) {
        setState(() {
          noofdays = diff.inDays;
          _totalnoofdayscontroller.text = noofdays.toString();
        });
      } else {
        _tempresumptiondatecontroller.clear();
        _tempactualresumptiondatecontroller.clear();
        _resumptiondatecontroller.clear();
        _actualresumptiondatecontroller.clear();
        AppUtils.showSingleDialogPopup(
            context,
            'From date and To Date is Mismatched!',
            "Ok",
            onexitpopup,
            AssetsImageWidget.errorimage);
      }
    } else {}
  }

  void onpostdutyresumption() async {
    DateTime now = DateTime.now();
    DateTime currentyear = DateTime(now.year);

    var json = {
      "Leaveinternalid": widget.model.message![widget.position].intenalId,
      "date": ApiService.mobilecurrentdate,
      "employeenumber": Prefs.getNsID(
        SharefprefConstants.sharednsid,
      ),
      "employeename": Prefs.getFirstName(
        SharefprefConstants.shareFirstName,
      ),
      "designation": Prefs.getDesignation(
        SharefprefConstants.shareddesignation,
      ),
      "location": "",
      "dept": Prefs.getDept(
        SharefprefConstants.shareddept,
      ),
      "resumptiondate": _resumptiondatecontroller.text.toString(),
      "actualresumptiondate": _actualresumptiondatecontroller.text.toString(),
      "expectedResumeBackDate": _resumptiondatecontroller.text,
      "workResume": isworkResume == true ? "Yes" : "No",
      "isLeaveExtended": isLeaveExtended,
      "actualWorkResumeDate": _actualresumptiondatecontroller.text,
      "actualTotalResumeDelayDays": _totalnoofdayscontroller.text,
      "workResumptionDone": isresumptionisdone == true ? "Yes" : "No",
      "createdby": Prefs.getNsID('nsid'),
      "createdbyName": Prefs.getFullName('Name'),
      "createdDate": ApiService.mobilecurrentdate,
      "Source": "Mob",
      "leaveType": widget.model.message![widget.position].leavetypecode,
      attachmentURL.isEmpty ? "" : "attachmentURL": attachmentURL,
      attachmentID.isEmpty ? "" : "attachmentID": attachmentID
    };
    print(jsonEncode(json));
    setState(() {
      loading = true;
    });
    ApiService.onpostdutyresumption(json).then((response) {
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

  dateTimeFormet(date) {
    return DateFormat('dd-MM-yyyy').format(date); // you can set your formet
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
    ApiService.postattachment(body).then((response) {
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString() == "true") {
          attachmentID = jsonDecode(response.body)['fileId'].toString();
          attachmentURL = jsonDecode(response.body)['url'].toString();
          attachlist[0].fileData = attachmentID;
          onpostdutyresumption();
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
