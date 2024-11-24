import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meal_management/Classes/UserEmailProvider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class Calculation extends StatefulWidget {
  const Calculation({super.key});

  @override
  State<Calculation> createState() => _CalculationState();
}

class _CalculationState extends State<Calculation> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DateTime _focusedMonth = DateTime.now(); // Selected month
  double _monthlyTotalExpense = 0.0;

  @override
  void initState() {
    super.initState();
    _calculateMonthlyExpense(_focusedMonth);
  }
  Future<void> _calculateMonthlyExpense(DateTime month) async {
    String email =
        Provider.of<UserEmailProvider>(context, listen: false).userEmail;
    String startOfMonth =
        "${month.year}-${month.month.toString().padLeft(2, '0')}-01";
    String endOfMonth =
        "${month.year}-${month.month.toString().padLeft(2, '0')}-31";

    try {
      QuerySnapshot expenseSnapshot = await _firestore
          .collection('meal_requests')
          .where('email', isEqualTo: email)
          .where('date', isGreaterThanOrEqualTo: startOfMonth)
          .where('date', isLessThanOrEqualTo: endOfMonth)
          .get();
      double totalExpense = 0.0;
      for (var doc in expenseSnapshot.docs) {
        double cost = (doc['total_cost'] ?? 0.0).toDouble();
        totalExpense += cost;
      }
      setState(() {
        _monthlyTotalExpense = totalExpense;
      });
    } catch (e) {
      print("Error calculating monthly expense: $e");
      setState(() {
        _monthlyTotalExpense = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
              child: TableCalendar(
                focusedDay: _focusedMonth,
                firstDay: DateTime(2020),
                lastDay: DateTime(2030),
                calendarFormat: CalendarFormat.month,
                onPageChanged: (focusedMonth) {
                  setState(() {
                    _focusedMonth = focusedMonth;
                  });
                  _calculateMonthlyExpense(focusedMonth);
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
            ),
            const SizedBox(height: 20),
            Text(
              "Total Expense for ${_focusedMonth.month}/${_focusedMonth.year}:",
              style: GoogleFonts.merriweather(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "\$${_monthlyTotalExpense.toStringAsFixed(2)}",
              style: GoogleFonts.merriweather(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
