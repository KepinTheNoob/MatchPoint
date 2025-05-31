import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TeamInputSection extends StatefulWidget {
  const TeamInputSection({Key? key}) : super(key: key);

  @override
  State<TeamInputSection> createState() => _TeamTabState();
}

class _TeamTabState extends State<TeamInputSection> {
  List<String> members = [''];
  List<TextEditingController> memberControllers = [];
  TextEditingController addMemberController = TextEditingController();
  TextEditingController scoreController = TextEditingController();

  bool isEditingScore = false;
  int score = 0;

  @override
  void initState() {
    super.initState();
    members = [''];
    memberControllers = [TextEditingController()];
  }

  @override
  void dispose() {
    for (var c in memberControllers) {
      c.dispose();
    }
    super.dispose();
  }

  // void _onMemberChanged(int index, String value) {
  //   members[index] = value;

  //   bool allFilled = members.every((element) => element.trim().isNotEmpty);

  //   if (allFilled) {
  //     setState(() {
  //       members.add('');
  //       memberControllers.add(TextEditingController());
  //     });
  //   } else {
  //     setState(() {});
  //   }
  // }

  // void _addMember() {
  //   setState(() {
  //     members.add('');
  //     memberControllers.add(TextEditingController());
  //   });
  // }

  void _removeMember(int index) {
    if (members.length <= 1) return; // minimal 1 member
    setState(() {
      members.removeAt(index);
      memberControllers[index].dispose();
      memberControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8FFFE),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/jeremy.png'),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Input name team',
                      border: UnderlineInputBorder(),
                      isDense: true, // ini bikin jarak lebih rapat
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.clear),
                )
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Team Members",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),

            // Scrollable list of members
            SizedBox(
              height: 250,
              child: ListView.builder(
                itemCount: members.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Input member name',
                            border: UnderlineInputBorder(),
                            isDense: true, // ini bikin jarak lebih rapat
                            contentPadding: EdgeInsets.symmetric(vertical: 6),
                          ),
                          controller: memberControllers[index],
                          onChanged: (value) {
                            setState(() {
                              members[index] = value;
                              bool allFilled =
                                  members.every((e) => e.trim().isNotEmpty);
                              if (allFilled) {
                                members.add('');
                                memberControllers.add(TextEditingController());
                              }
                            });
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: members.length > 1 ? Colors.red : Colors.grey,
                        ),
                        onPressed: members.length > 1
                            ? () => _removeMember(index)
                            : null,
                      ),
                    ],
                  );
                },
              ),
            ),

            Spacer(),
            const Text(
              "Team Score",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  decoration: BoxDecoration(
                    color: Color(0xffF19393),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  child: IconButton(
                    iconSize: 40,
                    onPressed: () {
                      setState(() {
                        if (score > 0) score--;
                      });
                    },
                    icon: const Icon(Icons.remove, color: Colors.black),
                  ),
                ),
                SizedBox(width: 26),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isEditingScore = true;
                      scoreController.text = score.toString();
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
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
                    alignment:
                        Alignment.center, // memastikan konten berada di tengah
                    child: isEditingScore
                        ? TextField(
                            controller: scoreController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isCollapsed: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            autofocus: true,
                            onSubmitted: (value) {
                              setState(() {
                                if (value.trim().isEmpty) {
                                  score = 0;
                                } else {
                                  score = int.tryParse(value) ?? score;
                                }
                                isEditingScore = false;
                              });
                            },
                          )
                        : Text(
                            score.toString(),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                  ),
                ),
                SizedBox(width: 26),
                Container(
                  width: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xffD2F5ED),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  child: IconButton(
                    iconSize: 40,
                    onPressed: () {
                      setState(() {
                        score++;
                      });
                    },
                    icon: const Icon(Icons.add, color: Colors.black),
                  ),
                ),
              ],
            ),
            SizedBox(height: 66)
          ],
        ),
      ),
    );
  }
}
