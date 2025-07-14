import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeesScreen extends StatefulWidget {
  const FeesScreen({super.key});

  @override
  State<FeesScreen> createState() => _FeesScreenState();
}

class _FeesScreenState extends State<FeesScreen> {
  final List<Map<String, String>> feesData = const [
    {
      'title': 'Term 1 Fees',
      'date': '2025-06-01',
      'image': 'assets/images/fees1.png',
      'amount': '₹10,000',
    },
    {
      'title': 'Term 2 Fees',
      'date': '2025-06-05',
      'image': 'assets/images/fees1.png',
      'amount': '₹12,500',
    },
    {
      'title': 'Exam Fees',
      'date': '2025-06-10',
      'image': 'assets/images/fees1.png',
      'amount': '₹2,000',
    },
    {
      'title': 'Library Fees',
      'date': '2025-06-12',
      'image': 'assets/images/fees1.png',
      'amount': '₹1,500',
    },
    {
      'title': 'Lab Fees',
      'date': '2025-06-15',
      'image': 'assets/images/fees1.png',
      'amount': '₹3,000',
    },
    {
      'title': 'Sports Fees',
      'date': '2025-06-18',
      'image': 'assets/images/fees1.png',
      'amount': '₹2,500',
    },
    {
      'title': 'Annual Fees',
      'date': '2025-06-20',
      'image': 'assets/images/fees1.png',
      'amount': '₹15,000',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4869b1),
        leading: IconButton(
          icon: Icon(CupertinoIcons.back, color: Colors.white, size: screenWidth * 0.06),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Fees Screen',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.048,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: screenWidth * 0.03),
            child: Image.asset(
              'assets/images/fee.png',
              height: screenWidth * 0.07,
              width: screenWidth * 0.07,
              color: Colors.orange,
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(screenWidth * 0.04),
        itemCount: feesData.length,
        itemBuilder: (context, index) {
          final item = feesData[index];
          return buildListItem(
            item['title'] ?? '',
            item['date'] ?? '',
            item['image'] ?? '',
            item['amount'] ?? '₹0',
            screenWidth,
            screenHeight,
          );
        },
      ),
    );
  }

  Widget buildListItem(String title, String date, String imagePath, String amount, double screenWidth, double screenHeight) {
    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(screenWidth * 0.04),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(screenWidth * 0.03),
          child: Image.asset(
            imagePath,
            height: screenWidth * 0.12,
            width: screenWidth * 0.12,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.042,
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.005),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Date: $date",
                  style: TextStyle(fontSize: screenWidth * 0.035)),
              Text(
                "Amount: $amount",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: screenWidth * 0.037,
                ),
              ),
            ],
          ),
        ),
        trailing: InkWell(
          onTap: () {
            // download action
          },
          borderRadius: BorderRadius.circular(screenWidth * 0.05),
          child: Container(
            padding: EdgeInsets.all(screenWidth * 0.02),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(screenWidth * 0.05),
            ),
            child: Icon(Icons.download, color: Colors.white, size: screenWidth * 0.05),
          ),
        ),
      ),
    );
  }
}
