import 'dart:convert';
import 'package:flutter/material.dart';
import '../commonclass/ApiConfigClass/ApiConfig_class.dart';
import 'FeedbackSuccess.dart';
import 'package:http/http.dart' as http;

class FeedbackScreen extends StatefulWidget {
  final String userId;
  const FeedbackScreen({super.key, required this.userId});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final PageController _pageController = PageController();
  bool isLoading = true;
  bool isSubmitting = false;
  int currentIndex = 0;
  List<dynamic> questions1 = [];
  List<dynamic> submitedFeedback = [];
  final List<Map<String, dynamic>> questions = [];
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchQuestions();
    commentController.addListener(() {
      debugPrint("📝 Real-time Comment: ${commentController.text}");
    });
  }

  Future<void> fetchQuestions() async {
    try {
      final url = ApiConfig.getFeedbackQuestionsUrl(widget.userId);
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          questions1 = data;
          for (int i = 0; i < questions1.length; i++) {
            questions.add(questions1[i]);
          }
          isLoading = false;
          debugPrint("✅ Questions loaded: ${questions.length}");
        });
      } else {
        throw Exception("Failed to load questions: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> submitFeedback() async {
    try {
      setState(() => isSubmitting = true);
      final url = ApiConfig.getFeedbackSubmitUrl(widget.userId); // Pass userId if required
      final payload = {
        'samId': widget.userId,
        'feedback': submitedFeedback,
      };
      debugPrint("📤 Sending payload: ${jsonEncode(payload)}");
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        debugPrint("✅ Feedback submitted successfully: ${response.body}");
        setState(() => submitedFeedback.clear()); // Clear after success
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
            "Failed to submit feedback: ${response.statusCode} - ${errorData['message'] ?? 'Unknown error'}");
      }
    } catch (e) {
      setState(() => isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error submitting feedback: $e"),
          action: SnackBarAction(
            label: 'Retry',
            onPressed: _nextQuestion,
          ),
        ),
      );
      rethrow; // Rethrow to prevent navigation on error
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  void _nextQuestion() async {
    if (currentIndex < questions.length) {
      setState(() {
        currentIndex++;
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    } else {
      // Validate all questions answered
      if (questions.any((q) => q['selected'] == null)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please answer all questions!")),
        );
        return;
      }

      // Validate comment
      String comment = commentController.text.trim();
      if (comment.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter a comment!")),
        );
        return;
      }

      setState(() {
        submitedFeedback.clear(); // Clear previous feedback
        for (int i = 0; i < questions.length; i++) {
          final qText = questions[i]['question'];
          final selectedIndex = questions[i]['selected'];
          final ans = selectedIndex != null
              ? (selectedIndex + 1).toString()
              : "0";
          submitedFeedback.add({"question": "$qText", "answer": ans});
          debugPrint("Q${i + 1}: $qText");
          debugPrint("Ans: $ans");
        }
        String comment = commentController.text.trim();
        debugPrint("📝 Final Comment on Submit: $comment");
        submitedFeedback.add({"question": "Final Comment", "answer": comment});
      });


      // Submit feedback to API
      try {
        await submitFeedback();
        // Navigate only if submission was successful
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FeedbackSuccessScreen()),
        );
      } catch (e) {
        // Navigation is prevented if submitFeedback throws an error
      }
    }
  }

  @override
  void dispose() {
    commentController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: screenHeight * 0.45,
                  width: screenWidth,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset('assets/images/Feedback1.png', fit: BoxFit.cover),
                      Container(color: Colors.black.withOpacity(0.6)),
                    ],
                  ),
                ),
                Expanded(
                  child: SafeArea(
                    top: false,
                    child: Column(
                      children: [
                        Expanded(
                          child: isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : PageView.builder(
                            controller: _pageController,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: questions.length + 1,
                            itemBuilder: (context, index) {
                              if (index < questions.length) {
                                final q = questions[index];
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.05,
                                    vertical: screenHeight * 0.025,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        q['question'],
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.045,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: screenHeight * 0.02),
                                      Row(
                                        children: List.generate(5, (starIndex) {
                                          final isFilled = (q['selected'] ?? -1) >= starIndex;
                                          return IconButton(
                                            onPressed: () {
                                              setState(() {
                                                q['selected'] = starIndex;
                                              });
                                            },
                                            icon: Icon(
                                              isFilled ? Icons.star : Icons.star_border,
                                              color: Colors.green,
                                              size: screenWidth * 0.08,
                                            ),
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return SingleChildScrollView(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.05,
                                      vertical: screenHeight * 0.025,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Your special comment:',
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.045,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: screenHeight * 0.015),
                                        TextFormField(
                                          controller: commentController,
                                          maxLines: 5,
                                          minLines: 3,
                                          decoration: InputDecoration(
                                            hintText: 'Write here...',
                                            hintStyle: TextStyle(fontSize: screenWidth * 0.04),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            contentPadding: EdgeInsets.all(screenWidth * 0.04),
                                          ),
                                        ),
                                        SizedBox(height: screenHeight * 0.02),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: screenWidth * 0.05,
                              bottom: screenHeight * 0.02,
                            ),
                            child: GestureDetector(
                              onTap: isSubmitting ? null : _nextQuestion,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.05,
                                  vertical: screenHeight * 0.015,
                                ),
                                decoration: BoxDecoration(
                                  color: isSubmitting ? Colors.grey : const Color(0xFF4869b1),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      currentIndex == questions.length ? 'Submit' : 'Next',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenWidth * 0.042,
                                      ),
                                    ),
                                    SizedBox(width: screenWidth * 0.02),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                      size: screenWidth * 0.05,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (isSubmitting)
              const Center(child: CircularProgressIndicator()),
          ],
        ));
  }
}
