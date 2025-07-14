import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:get/get.dart'; // Add this

class AttendanceCalendarPopup extends StatefulWidget {
  const AttendanceCalendarPopup({super.key});

  @override
  State<AttendanceCalendarPopup> createState() => _AttendanceCalendarPopupState();
}

class _AttendanceCalendarPopupState extends State<AttendanceCalendarPopup> {
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

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.015,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(screenWidth * 0.05)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, -2),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Select Date',
            style: TextStyle(
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
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
              todayDecoration: BoxDecoration(
                color: Colors.orangeAccent,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
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
                fontSize: screenWidth * 0.04,
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
          SizedBox(height: screenHeight * 0.02),

          // ✅ Jump Button
          if (_selectedDay != null)
            ElevatedButton(
              onPressed: () {
                Get.back(); // close the bottom sheet
                Get.to(() => const AttendanceDetailsScreen()); // jump
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Go to Details"),
            ),
        ],
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
            fontSize: screenWidth * 0.035,
          ),
        ),
      ),
    );
  }
}

// ✅ Example Next Screen
class AttendanceDetailsScreen extends StatelessWidget {
  const AttendanceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Attendance Details")),
      body: const Center(child: Text("Attendance Detail Page")),
    );
  }
}
