import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meal_management/Pages/admin/menu/AddMenu.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

class MenuManagement extends StatefulWidget {
  const MenuManagement({super.key});

  @override
  State<MenuManagement> createState() => _MenuManagementState();
}

class _MenuManagementState extends State<MenuManagement> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late DateTime _selectedDate;
  late String _selectedDateString;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedDateString = DateFormat('yyyy-MM-dd').format(_selectedDate);
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDate = selectedDay;
      _selectedDateString = DateFormat('yyyy-MM-dd').format(selectedDay);
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            child: Column(
              children: [
                Container(
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TableCalendar(
                        focusedDay: _selectedDate,
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2030, 12, 31),
                        selectedDayPredicate: (day) =>
                            isSameDay(day, _selectedDate),
                        onDaySelected: _onDaySelected,
                        calendarStyle: CalendarStyle(
                          defaultTextStyle: GoogleFonts.merriweather(),
                          weekendTextStyle: GoogleFonts.merriweather(),
                          selectedTextStyle: GoogleFonts.merriweather(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekdayStyle: GoogleFonts.merriweather(),
                          weekendStyle: GoogleFonts.merriweather(),
                        ),
                        headerStyle: HeaderStyle(
                          titleTextStyle: GoogleFonts.merriweather(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          titleCentered: true,
                          formatButtonVisible: false,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Lunch Menu',
                        style: GoogleFonts.merriweather(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(height: 10),
                      _buildMenuTable(_selectedDateString, 'Lunch'),
                      SizedBox(height: 20),
                      Text(
                        'Dinner Menu',
                        style: GoogleFonts.merriweather(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(height: 10),
                      _buildMenuTable(_selectedDateString, 'Dinner'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton.extended(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddLunchMenu(selectedDate: _selectedDate),
                            ),
                          );
                        },
                        label: Text(
                          'Add Menu',
                          style: GoogleFonts.merriweather(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                        icon: Icon(
                          CupertinoIcons.add,
                          color: Colors.white,
                        ),
                        backgroundColor: Color(0xFF1FAF40),
                        foregroundColor: Colors.black,
                        elevation: 0,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Meal Type
  Widget _buildMenuTable(String date, String mealType) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('meal_menus')
          .where('date', isEqualTo: date)
          .where('meal_type', isEqualTo: mealType)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'No menu available for $mealType on $date.',
              style: GoogleFonts.merriweather(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          );
        }

        double totalPrice = 0.0;
        List<Map<String, dynamic>> menuItems = [];

        for (var doc in snapshot.data!.docs) {
          var data = doc.data() as Map<String, dynamic>;
          totalPrice += data['price'] ?? 0.0;
          menuItems.add(data);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var item in menuItems)
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Rice Item:',
                            style: GoogleFonts.merriweather(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            "${item['rice'] ?? 'Unknown'}",
                            style: GoogleFonts.merriweather(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "\$${item['rice_price'] ?? 'Unknown'}",
                            textAlign: TextAlign.right,
                            style: GoogleFonts.merriweather(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Main Dish:',
                            style: GoogleFonts.merriweather(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            "${item['main_dish'] ?? 'Unknown'}",
                            style: GoogleFonts.merriweather(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "\$${item['main_dish_price'] ?? 'Unknown'}",
                            textAlign: TextAlign.right,
                            style: GoogleFonts.merriweather(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text('Second Dish:',
                              style: GoogleFonts.merriweather(
                                  fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            "${item['alternative_dish'] ?? 'Unknown'}",
                            style: GoogleFonts.merriweather(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "\$${item['alternative_dish_price'] ?? 'Unknown'}",
                            textAlign: TextAlign.right,
                            style: GoogleFonts.merriweather(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text('Drinks:',
                              style: GoogleFonts.merriweather(
                                  fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            "${item['drink'] ?? 'Unknown'}",
                            style: GoogleFonts.merriweather(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "\$${item['drink_price'] ?? 'Unknown'}",
                            textAlign: TextAlign.right,
                            style: GoogleFonts.merriweather(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text('Total Price:',
                              style: GoogleFonts.merriweather(
                                  fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "\$${item['total_price'] ?? 'Unknown'}",
                            textAlign: TextAlign.right,
                            style: GoogleFonts.merriweather(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
