import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:meal_management/Classes/UserEmailProvider.dart';
import 'package:meal_management/Classes/UserNameProvider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class BookMeal extends StatefulWidget {
  const BookMeal({super.key});

  @override
  State<BookMeal> createState() => _BookMealState();
}

class _BookMealState extends State<BookMeal> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DateTime _selectedDay = DateTime.now();
  String _getFormattedDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
          child: Column(
            children: [
              TableCalendar(
                focusedDay: _selectedDay,
                firstDay: DateTime(2020),
                lastDay: DateTime(2030),
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                  });
                },
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
              const SizedBox(height: 20),
              Text(
                "Selected Date: ${_getFormattedDate(_selectedDay)}",
                style: GoogleFonts.merriweather(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _showMealChoiceDialog(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1FAF40),
                    padding: EdgeInsets.symmetric(
                        vertical:
                            16),
                  ),
                  child: Text(
                    "Book Meal for ${_getFormattedDate(_selectedDay)}",
                    style: GoogleFonts.merriweather(
                        fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _showMenuChoiceDialog(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1FAF40),
                    padding: EdgeInsets.symmetric(
                        vertical:
                            16),
                  ),
                  child: Text(
                    "Show Menu for ${_getFormattedDate(_selectedDay)}",
                    style: GoogleFonts.merriweather(
                        fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to show dialog to choose meal type (Lunch or Dinner)
  void _showMealChoiceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Choose Meal Type",
            style: GoogleFonts.merriweather(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(" Lunch",
                    style: GoogleFonts.merriweather(fontSize: 18)),
                onTap: () {
                  _handleMealRequest("Lunch");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(" Dinner",
                    style: GoogleFonts.merriweather(fontSize: 18)),
                onTap: () {
                  _handleMealRequest("Dinner"); // Added missing semicolon here
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMenuChoiceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Choose Meal Type to View Menu",
            style: GoogleFonts.merriweather(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  "Lunch",
                  style: GoogleFonts.merriweather(fontSize: 18),
                ),
                onTap: () {
                  _showMenuForMealType("Lunch");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(
                  "Dinner",
                  style: GoogleFonts.merriweather(fontSize: 18),
                ),
                onTap: () {
                  _showMenuForMealType("Dinner");
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleMealRequest(String mealType) async {
    String email =
        Provider.of<UserEmailProvider>(context, listen: false).userEmail;
    String name =
        Provider.of<UserNameProvider>(context, listen: false).userName;

    QuerySnapshot menuSnapshot = await _firestore
        .collection('meal_menus')
        .where('date', isEqualTo: _getFormattedDate(_selectedDay))
        .where('meal_type', isEqualTo: mealType)
        .get();

    if (menuSnapshot.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("No $mealType menu available for today."),
        backgroundColor: Colors.red,
      ));
      return;
    }

    var userDoc = menuSnapshot.docs.first;

    double? menu_total_price = userDoc['total_price'];
    QuerySnapshot existingRequest = await _firestore
        .collection('meal_requests')
        .where('email', isEqualTo: email)
        .where('meal_type', isEqualTo: mealType)
        .where('date', isEqualTo: _getFormattedDate(_selectedDay))
        .get();

    if (existingRequest.docs.isEmpty) {
      await _firestore.collection('meal_requests').add({
        'email': email,
        'name': name,
        'date': _getFormattedDate(_selectedDay),
        'meal_type': mealType,
        'total_cost': menu_total_price,
        'request_status': 'Pending',
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "$mealType request successfully placed.",
          style: GoogleFonts.merriweather(),
        ),
        backgroundColor: Colors.green,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "You have already requested $mealType for today.",
          style: GoogleFonts.merriweather(),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  void _showMenuForMealType(String mealType) async {
    String todayDate = _getFormattedDate(_selectedDay);

    QuerySnapshot menuSnapshot = await _firestore
        .collection('meal_menus')
        .where('date', isEqualTo: todayDate)
        .where('meal_type', isEqualTo: mealType)
        .get();

    if (menuSnapshot.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("No $mealType menu available for $todayDate."),
        backgroundColor: Colors.red,
      ));
      return;
    }

    var menuItems = menuSnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "$mealType Menu for ${_getFormattedDate(_selectedDay)}",
            style: GoogleFonts.merriweather(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: menuItems.map((item) {
                return Column(
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
                          child: Text(
                            'Second Dish:',
                            style: GoogleFonts.merriweather(
                                fontWeight: FontWeight.bold),
                          ),
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
                          child: Text(
                            'Drinks:',
                            style: GoogleFonts.merriweather(
                                fontWeight: FontWeight.bold),
                          ),
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
                          flex: 3,
                          child: Text(
                            'Total Price:',
                            style: GoogleFonts.merriweather(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            '\$${(item['total_price'] ?? 0.0).toStringAsFixed(2)}',
                            textAlign: TextAlign.right,
                            style: GoogleFonts.merriweather(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
