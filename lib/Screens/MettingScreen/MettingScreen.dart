import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../commonclass/calender/attendencecalendergroup.dart';

class UpComingMettingScreen extends StatefulWidget {
  const UpComingMettingScreen({super.key});

  @override
  State<UpComingMettingScreen> createState() => _MettingScreenState();
}

class _MettingScreenState extends State<UpComingMettingScreen> {
  final PageController _pageController = PageController();
  final List<String> images = [
    'assets/images/m2.png',
    'assets/images/m_1.png',
    'assets/images/m6.png',
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4869b1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Upcoming Metting',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.groups, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SizedBox(
            height: screenHeight * 0.25,
            child: PageView.builder(
              controller: _pageController,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    images[index],
                    width: screenWidth,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: SmoothPageIndicator(
              controller: _pageController,
              count: images.length,
              effect: const WormEffect(
                dotColor: Colors.grey,
                activeDotColor: Color(0xFF4869b1),
                dotHeight: 7,
                dotWidth: 7,
              ),
            ),
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              Container(
                width: screenWidth * 0.4,
                height: 160,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF4869b1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/images/img1.png'),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: const [
                        Icon(Icons.calendar_month, color: Colors.white, size: 16),
                        SizedBox(width: 5),
                        Text(
                          '24 June 2025',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: const [
                        Icon(Icons.access_time, color: Colors.white, size: 16),
                        SizedBox(width: 5),
                        Text(
                          '10:00 to 11:00',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Container(
                  height: 160,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF39c12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/images/SUBJECT.Png',
                          height: 30,
                          width: 30,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        ' Subject: HTML',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        ' Guide: Aastha Mam ',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          const Text(
            'Student Overview',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF0FB),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Training: Web Development',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text('Roll No: 123456'),
                SizedBox(height: 4),
                Text('Location: Mumbai'),
                SizedBox(height: 4),
                Text('Email: rahul.sharma@email.com'),
                SizedBox(height: 4),
                Text('Phone: 9876543210'),
                SizedBox(height: 4),
                Text('Batch: 10:00 AM to 11:00 AM'),
                SizedBox(height: 4),
                Text('Status: Active'),
              ],
            ),
          ),

          const SizedBox(height: 20),

          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                isScrollControlled: true,
                builder: (_) => const AttendanceCalendarPopup(),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Attendance Overview',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Image.asset(
                  'assets/images/attendance.png',
                  height: 22,
                  width: 22,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildAttendanceSummaryBox('Total', '60 Days', Color(0xFF4869b1),),
              SizedBox(
                width: 5,
              ),
              _buildAttendanceSummaryBox('Present', '28 Days', Colors.green),
              SizedBox(
                width: 5,
              ),
              _buildAttendanceSummaryBox('Absent', '2 Days', Colors.redAccent),
              SizedBox(
                width: 5,
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
  Widget _buildAttendanceSummaryBox(String title, String count, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 1),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
