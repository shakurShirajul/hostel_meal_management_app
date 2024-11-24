import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class ViewBookings extends StatefulWidget {
  const ViewBookings({super.key});

  @override
  State<ViewBookings> createState() => _ViewBookingsState();
}

class _ViewBookingsState extends State<ViewBookings> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DateTime _selectedDate = DateTime.now();
  List<Map<String, dynamic>> _mealRequests = [];

  // Get the formatted date for the selected day
  String _getFormattedDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  void initState() {
    super.initState();
    _fetchMealRequests(_selectedDate);
  }

  Future<void> _fetchMealRequests(DateTime selectedDate) async {
    String selectedDateString =
        "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('meal_requests')
          .where('date', isEqualTo: selectedDateString)
          .get();

      List<Map<String, dynamic>> mealRequests = querySnapshot.docs.map((doc) {
        // Handle null values by providing default values
        return {
          'name': doc['name'] ?? 'Unknown',
          'meal_type': doc['meal_type'] ?? 'Not Specified',
          'date': doc['date'] ?? selectedDateString,
        };
      }).toList();

      setState(() {
        _mealRequests = mealRequests;
      });
    } catch (e) {
      print("Error fetching meal requests: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        decoration:const BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TableCalendar(
                focusedDay: _selectedDate,
                firstDay: DateTime(2020),
                lastDay: DateTime(2030),
                calendarFormat: CalendarFormat.month,
                selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDate = selectedDay;
                  });
                  _fetchMealRequests(
                      selectedDay); // Fetch data for the selected day
                },
                calendarStyle: CalendarStyle(
                  defaultTextStyle: GoogleFonts.merriweather(),
                  // Font for day numbers
                  weekendTextStyle: GoogleFonts.merriweather(),
                  selectedTextStyle: GoogleFonts.merriweather(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: GoogleFonts.merriweather(),
                  // Font for weekday labels
                  weekendStyle: GoogleFonts.merriweather(),
                ),
                headerStyle: HeaderStyle(
                  titleTextStyle: GoogleFonts.merriweather(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  titleCentered: true,
                  formatButtonVisible: false, // Hide the format button
                ),
              ),
              const SizedBox(height: 20),
              // Table to show meal requests
              _mealRequests.isEmpty
                  ? Center(child: Text("No meal requests for this date",style: GoogleFonts.merriweather(
                fontSize: 20,fontWeight: FontWeight.w700, color: Color(0xFF1FAF40)
              ),))
                  : Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                        
                          child: DataTable(
                            columns: [
                              DataColumn(
                                  label: Text("Name",
                                      style: GoogleFonts.merriweather(
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text("Meal Type",
                                      style: GoogleFonts.merriweather(
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text("Date",
                                      style: GoogleFonts.merriweather(
                                          fontWeight: FontWeight.bold))),
                            ],
                            rows: _mealRequests.map((request) {
                              return DataRow(cells: [
                                DataCell(Text(request['name'],
                                    style: GoogleFonts.merriweather())),
                                DataCell(Text(request['meal_type'],
                                    style: GoogleFonts.merriweather())),
                                DataCell(Text(request['date'],
                                    style: GoogleFonts.merriweather())),
                              ]);
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
