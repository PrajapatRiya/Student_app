import 'package:flutter/material.dart';
import 'FeedbackSuccess.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final PageController _pageController = PageController();
  int currentIndex = 0;
  final TextEditingController commentController = TextEditingController();

  final List<Map<String, dynamic>> questions = [
    {
      'question': '1) How is Your course training going?',
      'options': ['Average', 'Good', 'Excellent'],
      'selected': null,
    },
    {
      'question': '2) In your training you will find it easy to understand topics ?',
      'options': ['Yes', 'No'],
      'selected': null,
    },
    {
      'question': '3) In your training giving you Systematic guidance?',
      'options': ['Yes', 'No'],
      'selected': null,
    },
    {
      'question': '4) Are you Happy and satisfied with your experience at TCP INDIA COMPUTER EDUCATION?',
      'options': ['Yes', 'No'],
      'selected': null,
    },
    {
      'question': '5) Are you satisfied with the batch arrangement and Cleanliness of class rooms in the center?',
      'options': ['Yes', 'No'],
      'selected': null,
    },
    {
      'question': '6) Are you getting proper provision of drinking water and washroom?',
      'options': ['Yes', 'No'],
      'selected': null,
    },
    {
      'question': '7) Does your batch start on time and enough time is given?',
      'options': ['Yes', 'No'],
      'selected': null,
    },
    {
      'question': '8) How Satisfied are you with your trainer\'s ability to teach theory and practical?',
      'options': ['Average', 'Good', 'Excellent'],
      'selected': null,
    },
    {
      'question': '9) Do you want to refer your siblings or relatives?',
      'options': ['Yes', 'No'],
      'selected': null,
    },
    {
      'question': '10) Are Module tests conducted regularly in your batch?',
      'options': ['Yes', 'No'],
      'selected': null,
    },
    {
      'question': '11) Are computers available for extra practice and is a trainer available for revision?',
      'options': ['Yes', 'No'],
      'selected': null,
    },
  ];

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
        MaterialPageRoute(
          builder: (_) => const FeedbackSuccessScreen(),
        ),
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
                Image.asset(
                  'assets/images/Feedback1.png',
                  fit: BoxFit.cover,
                ),
                Container(
                  color: Colors.black.withOpacity(0.6),
                ),
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
                                ...List.generate(q['options'].length, (optionIndex) {
                                  return RadioListTile(
                                    value: optionIndex,
                                    groupValue: q['selected'],
                                    onChanged: (value) =>
                                        _onOptionSelected(index, value as int),
                                    title: Text(
                                      q['options'][optionIndex],
                                      style: TextStyle(fontSize: screenWidth * 0.042),
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
    );
  }
}
