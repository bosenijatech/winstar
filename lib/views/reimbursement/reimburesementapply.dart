import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:winstar/models/claimexpensemodel.dart';
import 'package:winstar/models/filemodel.dart';
import 'package:winstar/services/apiservice.dart';
import 'package:winstar/services/pref.dart';
import 'package:winstar/utils/api_details.dart';
import 'package:winstar/utils/app_utils.dart';
import 'package:winstar/utils/appcolor.dart';
import 'package:winstar/utils/constants.dart';
import 'package:winstar/utils/custom_indicatoronly.dart';
import 'package:winstar/utils/netsuite/netsuiteservice.dart';
import 'package:winstar/views/widgets/assets_image_widget.dart';
import 'package:winstar/views/widgets/custom_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class ReimburesementApplyPage extends StatefulWidget {
  const ReimburesementApplyPage({super.key});

  @override
  State<ReimburesementApplyPage> createState() =>
      _ReimburesementApplyPageState();
}

class _ReimburesementApplyPageState extends State<ReimburesementApplyPage> {
  late List<String> claimlist = [];
  String? getclaimid = "";
  String? getclaiminame = "";

  bool? check1 = false;
  late File file;
  List<String> files = [];
  List<String> attachmentlist = [];
  List<File> filelist = [];
  TextEditingController attachcontroller = TextEditingController();
  TextEditingController amountcontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  ClaimModel claimModel = ClaimModel();
  List<PlatformFile>? _paths;
  bool loading = false;
  final picker = ImagePicker();
  List<AttachModel> attachlist = [];
  File? imagefile;
  String attachmentID = "";
  String attachmentURL = "";
  @override
  void initState() {
    getreimlist();
    super.initState();
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
            text: "Reimbursement Application",
            color: Colors.black,
            fontSize: 20),
        centerTitle: true,
      ),
      body: !loading
          ? SingleChildScrollView(
              child: Column(
                children: [getdetails()],
              ),
            )
          : const Center(child: CustomIndicator()),
    );
  }

  Widget getdetails() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppUtils.buildNormalText(text: "Expense Category"),
          const SizedBox(height: 5),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: DropdownSearch<String>(
              popupProps: const PopupProps.menu(
                showSearchBox: true,
                showSelectedItems: true,
              ),
              items: claimlist,
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  hintText: 'Select Expense Category * ',
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
                for (int kk = 0; kk < claimModel.records!.length; kk++) {
                  if (claimModel.records![kk].name.toString() == val) {
                    getclaimid = claimModel.records![kk].id.toString();
                    getclaiminame = claimModel.records![kk].name.toString();

                    setState(() {});
                  }
                }
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          AppUtils.buildNormalText(text: "Amount"),
          const SizedBox(height: 5),
          TextFormField(
              controller: amountcontroller,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                  hintText: 'Amount ',
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                          BorderSide(width: 1, color: Appcolor.primarycolor)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: Colors.black26, width: 1),
                  ))),
          const SizedBox(height: 20),
          AppUtils.buildNormalText(text: "Attachment", fontSize: 12),
          const SizedBox(
            height: 10,
          ),
          TextField(
            readOnly: true,
            controller: attachcontroller,
            decoration: InputDecoration(
              hintText: 'Attachment',
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide:
                      BorderSide(width: 1, color: Appcolor.primarycolor)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.black26, width: 1),
              ),
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
          ),
          const SizedBox(
            height: 20,
          ),
          AppUtils.buildNormalText(text: "Description", fontSize: 12),
          const SizedBox(
            height: 10,
          ),
          Container(
              //padding: EdgeInsets.all(20),
              child: TextField(
            controller: descriptioncontroller,
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "ENTER DESCRIPTION",
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
              if (getclaimid.toString().isEmpty) {
                AppUtils.showSingleDialogPopup(
                    context,
                    "Please Choose any one Claim",
                    "Ok",
                    onexitpopup,
                    AssetsImageWidget.warningimage);
              } else if (amountcontroller.text.isEmpty ||
                  amountcontroller.text.toString() == "0") {
                AppUtils.showSingleDialogPopup(context, "Please Enter Amount",
                    "Ok", onexitpopup, AssetsImageWidget.warningimage);
              } else if (attachlist.isEmpty) {
                // attachlist.clear();
                // onpostreimrequest();
                AppUtils.showSingleDialogPopup(
                    context,
                    "Please make you sure attachment is Mandatory?",
                    "Ok",
                    onexitpopup,
                    AssetsImageWidget.warningimage);
              } else {
                onupload();
              }
            },
            name: "Apply Reimbursement Request",
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

  getreimlist() async {
    setState(() {
      loading = true;
    });
    try {
      Uri baseUri = Uri.parse(
          '${AppConstants.netSuiteapiBaseUrl}script=${AppConstants.claimtypescriptid}&deploy=${AppConstants.claimtypedeployid}');
      await NetSuiteApiService.client.get(baseUri).then((response) {
        setState(() {
          loading = false;
        });
        if (response.statusCode == 200) {
          claimModel =
              ClaimModel.fromJson(json.decode(json.decode(response.body)));
          claimlist.clear();
          for (int i = 0; i < claimModel.records!.length; i++) {
            claimlist.add(claimModel.records![i].name.toString());
          }
          //log(b['currentPage'].toString());
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

  cameraattachFile() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    setState(() {
      if (pickedFile != null) {
        filelist.add(File(pickedFile.path));
        attachmentlist.add(pickedFile.path.toString().split("/").last);
        files.clear();
        files.add(pickedFile.path);
        print(files.length);
        attachcontroller.text = filelist[0].path.toString();
        // getImage();
      } else {
        print('No image selected.');
      }
    });
  }

  pickFiles() async {
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: [
          'png',
          'jpg',
          'jpeg',
          'pdf',
          'doc',
          'docx',
          'xls',
        ],
      ))
          ?.files;
    } on PlatformException catch (e) {
      print(e.toString());
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      if (_paths != null) {
        print(_paths!.first.name);
        filelist.clear();
        attachmentlist.clear();
        files.clear();

        filelist.add(File(_paths!.first.path.toString()));
        attachmentlist.add(_paths.toString().split("/").last);
        files.clear();
        files.add(_paths!.first.path.toString());

        attachcontroller.text = _paths!.first.name;
      }
    });
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
          onpostreimrequest();
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

  void onpostreimrequest() async {
    DateTime now = DateTime.now();
    DateTime currentyear = DateTime(now.year);

    var json = {
      "requestapplicationno":
          "MOBREIM-${Prefs.getEmpID('empID').toString()}-${Prefs.getUserName('username').toString()}-${currentyear.year}",
      "date": ApiService.mobilecurrentdate,
      "expensecategorycode": getclaimid,
      "expensecategoryname": getclaiminame,
      "amount": amountcontroller.text,
      "description": descriptioncontroller.text,
      "attachmentUrl": attachmentURL,
      "iscancelled": "N",
      "iscancelledreason": "",
      "iscancelleddate": "",
      "isstatus": "Pending",
      "createdby": Prefs.getNsID('nsid'),
      "createdDate": ApiService.mobilecurrentdate,
      "toEmpID": Prefs.getNsID('nsid'),
      "toEmpName": Prefs.getFullName('Name'),
      "isSync": 0,
      "attachment": attachlist
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
    ApiService.postreimbursementrequest(json).then((response) {
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

  void onrefreshscreen() {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }
}
