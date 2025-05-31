import 'package:flutter/material.dart';
import 'package:matchpoint/page/featureMatch_page.dart';

class TeamTab extends StatefulWidget {
  const TeamTab({Key? key}) : super(key: key);

  @override
  State<TeamTab> createState() => _TeamMatchPageState();
}

class _TeamMatchPageState extends State<TeamTab> {
  List<String> members = [
    'Machivaelli Gonzales Lecture',
    'Team 1',
    'Team 1',
    'Team 1',
    'Team 1'
  ];
  int score = 0;

  int currentTab = 0;
  final List<Widget> screens = [
    FeatureMatchPage(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = FeatureMatchPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FFFE),
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: const Color(0xFFF3FEFD),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Historical Record",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        foregroundColor: Colors.black,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.settings),
                Icon(Icons.people),
              ],
            ),
            const SizedBox(height: 12),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [Text('Team 1'), Text('Team 2')],
            ),
            const Divider(thickness: 2),
            Row(
              children: [
                const CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage('assets/jeremy.png'),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Apex Of Generations',
                      border: UnderlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.clear),
                )
              ],
            ),
            const SizedBox(height: 24),
            const Text("Team Members",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),
            for (int i = 0; i < members.length; i++)
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: TextEditingController(text: members[i]),
                      decoration:
                          const InputDecoration(border: UnderlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // DropdownButton<String>(
                  //   value: i == 0 ? 'Captain' : 'Add Role',
                  //   items: const [
                  //     DropdownMenuItem(
                  //         value: 'Captain', child: Text('Captain')),
                  //     DropdownMenuItem(
                  //         value: 'Add Role', child: Text('Add Role')),
                  //   ],
                  //   onChanged: (value) {},
                  // ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      setState(() {
                        members.removeAt(i);
                      });
                    },
                  ),
                ],
              ),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(
                  hintText: 'Add Member...', border: UnderlineInputBorder()),
            ),
            const SizedBox(height: 24),
            const Text("Team Score",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 40,
                  onPressed: () {
                    setState(() {
                      if (score > 0) score--;
                    });
                  },
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: Text(
                    score.toString(),
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  iconSize: 40,
                  onPressed: () {
                    setState(() {
                      score++;
                    });
                  },
                  icon: const Icon(Icons.add_circle, color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              '* A Sports Type Must Be Selected\n* Both Teams Must Be Filled With At Least 1 Member',
              style: TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 12),
            Center(
              child: ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                ),
                child: const Text("Create Match",
                    style: TextStyle(color: Colors.grey)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
