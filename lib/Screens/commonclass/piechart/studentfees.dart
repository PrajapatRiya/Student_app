import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class CommonFeesContainer extends StatelessWidget {
  final Map<String, double> pieDataMap;
  final double paidAmount;
  final double unpaidAmount;
  final String nextInstallmentDate;

  const CommonFeesContainer({
    super.key,
    required this.pieDataMap,
    required this.paidAmount,
    required this.unpaidAmount,
    required this.nextInstallmentDate,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(2, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Fees Overview",
            style: TextStyle(
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: screenHeight * 0.02),

          Align(
            alignment: Alignment.centerLeft,
            child: PieChart(
              dataMap: pieDataMap,
              chartRadius: screenWidth / 2.6,
              colorList: const [
                Color(0xFF4869b1),
                Color(0xFFF39c12),
              ],
              chartType: ChartType.disc,
              ringStrokeWidth: screenWidth * 0.06,
              chartValuesOptions: ChartValuesOptions(
                showChartValuesInPercentage: true,
                showChartValues: true,
                chartValueStyle: TextStyle(
                  fontSize: screenWidth * 0.03,
                  color: Colors.black,
                ),
              ),
              legendOptions: const LegendOptions(
                showLegends: true,
                legendPosition: LegendPosition.left,
              ),
            ),
          ),

          SizedBox(height: screenHeight * 0.02),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFeeBox(
                "Paid Fees",
                "₹${paidAmount.toInt()}",
                const Color(0xFF4869b1),
                screenWidth,
              ),
              _buildFeeBox(
                "Unpaid Fees",
                "₹${unpaidAmount.toInt()}",
                const Color(0xFFF39c12),
                screenWidth,
              ),
            ],
          ),

          SizedBox(height: screenHeight * 0.02),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Next Installment",
                style: TextStyle(fontSize: screenWidth * 0.035),
              ),
              Text(
                "Date: $nextInstallmentDate",
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeeBox(String title, String amount, Color bgColor, double screenWidth) {
    return Container(
      width: screenWidth * 0.38,
      padding: EdgeInsets.all(screenWidth * 0.035),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(screenWidth * 0.025),
        border: Border.all(color: bgColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.bold,
              color: bgColor,
            ),
          ),
          SizedBox(height: screenWidth * 0.015),
          Text(
            amount,
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              color: bgColor,
            ),
          ),
        ],
      ),
    );
  }
}
