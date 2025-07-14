import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:studentapp/Screens/calenderscreen/calenderscreen.dart';

import '../commonclass/ApiConfigClass/ApiConfig_class.dart';

class AttendanceSummary {
  final String month;
  final int present;
  final int leave;
  final int absent;

  AttendanceSummary({
    required this.month,
    required this.present,
    required this.leave,
    required this.absent,
  });

  factory AttendanceSummary.fromJson(Map<String, dynamic> json) {
    return AttendanceSummary(
      month: json['month'] ?? '',
      present: json['p'] ?? 0,
      leave: json['l'] ?? 0,
      absent: json['a'] ?? 0,
    );
  }
}

class AttendenceScreen extends StatefulWidget {
  const AttendenceScreen({super.key});

  @override
  State<AttendenceScreen> createState() => _AttendenceScreenState();
}

class _AttendenceScreenState extends State<AttendenceScreen> {
  final box = GetStorage();

  List<AttendanceSummary> monthlyAttendance = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAttendance();
  }

  Future<void> fetchAttendance() async {
    final userId = box.read("userId");
    final url = Uri.parse(ApiConfig.getAttendanceUrl(userId));
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          monthlyAttendance =
              data.map((e) => AttendanceSummary.fromJson(e)).toList();
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error fetching attendance: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4869b1),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: screenWidth * 0.045,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Attendance Screen',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.05,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: screenWidth * 0.04),
            child: Image.asset(
              'assets/images/attendence.png',
              height: screenWidth * 0.08,
              width: screenWidth * 0.08,
            ),
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : monthlyAttendance.isEmpty
              ? const Center(child: Text("No attendance data found."))
              : ListView.builder(
                itemCount: monthlyAttendance.length,
                padding: EdgeInsets.all(screenWidth * 0.04),
                itemBuilder: (context, index) {
                  final item = monthlyAttendance[index];
                  final monthParts = item.month.split('-');
                  final monthName = monthParts[0];
                  final year = monthParts[1];

                  return Container(
                    margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                    padding: EdgeInsets.all(screenWidth * 0.03),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(screenWidth * 0.04),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CalenderScreen(),
                              ),
                            );
                          },
                          child: Container(
                            width: screenWidth * 0.20,
                            height: screenWidth * 0.20,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF39c12),
                              borderRadius: BorderRadius.circular(
                                screenWidth * 0.03,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  monthName,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.045,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.005),
                                Text(
                                  year,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: screenWidth * 0.035,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.03),
                        Container(
                          height: screenWidth * 0.20,
                          width: 2,
                          color: Colors.grey,
                        ),
                        SizedBox(width: screenWidth * 0.03),
                        Expanded(
                          child: Row(
                            children: [
                              _buildStatusTile(
                                "Present",
                                item.present.toString(),
                                Colors.green,
                                screenWidth,
                              ),
                              _verticalDivider(screenHeight),
                              _buildStatusTile(
                                "Absent",
                                item.absent.toString(),
                                Colors.red,
                                screenWidth,
                              ),
                              _verticalDivider(screenHeight),
                              _buildStatusTile(
                                "Leave",
                                item.leave.toString(),
                                Colors.orange,
                                screenWidth,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }

  Widget _buildStatusTile(
    String label,
    String value,
    Color color,
    double screenWidth,
  ) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: screenWidth * 0.035,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: screenWidth * 0.015),
          Container(
            width: screenWidth * 0.08,
            height: screenWidth * 0.08,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: screenWidth * 0.032,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _verticalDivider(double screenHeight) {
    return Container(
      width: 1.5,
      height: screenHeight * 0.07,
      color: Colors.grey.shade400,
    );
  }
}
