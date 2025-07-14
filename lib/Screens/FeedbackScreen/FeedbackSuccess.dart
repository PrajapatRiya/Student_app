import 'package:flutter/material.dart';
import 'package:studentapp/Screens/Homescreen/Home_screen.dart';

class FeedbackSuccessScreen extends StatelessWidget {
  const FeedbackSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/success.png',
                  height: screenHeight * 0.13,
                ),
                SizedBox(height: screenHeight * 0.04),
                Text(
                  'Thank You!',
                  style: TextStyle(
                    fontSize: screenWidth * 0.07,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF4869b1),
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),
                Text(
                  'Your feedback has been submitted successfully.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: screenHeight * 0.06),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder:  (context)=>HomeScreen()));
                 
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4869b1),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.12,
                      vertical: screenHeight * 0.018,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Back to Home',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
