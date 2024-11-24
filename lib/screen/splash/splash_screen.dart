import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meal_management/Pages/Login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 2150), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: ClipRRect(
                  child: Image.asset("assets/images/splash_screen_logo.png",
                      width: size.width * 0.5, height: size.width * 0.5),
                ),
              ),
              SizedBox(height: 5),
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 1.0, end: 45),
                duration: Duration(seconds: 2),
                builder: (context, double size, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Meal ",
                        style: GoogleFonts.merriweather(
                            fontSize: size,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF455218)),
                      ),
                      Text(
                        "Mate",
                        style: GoogleFonts.merriweather(
                          fontSize: size,
                          fontWeight: FontWeight.w900,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }
}
