import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matchpoint/model/match_model.dart';
import 'package:matchpoint/widgets/inputNotes_widget.dart';

class SettingsMatch extends StatefulWidget {
  final MatchInfo matchInfo;
  final Team teamA;
  final Team teamB;
  final Function(MatchInfo) onMatchInfoChanged;

  const SettingsMatch({
    Key? key,
    required this.matchInfo,
    required this.teamA,
    required this.teamB,
    required this.onMatchInfoChanged,
  }) : super(key: key);

  @override
  State<SettingsMatch> createState() => _SettingsMatchPageState();
}

class _SettingsMatchPageState extends State<SettingsMatch> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController locationController = TextEditingController();
  TextEditingController durationController = TextEditingController(text: '90');
  TextEditingController matchNotesController = TextEditingController(text: '');
  TextEditingController teamANotesController = TextEditingController(text: '');
  TextEditingController teamBNotesController = TextEditingController(text: '');

  String? selectedSportType;

  final List<String> sportTypes = [
    'Custom',
    'Football',
    'Basketball',
    'Tennis',
    'Badminton',
    'Table Tennis',
    'Volleyball',
    'Boxing'
  ];

  List<String> filteredSportTypes = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    selectedDate = widget.matchInfo.date ?? DateTime.now();

    selectedTime = widget.matchInfo.startingTime ?? TimeOfDay.now();

    locationController.text = widget.matchInfo.location ?? '';
    durationController.text = widget.matchInfo.duration?.toString() ?? '90';
    selectedSportType = widget.matchInfo.sportType ?? '';

    matchNotesController.text = widget.matchInfo.matchNotes ?? '';
    teamANotesController.text = widget.matchInfo.teamANotes ?? '';
    teamBNotesController.text = widget.matchInfo.teamBNotes ?? '';

    filteredSportTypes = List.from(sportTypes);

    locationController.addListener(updateParent);
    durationController.addListener(updateParent);

    searchController.addListener(() {
      final filter = searchController.text.toLowerCase();
      setState(() {
        filteredSportTypes = sportTypes
            .where((item) => item.toLowerCase().contains(filter))
            .toList();
      });
    });
  }

  void updateParent() {
    widget.onMatchInfoChanged(MatchInfo(
      location: locationController.text,
      duration: int.tryParse(durationController.text),
      sportType: selectedSportType,
      startingTime: selectedTime,
      date: selectedDate,
      matchNotes: matchNotesController.text,
      teamANotes: teamANotesController.text,
      teamBNotes: teamBNotesController.text,
    ));
  }

  @override
  void dispose() {
    searchController.dispose();
    locationController.dispose();
    durationController.dispose();
    matchNotesController.dispose();
    teamANotesController.dispose();
    teamBNotesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final today = DateTime.now();
    final onlyToday = DateTime(today.year, today.month, today.day);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: onlyToday,
      firstDate: DateTime(2000),
      lastDate: onlyToday,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Color(0xFFE0E9E9),
            ),
            colorScheme: ColorScheme.light(
              primary: Colors.teal,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.teal,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      updateParent();
    }
  }

  String _getBackgroundImagePath() {
    final type = (selectedSportType ?? '').toLowerCase().replaceAll(' ', '_');
    final filename = type.isEmpty ? 'custom' : type;
    return 'assets/background/$filename.png';
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Color(0xFFF2F9FA),
            ),
            colorScheme: ColorScheme.light(
              primary: Colors.teal,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.teal,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
      updateParent();
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('EEEE, d MMM yyyy').format(selectedDate);
    final formattedTime = selectedTime.format(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xffF8FFFE),
      body: Stack(
        children: [
          Positioned(
            bottom: -120,
            left: 0,
            right: 0,
            child: MediaQuery.of(context).size.height > 750
                ? Image.asset(
                    _getBackgroundImagePath(),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 150,
                        color: Colors.teal.withOpacity(0.1), // fallback warna
                        alignment: Alignment.center,
                        child:
                            Icon(Icons.image_not_supported, color: Colors.grey),
                      );
                    },
                  )
                : const SizedBox.shrink(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 7, 20, 7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Match Date',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                GestureDetector(
                  onTap: _selectDate,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      suffixIcon: const Icon(Icons.calendar_today, size: 20),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                    ),
                    child: Text(
                      formattedDate,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Match Location',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: locationController,
                      builder: (context, value, _) {
                        final currentLength = value.text.length;
                        return Text(
                          '$currentLength / 255 characters',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                TextField(
                  controller: locationController,
                  maxLength: 255,
                  style: const TextStyle(fontSize: 14),
                  buildCounter: (_,
                          {required currentLength,
                          required isFocused,
                          maxLength}) =>
                      null,
                  decoration: InputDecoration(
                    hintText: 'Location',
                    hintStyle: const TextStyle(color: Colors.grey),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    prefixIcon:
                        const Icon(Icons.location_on_outlined, size: 20),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () {
                        locationController.clear();
                        updateParent();
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Starting Time',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          GestureDetector(
                            onTap: _selectTime,
                            child: InputDecorator(
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 4, 8, 4),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                suffixIcon: const Icon(Icons.access_time),
                              ),
                              child: Text(
                                formattedTime,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Match Duration',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: durationController,
                                  style: TextStyle(fontSize: 16),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.fromLTRB(20, 4, 8, 4),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    suffixText: 'Minutes',
                                    suffixStyle: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: const Text(
                        'Sport Type',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: const Text(
                            'Select Sport',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          items: filteredSportTypes
                              .map((String item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                              .toList(),
                          value: filteredSportTypes.contains(selectedSportType)
                              ? selectedSportType
                              : null,
                          onChanged: (String? value) {
                            setState(() {
                              selectedSportType = value.toString();
                            });
                            updateParent();
                          },
                          buttonStyleData: ButtonStyleData(
                            height: 40,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xffF8FFFE),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black54),
                            ),
                          ),
                          iconStyleData: const IconStyleData(
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                            ),
                            iconSize: 20,
                            iconEnabledColor: Colors.black54,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 250,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            scrollbarTheme: ScrollbarThemeData(
                              radius: const Radius.circular(10),
                              thickness: MaterialStateProperty.all(6),
                              thumbVisibility: MaterialStateProperty.all(true),
                            ),
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                            padding: EdgeInsets.symmetric(horizontal: 12),
                          ),
                          dropdownSearchData: DropdownSearchData(
                            searchController: searchController,
                            searchInnerWidgetHeight: 50,
                            searchInnerWidget: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: TextField(
                                controller: searchController,
                                autofocus: true,
                                decoration: InputDecoration(
                                  hintText: "Type to search...",
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            searchMatchFn: (item, searchValue) {
                              return item.value
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchValue.toLowerCase());
                            },
                          ),
                          onMenuStateChange: (isOpen) {
                            if (!isOpen) {
                              searchController.clear();
                              setState(() {
                                filteredSportTypes = List.from(sportTypes);
                              });
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Spacer(),
                    Container(
                      width: (MediaQuery.of(context).size.width - 40 - 16) / 2,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            offset: const Offset(0, 4),
                            blurRadius: 6,
                            spreadRadius: 0,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          final result = await showMatchNotesDialog(
                            context,
                            teamAName: widget.teamA.nameTeam,
                            teamBName: widget.teamB.nameTeam,
                            initialMatchNote: matchNotesController.text,
                            initialTeamANote: teamANotesController.text,
                            initialTeamBNote: teamBNotesController.text,
                          );

                          if (result != null) {
                            setState(() {
                              matchNotesController.text =
                                  result['matchNotes'] ?? '';
                              teamANotesController.text =
                                  result['teamANotes'] ?? '';
                              teamBNotesController.text =
                                  result['teamBNotes'] ?? '';
                            });

                            updateParent();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor:
                              const Color.fromARGB(255, 189, 253, 247),
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                              color: Colors.black,
                              width: 0.8,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Expanded(
                              child: Text(
                                'Match Notes',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Icon(Icons.sticky_note_2_outlined,
                                color: Colors.black, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    selectedSportType ?? "???",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff40BBC4),
                    ),
                  ),
                ),
                // const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
