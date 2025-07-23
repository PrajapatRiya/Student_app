import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../calenderscreen/calenderscreen.dart';
import '../ApiConfigClass/ApiConfig_class.dart';

final storageBox = GetStorage();

class AttendanceCalendarPopup extends StatefulWidget {
  const AttendanceCalendarPopup({super.key});

  @override
  State<AttendanceCalendarPopup> createState() =>
      _AttendanceCalendarPopupState();
}

class _AttendanceCalendarPopupState extends State<AttendanceCalendarPopup> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<DateTime> presentDates = [];
  List<DateTime> absentDates = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAttendanceData();
  }

  Future<void> fetchAttendanceData() async {
    final userId = storageBox.read("userId");

    if (userId == null) {
      setState(() {
        presentDates = [];
        absentDates = [];
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("User ID not found")));
      return;
    }

    final month = _focusedDay.month.toString().padLeft(2, '0');
    final year = _focusedDay.year.toString();
    final url = Uri.parse(
      ApiConfig.getAttendanceDayWiseUrl(userId, month, year),
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<AttendanceModel> dataList =
            (jsonData as List)
                .map((item) => AttendanceModel.fromJson(item))
                .toList();

        List<DateTime> present = [];
        List<DateTime> absent = [];

        for (var item in dataList) {
          var dt = item.date.split("-")[0];
          final date = DateTime(_focusedDay.year, _focusedDay.month, int.parse(dt));
          if (item.atd.toUpperCase() == 'P') {
            present.add(date);
          } else if (item.atd.toUpperCase() == 'A') {
            absent.add(date);
          }
        }
print("present data");
        print(present);
        setState(() {
          presentDates = present;
          absentDates = absent;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${response.statusCode}")),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to fetch attendance")),
      );
    }
  }

  bool _isPresent(DateTime day) => presentDates.any((d) => isSameDay(d, day));
  bool _isAbsent(DateTime day) => absentDates.any((d) => isSameDay(d, day));

  Widget _buildMarker(Color color) {
    return Positioned(
      right: 1,
      bottom: 1,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Attendance Calendar Popup")),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(8.0),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
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
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, date, _) {
                      if (_isPresent(date)) return _buildMarker(Colors.green);
                      if (_isAbsent(date)) return _buildMarker(Colors.red);
                      return null;
                    },
                  ),
                ),
              ),
    );
  }
}
