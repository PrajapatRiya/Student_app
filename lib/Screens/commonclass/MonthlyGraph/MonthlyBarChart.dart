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
  List<double> monthlyValues = [];
  List<String> activeMonths = [];

  final List<String> allMonths = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  void initState() {
    super.initState();
    fetchChartAttendance();
  }

  Future<void> fetchChartAttendance() async {
    try {
      final box = GetStorage();
      final userId = box.read('userId');
      if (userId == null) {
        debugPrint("❌ userId not found");
        return;
      }

      final url = ApiConfig.getChartAttendanceUrl(userId);
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final data = jsonDecode(response.body);
        if (data is List) {
          List<double> newValues = [];
          for (var item in data) {
            double? parsed;
            if (item is num) {
              parsed = item.toDouble();
            } else {
              parsed = double.tryParse(item.toString());
            }

            if (parsed != null) {
              double percentage = parsed <= 1 ? parsed * 100 : parsed;
              newValues.add(percentage.clamp(0, 100));
            }
          }

          List<String> newMonths = [];
          if (newValues.isNotEmpty) {
            int startIndex = allMonths.length - newValues.length;
            newMonths = allMonths.sublist(startIndex);
          }

          // ✅ Store in local storage for AttendanceScreen
          final List<Map<String, dynamic>> chartData = [];
          for (int i = 0; i < newMonths.length && i < newValues.length; i++) {
            chartData.add({
              "month": newMonths[i],
              "percentage": newValues[i],
            });
          }
          box.write('chartAttendanceData', chartData);

          setState(() {
            monthlyValues = newValues;
            activeMonths = newMonths;
          });
        }
      }
    } catch (e) {
      debugPrint("Error: $e");
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
                alignment: BarChartAlignment.spaceEvenly,
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
                      final monthLabel = activeMonths[groupIndex];
                      return BarTooltipItem(
                        '$monthLabel: ${rod.toY.toStringAsFixed(1)}%',
                        const TextStyle(color: Colors.white),
                      );
                    },
                  ),
                  touchCallback:
                      (FlTouchEvent event, BarTouchResponse? response) {
                    if (response != null &&
                        response.spot != null &&
                        event is FlTapUpEvent) {
                      int index = response.spot!.touchedBarGroupIndex;
                      if (index < activeMonths.length) {
                        String selectedMonth = activeMonths[index];
                        int currentYear = DateTime.now().year;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CalenderScreen(selectedMonth, currentYear),
                          ),
                        );
                      }
                    }
                  },
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 45,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index < activeMonths.length) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 4,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  activeMonths[index],
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${monthlyValues[index].toStringAsFixed(0)}%',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 10,
                      reservedSize: 35,
                      getTitlesWidget: (value, _) => Text(
                        '${value.toInt()}%',
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                  topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(monthlyValues.length, (index) {
                  final double value = monthlyValues[index];
                  Color barColor;
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
                        width: 20,
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
