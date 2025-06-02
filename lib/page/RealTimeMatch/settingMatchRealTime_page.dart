import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matchpoint/model/match_model.dart';

class SettingsMatch extends StatefulWidget {
  final MatchInfo matchInfo;
  final Function(MatchInfo) onMatchInfoChanged;

  const SettingsMatch({
    Key? key,
    required this.matchInfo,
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
  String? selectedSportType;

  final List<String> sportTypes = [
    'Custom',
    'Football',
    'Basketball',
    'Tennis',
    'Badminton',
    'Tennis Table',
    'Volleyball',
    'Boxing'
  ];

  List<String> filteredSportTypes = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Initialize fields from widget.matchInfo
    selectedDate = widget.matchInfo.date ?? DateTime.now();

    // MatchInfo.startingTime bisa jadi TimeOfDay atau tak tau lah tapi makenya TimeOfDay
    selectedTime = widget.matchInfo.startingTime ?? TimeOfDay.now();

    locationController.text = widget.matchInfo.location ?? '';
    durationController.text = widget.matchInfo.duration?.toString() ?? '90';
    selectedSportType = widget.matchInfo.sportType ?? 'Custom';

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
    ));
  }

  @override
  void dispose() {
    searchController.dispose();
    locationController.dispose();
    durationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      updateParent();
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
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
          // Positioned(
          //   bottom: -60,
          //   left: 0,
          //   right: 0,
          //   child: SizedBox(
          //     child: Image.asset(
          //       'assets/background/${(selectedSportType ?? 'Custom').toLowerCase().replaceAll(' ', '_')}.png',
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
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
                const Text('Match Location',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                TextField(
                  controller: locationController,
                  style: TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Location',
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    prefixIcon:
                        const Icon(Icons.location_on_outlined, size: 20),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () =>
                          {locationController.clear(), updateParent()},
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
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
                              // Bersihkan search saat dropdown ditutup
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
                const SizedBox(height: 150),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
