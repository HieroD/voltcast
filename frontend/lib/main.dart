import 'package:flutter/material.dart';
import './theme/app_theme.dart';
import './screens/input_screen.dart';
import './screens/about_screen.dart';

void main() {
  runApp(const VoltCastApp());
}

class VoltCastApp extends StatelessWidget {
  const VoltCastApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VoltCast',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const InputScreen(),
    const AboutScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.darkGray.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: AppColors.white,
          selectedItemColor: AppColors.electricBlue,
          unselectedItemColor: AppColors.mediumGray,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.bolt),
              label: 'Prediksi',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info_outline),
              label: 'Tentang',
            ),
          ],
        ),
      ),
    );
  }
}