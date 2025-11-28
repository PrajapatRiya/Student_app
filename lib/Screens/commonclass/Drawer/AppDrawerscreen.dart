import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

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
import '../ApiConfigClass/ApiConfig_class.dart';
import '../CertificateScreen/Certificate_Screen.dart';



class StudentInfo {
  final String name;
  final String rollNo;
  final String training;

  StudentInfo({
    required this.name,
    required this.rollNo,
    required this.training,
  });

  factory StudentInfo.fromJson(Map<String, dynamic> json) {
    return StudentInfo(
      name: json['name']?.toString() ?? 'N/A',
      rollNo: json['studentId']?.toString() ??
          json['id']?.toString() ??
          json['rollNo']?.toString() ??
          'N/A',
      training:
      json['course']?.toString() ?? json['training']?.toString() ?? 'N/A',
    );
  }
}

// -------------------- MAIN DRAWER CLASS --------------------
class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final storageBox = GetStorage();
  bool isLoadingStudent = true;
  StudentInfo? studentInfo;

  @override
  void initState() {
    super.initState();
    getStudentInfo();
  }

  // -------------------- API CALL FUNCTION --------------------
  Future<void> getStudentInfo() async {
    final userId = storageBox.read("userId") ?? "";
    print("userid = $userId");

    if (userId.isEmpty) {
      setState(() {
        isLoadingStudent = false;
        studentInfo =
            StudentInfo(name: 'N/A', rollNo: 'N/A', training: 'N/A');
      });
      return;
    }

    final url = Uri.parse(ApiConfig.getStudentInfoUrl(userId));
    print("student url = $url");

    try {
      final response = await http.get(url);
      print("response student = ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          studentInfo = StudentInfo.fromJson(data);
          isLoadingStudent = false;
        });
      } else {
        setState(() {
          isLoadingStudent = false;
          studentInfo =
              StudentInfo(name: 'N/A', rollNo: 'N/A', training: 'N/A');
        });
      }
    } catch (e) {
      print("Error fetching student info: $e");
      setState(() {
        isLoadingStudent = false;
        studentInfo =
            StudentInfo(name: 'N/A', rollNo: 'N/A', training: 'N/A');
      });
    }
  }

  // -------------------- UI --------------------
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
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
                // -------------------- HEADER --------------------
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  color: Colors.black.withOpacity(0.35),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 45,
                        backgroundImage: AssetImage('assets/images/splash.png'),
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      if (isLoadingStudent)
                        const CircularProgressIndicator(color: Colors.white)
                      else
                        Column(
                          children: [
                            Text(
                              studentInfo?.name ?? 'N/A',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.057,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            Text(
                              'Roll No: ${studentInfo?.rollNo ?? 'N/A'}',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: screenWidth * 0.035,
                              ),
                            ),
                            Text(
                              studentInfo?.training ?? 'N/A',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: screenWidth * 0.035,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),

                const Divider(color: Colors.white70, height: 1),

                // -------------------- MENU ITEMS --------------------
                Container(
                  color: Colors.black.withOpacity(0.60),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    children: [
                      _buildDrawerTile(context, Icons.home, 'Home',
                          const HomeScreen(), screenWidth),
                      _buildDrawerTile(context, Icons.check_circle, 'Attendance',
                          const AttendenceScreen(), screenWidth),
                      _buildDrawerTile(context, Icons.wallet, 'Fees',
                          const FeesScreen(), screenWidth),
                      _buildDrawerTile(context, Icons.group, 'Batch',
                          const BatchScreen(), screenWidth),
                      _buildDrawerTile(context, Icons.assignment, 'Test Report',
                          const ExamScreen(), screenWidth),
                      _buildDrawerTile(
                        context,
                        null,
                        'Leave Request',
                        LeaveRequestScreen(userId: userId),
                        screenWidth,
                        imageAsset: 'assets/images/leave.png',
                      ),
                      _buildDrawerTile(context, Icons.feedback, 'Feedback',
                          const FeedbacklistScreen(), screenWidth),
                      _buildDrawerTile(context, Icons.people, 'Parents Meeting',
                          const MettingScreen(), screenWidth),
                      _buildDrawerTile(context, Icons.book, 'Materials',
                          const MaterialsScreen(), screenWidth),
                      _buildDrawerTile(context, Icons.card_membership,
                          'Certificates', const CertificateScreen(), screenWidth),
                      _buildDrawerTile(context, Icons.person, 'Profile',
                          const ProfilesScreen(), screenWidth),
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

  // -------------------- TILE BUILDER --------------------
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
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => screen));
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
