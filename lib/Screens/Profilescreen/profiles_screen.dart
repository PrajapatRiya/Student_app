import 'package:flutter/material.dart';

class ProfilesScreen extends StatefulWidget {
  const ProfilesScreen({super.key});

  @override
  State<ProfilesScreen> createState() => _ProfilesScreenState();
}

class _ProfilesScreenState extends State<ProfilesScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFd0daef),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4869b1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white,size: 19,),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Profile Screen',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.06,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: screenWidth * 0.04),
            child: Image.asset(
              'assets/images/edit.png',
              color: Colors.orange,
              height: screenWidth * 0.08,
              width: screenWidth * 0.08,
            ),
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFFd0daef),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.015,
          ),
          child: ListView(
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      width: screenHeight * 0.12,
                      height: screenHeight * 0.12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                        image: const DecorationImage(
                          image: AssetImage('assets/images/splash.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Riya Oza",
                      style: TextStyle(
                        fontSize: screenWidth * 0.07,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF4869b1),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              _infoCardWithIcon(
                iconPath: 'assets/images/card.png',
                title: "Student ID",
                value: "TCP-MS-25/26-04-0001",
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),
              _infoCardWithIcon(
                iconPath: 'assets/images/Addmisson.png',
                title: "Admission Date",
                value: "10-04-2025",
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),
              _infoCardWithIcon(
                iconPath: 'assets/images/course.png',
                title: "Course",
                value: "Best UI UX Design Course\nTCPIndia, Mehsana",
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),
              _infoCardWithIcon(
                iconPath: 'assets/images/attendence.png',
                title: "Batch / Year",
                value: "2024 - 2025",
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),
              _infoCardWithIcon(
                iconPath: 'assets/images/telephone.png',
                title: "Mobile Number",
                value: "9099858370",
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),
              _infoCardWithIcon(
                iconPath: 'assets/images/map.png',
                title: "Address",
                value: "kANAP FLAT, Near ASHIRVAD FLAT , T.B ROAD - MEHSANA",
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCardWithIcon({
    required String iconPath,
    required String title,
    required String value,
    required double screenWidth,
    required double screenHeight,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.015),
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            iconPath,
            height: screenHeight * 0.04,
            width: screenHeight * 0.03,
            fit: BoxFit.contain,
          ),
          SizedBox(width: screenWidth * 0.04),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: "$title:\n",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: screenWidth * 0.043,
                ),
                children: [
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: screenWidth * 0.042,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
