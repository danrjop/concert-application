import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'screens/index.dart';
import 'constants/app_constants.dart';
import 'services/auth_service.dart';
import 'services/user_profile_service.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
      create: (_) => AuthService(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProfileService(),
        ),
      ],
      child: Consumer<AuthService>(
        builder: (context, authService, _) {
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
            debugShowCheckedModeBanner: false,
            initialRoute: authService.status == AuthStatus.authenticated ? '/home' : '/signup',
            routes: {
              '/signup': (context) => const SignupScreen(),
              '/login': (context) => const LoginScreen(),
              '/home': (context) => const MainNavigationScreen(),
              '/edit_profile': (context) => const EditProfileScreen(),
              '/account_settings': (context) => const AccountSettingsScreen(),
              '/edit_name': (context) => const EditNameScreen(),
              '/edit_username': (context) => const EditUsernameScreen(),
              '/edit_bio': (context) => const EditBioScreen(),
            },
          );
        },
      ),
    );
  }
}
