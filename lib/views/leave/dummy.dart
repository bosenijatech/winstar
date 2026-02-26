import 'dart:convert';
import 'package:bindhaeness/models/holidaymastermodel.dart';
import 'package:bindhaeness/models/loginmodel.dart';
import 'package:bindhaeness/services/userstatusservice.dart';
import 'package:bindhaeness/views/payslip/viewallfiles.dart';
import 'package:bindhaeness/views/widgets/wishthempage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bindhaeness/models/announcementmodel.dart';
import 'package:bindhaeness/models/error_model.dart';
import 'package:bindhaeness/models/pendingmodel.dart';
import 'package:bindhaeness/routenames.dart';
import 'package:bindhaeness/services/apiservice.dart';
import 'package:bindhaeness/services/pref.dart';
import 'package:bindhaeness/utils/app_utils.dart';
import 'package:bindhaeness/utils/constants.dart';
import 'package:bindhaeness/utils/sharedprefconstants.dart';
import 'package:bindhaeness/views/widgets/assets_image_widget.dart';
import 'package:http/http.dart' as http;

class DummyScreen extends StatefulWidget {
  const DummyScreen({super.key});

  @override
  State<DummyScreen> createState() => _DummyScreenState();
}

class _DummyScreenState extends State<DummyScreen> {
  List<AnnouncementData> announcementList = [];

  bool loading = false;
  int leaveCount = 0;
  int letterCount = 0;
  int totalCount = 0;
  ErrorModelNetSuite errorModelNetSuite = ErrorModelNetSuite();
  List<HolidayModel> holidayList = [];

  PendingModel model = PendingModel();
  List<Map<String, String>> wishData = [];
  List<Map<String, String>> leaveData = [];
  List<Map<String, String>> allWishData = [];
  final months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];
  @override
  void initState() {
    UserStatusService().startChecking(context);
    getAllEvents();
    super.initState();
  }

  @override
  void dispose() {
    UserStatusService().stopChecking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xfff6f8fb),
      body: !loading
          ? SafeArea(
              child: RefreshIndicator(
                onRefresh: () async => getAllEvents(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        headerSection(),
                        const SizedBox(height: 10),
                        otherServicesSection(),
                        const SizedBox(height: 10),
                        if (announcementList.isNotEmpty) announcementSection(),
                        const SizedBox(height: 10),
                        wishlistwidgets(),
                        const SizedBox(height: 10),
                        leavewidgets(),
                        const SizedBox(height: 10),
                        upcomingHolidays(),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget headerSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Profile avatar
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage:
                      Prefs.getGender(SharefprefConstants.sharedgender)
                                  .toString() ==
                              "Male"
                          ? const AssetImage('assets/icons/male.jpeg')
                          : const AssetImage('assets/icons/female.jpeg'),
                ),
              ),
              const SizedBox(width: 12),
              // Greeting text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello ${Prefs.getFullName(SharefprefConstants.shareFullName) ?? "User"}!',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                  const Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Notification icon
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.logout, color: Colors.red),
              onPressed: () {
                logout();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget otherServicesSection() {
    final services = [
      {
        'icon': CupertinoIcons.person_2,
        'label': 'My Profile',
        'color': Colors.blue
      },
      {
        'icon': Icons.flight_takeoff_rounded,
        'label': 'Leave Request',
        'color': Colors.purple
      },
      {
        'icon': Icons.description_outlined,
        'label': 'Letter Request',
        'color': Colors.amber
      },
      {
        'icon': Icons.picture_as_pdf,
        'label': 'Pay Slip',
        'color': Colors.green
      },
      {
        'icon': Icons.account_balance_wallet_rounded,
        'label': 'Expense Claim',
        'color': Colors.deepPurple
      },
      {'icon': Icons.group, 'label': 'Team', 'color': Colors.redAccent},
      {
        'icon': Icons.devices_other,
        'label': 'Asset Request',
        'color': Colors.indigo
      },
      {
        'icon': Icons.flight_takeoff_outlined,
        'label': 'Comp Off Leave',
        'color': Colors.pink
      },
      {
        'icon': Icons.devices_other,
        'label': 'Re-join Request',
        'color': Colors.teal
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: services.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
            ),
            itemBuilder: (context, index) {
              final service = services[index];
              return GestureDetector(
                onTap: () {
                  if (index == 0) {
                    Navigator.pushNamed(context, RouteNames.viewprofile)
                        .then((_) {
                      getAllEvents();
                    });
                  } else if (index == 1) {
                    Navigator.pushNamed(context, RouteNames.viewleave)
                        .then((_) {
                      getAllEvents();
                    });
                  } else if (index == 2) {
                    Navigator.pushNamed(context, RouteNames.viewletter)
                        .then((_) {
                      getAllEvents();
                    });
                  } else if (index == 3) {
                    Navigator.pushNamed(context, RouteNames.payslip).then((_) {
                      getAllEvents();
                    });
                  } else if (index == 4) {
                    Navigator.pushNamed(context, RouteNames.reimview).then((_) {
                      getAllEvents();
                    });
                  } else if (index == 5) {
                    Navigator.pushNamed(context, RouteNames.myteam).then((_) {
                      getAllEvents();
                    });
                  } else if (index == 6) {
                    Navigator.pushNamed(context, RouteNames.viewasset)
                        .then((_) {
                      getAllEvents();
                    });
                  } else if (index == 7) {
                    Navigator.pushNamed(context, RouteNames.viewcompoffleave)
                        .then((_) {
                      getAllEvents();
                    });
                  } else if (index == 8) {
                    Navigator.pushNamed(context, RouteNames.viewrejoin)
                        .then((_) {
                      getAllEvents();
                    });
                  }
                },
                child: Column(
                  children: [
                    Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: service['color'] as Color, width: 1.5),
                        borderRadius: BorderRadius.circular(16),
                        color: (service['color'] as Color).withOpacity(0.05),
                      ),
                      child: Icon(service['icon'] as IconData,
                          color: service['color'] as Color, size: 28),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      service['label'] as String,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget dashboardGrid(double width) {
    final List<Map<String, dynamic>> items = [
      {
        'icon': Icons.person,
        'label': 'My Profile',
        'color': const Color(0xff5cbc3c),
        'route': RouteNames.viewprofile
      },
      {
        'icon': Icons.calendar_today,
        'label': 'Leave Request',
        'color': const Color(0xfffe5d3b),
        'route': RouteNames.viewleave
      },
      {
        'icon': Icons.dock,
        'label': 'Letter Request',
        'color': const Color(0xffe32845),
        'route': RouteNames.viewletter
      },
      {
        'icon': Icons.receipt_long,
        'label': 'Pay Slip',
        'color': const Color(0xff31aaf3),
        'route': RouteNames.payslip
      },
      {
        'icon': Icons.task,
        'label': 'View Claim',
        'color': const Color(0xff785af6),
        'route': RouteNames.reimview
      },
      {
        'icon': Icons.people,
        'label': 'Team',
        'color': const Color(0xfff59d00),
        'route': RouteNames.myteam
      },
      {
        'icon': Icons.devices_other,
        'label': 'Asset Request',
        'color': const Color(0xfff500e9),
        'route': RouteNames.viewasset
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: width < 600 ? 3 : 5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return InkWell(
          onTap: () => Navigator.pushNamed(context, item['route']),
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [item['color'], item['color'].withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: item['color'].withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(2, 4),
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item['icon'], color: Colors.white, size: 30),
                const SizedBox(height: 8),
                Text(item['label'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget announcementSection() {
    return Card(
      elevation: 3,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.white,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.campaign_rounded,
                      color: Colors.purple, size: 22),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Announcements',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              height: 3,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 16),

            // 🔹 List
            if (announcementList.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    "",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                ),
              )
            else
              ListView.separated(
                separatorBuilder: (_, __) => Divider(
                  color: Colors.grey.shade300,
                  height: 20,
                ),
                itemCount: announcementList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final ann = announcementList[index];
                  return InkWell(
                    onTap: () async {
                      if (ann.attachmentURL.isNotEmpty) {
                        final mime =
                            await AppConstants.getMimeType(ann.attachmentURL);
                        final ext = AppConstants.getExtensionFromMime(mime);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ViewFiles(
                              fileUrl: ann.attachmentURL,
                              fileName: 'file.$ext',
                              mimeType: mime,
                            ),
                          ),
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.purple.shade100,
                            child: Text(
                              ann.message.isNotEmpty
                                  ? ann.message[0].toUpperCase()
                                  : "?",
                              style: const TextStyle(
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ann.message,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                if (ann.attachmentURL.isNotEmpty)
                                  const Row(
                                    children: [
                                      Icon(Icons.attach_file,
                                          color: Colors.purple, size: 18),
                                      SizedBox(width: 4),
                                      Text(
                                        "View Attachment",
                                        style: TextStyle(
                                            color: Colors.purple,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          ann.attachmentURL.isNotEmpty
                              ? const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 16,
                                  color: Colors.grey,
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  // 🌿 Modern Holiday Section
  Widget upcomingHolidays() {
    if (holidayList.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
            child: Text('No upcoming holidays 🎉',
                style: TextStyle(color: Colors.grey, fontSize: 15))),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Holiday List',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontSize: 16)),
          const SizedBox(height: 8),
          Container(height: 4, width: 40, color: Colors.blueAccent),
          const SizedBox(height: 10),
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: holidayList.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final holiday = holidayList[index];
                return Container(
                  width: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppConstants
                            .colorArray[index % AppConstants.colorArray.length],
                        AppConstants
                            .colorArray[index % AppConstants.colorArray.length]
                            .withOpacity(0.8)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(holiday.name ?? '',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        Text(holiday.holidayDate ?? '',
                            style: const TextStyle(color: Colors.white)),
                        Text(holiday.holidayDay ?? '',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget wishlistwidgets() {
    return wishData.isNotEmpty
        ? Padding(
            padding:
                const EdgeInsetsGeometry.symmetric(horizontal: 5, vertical: 5),
            child: Card(
                elevation: 2,
                child: WishThemWidget(
                    type: "UpComing Birthday", wishList: wishData)))
        : const SizedBox(
            width: 0,
            height: 0,
          );
  }

  Widget leavewidgets() {
    return leaveData.isNotEmpty
        ? Padding(
            padding:
                const EdgeInsetsGeometry.symmetric(horizontal: 5, vertical: 5),
            child: Card(
              elevation: 2,
              child: WishThemWidget(
                wishList: leaveData,
                type: "Off this Week",
              ),
            ),
          )
        : const SizedBox(
            width: 0,
            height: 0,
          );
  }

  void logout() async {
    Prefs.clear(); // Clears all stored preferences
    Prefs.remove("remove"); // Redundant if clear() already wipes everything
    Prefs.setLoggedIn(
        SharefprefConstants.sharefloggedin, false); // Explicit logout flag

    Navigator.pushNamedAndRemoveUntil(
      context,
      RouteNames.loginscreen,
      (Route<dynamic> route) => false,
    );
  }

  void getAllEvents() async {
    if (!mounted) return;

    setState(() => loading = true);

    await Future.wait<void>([
      syncCredentialsFromBackend(),
      fetchHolidayData(),
      getleavelist(),
      getannouncement(),
      getBirthdayList(),
    ]);
    if (!mounted) return;
    setState(() => loading = false);
  }

  Future<void> syncCredentialsFromBackend() async {
    final response = await http.get(
        Uri.parse('${AppConstants.apiBaseUrl}api/mobileapp/getcredentials'));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      if (body['status'].toString() == "true") {
        final loginModel = LoginModel.fromJson(body);

        if (loginModel.secretkey != null && loginModel.secretkey!.isNotEmpty) {
          await updateSharedPrefIfDifferent(loginModel);
        }
      }
    }
  }

  Future<void> updateSharedPrefIfDifferent(LoginModel loginModel) async {
    final newKey = loginModel.secretkey![0];

    // Read existing values
    final currentConsumerKey =
        Prefs.getnetsuiteConsumerKey("netsuiteConsumerKey");
    final currentConsumerSecret =
        Prefs.getnetsuiteConsumerSecret("netsuiteConsumerSecret");
    final currentToken = Prefs.getnetsuiteToken("netsuiteToken");
    final currentTokenSecret =
        Prefs.getnetsuiteTokenSecret("netsuiteTokenSecret");
    final currentRealm = Prefs.getRealm("netSuiteRealm");

    // Update only if different
    if (currentConsumerKey != newKey.cONSUMERKEY) {
      await Prefs.setnetsuiteConsumerKey(
          "netsuiteConsumerKey", newKey.cONSUMERKEY.toString());
    }

    if (currentConsumerSecret != newKey.cONSUMERSECRET) {
      await Prefs.setnetsuiteConsumerSecret(
          "netsuiteConsumerSecret", newKey.cONSUMERSECRET.toString());
    }

    if (currentToken != newKey.aCCESSTOKEN) {
      await Prefs.setnetsuiteToken(
          "netsuiteToken", newKey.aCCESSTOKEN.toString());
    }

    if (currentTokenSecret != newKey.tOKENSECRET) {
      await Prefs.setnetsuiteTokenSecret(
          "netsuiteTokenSecret", newKey.tOKENSECRET.toString());
    }

    if (currentRealm != newKey.rEALM) {
      await Prefs.setRealm("netSuiteRealm", newKey.rEALM.toString());
    }

    print("SharedPreferences updated if any key changed");
  }

  Future<void> getannouncement() async {
    try {
      final response = await ApiService.viewannouncement();

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List rootData = decoded['data'];

        // Extract inner "data" arrays and flatten
        announcementList = rootData.expand((announcement) {
          final List dataList = announcement['data'] ?? [];
          return dataList.map((e) => AnnouncementData.fromJson(e));
        }).toList();

        print(jsonEncode(announcementList));
      } else {
        throw Exception(jsonDecode(response.body)['message'].toString());
      }
    } catch (e) {
      if (!mounted) return;
      AppUtils.showSingleDialogPopup(
        context,
        e.toString(),
        "Ok",
        onexitpopup,
        AssetsImageWidget.errorimage,
      );
    }
  }

  Future<void> fetchHolidayData() async {
    try {
      setState(() => loading = true);

      final List<HolidayModel> holidays = await ApiService.getHolidayMaster(
          regionFilter:
              Prefs.getWorkRegion(SharefprefConstants.sharedWorkregion) ?? "");

      setState(() {
        holidayList.clear();
        holidayList.addAll(holidays);
        loading = false;
      });
    } catch (e) {
      print("Error fetching holidays: $e");
      setState(() => loading = false);
    }
  }

  Future<void> getleavelist() async {
    try {
      final response = await ApiService.getPendingleaves();
      if (!mounted) return;
      setState(() {
        loading = false;
      });

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded['status'] == true) {
          final leaveResponse = decoded['data'];
          if (leaveResponse is List) {
            leaveData = leaveResponse.map<Map<String, String>>((emp) {
              final fullName = emp['toEmpName']?.toString() ?? '';
              final initials = fullName.trim().isNotEmpty
                  ? fullName
                      .trim()
                      .split(" ")
                      .where((e) => e.isNotEmpty)
                      .map((e) => e.characters.first)
                      .take(2)
                      .join()
                  : "??";

              return {
                "name": fullName,
                "date": emp['leaveDate']?.toString() ?? '',
                "type": "LEAVE",
                "initials": initials,
                "photo": ""
              };
            }).toList();

            if (!mounted) return;
            setState(() {
              allWishData = [...wishData, ...leaveData];
            });
          } else {
            if (!mounted) return;
            setState(() {
              leaveData = [];
            });
          }
          print("Leave List: $leaveData");
        } else {
          if (!mounted) return;
          setState(() {
            leaveData = [];
          });
        }
      } else {
        //throw Exception(jsonDecode(response.body)['message'].toString());
      }
    } catch (e) {
      if (!mounted) return;
      AppUtils.showSingleDialogPopup(
        context,
        e.toString(),
        "Ok",
        onexitpopup,
        AssetsImageWidget.errorimage,
      );
    }
  }

  Future<void> getBirthdayList() async {
    try {
      final response = await ApiService.getBirthdayList();
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        final data = decoded['message'];
        if (decoded['status'].toString() == "true" && data is List) {
          final List<dynamic> rawList = data;

          final List<Map<String, dynamic>> mapped = rawList.map((emp) {
            final firstName = emp['firstName'] ?? '';
            final lastName = emp['lastName'] ?? '';
            final fullName = "$firstName $lastName".trim();

            final dob = emp['dateOfBirth'] ?? ''; // "19/09/2000"
            String formattedDate = '';
            if (dob.contains("/")) {
              final parts = dob.split("/");
              if (parts.length >= 2) {
                final day = parts[0];
                final month = parts[1];
                formattedDate = "$day ${months[int.parse(month) - 1]}";
              }
            }

            return {
              "name": fullName,
              "date": formattedDate,
              "type": "B'DAY",
              "initials": fullName.isNotEmpty
                  ? fullName
                      .split(" ")
                      .map((e) => e.isNotEmpty ? e[0] : "")
                      .take(2)
                      .join()
                  : "??",
              "photo": "",
            };
          }).toList();

          if (!mounted) return;
          setState(() {
            wishData = mapped.cast<Map<String, String>>();
            allWishData = [...wishData, ...leaveData];
          });
        } else {
          if (!mounted) return;
          setState(() {
            wishData = [];
          });
        }
      } else {
        throw Exception(jsonDecode(response.body)['message'].toString());
      }
    } catch (e) {
      if (!mounted) return;
      AppUtils.showSingleDialogPopup(
        context,
        e.toString(),
        "Ok",
        onexitpopup,
        AssetsImageWidget.errorimage,
      );
    }
  }

  void onexitpopup() {
    AppUtils.pop(context);
  }

  String formatDate(DateTime date) => DateFormat('d MMMM y').format(date);
}
