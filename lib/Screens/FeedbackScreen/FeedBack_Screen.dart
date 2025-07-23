import 'dart:convert';

import 'package:flutter/cupertino.dart';
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
  int currentIndex = 0;
  List<dynamic> questions1 = [];
  final List<Map<String, dynamic>> questions=[];
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async{
    try{
      final url = ApiConfig.getFeedbackQuestionsUrl(widget.userId);

      final response = await http.get(Uri.parse(url));



      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          questions1 = data;
          print("ele => "+ questions1.length.toString());
          for(int i=0;i<questions1.length;i++){
            print(questions1[i]);

            questions.add(questions1[i]);
          }
          print("questions");
          print(questions);
        });

      }
    }
    catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  void _onOptionSelected(int questionIndex, int selectedOptionIndex) {
    setState(() {
      questions[questionIndex]['selected'] = selectedOptionIndex;
    });
  }

  void _nextQuestion() {
    if (currentIndex < questions.length) {
      setState(() {
        currentIndex++;
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    } else {
      String comment = commentController.text;
      print("Comment submitted: $comment");

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const FeedbackSuccessScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
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
                    child: PageView.builder(
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
                                ...List.generate(q['options'].length, (
                                  optionIndex,
                                ) {
                                  return RadioListTile(
                                    value: optionIndex,
                                    groupValue: q['selected'],
                                    onChanged:
                                        (value) => _onOptionSelected(
                                          index,
                                          value as int,
                                        ),
                                    title: Text(
                                      q['options'][optionIndex],
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.042,
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          );
                        } else {
                          return Padding(
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
                                  decoration: InputDecoration(
                                    hintText: 'Write here...',
                                    hintStyle: TextStyle(
                                      fontSize: screenWidth * 0.04,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                              ],
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
                        onTap: _nextQuestion,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05,
                            vertical: screenHeight * 0.015,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4869b1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                currentIndex == questions.length
                                    ? 'Submit'
                                    : 'Next',
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
    );
  }
}
