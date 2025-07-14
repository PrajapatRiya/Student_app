import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studentapp/Screens/FeedbackScreen/FeedBack_Screen.dart';

class FeedbacklistScreen extends StatefulWidget {
  const FeedbacklistScreen({super.key});

  @override
  State<FeedbacklistScreen> createState() => _FeedbacklistScreenState();
}

class _FeedbacklistScreenState extends State<FeedbacklistScreen> {
  final List<String> dates = [
    '01 Jul 2025',
    '30 Jun 2025',
    '29 Jun 2025',
    '28 Jun 2025',
    '27 Jun 2025',
    '26 Jun 2025',
    '25 Jun 2025',
    '24 Jun 2025',
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF4869b1),
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Feedback List',
          style: TextStyle(
            color: Colors.white,
            fontSize: screenWidth * 0.048,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              color: Colors.white, size: screenWidth * 0.05),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: screenWidth * 0.04),
            child: Container(
              height: screenHeight * 0.05,
              width: screenHeight * 0.05,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                  )
                ],
              ),
              child: IconButton(
                icon: Icon(Icons.add,
                    color: const Color(0xFF4869b1), size: screenWidth * 0.05),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FeedbackScreen(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.02,
        ),
        itemCount: dates.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: screenHeight * 0.02),
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenHeight * 0.02,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(screenWidth * 0.03),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        color: Colors.blue, size: screenWidth * 0.06),
                    SizedBox(width: screenWidth * 0.04),
                    Text(
                      dates[index],
                      style: TextStyle(
                        fontSize: screenWidth * 0.042,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: screenHeight * 0.045,
                  width: screenHeight * 0.045,
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: screenWidth * 0.04,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
