import 'package:flutter/material.dart';

class MaterialsScreen extends StatefulWidget {
  const MaterialsScreen({super.key});

  @override
  State<MaterialsScreen> createState() => _MaterialsScreenState();
}

class _MaterialsScreenState extends State<MaterialsScreen> {
  final List<Map<String, String>> courseList = [
    {'image': 'assets/images/html.png', 'title': 'HTML'},
    {'image': 'assets/images/figma.png', 'title': 'Figma'},
    {'image': 'assets/images/css.png', 'title': 'CSS'},
    {'image': 'assets/images/js.png', 'title': 'JavaScript'},
    {'image': 'assets/images/jquery.png', 'title': 'JQuery'},
    {'image': 'assets/images/java.png', 'title': 'Java'},
    {'image': 'assets/images/bootstrep.png', 'title': 'BootStrap'},
    {'image': 'assets/images/.net1.png', 'title': '.NET'},
    {'image': 'assets/images/php1.png', 'title': 'PHP'},
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4869b1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 19),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Materials Screen',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.06,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: screenWidth * 0.04),
            child: Image.asset(
              'assets/images/open-book.png',
              color: Colors.white,
              height: screenWidth * 0.08,
              width: screenWidth * 0.08,
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: courseList.length,
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemBuilder: (context, index) {
          final course = courseList[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 6,
                    spreadRadius: 1,
                    offset: const Offset(2, 4), // x: right, y: down
                  ),
                ],
              ),
              child: Row(
                children: [
                  Image.asset(
                    course['image']!,
                    height: screenWidth * 0.12,
                    width: screenWidth * 0.12,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      course['title']!,
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
