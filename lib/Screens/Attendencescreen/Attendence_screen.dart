import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:studentapp/Screens/calenderscreen/calenderscreen.dart';
import '../commonclass/ApiConfigClass/ApiConfig_class.dart';

class AttendanceSummary {
  final String month;
  final int present;
  final int leave;
  final int absent;
  final int holiday;
  final int total;
  final double percentage;

  AttendanceSummary({
    required this.month,
    required this.present,
    required this.leave,
    required this.absent,
    required this.holiday,
    required this.total,
    required this.percentage,
  });

  factory AttendanceSummary.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    final present = parseInt(json['p']);
    final leave = parseInt(json['l']);
    final absent = parseInt(json['a']);
    final holiday = parseInt(json['h']);
    final total = parseInt(json['t']) != 0
        ? parseInt(json['t'])
        : (present + leave + absent + holiday);

    // Handle 'per' value safely
    double per = parseDouble(json['per']);
    if (per == 0.0 && total > 0) {
      per = ((present + leave) / total) * 100;
    } else if (per <= 1) {
      per = per * 100;
    }

    return AttendanceSummary(
      month: json['month'] ?? '',
      present: present,
      leave: leave,
      absent: absent,
      holiday: holiday,
      total: total,
      percentage: per.clamp(0, 100),
    );
  }

  AttendanceSummary copyWith({double? percentage}) {
    return AttendanceSummary(
      month: month,
      present: present,
      leave: leave,
      absent: absent,
      holiday: holiday,
      total: total,
      percentage: percentage ?? this.percentage,
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
    if (userId == null) {
      debugPrint("❌ userId not found");
      return;
    }

    final attendanceUrl = Uri.parse(ApiConfig.getAttendanceUrl(userId));
    final chartUrl = Uri.parse(ApiConfig.getChartAttendanceUrl(userId));

    try {
      // Call both APIs in parallel
      final responses = await Future.wait([
        http.get(attendanceUrl),
        http.get(chartUrl),
      ]);

      final attendanceResponse = responses[0];
      final chartResponse = responses[1];

      List<AttendanceSummary> summaries = [];

      if (attendanceResponse.statusCode == 200 &&
          attendanceResponse.body.isNotEmpty) {
        final List data = json.decode(attendanceResponse.body);
        summaries = data.map((e) => AttendanceSummary.fromJson(e)).toList();
      }

      // --- Fetch chart percentages (bar graph API) ---
      List<double> chartPercentages = [];
      List<String> chartMonths = [];
      if (chartResponse.statusCode == 200 && chartResponse.body.isNotEmpty) {
        final chartData = json.decode(chartResponse.body);
        if (chartData is List) {
          for (var item in chartData) {
            double? parsed;
            if (item is num) {
              parsed = item.toDouble();
            } else {
              parsed = double.tryParse(item.toString());
            }
            if (parsed != null) {
              double percentage = parsed <= 1 ? parsed * 100 : parsed;
              chartPercentages.add(percentage.clamp(0, 100));
            }
          }

          // Create corresponding month names for these chart ratios
          final allMonths = [
            'Jan',
            'Feb',
            'Mar',
            'Apr',
            'May',
            'Jun',
            'Jul',
            'Aug',
            'Sep',
            'Oct',
            'Nov',
            'Dec'
          ];
          int startIndex = allMonths.length - chartPercentages.length;
          if (startIndex >= 0 && startIndex < allMonths.length) {
            chartMonths = allMonths.sublist(startIndex);
          }
        }
      }

      // --- Match chart ratios to attendance months ---
      for (int i = 0; i < summaries.length; i++) {
        final summary = summaries[i];
        for (int j = 0; j < chartMonths.length; j++) {
          if (summary.month.contains(chartMonths[j])) {
            summaries[i] =
                summary.copyWith(percentage: chartPercentages[j].toDouble());
          }
        }
      }

      setState(() {
        monthlyAttendance = summaries;
        isLoading = false;
      });
    } catch (e, s) {
      debugPrint("❌ Error fetching attendance data: $e");
      debugPrintStack(stackTrace: s);
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
          icon: Icon(Icons.arrow_back_ios_new,
              color: Colors.white, size: screenWidth * 0.045),
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : monthlyAttendance.isEmpty
          ? const Center(child: Text("No attendance data found."))
          : AnimationLimiter(
        child: ListView.builder(
          itemCount: monthlyAttendance.length,
          padding: EdgeInsets.all(screenWidth * 0.04),
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: _buildAttendanceItem(
                    monthlyAttendance[index],
                    screenHeight,
                    screenWidth,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAttendanceItem(
      AttendanceSummary item, double screenHeight, double screenWidth) {
    final monthParts = item.month.split('-');
    final monthName = monthParts.first;
    final year = monthParts.length > 1 ? monthParts[1] : '';

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
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  if (year.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CalenderScreen(monthName, int.parse(year)),
                      ),
                    );
                  }
                },
                child: Container(
                  width: screenWidth * 0.20,
                  height: screenWidth * 0.20,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF39c12),
                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(monthName,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: screenHeight * 0.005),
                      Text(year,
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: screenWidth * 0.035)),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatusTile("Present", item.present.toString(),
                        Colors.green, screenWidth),
                    _buildStatusTile("Absent", item.absent.toString(),
                        Colors.red, screenWidth),
                    _buildStatusTile("Leave", item.leave.toString(),
                        Colors.orange, screenWidth),
                    _buildStatusTile("Holiday", item.holiday.toString(),
                        Colors.purple, screenWidth),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Days: ${item.total}',
                  style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              Row(
                children: [
                  Text('Percentage: ',
                      style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87)),
                  Text("${item.percentage.toStringAsFixed(1)}%",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.030,
                        color: item.percentage >= 75
                            ? Colors.green
                            : item.percentage >= 50
                            ? Colors.orange
                            : Colors.red,
                      )),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTile(
      String label, String value, Color color, double screenWidth) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: screenWidth * 0.030,
                  color: Colors.black87)),
          SizedBox(height: screenWidth * 0.015),
          Container(
            width: screenWidth * 0.08,
            height: screenWidth * 0.08,
            decoration: BoxDecoration(
                color: color.withOpacity(0.15), shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(value,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: screenWidth * 0.032)),
          ),
        ],
      ),
    );
  }
}
