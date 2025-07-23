import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:studentapp/Screens/calenderscreen/calenderscreen.dart';
import '../ApiConfigClass/ApiConfig_class.dart';

class MonthlyBarChart extends StatefulWidget {
  @override
  State<MonthlyBarChart> createState() => _MonthlyBarChartState();
}

class _MonthlyBarChartState extends State<MonthlyBarChart> {
  final List<double> monthlyValues = [];

  final List<String> months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  void initState() {
    super.initState();
    fetchChartAttendance();
  }

  Future<void> fetchChartAttendance() async {
    final box = GetStorage();
    final userId = box.read('userId');

    if (userId == null) {
      print("❌ Error: userId not found in storage.");
      return;
    }

    final url = ApiConfig.getChartAttendanceUrl(userId);
    print("📡 Calling API: $url");

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("✅ Attendance Chart Data: $data");

        // Clear old values if any
        monthlyValues.clear();

        for (var item in data) {
          final parsed = double.tryParse(item.toString());
          if (parsed != null) {
            monthlyValues.add(parsed);
          }
        }

        print("📊 Parsed Monthly Values: $monthlyValues");

        // Refresh UI
        setState(() {});
      } else {
        print("❌ API Error: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Exception: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: monthlyValues.isEmpty
            ? const CircularProgressIndicator()
            : Container(
          width: MediaQuery.of(context).size.width * 0.95,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: AspectRatio(
            aspectRatio: 1.3,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceBetween,
                minY: 0,
                maxY: 100,
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 10,
                  getDrawingHorizontalLine: (value) =>
                      FlLine(color: Colors.grey[300], strokeWidth: 1),
                ),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.black87,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${months[group.x]}: ${rod.toY.toInt()}',
                        const TextStyle(color: Colors.white),
                      );
                    },
                  ),
                  touchCallback: (
                      FlTouchEvent event,
                      BarTouchResponse? response,
                      ) {
                    if (response != null &&
                        response.spot != null &&
                        event is FlTapUpEvent) {
                      int index = response.spot!.touchedBarGroupIndex;
                      String selectedMonth = months[index];
                      int currentYear = DateTime.now().year;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CalenderScreen(selectedMonth,currentYear),
                        ),
                      );
                    }
                  },
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 4,
                          child: Text(
                            index < months.length ? months[index] : '',
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 10,
                      reservedSize: 30,
                      getTitlesWidget: (value, _) => Text(
                        '${value.toInt()}',
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(monthlyValues.length, (index) {
                  final double value = monthlyValues[index];
                  late final Color barColor;

                  if (value < 50) {
                    barColor = Colors.redAccent;
                  } else if (value < 70) {
                    barColor = Colors.orangeAccent;
                  } else {
                    barColor = Colors.green;
                  }

                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: value,
                        width: 14,
                        borderRadius: BorderRadius.circular(6),
                        color: barColor,
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
