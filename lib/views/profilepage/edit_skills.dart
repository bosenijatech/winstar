import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:powergroupess/models/empinfomodel.dart';
import 'package:powergroupess/models/filemodel.dart';
import 'package:powergroupess/services/apiservice.dart';
import 'package:powergroupess/services/pref.dart';
import 'package:powergroupess/utils/api_details.dart';
import 'package:powergroupess/utils/app_utils.dart';
import 'package:powergroupess/utils/appcolor.dart';
import 'package:powergroupess/utils/constants.dart';
import 'package:powergroupess/utils/custom_indicatoronly.dart';
import 'package:powergroupess/utils/netsuite/netsuiteservice.dart';
import 'package:powergroupess/utils/sharedprefconstants.dart';
import 'package:powergroupess/views/profilepage/empskillsmodel.dart';
import 'package:powergroupess/views/widgets/assets_image_widget.dart';
import 'package:powergroupess/views/widgets/custom_button.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class EditSkills extends StatefulWidget {
  final EmpInfoModel model;
  final bool? iseditable;
  final int? position;
  const EditSkills(
      {super.key,
      required this.model,
      required this.iseditable,
      required this.position});

  @override
  State<EditSkills> createState() => _EditSkillsState();
}

class _EditSkillsState extends State<EditSkills> {
  TextEditingController skillnamecontroller = TextEditingController();
  TextEditingController skillexpcontroller = TextEditingController();
  TextEditingController skillcertificatecontroller = TextEditingController();
  bool loading = false;
  EMpSkillsModel eMpSkillsModel = EMpSkillsModel();
  List<String> skillsist = [];
  String getskillsname = "";
  String getyearofexp = "";
  String getskillcode = "";

  List<AttachModel> attachlist = [];
  String attachmentID = "";
  String attachmentURL = "";

  final picker = ImagePicker();
  File? imagefile;
  String internalId = "";
  @override
  void initState() {
    if (widget.iseditable == true) {
      internalId = widget
          .model.message!.skill![widget.position!.toInt()].internalid
          .toString();
      getskillsname = widget
          .model.message!.skill![widget.position!.toInt()].skillName
          .toString();
      getskillcode = widget
          .model.message!.skill![widget.position!.toInt()].skillCode
          .toString();

      skillcertificatecontroller.text = widget
          .model.message!.skill![widget.position!.toInt()].skillCertificate
          .toString();
      skillexpcontroller.text = widget
          .model.message!.skill![widget.position!.toInt()].skillexperience
          .toString();
      attachmentURL = widget
          .model.message!.skill![widget.position!.toInt()].skillCertificate
          .toString();
      attachmentID = widget
          .model.message!.skill![widget.position!.toInt()].skillCertificateID
          .toString();
    } else {
      skillnamecontroller.text = "";
      skillcertificatecontroller.text = "";
      skillexpcontroller.text = "";
    }
    getskills();
    super.initState();
  }

  @override
  void dispose() {
    skillnamecontroller.clear();
    skillcertificatecontroller.clear();
    skillexpcontroller.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.clear, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: AppUtils.buildNormalText(
            text: "Skills", color: Colors.white, fontSize: 20),
        centerTitle: true,
      ),
      body: !loading
          ? SingleChildScrollView(
              child: Column(
                children: [getwidget()],
              ),
            )
          : const Center(
              child: CustomIndicator(),
            ),
    );
  }

  Widget getwidget() {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(children: [
        Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                DropdownSearch<String>(
                  popupProps: const PopupProps.menu(
                    showSearchBox: true,
                    showSelectedItems: true,
                  ),
                  items: skillsist,
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                        icon: Icon(Icons.school),
                        hintText: "Select Skills",
                        label: Text("Select Skills")),
                  ),
                  onChanged: (val) {
                    for (int kk = 0;
                        kk < eMpSkillsModel.records!.length;
                        kk++) {
                      if (eMpSkillsModel.records![kk].skillName.toString() ==
                          val) {
                        getskillsname =
                            eMpSkillsModel.records![kk].skillName.toString();
                        getskillcode =
                            eMpSkillsModel.records![kk].id.toString();
                        skillexpcontroller.text = getyearofexp;
                        setState(() {});
                      }
                    }
                  },
                  selectedItem: getskillsname,
                ),
                const SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: false,
                  child: TextFormField(
                    controller: skillexpcontroller,
                    maxLength: 100,
                    decoration: const InputDecoration(
                      counterText: '',
                      labelText: 'Year Of Experience',
                      icon: Icon(Icons.message),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true, signed: false),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // TextFormField(
                //   controller: skillcertificatecontroller,
                //   maxLength: 100,
                //   decoration: const InputDecoration(
                //     counterText: '',
                //     labelText: 'CERTIFICATE',
                //     icon: Icon(Icons.message),
                //   ),
                // ),
                // const SizedBox(
                //   height: 10,
                // ),
                TextField(
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true, signed: false),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r"[0-9.]"))
                  ],
                  controller: skillexpcontroller,
                  maxLength: 100,
                  decoration: const InputDecoration(
                    counterText: '',
                    labelText: 'YEAR OF EXPERIENCE',
                    icon: Icon(Icons.message),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  readOnly: true,
                  controller: skillcertificatecontroller,
                  maxLength: 250,
                  decoration: InputDecoration(
                      counterText: '',
                      border: const UnderlineInputBorder(),
                      icon: InkWell(
                          onTap: () {
                            if (widget
                                    .model
                                    .message!
                                    .skill![widget.position!.toInt()]
                                    .skillCertificate
                                    .toString()
                                    .isEmpty ||
                                widget
                                        .model
                                        .message!
                                        .skill![widget.position!.toInt()]
                                        .skillCertificate
                                        .toString() ==
                                    "null") {
                            } else {
                              _launchUrl(
                                  widget
                                      .model
                                      .message!
                                      .skill![widget.position!.toInt()]
                                      .skillCertificate
                                      .toString(),
                                  isNewTab: true);
                            }
                          },
                          child: Icon(Icons.visibility,
                              color: (widget.iseditable == true &&
                                      widget
                                          .model
                                          .message!
                                          .skill![widget.position!.toInt()]
                                          .skillCertificate
                                          .toString()
                                          .isEmpty)
                                  ? Colors.grey.shade300
                                  : Colors.black)),
                      hintText: "Click here to Attach file",
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
                            if (element.isDenied ||
                                element.isPermanentlyDenied) {
                              await openAppSettings();
                            }
                          });
                          AppUtils.showBottomCupertinoDialog(context,
                              title: "Choose any one option",
                              btn1function: () async {
                            AppUtils.pop(context);
                            getImageFromCamera();
                          }, btn2function: () {
                            AppUtils.pop(context);
                            _pickFile();
                          });
                        },
                      )),
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                  onPressed: () {
                    // if (widget.iseditable == true && attachlist.isEmpty) {
                    //   updateskills(widget
                    //       .model.message!.skill![widget.position!.toInt()].sId
                    //       .toString());
                    // } else if (widget.iseditable == true &&
                    //     attachlist.isNotEmpty) {
                    //   uploadfiles(widget
                    //       .model.message!.skill![widget.position!.toInt()].sId
                    //       .toString());
                    // } else {
                    //   if (getskillsname.isEmpty) {
                    //     AppUtils.buildNormalText(
                    //         text: "Please Choose one Skills");
                    //   } else if (skillexpcontroller.text.isEmpty) {
                    //     AppUtils.buildNormalText(
                    //         text: "Please Enter Year Of Experience");
                    //   } else if (skillcertificatecontroller.text.isEmpty) {
                    //     AppUtils.buildNormalText(
                    //         text: "Please Enter Certificate");
                    //   } else if (attachlist.isEmpty) {
                    //     addskills();
                    //   } else if (attachlist.isNotEmpty) {
                    //     uploadfiles("");
                    //   }
                    // }
                    if (getskillcode.isEmpty) {
                      AppUtils.showSingleDialogPopup(
                          context,
                          "Please Choose Skills",
                          "Ok",
                          onexitpopup,
                          AssetsImageWidget.warningimage);
                    } else if (skillexpcontroller.text.isEmpty) {
                      AppUtils.showSingleDialogPopup(
                          context,
                          "Please Enter Experience",
                          "Ok",
                          onexitpopup,
                          AssetsImageWidget.warningimage);
                    } else if (attachlist.isEmpty &&
                        widget.iseditable == true &&
                        internalId.isNotEmpty) {
                      updateskills(widget
                          .model.message!.skill![widget.position!.toInt()].sId
                          .toString());
                    } else if (attachmentID.isNotEmpty &&
                        attachmentURL.isNotEmpty &&
                        internalId.isEmpty) {
                      addskills();
                    } else if (attachlist.isNotEmpty &&
                        widget.iseditable == true &&
                        internalId.isNotEmpty) {
                      uploadfiles(widget
                          .model.message!.skill![widget.position!.toInt()].sId
                          .toString());
                    } else if (widget.iseditable == false &&
                        attachlist.isEmpty &&
                        internalId.isEmpty) {
                      addskills();
                    } else if (widget.iseditable == false &&
                        attachlist.isNotEmpty) {
                      uploadfiles("");
                    }
                  },
                  name: "Submit",
                  circularvalue: 30,
                  fontSize: 14,
                )
              ],
            )),
      ]),
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
      skillcertificatecontroller.text =
          pickedFile.path.toString().split("/").last;
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
          skillcertificatecontroller.text = file0.path;
          final bytes = File(file0.path).readAsBytesSync();
          file64 = base64Encode(bytes);
        } else {
          //Image
          skillcertificatecontroller.text = file0.path.toString();
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

  void pickerdate(controller) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(), //.subtract(Duration(days: 1)),
        lastDate: DateTime(2100));

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

      var dateFormate =
          DateFormat("dd/MM/yyyy").format(DateTime.parse(formattedDate));

      controller.text = dateFormate;
    }
  }

  void uploadfiles(sid) async {
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
          if (widget.iseditable == true) {
            updateskills(sid);
          } else {
            addskills();
          }
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

  void updateskills(String sid) {
    var json = {
      "type": "skill",
      "firstName": Prefs.getFirstName(
        SharefprefConstants.shareFirstName,
      ),
      "middleName": Prefs.getMiddleName(
        SharefprefConstants.shareMiddleName,
      ),
      "lastName": Prefs.getLastName(
        SharefprefConstants.sharedLastName,
      ),
      "_id": sid,
      "internalid": widget
          .model.message!.skill![widget.position!.toInt()].internalid
          .toString(),
      "skillCode": getskillcode,
      "skillName": getskillsname,
      "yearOfExperience": skillexpcontroller.text,
      "attachmentUrl": attachmentURL,
      "attachmentID": attachmentID,
      //"yearOfExperience": skillexpcontroller.text,
    };
    print(jsonEncode(json));
    setState(() {
      loading = true;
    });
    ApiService.updatemaster(json).then((response) {
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString() == "true") {
          Navigator.pop(context);
        } else {
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

  void addskills() {
    var json = {
      "nsId": Prefs.getNsID("nsid"),
      "firstName": Prefs.getFirstName(
        SharefprefConstants.shareFirstName,
      ),
      "middleName": Prefs.getMiddleName(
        SharefprefConstants.shareMiddleName,
      ),
      "lastName": Prefs.getLastName(
        SharefprefConstants.sharedLastName,
      ),
      "type": "skill",
      "skillCode": getskillcode,
      "skillName": getskillsname,
      "yearOfExperience": skillexpcontroller.text,
      "attachmentUrl": attachmentURL,
      "attachmentID": attachmentID
    };
    print(jsonEncode(json));
    setState(() {
      loading = true;
    });
    ApiService.addprofiles(json).then((response) {
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString() == "true") {
          Navigator.pop(context);
        } else {
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

  void getskills() async {
    setState(() {
      loading = true;
    });
    try {
      Uri baseUri = Uri.parse(
          '${AppConstants.netSuiteapiBaseUrl}script=${AppConstants.empskillscriptid}&deploy=${AppConstants.empskilldeployid}');
      await NetSuiteApiService.client.get(baseUri).then((response) {
        setState(() {
          loading = false;
        });
        if (response.statusCode == 200) {
          eMpSkillsModel =
              EMpSkillsModel.fromJson(json.decode(json.decode(response.body)));
          skillsist.clear();
          eMpSkillsModel.records!
              .map((e) => {skillsist.add(e.skillName.toString())});

          for (var v in eMpSkillsModel.records!) {
            skillsist.add(v.skillName.toString());
          }
          print(jsonEncode(skillsist));
        } else {
          AppUtils.showSingleDialogPopup(context,
              json.decode(json.decode(response.body)), "Ok", onexitpopup, null);
        }
      });
    } on Exception catch (_) {
      setState(() {
        loading = false;
      });
      rethrow;
    }
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
