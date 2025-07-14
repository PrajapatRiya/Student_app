import 'package:flutter/material.dart';
import 'package:studentapp/Screens/Batchscreen/Batchslot_Screen.dart';

class BatchScreen extends StatefulWidget {
  const BatchScreen({super.key});

  @override
  State<BatchScreen> createState() => _BatchScreenState();
}

class _BatchScreenState extends State<BatchScreen> {
  final List<Map<String, String>> courseList = [
    {
      'title': 'SDLC',
      'status': 'Active',
      'time': '9:30 - 10:30',
      'date': '1-1-2025 - 30-1-2025',
      'image': 'assets/images/SDLC.png'
    },
    {
      'title': 'HTML',
      'status': 'Pending',
      'time': '11:00 - 12:00',
      'date': '2-1-2025 - 15-2-2025',
      'image': 'assets/images/html.png'
    },
    {
      'title': 'CSS',
      'status': 'Completed',
      'time': '12:00 - 1:00',
      'date': '3-1-2025 - 10-2-2025',
      'image': 'assets/images/css.png'
    },
    {
      'title': 'Bootstrap',
      'status': 'Active',
      'time': '2:00 - 3:00',
      'date': '4-1-2025 - 28-2-2025',
      'image': 'assets/images/bootstrep.png'
    },
    {
      'title': 'jQuery',
      'status': 'Pending',
      'time': '3:30 - 4:30',
      'date': '5-1-2025 - 25-2-2025',
      'image': 'assets/images/jquery.png'
    },
    {
      'title': 'JavaScript',
      'status': 'Active',
      'time': '5:00 - 6:00',
      'date': '6-1-2025 - 20-2-2025',
      'image': 'assets/images/java.png'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4869b1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BatchSlotScreen()),
            );
          },
          child: Text(
            'Batch Screen',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.06,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: screenWidth * 0.04),
            child: Image.asset(
              'assets/images/batch.png',
              color: Colors.orange,
              height: screenWidth * 0.08,
              width: screenWidth * 0.08,
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: courseList.length,
        itemBuilder: (context, index) {
          final item = courseList[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Image (Asset)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      item['image']!,
                      height: screenWidth * 0.10,
                      width: screenWidth * 0.10,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title & Fixed Upcoming Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item['title']!,
                              style: TextStyle(
                                fontSize: screenWidth * 0.042,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              width: screenWidth * 0.24,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.007),
                              decoration: BoxDecoration(
                                color:  Color(0xFFF39c12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Upcoming',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.03,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // Time
                        Row(
                          children: [
                            const Icon(Icons.access_time,
                                size: 16, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text(item['time']!,
                                style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // Date
                        Row(
                          children: [
                            const Icon(Icons.calendar_today,
                                size: 16, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text(item['date']!,
                                style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
