import 'package:flutter/material.dart';
import 'package:matchpoint/page/settingMatch_page.dart';
import 'package:matchpoint/page/teamTab_page.dart';

class CreateHistory extends StatelessWidget {
  const CreateHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // jumlah tab
      child: Scaffold(
        appBar: AppBar(
          elevation: 0, // hilangkan shadow bawaan
          backgroundColor: const Color(0xFFF3FEFD),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "Historical Record",
            style: TextStyle(color: Colors.black),
          ),
          foregroundColor: Colors.black,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(
                50), // total tinggi untuk divider + tabbar
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey, // warna border bottom
                ),
                const TabBar(
                  indicatorColor: Color(0xff40BBC4),
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(icon: Icon(Icons.settings_outlined)),
                    Tab(icon: Icon(Icons.group)),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            SettingsMatch(),
            TeamPageWithTab(),
          ],
        ),
      ),
    );
  }
}
