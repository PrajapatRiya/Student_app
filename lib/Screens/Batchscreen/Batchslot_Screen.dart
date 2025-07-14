import 'package:flutter/material.dart';

class BatchSlotScreen extends StatefulWidget {
  const BatchSlotScreen({super.key});

  @override
  State<BatchSlotScreen> createState() => _BatchSlotScreenState();
}

class _BatchSlotScreenState extends State<BatchSlotScreen> {
  final Map<String, List<String>> batchSlots = const {
    'Morning Slots': [
      '8:30 AM – 10:00 AM',
      '9:00 AM – 10:30 AM',
      '9:30 AM – 11:00 AM',
      '10:00 AM – 11:30 AM',
      '10:30 AM – 12:00 PM',
      '11:00 AM – 12:30 PM',
    ],
    'Afternoon Slots': [
      '2:00 PM – 3:30 PM',
      '2:30 PM – 4:00 PM',
      '3:00 PM – 4:30 PM',
      '3:30 PM – 5:00 PM',
      '4:00 PM – 5:30 PM',
      '4:30 PM – 6:00 PM',
      '5:00 PM – 6:30 PM',
      '5:30 PM – 7:00 PM',
    ],
  };

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Batch Slot Timings',
          style: TextStyle(
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF4869b1),
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: screenWidth * 0.03),
            child: Image.asset(
              'assets/images/time.png',
              width: screenWidth * 0.06,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(screenWidth * 0.04),
        children: [
          _buildSlotContainer('Morning Slots', const Color(0xFF4869b1), screenWidth, screenHeight),
          SizedBox(height: screenHeight * 0.03),
          _buildSlotContainer('Afternoon Slots', const Color(0xFFF39c12), screenWidth, screenHeight),
        ],
      ),
    );
  }

  Widget _buildSlotContainer(String title, Color headingColor, double screenWidth, double screenHeight) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(screenWidth * 0.02),
        color: Colors.white,
      ),
      child: Table(
        columnWidths: {
          0: FixedColumnWidth(screenWidth * 0.1),
          1: FlexColumnWidth(),
        },
        border: TableBorder.symmetric(
          inside: BorderSide(color: Colors.grey.shade300),
        ),
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: headingColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(screenWidth * 0.02),
                topRight: Radius.circular(screenWidth * 0.02),
              ),
            ),
            children: [
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.02),
                child: Icon(
                  Icons.access_time_filled,
                  size: screenWidth * 0.05,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // 🔹 Timing rows
          ...batchSlots[title]!.map((slot) {
            return TableRow(
              children: [
                Padding(
                  padding: EdgeInsets.all(screenWidth * 0.02),
                  child: Icon(
                    Icons.access_time,
                    size: screenWidth * 0.045,
                    color: Colors.black54,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.015,
                    horizontal: screenWidth * 0.02,
                  ),
                  child: Text(
                    slot,
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}
