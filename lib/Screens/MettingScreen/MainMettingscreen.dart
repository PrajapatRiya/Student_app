import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'MettingScreen.dart';

class MettingScreen extends StatelessWidget {
  const MettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final List<Map<String, String>> meetings = [
      {
        'date': '20/03/2025',
        'time': '2:00 TO 3:00',
        'image': 'assets/images/communicate.png'
      },
      {
        'date': '21/03/2025',
        'time': '11:00 TO 12:00',
        'image': 'assets/images/communicate.png'
      },
      {
        'date': '22/03/2025',
        'time': '10:30 TO 11:30',
        'image': 'assets/images/communicate.png'
      },
      {
        'date': '23/03/2025',
        'time': '3:00 TO 4:00',
        'image': 'assets/images/communicate.png'
      },
      {
        'date': '24/03/2025',
        'time': '1:00 TO 2:00',
        'image': 'assets/images/communicate.png'
      },
      {
        'date': '25/03/2025',
        'time': '4:30 TO 5:30',
        'image': 'assets/images/communicate.png'
      },
      {
        'date': '26/03/2025',
        'time': '9:00 TO 10:00',
        'image': 'assets/images/communicate.png'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4869b1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Metting Screen',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.groups, color: Colors.white, size: 22.sp),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.02,
        ),
        itemCount: meetings.length,
        itemBuilder: (context, index) {
          final meeting = meetings[index];
          return Container(
            margin: EdgeInsets.only(bottom: screenHeight * 0.02),
            padding: EdgeInsets.all(screenWidth * 0.04),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.asset(
                    meeting['image']!,
                    height: screenHeight * 0.08,
                    width: screenHeight * 0.08,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: screenWidth * 0.03),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 18.sp, color: Colors.grey),
                          SizedBox(width: 4.w),
                          Text(
                            'Time: ',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            meeting['time']!,
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 18.sp, color: Colors.grey),
                          SizedBox(width: 4.w),
                          Text(
                            'Date: ',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            meeting['date']!,
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const UpComingMettingScreen()),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.arrow_forward, color: Colors.white, size: 20.sp),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      backgroundColor: const Color(0xFFF5F5F5),
    );
  }
}
