import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:studentapp/Screens/Introductionscreen/introduction_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => currentPage = index);
            },
            children: [
              buildIntroPage(screenHeight, screenWidth, 'assets/images/welcome1.jpg', ),
              buildIntroPage(screenHeight, screenWidth, 'assets/images/welcome2.jpg'),
              buildIntroPage(screenHeight, screenWidth, 'assets/images/welcome3.jpg'),
              const IntroductionScreen(),
            ],
          ),

          if (currentPage != 3)
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      _pageController.jumpToPage(3);
                    },
                    child: Text("Skip", style: TextStyle(fontSize: 14.sp)),
                  ),
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: 4,
                    effect: ExpandingDotsEffect(
                      dotHeight: 7,
                      dotWidth: 7,
                      activeDotColor: Colors.blueAccent,
                      dotColor: Colors.grey.shade300,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (currentPage == 3) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const IntroductionScreen(),
                          ),
                        );
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Icon(
                      currentPage == 3 ? Icons.check : Icons.arrow_forward,
                      size: 22.sp,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget buildIntroPage(double screenHeight, double screenWidth, String imagePath, {bool isFirst = false}) {
    return Container(
      padding: isFirst
          ? EdgeInsets.zero
          : EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.05),

          // 🔹 Image
          SizedBox(
            height: screenHeight * 0.37,
            width: double.infinity,
            child: Image.asset(
              imagePath,
              fit: isFirst ? BoxFit.cover : BoxFit.contain,
            ),
          ),

          SizedBox(height: screenHeight * 0.09),
          Container(
            width: double.infinity,
            color: const Color(0xFFF39c12),
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.02,
              vertical: screenHeight * 0.01,
            ),
            child: Text(
              "STEP INTO THE WORLD OF OPPORTUNITY",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: screenHeight * 0.02),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "WITH SKILLS ",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
                TextSpan(
                  text: "THAT EMPLOYERS VALUE\nAND INDUSTRIES DEMAND.",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: screenHeight * 0.035),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.06,
                    vertical: screenHeight * 0.015,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4869b1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "JOIN TCP INDIA",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),
                Text(
                  "Where Learning\nBecomes Leadership",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),
          SizedBox(height: screenHeight * 0.08),
        ],
      ),
    );
  }
}
