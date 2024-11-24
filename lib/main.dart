import 'package:flutter/material.dart';
import 'package:meal_management/Classes/UserEmailProvider.dart';
import 'package:meal_management/Classes/UserNameProvider.dart';
import 'package:meal_management/Pages/Login.dart';
import 'package:meal_management/Pages/admin/AdminDashboard.dart';
import 'package:meal_management/Pages/admin/DashboardScreen.dart';
import 'package:meal_management/Pages/admin/menu/AddMenu.dart';
import 'package:meal_management/Pages/student/StudentDashboardScreen.dart';
import 'package:meal_management/firebase_options.dart';
import 'package:meal_management/screen/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserEmailProvider()),
        ChangeNotifierProvider(create: (_) => UserNameProvider()),
      ],
      child: MyApp(),
    ),
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Login()
      );
  }
}
