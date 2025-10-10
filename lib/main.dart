import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vehicle_impound_app/screens/splash_screen.dart';
import 'package:vehicle_impound_app/utils/colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Impoundly',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primary,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          primary: primary,
        ),
        useMaterial3: true,
        fontFamily: 'Regular',
        appBarTheme: const AppBarTheme(
          backgroundColor: primary,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'Bold',
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
