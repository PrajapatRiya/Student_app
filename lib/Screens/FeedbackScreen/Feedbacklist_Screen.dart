import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // For date parsing
import 'package:studentapp/Screens/FeedbackScreen/FeedBack_Screen.dart';
import 'package:studentapp/Screens/FeedbackScreen/Feedback_detailes_Screen.dart';
import '../commonclass/ApiConfigClass/ApiConfig_class.dart';

// Feedback model (adjust based on actual API response)
class Feedback {
  final String id; // Adjust fields based on your API response
  final String date;

  Feedback({required this.id, required this.date});

  factory Feedback.fromJson(Map<String, dynamic> json) {
    return Feedback(
      id: json['id'].toString(),
      date: json['date'] ?? '', // Adjust based on API response
    );
  }
}

class FeedbacklistScreen extends StatefulWidget {
  const FeedbacklistScreen({super.key});

  @override
  State<FeedbacklistScreen> createState() => _FeedbacklistScreenState();
}

class _FeedbacklistScreenState extends State<FeedbacklistScreen> {
  final storageBox = GetStorage();
  List<Feedback> feedbackList = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchFeedbackList();
  }

  // Function to call GetFeedbackList API using ApiConfig
  Future<void> fetchFeedbackList() async {
    final userId = storageBox.read("userId");
    if (userId == null) {
      setState(() {
        errorMessage = "User ID not found";
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse(ApiConfig.getFeedbackListUrl(userId)), // Use ApiConfig
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          feedbackList = data.map((json) => Feedback.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Failed to load feedback: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error fetching feedback: $e";
        isLoading = false;
      });
    }
  }

  // Function to check if the date is between 1st and 5th of the month
  bool isDateBetween1And5(String dateString) {
    try {
      // Parse the date string (adjust format based on API response)
      final DateTime date = DateFormat('dd MMM yyyy').parse(dateString);
      return date.day >= 1 && date.day <= 5;
    } catch (e) {
      print('Error parsing date: $e');
      return false; // Return false if date parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final userId = storageBox.read("userId");

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF4869b1),
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Feedback List',
          style: TextStyle(
            color: Colors.white,
            fontSize: screenWidth * 0.048,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              color: Colors.white, size: screenWidth * 0.05),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: screenWidth * 0.04),
            child: Container(
              height: screenHeight * 0.05,
              width: screenHeight * 0.05,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                  )
                ],
              ),
              child: IconButton(
                icon: Icon(Icons.add,
                    color: const Color(0xFF4869b1), size: screenWidth * 0.05),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FeedbackScreen(userId: userId),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : feedbackList.isEmpty
          ? const Center(child: Text("No feedback available"))
          : ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.02,
        ),
        itemCount: feedbackList.length,
        itemBuilder: (context, index) {
          final isVisible =
          isDateBetween1And5(feedbackList[index].date);

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FeedbackDetailsScreen(
                    feedbackId: feedbackList[index].id,
                  ),
                ),
              );
            },
            child: Container(
              margin:
              EdgeInsets.only(bottom: screenHeight * 0.02),
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.02,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.circular(screenWidth * 0.03),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          color: Colors.blue,
                          size: screenWidth * 0.06),
                      SizedBox(width: screenWidth * 0.04),
                      Text(feedbackList[index].date),
                    ],
                  ),
                  if (isVisible)
                    Container(
                      height: screenHeight * 0.045,
                      width: screenHeight * 0.045,
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: screenWidth * 0.04,
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
