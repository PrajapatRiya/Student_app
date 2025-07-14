import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:studentapp/Screens/Attendencescreen/Attendence_screen.dart';
import 'package:studentapp/Screens/Homescreen/Home_screen.dart';
import 'package:studentapp/Screens/Profilescreen/profiles_screen.dart';
import '../../FeesScreen/Fees_Screen.dart';

class BottomBar extends StatefulWidget {
  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int selectedIndex = 0;

  final List<Widget> screens = [
    HomeScreen(),
    AttendenceScreen(),
    FeesScreen(),
    ProfilesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: screens[selectedIndex],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: Colors.white.withOpacity(0.6),
            child: SalomonBottomBar(
              currentIndex: selectedIndex,
              onTap: (i) => setState(() => selectedIndex = i),
              items: [
                SalomonBottomBarItem(
                  icon: Icon(Icons.home),
                  title: Text("Home"),
                  selectedColor: Color(0xFF4869b1),
                ),
                SalomonBottomBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  title: Text("Attendance"),
                  selectedColor: Color(0xFF4869b1),
                ),
                SalomonBottomBarItem(
                  icon: Icon(Icons.account_balance_wallet_outlined),
                  title: Text("Fees"),
                  selectedColor: Color(0xFF4869b1),
                ),
                SalomonBottomBarItem(
                  icon: Icon(Icons.person_outline),
                  title: Text("Profile"),
                  selectedColor: Color(0xFF4869b1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
