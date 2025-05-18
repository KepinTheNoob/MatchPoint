import 'package:flutter/material.dart';
import 'package:matchpoint/main.dart';

class FeatureMatchPage extends StatelessWidget {
  const FeatureMatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xF0F8FFFE),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 2),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Featured Match",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Divider(
              thickness: 0.5,
              color: Colors.black,
              indent: MediaQuery.of(context).size.width * 0.03,
              endIndent: MediaQuery.of(context).size.width * 0.03,
            ),
            SizedBox(height: 16),
            _buildMatchCard(), // Featured match
            const Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 2),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Match History",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Divider(
              thickness: 0.5,
              color: Colors.black,
              indent: MediaQuery.of(context).size.width * 0.03,
              endIndent: MediaQuery.of(context).size.width * 0.03,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // Nanti isi match history di sini, gunakan _buildMatchCard()
                  // _buildMatchCard(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.lightBlue[50],
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {},
              ),
              const SizedBox(width: 30), // space for the FAB
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyHomePage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        onPressed: () {
          // Logic to add new match
        },
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }

  Widget _buildMatchCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEFF4FF), Color(0xFFFFE5E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Tuesday, 28 Jan 2014, 14:00 PM EST",
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
              Text(
                "Basketball Match",
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Left team
              _buildTeamColumn("Apex"),
              const Expanded(
                child: Column(
                  children: [
                    Text("VS",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text(
                      "21 - 20",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("WIN",
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w900)),
                        SizedBox(width: 12),
                        Text("LOSE",
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ],
                ),
              ),
              // Right team
              _buildTeamColumn("T1 Sports", isLeft: false),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTeamColumn(String teamName, {bool isLeft = true}) {
    return Expanded(
      child: Column(
        crossAxisAlignment:
            isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Text(
            teamName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment:
                isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: isLeft
                ? [
                    Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Lenardo", overflow: TextOverflow.ellipsis),
                          Text("Avocado", overflow: TextOverflow.ellipsis),
                          Text("Ilianiano", overflow: TextOverflow.ellipsis),
                          Text("La Mancha Don",
                              overflow: TextOverflow.ellipsis),
                          Text("...", overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ]
                : [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          Text("Lenardo", overflow: TextOverflow.ellipsis),
                          Text("Avocado", overflow: TextOverflow.ellipsis),
                          Text("Ilianiano", overflow: TextOverflow.ellipsis),
                          Text("La Mancha Don",
                              overflow: TextOverflow.ellipsis),
                          Text("...", overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.only(left: 8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                    ),
                  ],
          ),
        ],
      ),
    );
  }
}
