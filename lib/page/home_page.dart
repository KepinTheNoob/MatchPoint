import 'package:flutter/material.dart';
import 'package:matchpoint/page/settings_page.dart';
import 'package:matchpoint/widgets/createMatchDialog_widget.dart';
import 'featureMatch_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentTab = 0;
  final List<Widget> screens = [
    FeatureMatchPage(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = FeatureMatchPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(bucket: bucket, child: currentScreen),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff81D8E0),
        child: Icon(
          Icons.add,
          size: 28,
        ),
        onPressed: () {
          showCreateMatchHistoryDialog(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 20,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomAppBar(
          elevation: 10,
          color: Color(0xffD7F8FD),
          shape: CircularNotchedRectangle(),
          notchMargin: 8,
          child: Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      minWidth: 40,
                      onPressed: () {
                        currentTab = 0;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SettingsPage()));
                      },
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.settings,
                              color:
                                  currentTab == 0 ? Colors.black : Colors.black,
                            ),
                            Text('Settings',
                                style: TextStyle(
                                    color: currentTab == 0
                                        ? Colors.black
                                        : Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold))
                          ]),
                    )
                  ],
                ),
                const SizedBox(width: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          currentScreen = FeatureMatchPage();
                          currentTab = 0;
                        });
                      },
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.home,
                              color:
                                  currentTab == 0 ? Colors.black : Colors.black,
                            ),
                            Text('Home',
                                style: TextStyle(
                                    color: currentTab == 0
                                        ? Colors.black
                                        : Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold))
                          ]),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
