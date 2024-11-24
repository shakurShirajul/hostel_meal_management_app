import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:meal_management/Classes/UserEmailProvider.dart';
import 'package:meal_management/Classes/UserNameProvider.dart';
import 'package:provider/provider.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int totalMealRequests = 0;
  int totalAmountSpent = 0;

  @override
  void initState() {
    super.initState();
    _fetchMealData();
  }

  Future<void> _fetchMealData() async {
    String email = Provider.of<UserEmailProvider>(context, listen: false).userEmail;
    try {
      DateTime now = DateTime.now();
      DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
      DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
      String firstDayFormatted =
          DateFormat('yyyy-MM-dd').format(firstDayOfMonth);
      String lastDayFormatted = DateFormat('yyyy-MM-dd').format(lastDayOfMonth);
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(
              'meal_requests')
          .where('email', isEqualTo: email)
          .where('date', isGreaterThanOrEqualTo: firstDayFormatted)
          .where('date', isLessThanOrEqualTo: lastDayFormatted)
          .get();

      int mealCount = 0;
      int amountSpent = 0;
      for (var doc in querySnapshot.docs) {
        mealCount++;
        amountSpent += (doc['total_cost'] as num?)?.toInt() ?? 0;
      }
      setState(() {
        totalMealRequests = mealCount;
        totalAmountSpent = amountSpent;
      });
    } catch (e) {
      print('Error fetching meal data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String name = Provider.of<UserNameProvider>(context).userName;
    DateTime now = DateTime.now();
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: size.width,
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Hi $name,",
                      style: GoogleFonts.merriweather(fontSize: 22),
                    ),
                    const Icon(
                      Icons.notifications,
                      size: 35.0,
                      color: Colors.orange,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Container(
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(
                              Icons.lunch_dining,
                              size: 35.0,
                              color: Colors.white,
                            ),
                            Text(
                              '$totalMealRequests',
                              style: GoogleFonts.merriweather(
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Total Meal Requests\nMonth: ${DateFormat('MMMM').format(now)}',
                          style: GoogleFonts.merriweather(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.attach_money,
                              size: 35.0,
                              color: Colors.white,
                            ),
                            Text(
                              '\$${totalAmountSpent}',
                              style: GoogleFonts.merriweather(
                                  fontSize: 40,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Total Amount Spent\nMonth: ${DateFormat('MMMM').format(now)}',
                          style: GoogleFonts.merriweather(
                              fontSize: 18,  fontWeight: FontWeight.w900,
                            color: Colors.white,),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
