import 'dart:convert';
import 'package:flutter/material.dart';
import '../commonclass/ApiConfigClass/ApiConfig_class.dart';
import 'package:http/http.dart' as http;

class FeedbackDetailsScreen extends StatefulWidget {
  final String feedbackId;

  const FeedbackDetailsScreen({super.key, required this.feedbackId});

  @override
  State<FeedbackDetailsScreen> createState() => _FeedbackDetailsScreenState();
}

class _FeedbackDetailsScreenState extends State<FeedbackDetailsScreen> {
  bool isLoading = true;
  List<Map<String, String>> feedbackData = [];

  @override
  void initState() {
    super.initState();
    fetchFeedbackById(widget.feedbackId);
  }

  Future<void> fetchFeedbackById(String feedbackId) async {
    try {
      final url = ApiConfig.getFeedbackByIdUrl(feedbackId);
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        List<Map<String, String>> loadedData = [];
        for (var item in data) {
          loadedData.add({
            "q": item["question"] ?? "",
            "a": item["answer"] ?? "",
          });
        }

        setState(() {
          feedbackData = loadedData;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
      print("Error: $e");
    }
  }

  Widget _buildAnswerWidget(String ans) {
    final starMatch = RegExp(r'(\d+)').firstMatch(ans);
    if (starMatch != null) {
      final rating = int.tryParse(starMatch.group(0)!);
      if (rating != null && rating > 0) {
        return Row(
          children: List.generate(5, (index) {
            return Icon(
              index < rating ? Icons.star : Icons.star_border,
              color:Colors.green,
              size: 22,
            );
          }),
        );
      }
    }

    // अगर rating नहीं मिली → simple text दिखाओ
    return Text(
      "A: $ans",
      style: const TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feedback Details"),
        backgroundColor: const Color(0xFF4869b1),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : feedbackData.isEmpty
          ? const Center(child: Text("No feedback found"))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: feedbackData.length,
        itemBuilder: (context, index) {
          final item = feedbackData[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Q: ${item['q']}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildAnswerWidget(item['a'] ?? ""),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
