import 'package:flutter/material.dart';
import 'package:matchpoint/data.dart';
import 'package:matchpoint/widgets/carousel_widget.dart';
import 'package:matchpoint/widgets/matchCard_widget.dart';

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
              padding: EdgeInsets.only(left: 16, right: 16, top: 2, bottom: 2),
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
            SizedBox(height: 10),
            CustomCarousel(
              imageUrls: AppData.innerStyleImages,
              isInnerStyle: true,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 2, bottom: 2),
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
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [matchCard()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
