import 'package:flutter/material.dart';
import 'utils/theme.dart';
import 'screens/chatbot_page.dart';
import 'screens/sentiment_page.dart';

void main() => runApp(const BudayaAcehApp());

class BudayaAcehApp extends StatelessWidget {
  const BudayaAcehApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laskar Budaya Aceh',
      theme: appTheme,
      home: const MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  static const List<Widget> _pages = <Widget>[
    ChatbotPage(),
    SentimentAnalysisPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Laskar Budaya Aceh')),
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Chat Budaya',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            activeIcon: Icon(Icons.analytics),
            label: 'Analisis Sentimen',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
