import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matchpoint/widgets/teamInput_widget.dart';

class TeamPageWithTab extends StatelessWidget {
  const TeamPageWithTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF3FEFD),
          border: Border(
            top: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(12, 7, 12, 7),
        child: Row(
          children: [
            Expanded(
                child: Row(
              children: [
                const Icon(
                  Icons.warning_amber_outlined,
                  color: Colors.red,
                  size: 16, // sesuaikan ukuran icon
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(text: '* A Sports Type Must Be Selected\n'),
                        TextSpan(
                            text:
                                '* Both Teams Must Be Filled With At Least 1 Member'),
                      ],
                    ),
                  ),
                )
              ],
            )),
            ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade300,
              ),
              child: Text(
                'Create Match',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Material(
              color: const Color(0xFFF3FEFD),
              child: TabBar(
                indicatorColor: const Color(0xff40BBC4),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: GoogleFonts.quicksand(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelStyle: GoogleFonts.quicksand(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                tabs: const [
                  Tab(text: "Team 1"),
                  Tab(text: "Team 2"),
                ],
              ),
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  TeamInputSection(),
                  TeamInputSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
