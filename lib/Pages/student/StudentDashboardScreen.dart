import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meal_management/Pages/student/Calculation/Calculation.dart';
import 'package:meal_management/Pages/student/Dashboard/StudentDashboard.dart';
import 'package:meal_management/Pages/student/Meal/BookMeal.dart';
import 'package:meal_management/services/auth_service.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = <Widget>[
    StudentDashboard(),
    BookMeal(),
    Calculation(),
  ];
  void _logout() {
    AuthService().signout(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 3) {
            _logout();
          } else {
            _onItemTapped(index);
          }
        },
        items: [
           BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Book Meal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Calculation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app),
            label: 'Logout',
          ),
        ],
        selectedItemColor: Color(0xFF1FAF40),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        selectedLabelStyle: GoogleFonts.merriweather(),
        unselectedLabelStyle: GoogleFonts.merriweather(),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
