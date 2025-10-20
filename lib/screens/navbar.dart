import 'package:attendance_app/screens/unified_section_page.dart';
import 'package:attendance_app/theme/theme_provider.dart';
import 'package:attendance_app/theme/theme_settings_widget.dart';
import 'package:flutter/material.dart';

class NavigatorScreen extends StatefulWidget {
  final ThemeProvider themeProvider;
  
  const NavigatorScreen({
    Key? key,
    required this.themeProvider,
  }) : super(key: key);

  @override
  State<NavigatorScreen> createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigatorScreen> {
  int currentIndex = 0;
  late PageController _pageController;
  
  // Create pages with unique keys to prevent state conflicts
  late final List<Widget> listOfScreens = [
    UnifiedSectionPage(
      key: PageStorageKey<String>('grade_1'),
      grade: 1,
      gradeTitle: 'الصف الاول الثانوي',
    ),
    UnifiedSectionPage(
      key: PageStorageKey<String>('grade_2'),
      grade: 2,
      gradeTitle: 'الصف الثاني الثانوي',
    ),
    UnifiedSectionPage(
      key: PageStorageKey<String>('grade_3'),
      grade: 3,
      gradeTitle: 'الصف الثالث الثانوي',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
          _pageController.jumpToPage(index);
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "الصف الاول الثانوي ",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "الصف الثاني الثانوي ",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "الصف الثالث الثانوي",
          ),
        ],
      ),
      floatingActionButton: FloatingThemeToggle(themeProvider: widget.themeProvider),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Disable swipe to prevent conflicts
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        children: listOfScreens,
      ),
    );
  }
}
