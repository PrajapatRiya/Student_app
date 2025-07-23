import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:studentapp/Screens/Examscreen/Examscreen.dart';
import 'package:studentapp/Screens/FeedbackScreen/Feedbacklist_Screen.dart';
import 'package:studentapp/Screens/LeaveRequestScreen/Leave_Screen.dart';
import 'package:studentapp/Screens/MettingScreen/MainMettingscreen.dart';
import '../../Attendencescreen/Attendence_screen.dart';
import '../../Batchscreen/Batch_screen.dart';
import '../../FeedbackScreen/FeedBack_Screen.dart';
import '../../FeesScreen/Fees_Screen.dart';
import '../../Homescreen/Home_screen.dart';
import '../../MaterialSScreen/Materials_Screen.dart';
import '../../MettingScreen/MettingScreen.dart';
import '../../Profilescreen/profiles_screen.dart';
import '../CertificateScreen/Certificate_Screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});



  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;


    final storageBox = GetStorage();
    final userId = storageBox.read("userId") ?? "";

    return Container(
      width: screenWidth * 0.8,
      child: Drawer(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/drawer1.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.9),
                    Colors.black.withOpacity(0.1),
                  ],
                ),
              ),
            ),
            ListView(
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.35),
                  ),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 45,
                        backgroundImage: AssetImage('assets/images/splash.png'),
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      Text(
                        'John Doe',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.057,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.005),
                      Text(
                        'Roll No: 12',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: screenWidth * 0.035,
                        ),
                      ),
                      Text(
                        'B.Sc Computer Science',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: screenWidth * 0.035,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white70, height: 1),
                Container(
                  color: Colors.black.withOpacity(0.60),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    children: [
                      _buildDrawerTile(context, Icons.home, 'Home', const HomeScreen(), screenWidth),
                      _buildDrawerTile(context, Icons.check_circle, 'Attendance', const AttendenceScreen(), screenWidth),
                      _buildDrawerTile(context, Icons.wallet, 'Fees', const FeesScreen(), screenWidth),
                      _buildDrawerTile(context, Icons.group, 'Batch', const BatchScreen(), screenWidth),
                      _buildDrawerTile(context, Icons.assignment, 'Test Report', const ExamScreen(), screenWidth),
                      // Custom Leave Request with image icon
                      _buildDrawerTile(
                        context,
                        null,
                        'Leave Request',
                        LeaveRequestScreen(userId:userId),
                        screenWidth,
                        imageAsset: 'assets/images/leave.png',
                      ),
                      _buildDrawerTile(context, Icons.feedback, 'Feedback', const FeedbacklistScreen(), screenWidth),
                      _buildDrawerTile(context, Icons.people, 'Parents Meeting', const MettingScreen(), screenWidth),
                      _buildDrawerTile(context, Icons.book, 'Materials', const MaterialsScreen(), screenWidth),
                      _buildDrawerTile(context, Icons.card_membership, 'Certificates', const CertificateScreen(), screenWidth),
                      _buildDrawerTile(context, Icons.person, 'Profile', const ProfilesScreen(), screenWidth),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerTile(
      BuildContext context,
      IconData? icon,
      String title,
      Widget screen,
      double screenWidth, {
        String? imageAsset,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          splashColor: Colors.white24,
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white.withOpacity(0.05),
            ),
            child: Row(
              children: [
                imageAsset != null
                    ? Image.asset(
                  imageAsset,
                  width: 22,
                  height: 22,
                  color: Colors.white,
                )
                    : Icon(icon, color: Colors.white),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.043,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
