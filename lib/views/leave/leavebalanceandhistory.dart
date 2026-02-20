import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:powergroupess/utils/app_utils.dart';
import 'package:powergroupess/views/leave/leavebalance.dart';
import 'package:powergroupess/views/leave/leavehistory.dart';

class LeaveandHistoryTab extends StatefulWidget {
  const LeaveandHistoryTab({super.key});

  @override
  State<LeaveandHistoryTab> createState() => _LeaveandHistoryTabState();
}

class _LeaveandHistoryTabState extends State<LeaveandHistoryTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int currentindex = 0;
  @override
  void initState() {
    _tabController = TabController(initialIndex: 0, vsync: this, length: 2);
    super.initState();

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          currentindex = _tabController.index;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: const Icon(CupertinoIcons.back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: AppUtils.buildNormalText(
                text: "Leave Balance & History",
                color: Colors.black,
                fontSize: 14),
            centerTitle: true,
            bottom: TabBar(
                controller: _tabController,
                indicatorColor: Colors.yellow,
                onTap: (var index) {
                  print(index);
                  if (index == 0) {
                    currentindex = index;
                  } else if (index == 1) {
                    currentindex = index;
                  }
                  setState(() {});
                },
                tabs: const [
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Leave Balances",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Leave history",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ]),
          ),
          body: TabBarView(
            controller: _tabController,
            children: const [LeaveBalancePage(), LeaveandHistoryPage()],
          )),
    );
  }
}
