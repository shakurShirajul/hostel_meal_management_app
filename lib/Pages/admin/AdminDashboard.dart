import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:meal_management/Classes/UserNameProvider.dart';
import 'package:meal_management/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int todayMealRequests = 0;
  double todayIncome = 0.0;
  int prevDayMealRequests = 0;
  double prevDayIncome = 0.0;
  bool isTrendingUp = true;
  int studentCount = 0;
  String name = '';

  Future<void> fetchData() async {
    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String yesterdayDate = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(Duration(days: 1)));

    try {
      QuerySnapshot todaySnapshot = await _firestore
          .collection('meal_requests')
          .where('date', isEqualTo: todayDate)
          .get();

      int totalMealRequests = todaySnapshot.docs.length;
      double totalCost = todaySnapshot.docs.fold(0.0, (sum, doc) {
        return sum + (doc['total_cost'] ?? 0);
      });

      QuerySnapshot yesterdaySnapshot = await _firestore
          .collection('meal_requests')
          .where('date', isEqualTo: yesterdayDate)
          .get();

      int prevMealRequests = yesterdaySnapshot.docs.length;
      double prevTotalCost = yesterdaySnapshot.docs.fold(0.0, (sum, doc) {
        return sum + (doc['total_cost'] ?? 0);
      });

      QuerySnapshot studentSnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'student')
          .get();

      int totalStudents = studentSnapshot.docs.length;

      setState(() {
        todayMealRequests = totalMealRequests;
        todayIncome = totalCost;
        prevDayMealRequests = prevMealRequests;
        prevDayIncome = prevTotalCost;
        studentCount = totalStudents;
        isTrendingUp = (totalMealRequests > prevMealRequests) &&
            (totalCost > prevTotalCost);
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    String name = Provider.of<UserNameProvider>(context).userName;
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: size.width,
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
            child: Column(
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                                Icon(
                                  Icons.people,
                                  size: 35.0,
                                  color: Colors.white,
                                ),
                                Text(
                                  "$studentCount",
                                  style: GoogleFonts.merriweather(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Total,\nStudents",
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
                    SizedBox(height: 15),
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
                                  isTrendingUp
                                      ? Icons.trending_up
                                      : Icons.trending_down,
                                  size: 35.0,
                                  color:
                                      isTrendingUp ? Colors.green : Colors.red,
                                ),
                                Text(
                                  "$todayMealRequests",
                                  style: GoogleFonts.merriweather(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Today,\nMeal Request",
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
                    // Total income container
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: size.width,
                      decoration: BoxDecoration(
                        color: Colors.lightBlueAccent,
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
                                  isTrendingUp
                                      ? Icons.trending_up
                                      : Icons.trending_down,
                                  size: 35.0,
                                  color:
                                      isTrendingUp ? Colors.green : Colors.red,
                                ),
                                Text(
                                  "\$${todayIncome.toStringAsFixed(2)}",
                                  style: GoogleFonts.merriweather(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Today,\nTotal Earning",
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
