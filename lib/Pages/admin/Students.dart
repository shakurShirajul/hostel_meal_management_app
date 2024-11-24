import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meal_management/Pages/admin/students/AddNewStudent.dart';
import 'package:meal_management/Pages/admin/students/ShowAllStudents.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({super.key});

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(

      body: Container(
        width: size.width,
        color: Colors.white,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Manage Students",
                    style: GoogleFonts.merriweather(
                        fontSize: 25, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddNewStudent()),
                      );
                    },
                    icon:const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    // Add your desired icon
                    label: Text(
                      "Add New Student",
                      style: GoogleFonts.merriweather(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1FAF40),
                      minimumSize: Size(double.infinity, 50),
                      // Full width, with a height of 50
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Radius of 10
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShowAllStudents()),
                      );
                    },
                    icon:const Icon(
                      Icons.view_agenda,
                      color: Colors.white,
                    ),
                    // Add your desired icon
                    label: Text(
                      "Show All Student",
                      style: GoogleFonts.merriweather(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1FAF40),
                      minimumSize: Size(double.infinity, 50),
                      // Full width, with a height of 50
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Radius of 10
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
