  import 'package:flutter/material.dart';
  import 'package:flutter_screenutil/flutter_screenutil.dart';
  import 'package:get_storage/get_storage.dart';
  import 'package:studentapp/Screens/Homescreen/Home_screen.dart';
  import 'package:studentapp/Screens/MaterialSScreen/Materials_Screen.dart';
  import 'package:studentapp/Screens/SplashScreen/splash_screen.dart';
  import 'package:studentapp/Screens/WelcomeScreen/WelcomeScreen.dart';
  import 'Screens/Batchscreen/Batchslot_Screen.dart';
  import 'Screens/FeedbackScreen/FeedBack_Screen.dart';
  import 'Screens/FeedbackScreen/FeedbackSuccess.dart';
  import 'Screens/FeedbackScreen/Feedbacklist_Screen.dart';
  import 'Screens/Introductionscreen/introduction_screen.dart';
  import 'Screens/LeaveRequestScreen/Leave_Screen.dart';
  import 'Screens/MettingScreen/MainMettingscreen.dart';
  import 'Screens/commonclass/CertificateScreen/Certificate_Screen.dart';
  import 'Screens/commonclass/bottombar/Bottombar.dart';

  void main() async {
    await GetStorage.init(); // Initialize storage
    runApp(MyApp());
  }

  class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
      return ScreenUtilInit(
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              fontFamily: 'Lato',
              // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
            home:SplashScreen(),
          );
        },
      );
    }
  }
