import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../commonclass/ApiConfigClass/ApiConfig_class.dart';

class CalenderScreen extends StatefulWidget {
  final String monthName;
  final int year;

  const CalenderScreen(this.monthName, this.year, {super.key});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class AttendanceModel {
  final String date;
  final String atd;

  AttendanceModel({required this.date, required this.atd});

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      date: json['date'].toString(),
      atd: json['atd']?.toString().toUpperCase() ?? 'A',
    );
  }
}

class _CalenderScreenState extends State<CalenderScreen> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  List<DateTime> presentDates = [];
  List<DateTime> absentDates = [];
  List<DateTime> leaveDates = [];

  bool isLoading = true;

  final Map<String, int> monthMap = {
    'Jan': 1, 'January': 1,
    'Feb': 2, 'February': 2,
    'Mar': 3, 'March': 3,
    'Apr': 4, 'April': 4,
    'May': 5,
    'Jun': 6, 'June': 6,
    'Jul': 7, 'July': 7,
    'Aug': 8, 'August': 8,
    'Sep': 9, 'September': 9,
    'Oct': 10, 'October': 10,
    'Nov': 11, 'November': 11,
    'Dec': 12, 'December': 12,
  };

  @override
  void initState() {
    super.initState();

    int? monthNum = monthMap[widget.monthName];
    if (monthNum != null) {
      _focusedDay = DateTime(widget.year, monthNum, 1);
    } else {
      _focusedDay = DateTime.now();
    }

    fetchAttendanceData();
  }

  Future<void> fetchAttendanceData() async {
    final storageBox = GetStorage();
    final userId = storageBox.read("userId");

    if (userId == null) {
      presentDates.clear();
      absentDates.clear();
      leaveDates.clear();
      isLoading = false;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User ID not found. Please log in.')),
      );
      return;
    }

    final month = _focusedDay.month.toString().padLeft(2, '0');
    final year = _focusedDay.year.toString();
    final url = Uri.parse(ApiConfig.getAttendanceDayWiseUrl(userId, month, year));

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData is! List) {
          setState(() => isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid API response format')),
          );
          return;
        }

        List<AttendanceModel> dataList =
        (jsonData as List).map((item) => AttendanceModel.fromJson(item)).toList();

        presentDates.clear();
        absentDates.clear();
        leaveDates.clear();

        for (var item in dataList) {
          List<String> parts = item.date.split("-");
          if (parts.length != 3) continue;

          final date = DateTime(
            int.parse(parts[0]),
            int.parse(parts[1]),
            int.parse(parts[2]),
          );

          switch (item.atd) {
            case 'P':
              presentDates.add(date);
              break;
            case 'A':
              absentDates.add(date);
              break;
            case 'L':
              leaveDates.add(date);
              break;
          }
        }

        setState(() {
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load data: ${response.statusCode}')),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching attendance data: $e')),
      );
    }
  }

  bool _isSameDay(DateTime? a, DateTime b) {
    if (a == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget _buildAttendanceCircle(int day, Color color, double screenWidth) {
    return Center(
      child: Container(
        width: screenWidth * 0.09,
        height: screenWidth * 0.09,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: Text(
          '$day',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.04,
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceSummaryBox(
      String title,
      String count,
      Color color,
      double screenWidth,
      ) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: screenWidth * 0.04,
              ),
            ),
            Text(
              count,
              style: TextStyle(color: color, fontSize: screenWidth * 0.035),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4869b1),
        title: Text(
          'Calendar',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.048,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: screenWidth * 0.045,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.015,
        ),
        child: AnimationLimiter(
          child: Column(
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 600),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(child: widget),
              ),
              children: [
                TableCalendar(
                  firstDay: DateTime.utc(2020),
                  lastDay: DateTime.utc(2030),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => _isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                      isLoading = true;
                    });
                    fetchAttendanceData();
                  },
                  calendarStyle: const CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, date, _) {
                      if (presentDates.any((d) => _isSameDay(d, date))) {
                        return _buildAttendanceCircle(date.day, Colors.green, screenWidth);
                      }
                      if (absentDates.any((d) => _isSameDay(d, date))) {
                        return _buildAttendanceCircle(date.day, Colors.red, screenWidth);
                      }
                      if (leaveDates.any((d) => _isSameDay(d, date))) {
                        return _buildAttendanceCircle(date.day, Colors.orange, screenWidth);
                      }
                      return null;
                    },
                    todayBuilder: (context, date, _) {
                      return _buildAttendanceCircle(date.day, Colors.blue, screenWidth);
                    },
                    selectedBuilder: (context, date, _) {
                      return _buildAttendanceCircle(date.day, Colors.blueAccent, screenWidth);
                    },
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildAttendanceSummaryBox(
                      'Total',
                      '${presentDates.length + absentDates.length + leaveDates.length} Days',
                      const Color(0xFF4869b1),
                      screenWidth,
                    ),
                    _buildAttendanceSummaryBox(
                      'Present',
                      '${presentDates.length} Days',
                      Colors.green,
                      screenWidth,
                    ),
                    _buildAttendanceSummaryBox(
                      'Absent',
                      '${absentDates.length} Days',
                      Colors.redAccent,
                      screenWidth,
                    ),
                    _buildAttendanceSummaryBox(
                      'Leave',
                      '${leaveDates.length} Days',
                      const Color(0xFFFF6B35),
                      screenWidth,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
