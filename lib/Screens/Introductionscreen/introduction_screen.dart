import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studentapp/Screens/Homescreen/Home_screen.dart';
import 'package:studentapp/Screens/loginscreen/login_screen.dart';

import '../commonclass/bottombar/Bottombar.dart';

class IntroductionScreen extends StatelessWidget {
  const IntroductionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF4869b1);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final box = GetStorage();
    var usrId = box.read("userId");

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double contentWidth = constraints.maxWidth > 600 ? 600 : screenWidth;
          return ConstrainedBox(
            constraints: BoxConstraints(maxWidth: contentWidth),
            child: Column(
              children: [
                Container(
                  height: screenHeight * 0.33,
                  width: screenWidth,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor, Color(0xFF4869b1)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  padding: EdgeInsets.only(bottom: screenHeight * 0.03),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset(
                        'assets/images/tisa3.png',
                        height: screenHeight * 0.17,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      width: screenWidth,
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.04,
                        horizontal: screenWidth * 0.06,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(screenWidth * 0.16),
                          topRight: Radius.circular(screenWidth * 0.16),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Welcome Back!!",
                            style: TextStyle(
                              fontSize: screenWidth * 0.06,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.04),
                          Image.asset(
                            'assets/images/computer.png',
                            height: screenHeight * 0.18,
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          Text(
                            "TCP India is a leading company specializing in products and solutions related to agriculture, water management, and construction.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: screenWidth * 0.038,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.09),
                          SizedBox(
                            width: screenWidth,
                            height: screenHeight * 0.065,
                            child: ElevatedButton(
                              onPressed: () {
                                print("uId = ${usrId}");
                                if(usrId!=null && usrId!="00000000-0000-0000-0000-000000000000")
                                  {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(

                                        builder: (context) =>  BottomBar(),
                                      ),
                                    );
                                  }
                                else{
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(

                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                }

                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Get started",
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.045,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.02),
                                  const Icon(Icons.arrow_forward, color: Colors.white),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.05),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: 'Power By ',
                              style: TextStyle(
                                fontSize: screenWidth * 0.035,
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Jove Infoverse & Edunest(JIE)',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth * 0.035,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
