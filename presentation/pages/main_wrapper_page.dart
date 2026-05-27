import 'package:flutter/material.dart';
import 'package:discover_app/features/discover/presentation/pages/discover_page.dart';

class MainWrapperPage extends StatefulWidget {
  const MainWrapperPage({super.key});

  @override
  State<MainWrapperPage> createState() => _MainWrapperPageState();
}

class _MainWrapperPageState extends State<MainWrapperPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DiscoverPage(), 
    const Center(child: Text('Games Screen', style: TextStyle(color: Colors.white))),     
    const Center(child: Text('New & Hot', style: TextStyle(color: Colors.white))),       
    const Center(child: Text('Fast Laughs', style: TextStyle(color: Colors.white))),     
    const Center(child: Text('Downloads', style: TextStyle(color: Colors.white))),       
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.sports_esports_outlined), label: 'Games'),
          BottomNavigationBarItem(icon: Icon(Icons.video_library_outlined), label: 'New & Hot'),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_emotions_outlined), label: 'Fast Laughs'),
          BottomNavigationBarItem(icon: Icon(Icons.download_for_offline_outlined), label: 'Downloads'),
        ],
      ),
    );
  }
}