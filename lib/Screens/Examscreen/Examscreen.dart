import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExamScreen extends StatefulWidget {
  const ExamScreen({super.key});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  final List<Map<String, String>> examList = [
    {'image': 'assets/images/html.png', 'title': 'HTML', 'date': '20 June 2025', 'marks': '60 Marks'},
    {'image': 'assets/images/figma.png', 'title': 'Figma', 'date': '22 June 2025', 'marks': '80 Marks'},
    {'image': 'assets/images/css.png', 'title': 'Css', 'date': '25 June 2025', 'marks': '55 Marks'},
    {'image': 'assets/images/js.png', 'title': 'Java script', 'date': '21 June 2025', 'marks': '75 Marks'},
    {'image': 'assets/images/jquery.png', 'title': 'Jquery', 'date': '12 June 2025', 'marks': '65 Marks'},
    {'image': 'assets/images/java.png', 'title': 'Java', 'date': '15 June 2025', 'marks': 'Absent'}, // Absent
    {'image': 'assets/images/bootstrep.png', 'title': 'BootStrap', 'date': '10 June 2025', 'marks': '78 Marks'},
    {'image': 'assets/images/.net1.png', 'title': '.net', 'date': '5 June 2025', 'marks': '71 Marks'},
    {'image': 'assets/images/php1.png', 'title': 'PHP', 'date': '18 June 2025', 'marks': '86 Marks'},
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFC1D3ED),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4869b1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: screenWidth * 0.06),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'UI/UX Design',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.05,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Image.asset(
              'assets/images/exam.png',
              color: Colors.white,
              width: 30.sp,
              height: 30.sp,
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: examList.length,
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.015),
        itemBuilder: (context, index) {
          final item = examList[index];
          final String marksText = item['marks']!;
          final bool isAbsent = marksText.toLowerCase() == 'absent';
          final int? marksValue = int.tryParse(marksText.split(' ').first);

          final Color marksColor = isAbsent
              ? Colors.red
              : (marksValue != null && marksValue >= 70)
              ? Colors.green
              : const Color(0xFFF39c12);

          return Container(
            margin: EdgeInsets.only(bottom: screenHeight * 0.015),
            padding: EdgeInsets.all(screenWidth * 0.04),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(screenWidth * 0.035),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  blurRadius: screenWidth * 0.04,
                  offset: Offset(0, screenHeight * 0.005),
                ),
              ],
            ),
            child: Row(
              children: [
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(screenWidth * 0.025),
                  child: Image.asset(
                    item['image']!,
                    width: screenWidth * 0.11,
                    height: screenWidth * 0.11,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: screenWidth * 0.04),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title']!,
                        style: TextStyle(
                          fontSize: screenWidth * 0.042,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.005),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: screenWidth * 0.035, color: Colors.grey),
                          SizedBox(width: screenWidth * 0.015),
                          Text(
                            item['date']!,
                            style: TextStyle(fontSize: screenWidth * 0.037, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Marks Container
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.03,
                    vertical: screenHeight * 0.007,
                  ),
                  decoration: BoxDecoration(
                    color: marksColor,
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                  ),
                  child: isAbsent
                      ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.block, size: screenWidth * 0.04, color: Colors.white),
                      SizedBox(width: screenWidth * 0.01),
                      Text(
                        marksText,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                      : Text(
                    marksText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.bold,
                    ),
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
