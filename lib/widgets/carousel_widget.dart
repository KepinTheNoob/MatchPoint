import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:matchpoint/model/match_model.dart';
import 'package:matchpoint/page/viewMatchInfo_page.dart';
import 'package:matchpoint/utils/image_viewer_helper.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';

class CustomCarousel extends StatefulWidget {
  final List<String> imageUrls;
  final bool isInnerStyle;
  final double? height;
  final double? width;

  const CustomCarousel({
    super.key,
    required this.imageUrls,
    this.isInnerStyle = true,
    this.height,
    this.width,
  });

  @override
  State<CustomCarousel> createState() => _CustomCarouselState();
}

class _CustomCarouselState extends State<CustomCarousel>
    with SingleTickerProviderStateMixin {
  MotionTabBarController? _motionTabBarController;
  late CarouselSliderController _carouselController;
  int _currentPage = 0;

  final List<MatchInfo> dummyMatchInfoList = [
    MatchInfo(
      id: 'match1',
      date: DateTime(2025, 6, 15),
      location: 'Stadium A',
      duration: 90,
      startingTime: TimeOfDay(hour: 15, minute: 30),
      sportType: 'Football',
      createdBy: 'user123',
    ),
    MatchInfo(
      id: 'match2',
      date: DateTime(2025, 6, 20),
      location: 'Court B',
      duration: 60,
      startingTime: TimeOfDay(hour: 18, minute: 0),
      sportType: 'Basketball',
      createdBy: 'user456',
    ),
  ];

  final List<Team> dummyTeamAList = [
    Team(
      nameTeam: 'Red Warriors',
      picId: '1',
      listTeam: ['Alice', 'Bob', 'Charlie'],
      score: 3,
    ),
    Team(
      nameTeam: 'Blue Sharks',
      picId: '2',
      listTeam: ['Dave', 'Eve', 'Frank'],
      score: 7,
    ),
  ];

  final List<Team> dummyTeamBList = [
    Team(
      nameTeam: 'Green Giants',
      picId: '3',
      listTeam: ['Grace', 'Hank', 'Ivy'],
      score: 2,
    ),
    Team(
      nameTeam: 'Yellow Tigers',
      picId: '4',
      listTeam: ['Jack', 'Karen', 'Leo'],
      score: 8,
    ),
  ];

  @override
  void initState() {
    _carouselController = CarouselSliderController();
    _motionTabBarController = MotionTabBarController(
      initialIndex: 1,
      length: 4,
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    _motionTabBarController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.height ?? MediaQuery.of(context).size.height * 0.15;
    final width = widget.width ?? MediaQuery.of(context).size.width;

    return Column(
      children: [
        SizedBox(
          height: height,
          width: width,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: CarouselSlider(
                  items: widget.imageUrls.map((imagePath) {
                    return CustomImageViewer.show(
                      context: context,
                      url: imagePath,
                      fit: BoxFit.cover,
                      radius: widget.isInnerStyle ? 10 : 0,
                    );
                  }).toList(),
                  carouselController: _carouselController,
                  options: CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: true,
                    viewportFraction: widget.isInnerStyle ? 0.8 : 0.95,
                    aspectRatio: widget.isInnerStyle ? 16 / 9 : 16 / 8,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                  ),
                ),
              ),
              if (widget.isInnerStyle) ...[
                Positioned(
                  left: 11,
                  child: CircleAvatar(
                    backgroundColor: Color(0xff81D8E0).withOpacity(0.8),
                    child: IconButton(
                      onPressed: () {
                        _carouselController.animateToPage(_currentPage - 1);
                      },
                      icon: const Icon(Icons.arrow_back_ios, size: 20),
                    ),
                  ),
                ),
                Positioned(
                  right: 11,
                  child: CircleAvatar(
                    backgroundColor: Color(0xff81D8E0).withOpacity(0.8),
                    child: IconButton(
                      onPressed: () {
                        _carouselController.animateToPage(_currentPage + 1);
                      },
                      icon: const Icon(Icons.arrow_forward_ios, size: 20),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.imageUrls.length, (index) {
            final isSelected = _currentPage == index;
            return GestureDetector(
              // onTap: () => _carouselController.animateToPage(index),
              onTap: () {
                // TODO: Ganti dengan data yang kamu mau kirim ke ViewMatchInfoPage
                final yourMatchInfoObj = dummyMatchInfoList[1];
                final yourTeamAObj = dummyTeamAList[1];
                final yourTeamBObj = dummyTeamBList[1];

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ViewMatchInfoPage(
                      matchInfo: yourMatchInfoObj,
                      teamA: yourTeamAObj,
                      teamB: yourTeamBObj,
                    ),
                  ),
                );
              },
              child: AnimatedContainer(
                width: widget.isInnerStyle
                    ? (isSelected ? 55 : 17)
                    : (isSelected ? 30 : 10),
                height: 10,
                margin: EdgeInsets.symmetric(horizontal: isSelected ? 6 : 3),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (widget.isInnerStyle
                          ? Color(0xff81D8E0)
                          : Colors.deepPurpleAccent)
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(40),
                ),
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              ),
            );
          }),
        ),
      ],
    );
  }
}
