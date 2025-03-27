import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/index.dart';
import 'constants/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Concert Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: AppConstants.backgroundColor,
        appBarTheme: AppBarTheme(
          color: AppConstants.backgroundColor,
          elevation: 0,
          iconTheme: IconThemeData(color: AppConstants.textColor),
          titleTextStyle: TextStyle(color: AppConstants.textColor, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ), 
      home: const MainNavigationScreen(),
    );
  }
}
