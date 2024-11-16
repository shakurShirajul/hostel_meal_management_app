import 'package:flutter/material.dart';
import 'package:meal_management/screen/splash/splash_screen.dart';

main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen()
      );
  }
}
