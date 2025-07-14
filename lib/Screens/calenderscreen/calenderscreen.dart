import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final List<DateTime> presentDates = [
    DateTime.utc(2025, 6, 24),
    DateTime.utc(2025, 7, 5),
    DateTime.utc(2025, 8, 15),
    DateTime.utc(2025, 9, 1),
  ];

  final List<DateTime> absentDates = [
    DateTime.utc(2025, 6, 22),
    DateTime.utc(2025, 7, 10),
    DateTime.utc(2025, 8, 18),
    DateTime.utc(2025, 9, 5),
  ];

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
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
            fontFamily: 'Lato',
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.048, // ≈ 16–18sp
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: screenWidth * 0.045),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.015,
        ),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.015),
            TableCalendar(
              firstDay: DateTime.utc(2020),
              lastDay: DateTime.utc(2030),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarStyle: CalendarStyle(
                todayDecoration: const BoxDecoration(
                  color: Colors.orangeAccent,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                ),
                weekendTextStyle: TextStyle(
                  color: Colors.redAccent,
                  fontSize: screenWidth * 0.035,
                ),
                defaultTextStyle: TextStyle(
                  fontSize: screenWidth * 0.035,
                ),
              ),
              headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                titleTextStyle: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black54, size: screenWidth * 0.05),
                rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black54, size: screenWidth * 0.05),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekendStyle: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.032,
                ),
                weekdayStyle: TextStyle(
                  color: Colors.black87,
                  fontSize: screenWidth * 0.032,
                ),
              ),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, date, _) {
                  for (final d in presentDates) {
                    if (_isSameDay(d, date)) {
                      return _buildAttendanceCircle(date.day, Colors.green, screenWidth);
                    }
                  }
                  for (final d in absentDates) {
                    if (_isSameDay(d, date)) {
                      return _buildAttendanceCircle(date.day, Colors.red, screenWidth);
                    }
                  }
                  return null;
                },
                todayBuilder: (context, date, _) {
                  return _buildAttendanceCircle(date.day, Colors.orangeAccent, screenWidth);
                },
                selectedBuilder: (context, date, _) {
                  return _buildAttendanceCircle(date.day, Colors.blueAccent, screenWidth);
                },
              ),
            ),
            SizedBox(height: screenHeight * 0.04),

            // 👇 Attendance Summary Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildAttendanceSummaryBox('Total', '60 Days', const Color(0xFF4869b1), screenWidth),
                SizedBox(width: screenWidth * 0.02),
                _buildAttendanceSummaryBox('Present', '28 Days', Colors.green, screenWidth),
                SizedBox(width: screenWidth * 0.02),
                _buildAttendanceSummaryBox('Absent', '2 Days', Colors.redAccent, screenWidth),
              ],
            ),

            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceCircle(int day, Color color, double screenWidth) {
    return Center(
      child: Container(
        width: screenWidth * 0.09,
        height: screenWidth * 0.09,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          '$day',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.032, // ≈ sp
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceSummaryBox(String title, String count, Color color, double screenWidth) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: screenWidth * 0.025),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(screenWidth * 0.03),
          border: Border.all(color: color),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: screenWidth * 0.035,
              ),
            ),
            SizedBox(height: screenWidth * 0.01),
            Text(
              count,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: color,
                fontSize: screenWidth * 0.03,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
