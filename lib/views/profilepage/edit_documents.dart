import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:developer' as log;

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:powergroupess/models/companymodel.dart';
import 'package:powergroupess/models/documentmodel.dart';
import 'package:powergroupess/models/empinfomodel.dart';
import 'package:powergroupess/models/filemodel.dart';
import 'package:powergroupess/services/apiservice.dart';
import 'package:powergroupess/services/pref.dart';
import 'package:powergroupess/utils/app_utils.dart';
import 'package:powergroupess/utils/appcolor.dart';
import 'package:powergroupess/utils/constants.dart';
import 'package:powergroupess/utils/netsuite/netsuiteservice.dart';
import 'package:powergroupess/utils/sharedprefconstants.dart';
import 'package:powergroupess/views/widgets/assets_image_widget.dart';
import 'package:powergroupess/views/widgets/custom_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';

import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class EditDocuments extends StatefulWidget {
  final EmpInfoModel model;
  final bool? iseditable;
  final int? position;
  const EditDocuments(
      {super.key,
      required this.model,
      required this.iseditable,
      required this.position});

  @override
  State<EditDocuments> createState() => _EditDocumentsState();
}

class _EditDocumentsState extends State<EditDocuments> {
  TextEditingController expirydatecontroller = TextEditingController();
  TextEditingController attachmentcontroller = TextEditingController();
  TextEditingController idnumbercontroller = TextEditingController();
  TextEditingController countryissuecontroller = TextEditingController();
  TextEditingController issuedatecontroller = TextEditingController();
  TextEditingController designationcontroller = TextEditingController();
  TextEditingController remarkscontroller = TextEditingController();
  TextEditingController remainderdatecontroller = TextEditingController();

  String? remainderval;

  bool loading = false;
  DocumentModel documentModel = DocumentModel();
  CompanyModel companyModel = CompanyModel();
  final picker = ImagePicker();
  File? imagefile;
  List<String> files = [];
  List<File> filelist = [];
  List<PlatformFile>? _paths;
  List<String> dependentslist = [];
  List<String> companylist = [];
  String getdocumentsname = "";
  String getdocumentid = "";
  List<AttachModel> attachlist = [];
  String attachmentID = "";
  String attachmentURL = "";

  String getcompanyname = "";
  String getcompanyid = "";

  String intenralId = "";
  @override
  void initState() {
    if (widget.iseditable == true) {
      intenralId = widget
          .model.message!.documents![widget.position!.toInt()].internalid
          .toString();

      idnumbercontroller.text = widget
          .model.message!.documents![widget.position!.toInt()].idNo
          .toString();

      countryissuecontroller.text = widget
          .model.message!.documents![widget.position!.toInt()].countryofIssue
          .toString();

      issuedatecontroller.text = widget
          .model.message!.documents![widget.position!.toInt()].issueDate
          .toString();

      expirydatecontroller.text = widget
          .model.message!.documents![widget.position!.toInt()].expiryDate
          .toString();

      designationcontroller.text = widget
          .model.message!.documents![widget.position!.toInt()].designation
          .toString();

      remarkscontroller.text = widget
          .model.message!.documents![widget.position!.toInt()].remarks
          .toString();

      remainderval = widget
          .model.message!.documents![widget.position!.toInt()].remainder
          .toString();

      remainderdatecontroller.text = widget
          .model.message!.documents![widget.position!.toInt()].remainderDate
          .toString();

      attachmentcontroller.text = widget
              .model.message!.documents![widget.position!.toInt()].attachment ??
          "";
      attachmentURL = widget
              .model.message!.documents![widget.position!.toInt()].attachment ??
          "";

      attachmentID = widget.model.message!.documents![widget.position!.toInt()]
              .attachmentID ??
          "";

      getdocumentid = widget
          .model.message!.documents![widget.position!.toInt()].documentNo
          .toString();

      getdocumentsname = widget
          .model.message!.documents![widget.position!.toInt()].documentType
          .toString();
      getcompanyname = widget
          .model.message!.documents![widget.position!.toInt()].companyName
          .toString();
      getcompanyid = widget
          .model.message!.documents![widget.position!.toInt()].companyid
          .toString();
    } else {
      expirydatecontroller.text = "";
      attachmentcontroller.text = "";
      idnumbercontroller.text = "";
      countryissuecontroller.text = "";
      issuedatecontroller.text = "";
      designationcontroller.text = "";
      remarkscontroller.text = "";
      remainderdatecontroller.text = "";
      attachmentURL = "";
    }
    getdocuments();
    getcompanydetails();
    super.initState();
  }

  @override
  void dispose() {
    expirydatecontroller.dispose();
    attachmentcontroller.dispose();
    idnumbercontroller.dispose();
    countryissuecontroller.dispose();
    issuedatecontroller.dispose();
    designationcontroller.dispose();
    remarkscontroller.dispose();
    remainderdatecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            icon: const Icon(CupertinoIcons.clear, color: Colors.white),
            onPressed: () {
              AppUtils.hideKeyboard(context);
              Navigator.of(context).pop();
            }),
        title: AppUtils.buildNormalText(
            text: "Documents", color: Colors.white, fontSize: 20),
        centerTitle: true,
      ),
      body: !loading
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    children: [getwidget()],
                  ),
                ))
              ],
            )
          : const Center(
              child: CupertinoActivityIndicator(
                  radius: 30.0, color: Appcolor.twitterBlue),
            ),
      persistentFooterButtons: [
        CustomButton(
          onPressed: () {
            if (idnumbercontroller.text.isEmpty) {
              AppUtils.showSingleDialogPopup(context, "Please Enter Id Number",
                  "Ok", onexitpopup, AssetsImageWidget.warningimage);
            } else if (getdocumentid.isEmpty ||
                getdocumentid.toString() == "null") {
              AppUtils.showSingleDialogPopup(context, "Please Choose DocType",
                  "Ok", onexitpopup, AssetsImageWidget.warningimage);
            } else if (getcompanyname.isEmpty) {
              AppUtils.showSingleDialogPopup(
                  context,
                  "Please Choose Company Name",
                  "Ok",
                  onexitpopup,
                  AssetsImageWidget.warningimage);
            } else if (countryissuecontroller.text.isEmpty) {
              AppUtils.showSingleDialogPopup(
                  context,
                  "Please Enter Country Of Issue",
                  "Ok",
                  onexitpopup,
                  AssetsImageWidget.warningimage);
            } else if (issuedatecontroller.text.isEmpty) {
              AppUtils.showSingleDialogPopup(context, "Please Enter Issue Date",
                  "Ok", onexitpopup, AssetsImageWidget.warningimage);
            } else if (expirydatecontroller.text.isEmpty) {
              AppUtils.showSingleDialogPopup(
                  context,
                  "Please Enter Expiry Date",
                  "Ok",
                  onexitpopup,
                  AssetsImageWidget.warningimage);
            } else if (remainderval.toString() == "" ||
                remainderval.toString() == "null") {
              AppUtils.showSingleDialogPopup(context, "Please Choose remainder",
                  "Ok", onexitpopup, AssetsImageWidget.warningimage);
            } else if (remainderdatecontroller.text.isEmpty) {
              AppUtils.showSingleDialogPopup(
                  context,
                  "Please Choose Remainder date",
                  "Ok",
                  onexitpopup,
                  AssetsImageWidget.warningimage);
            } else if (widget.iseditable == true && intenralId.isNotEmpty) {
              if (attachlist.isEmpty) {
                updatedocuments(widget
                    .model.message!.documents![widget.position!.toInt()].sId
                    .toString());
              } else {
                uploadfiles(widget
                    .model.message!.documents![widget.position!.toInt()].sId
                    .toString());
              }
            } else {
              if (getdocumentsname.isEmpty) {
                AppUtils.showSingleDialogPopup(
                    context, "Document Name", "Ok", onexitpopup, null);
              } else if (attachmentcontroller.text.isNotEmpty &&
                  widget.iseditable == true &&
                  intenralId.isEmpty) {
                uploadfiles(widget
                    .model.message!.documents![widget.position!.toInt()].sId
                    .toString());
              } else if (attachmentID.isNotEmpty &&
                  attachmentURL.isNotEmpty &&
                  intenralId.isEmpty) {
                adddocuments();
              } else if (attachlist.isNotEmpty &&
                  widget.iseditable == false &&
                  intenralId.isEmpty) {
                uploadfiles("");
              } else if (attachlist.isEmpty &&
                  widget.iseditable == false &&
                  intenralId.isEmpty) {
                adddocuments();
              }
            }
          },
          name: "Submit",
          circularvalue: 30,
          fontSize: 16,
        )
      ],
    );
  }

  Widget getwidget() {
    return Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              textCapitalization: TextCapitalization.characters,
              controller: idnumbercontroller,
              maxLength: 100,
              decoration: InputDecoration(
                counterText: '',
                labelText: 'ID Number',
                icon: Icon(
                  Icons.home,
                  color: Colors.grey.shade300,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            DropdownSearch<String>(
              popupProps: const PopupProps.menu(
                showSearchBox: true,
                showSelectedItems: true,
              ),
              items: dependentslist,
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                    icon: Icon(Icons.description),
                    hintText: "Select Documents",
                    label: Text("Select Documents")),
              ),
              onChanged: (val) {
                for (int kk = 0; kk < documentModel.records!.length; kk++) {
                  if (documentModel.records![kk].name.toString() == val) {
                    getdocumentsname =
                        documentModel.records![kk].name.toString();
                    getdocumentid = documentModel.records![kk].id.toString();

                    setState(() {});
                  }
                }
              },
              selectedItem: getdocumentsname,
            ),
            const SizedBox(
              height: 10,
            ),
            DropdownSearch<String>(
              popupProps: const PopupProps.menu(
                showSearchBox: true,
                showSelectedItems: true,
              ),
              items: companylist,
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                    icon: Icon(Icons.description),
                    hintText: "Select Company",
                    label: Text("Select Company")),
              ),
              onChanged: (val) {
                for (int kk = 0; kk < companyModel.records!.length; kk++) {
                  if (companyModel.records![kk].name.toString() == val) {
                    getcompanyname = companyModel.records![kk].name.toString();
                    getcompanyid = companyModel.records![kk].id.toString();

                    setState(() {});
                  }
                }
              },
              selectedItem: getcompanyname,
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              textCapitalization: TextCapitalization.characters,
              controller: countryissuecontroller,
              maxLength: 100,
              decoration: InputDecoration(
                counterText: '',
                labelText: 'Country Of Issue',
                icon: Icon(
                  Icons.home,
                  color: Colors.grey.shade300,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: issuedatecontroller,
              maxLength: 100,
              readOnly: true,
              onTap: () {
                pickerdate(issuedatecontroller);
              },
              decoration: InputDecoration(
                counterText: '',
                labelText: 'Issue Date',
                icon: Icon(Icons.join_full, color: Colors.grey.shade300),
              ),
            ),
            TextFormField(
              readOnly: true,
              onTap: () {
                pickerdate(expirydatecontroller);
              },
              controller: expirydatecontroller,
              maxLength: 100,
              decoration: InputDecoration(
                counterText: '',
                labelText: 'Expiry Date',
                icon: Icon(Icons.date_range, color: Colors.grey.shade300),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: designationcontroller,
              maxLength: 100,
              decoration: InputDecoration(
                counterText: '',
                labelText: 'Designation',
                icon: Icon(Icons.join_full, color: Colors.grey.shade300),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: remarkscontroller,
              maxLength: 100,
              decoration: InputDecoration(
                counterText: '',
                labelText: 'Remarks',
                icon: Icon(Icons.join_full, color: Colors.grey.shade300),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
                margin: const EdgeInsets.only(
                  left: 35,
                ),
                width: double.infinity,
                child: DropdownSearch<String>(
                    popupProps: const PopupProps.modalBottomSheet(
                      showSelectedItems: true,
                    ),
                    items: const ["true", "false"],
                    dropdownDecoratorProps: const DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "Remainder ",
                        hintText: "Remainder",
                      ),
                    ),
                    onChanged: (values) {
                      remainderval = values;
                      print(remainderval);
                    },
                    selectedItem: remainderval)),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: remainderdatecontroller,
              maxLength: 100,
              readOnly: true,
              onTap: () {
                pickerdate(remainderdatecontroller);
              },
              decoration: InputDecoration(
                counterText: '',
                labelText: 'Remainder Date',
                icon: Icon(Icons.join_full, color: Colors.grey.shade300),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              readOnly: true,
              controller: attachmentcontroller,
              maxLength: 250,
              decoration: InputDecoration(
                  counterText: '',
                  border: const UnderlineInputBorder(),
                  icon: InkWell(
                      onTap: () {
                        if (widget.model.message!
                                .documents![widget.position!.toInt()].attachment
                                .toString()
                                .isEmpty ||
                            widget
                                    .model
                                    .message!
                                    .documents![widget.position!.toInt()]
                                    .attachment
                                    .toString() ==
                                "null") {
                        } else {
                          _launchUrl(widget.model.message!
                              .documents![widget.position!.toInt()].attachment
                              .toString());
                        }
                      },
                      child: Icon(Icons.view_agenda,
                          color: (widget.iseditable == true &&
                                  widget
                                      .model
                                      .message!
                                      .documents![widget.position!.toInt()]
                                      .attachment
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
                        if (element.isDenied || element.isPermanentlyDenied) {
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
              height: 10,
            ),
          ],
        ));
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
      attachmentcontroller.text = pickedFile.path.toString().split("/").last;
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
          attachmentcontroller.text = file0.path;
          final bytes = File(file0.path).readAsBytesSync();
          file64 = base64Encode(bytes);
        } else {
          //Image
          attachmentcontroller.text = file0.path.toString();
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

  void getdocuments() async {
    setState(() {
      loading = true;
    });
    try {
      Uri baseUri = Uri.parse(
          '${AppConstants.netSuiteapiBaseUrl}script=${AppConstants.empdocumentscriptid}&deploy=${AppConstants.empdocumentdeployid}');
      await NetSuiteApiService.client.get(baseUri).then((response) {
        setState(() {
          loading = false;
        });
        if (response.statusCode == 200) {
          documentModel =
              DocumentModel.fromJson(json.decode(json.decode(response.body)));
          dependentslist.clear();
          for (int i = 0; i < documentModel.records!.length; i++) {
            dependentslist.add(documentModel.records![i].name.toString());
          }
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

  void getcompanydetails() async {
    setState(() {
      loading = true;
    });
    try {
      Uri baseUri = Uri.parse(
          '${AppConstants.netSuiteapiBaseUrl}script=${AppConstants.getcompanyscriptid}&deploy=${AppConstants.getcompanydeployod}');
      await NetSuiteApiService.client.get(baseUri).then((response) {
        setState(() {
          loading = false;
        });
        if (response.statusCode == 200) {
          companyModel =
              CompanyModel.fromJson(json.decode(json.decode(response.body)));

          companylist.clear();
          for (int i = 0; i < companyModel.records!.length; i++) {
            companylist.add(companyModel.records![i].name.toString());
          }
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
            updatedocuments(sid);
          } else {
            adddocuments();
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

  void adddocuments() {
    var json = {
      "nsId": Prefs.getNsID('nsid'),
      "firstName": Prefs.getFirstName(
        SharefprefConstants.shareFirstName,
      ),
      "middleName": Prefs.getMiddleName(
        SharefprefConstants.shareMiddleName,
      ),
      "lastName": Prefs.getLastName(
        SharefprefConstants.sharedLastName,
      ),
      "type": "documents",
      "idNo": idnumbercontroller.text,
      "documentNo": getdocumentid,
      "documentType": getdocumentsname,
      "companyName": getcompanyname,
      "companyID": getcompanyid,
      "issueDate": issuedatecontroller.text,
      "expiryDate": expirydatecontroller.text,
      "countryOfIssue": countryissuecontroller.text,
      "designation": designationcontroller.text,
      "remarks": remarkscontroller.text,
      "remainder": remainderval.toString() == "true" ? true : false,
      "remainderDate": remainderdatecontroller.text,
      attachmentURL.isEmpty || attachmentURL.toString() == "null"
          ? ""
          : "attachmentUrl": attachmentURL,
      attachmentID.isEmpty || attachmentID.toString() == "null"
          ? ""
          : "attachmentID": attachmentID
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
          AppUtils.showSingleDialogPopup(context,
              jsonDecode(response.body)['message'], "Ok", onexitpopup, null);
        }
      } else {
        throw Exception(jsonDecode(response.body)['message'].toString());
      }
    }).catchError((e) {
      setState(() {
        loading = false;
      });
      AppUtils.showSingleDialogPopup(
          context, e.toString(), "Ok", onexitpopup, null);
    });
  }

  void pickerdate(controller) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900), //.subtract(Duration(days: 1)),
        lastDate: DateTime(2100));
    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      var dateFormate =
          DateFormat("dd/MM/yyyy").format(DateTime.parse(formattedDate));
      controller.text = dateFormate;
    }
  }

  void updatedocuments(String sid) {
    var json = {
      "nsId": Prefs.getNsID('nsid'),
      "firstName": Prefs.getFirstName(
        SharefprefConstants.shareFirstName,
      ),
      "middleName": Prefs.getMiddleName(
        SharefprefConstants.shareMiddleName,
      ),
      "lastName": Prefs.getLastName(
        SharefprefConstants.sharedLastName,
      ),
      "type": "documents",
      "_id": sid,
      "idNo": idnumbercontroller.text,
      "internalid": widget
          .model.message!.documents![widget.position!.toInt()].internalid
          .toString(),
      "documentNo": getdocumentid,
      "documentType": getdocumentsname,
      "companyName": getcompanyname,
      "companyid": getcompanyid,
      "issueDate": issuedatecontroller.text,
      "expiryDate": expirydatecontroller.text,
      "countryOfIssue": countryissuecontroller.text,
      "designation": designationcontroller.text,
      "remarks": remarkscontroller.text,
      "remainder": remainderval.toString() == "true" ? true : false,
      "remainderDate": remainderdatecontroller.text,
      "attachmentUrl": attachmentURL,
      "attachmentID": attachmentID
      // attachmentID.isEmpty ||
      //         attachmentID == "" ||
      //         attachmentID.toString() == "null"
      //     ? ""
      //     : "attachmentID": attachmentID
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
          AppUtils.showSingleDialogPopup(context,
              jsonDecode(response.body)['message'], "Ok", onexitpopup, null);
        }
      } else {
        throw Exception(jsonDecode(response.body)['message'].toString());
      }
    }).catchError((e) {
      setState(() {
        loading = false;
      });
      AppUtils.showSingleDialogPopup(
          context, e.toString(), "Ok", onexitpopup, null);
    });
  }

  void onexitpopup() {
    Navigator.of(context).pop();
  }
}
