import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:studentapp/Screens/Batchscreen/Batchslot_Screen.dart';

import '../commonclass/ApiConfigClass/ApiConfig_class.dart';

class BatchScreen extends StatefulWidget {
  const BatchScreen({super.key});

  @override
  State<BatchScreen> createState() => _BatchScreenState();
}

class _BatchScreenState extends State<BatchScreen> {
  List<Map<String, dynamic>> courseList = [];
  bool isLoading = true;

  final storageBox = GetStorage();

  @override
  void initState() {
    super.initState();
    fetchBatchList();
  }

  Future<void> fetchBatchList() async {
    try {
      final userId = storageBox.read("userId");

      final url = ApiConfig.getBatchListUrl(userId);
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);

        courseList = data.map((item) {
          return {
            "title": item["batchTitle"] ?? "",
            "date": item["batchDate"] ?? "",
            "time": item["batchTime"] ?? "",
            "status": item["batchStatus"] ?? "",
          };
        }).toList().cast<Map<String, dynamic>>(); // 🔹 ab dynamic cast

        setState(() => isLoading = false);
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Error fetching batch list: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4869b1),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: screenWidth * 0.05,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BatchSlotScreen()),
            );
          },
          child: Text(
            'Batch Screen',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.055,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: screenWidth * 0.04),
            child: Image.asset(
              'assets/images/docs.png',
              color: Colors.orange,
              height: screenHeight * 0.035,
              width: screenHeight * 0.035,
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: EdgeInsets.all(screenWidth * 0.03),
        itemCount: courseList.length,
        itemBuilder: (context, index) {
          final item = courseList[index];
          return Card(
            margin: EdgeInsets.only(bottom: screenHeight * 0.015),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(screenWidth * 0.03),
            ),
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.03),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(screenWidth * 0.02),
                    child: Image.asset(
                      'assets/images/batch.png',
                      height: screenWidth * 0.15,
                      width: screenWidth * 0.15,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${item['title']}", // 🔹 dynamic ke liye string interpolation
                              style: TextStyle(
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              width: screenWidth * 0.25,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.006,
                                horizontal: screenWidth * 0.02,
                              ),
                              decoration: BoxDecoration(
                                color: (item['status'] == "Pending")
                                    ? Colors.yellow
                                    : (item['status'] == "Running")
                                    ? Colors.orange
                                    : (item['status'] == "Completed")
                                    ? Colors.green
                                    : Colors.grey, // fallback if API sends something else
                                borderRadius: BorderRadius.circular(
                                  screenWidth * 0.05,
                                ),
                              ),
                              child: Text(
                                "${item['status']}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.032,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                          ],
                        ),
                        SizedBox(height: screenHeight * 0.008),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: screenWidth * 0.04,
                              color: Colors.grey,
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            Text(
                              "${item['time']}",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: screenWidth * 0.035,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.006),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: screenWidth * 0.04,
                              color: Colors.grey,
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            Text(
                              "${item['date']}",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: screenWidth * 0.035,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
