import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matchpoint/model/match_model.dart';
import 'package:matchpoint/widgets/selectProfileBottomSheets_widget.dart';

class TeamInputSection extends StatefulWidget {
  final Team initialData;
  final Function(Team) onChanged;
  final String matchType;

  const TeamInputSection({
    Key? key,
    required this.initialData,
    required this.onChanged,
    required this.matchType,
  }) : super(key: key);

  @override
  State<TeamInputSection> createState() => _TeamTabState();
}

class _TeamTabState extends State<TeamInputSection> {
  List<String> members = [''];
  List<TextEditingController> memberControllers = [];
  TextEditingController teamNameController = TextEditingController();
  TextEditingController scoreController = TextEditingController();
  String selectedImage = 'assets/profile/1.png';
  String? matchType;

  bool isEditingScore = false;
  int score = 0;

  int? activeIndex;
  String activeText = '';

  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    teamNameController =
        TextEditingController(text: widget.initialData.nameTeam ?? '');
    score = widget.initialData.score;
    selectedImage = 'assets/profile/${widget.initialData.picId ?? "1"}.png';
    matchType = widget.matchType;

    members = List<String>.from(widget.initialData.listTeam);
    if (members.isEmpty) members = [''];
    if (members.isEmpty) members = [''];

    memberControllers =
        members.map((e) => TextEditingController(text: e)).toList();

    // Ensure always at least 1 empty controller at the end
    if (members.isEmpty || members.last.trim().isNotEmpty) {
      members.add('');
      memberControllers.add(TextEditingController());
    }

    teamNameController.addListener(_triggerOnChanged);
    // Trigger onChanged untuk initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _triggerOnChanged();
    });
  }

  void _triggerOnChanged() {
    final cleanMembers = memberControllers
        .map((c) => c.text.trim())
        .where((name) => name.isNotEmpty)
        .toList();

    widget.onChanged(
      Team(
        nameTeam: teamNameController.text.trim(),
        picId: selectedImage.split('/').last.split('.').first,
        listTeam: cleanMembers,
        score: score,
      ),
    );
  }

  @override
  void dispose() {
    teamNameController.dispose();
    scoreController.dispose();
    for (var c in memberControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _removeMember(int index) {
    if (members.length <= 1) return;
    setState(() {
      members.removeAt(index);
      memberControllers[index].dispose();
      memberControllers.removeAt(index);
    });
    _triggerOnChanged();
  }

  void _openAvatarSheet() {
    showSelectAvatarSheet(context, (String imageId) {
      setState(() {
        selectedImage = 'assets/profile/$imageId.png';
      });
      _triggerOnChanged();
    });
  }

  String _truncateInput(String input) {
    String trimmed = input.trim();
    if (trimmed.length <= 12) return trimmed;
    return '...${trimmed.substring(trimmed.length - 12)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FFFE),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _openAvatarSheet();
                        },
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.grey.shade400,
                                  width: 2,
                                ),
                              ),
                              padding: const EdgeInsets.all(4),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage: AssetImage(selectedImage),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 2,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Icon(
                                    Icons.edit,
                                    size: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: teamNameController,
                          decoration: InputDecoration(
                            hintText: 'Input team name',
                            border: UnderlineInputBorder(),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                            errorText: teamNameController.text.length > 22
                                ? 'Team name must be 22 characters or less'
                                : null,
                          ),
                          maxLength: 22,
                          onChanged: (value) {
                            setState(() {});
                            _triggerOnChanged();
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          teamNameController.clear();
                        },
                        icon: const Icon(Icons.clear),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        "Team Members",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(width: 14),
                      if (activeIndex != null && activeText.trim().isNotEmpty)
                        Flexible(
                          child: Text(
                            'Current name: ${_truncateInput(activeText)}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: members.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Expanded(
                              child: Focus(
                                onFocusChange: (hasFocus) {
                                  if (hasFocus) {
                                    setState(() {
                                      activeIndex = index;
                                      activeText =
                                          memberControllers[index].text;
                                    });
                                  } else {
                                    activeIndex = null;
                                    activeText = '';
                                  }
                                },
                                child: TextField(
                                    controller: memberControllers[index],
                                    decoration: const InputDecoration(
                                      hintText: 'Input member name',
                                      border: UnderlineInputBorder(),
                                      isDense: true,
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 6),
                                    ),
                                    maxLength: 38,
                                    onChanged: (value) {
                                      if (value.trim().isEmpty &&
                                          members.length > 1) {
                                        setState(() {
                                          if (activeIndex == index) {
                                            activeIndex = null;
                                            activeText = '';
                                          }
                                          members.removeAt(index);
                                          memberControllers.removeAt(index);
                                        });

                                        _triggerOnChanged();
                                        return;
                                      }

                                      setState(() {
                                        members[index] = value;
                                        activeIndex = index;
                                        activeText = value;

                                        bool isLast =
                                            index == members.length - 1;
                                        if (isLast && value.trim().isNotEmpty) {
                                          members.add('');
                                          memberControllers
                                              .add(TextEditingController());
                                        }
                                      });

                                      _triggerOnChanged();
                                    }),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                color: (members.length > 1 &&
                                        members[index].trim().isNotEmpty)
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                              onPressed: (members.length > 1 &&
                                      members[index].trim().isNotEmpty)
                                  ? () => _removeMember(index)
                                  : null,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (matchType == 'history') ...[
                    const Text(
                      "Team Score",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xffF19393),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: IconButton(
                            iconSize: 40,
                            onPressed: () {
                              setState(() {
                                if (score > 0 && matchType == 'history')
                                  score--;
                              });
                              _triggerOnChanged();
                            },
                            icon: const Icon(Icons.remove, color: Colors.black),
                          ),
                        ),
                        const SizedBox(width: 26),
                        GestureDetector(
                          onTap: () {
                            scoreController.text = score.toString();
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                  backgroundColor: const Color(0xFfffffff),
                                  contentPadding: const EdgeInsets.all(24),
                                  title: const Text('Edit Score'),
                                  content: TextField(
                                    controller: scoreController,
                                    autofocus: true,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    decoration: const InputDecoration(
                                      hintText: 'Enter new score',
                                    ),
                                    onSubmitted: (value) {
                                      setState(() {
                                        score =
                                            int.tryParse(value.trim()) ?? score;
                                      });
                                      _triggerOnChanged();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text(
                                        "Cancel",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          score = int.tryParse(scoreController
                                                  .text
                                                  .trim()) ??
                                              score;
                                        });
                                        _triggerOnChanged();
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        "Save",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.27,
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
                            child: Text(
                              textAlign: TextAlign.center,
                              score.toString(),
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 26),
                        Container(
                          width: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xffD2F5ED),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: IconButton(
                            iconSize: 40,
                            onPressed: () {
                              setState(() {
                                score++;
                              });
                              _triggerOnChanged();
                            },
                            icon: const Icon(Icons.add, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (matchType != 'history' &&
                      (MediaQuery.of(context).size.height > 700))
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
