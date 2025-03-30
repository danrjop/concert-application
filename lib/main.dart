import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'screens/index.dart';
import 'constants/app_constants.dart';
import 'services/auth_service.dart';
import 'services/user_profile_service.dart';
import 'services/city/city_service_provider.dart';
import 'services/theme/theme_service.dart';

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
        ChangeNotifierProvider(
          create: (_) => CityServiceProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeService(),
        ),
      ],
      child: Consumer2<AuthService, ThemeService>(
        builder: (context, authService, themeService, _) {
          return MaterialApp(
            title: 'Concert Tracker',
            themeMode: themeService.themeMode, // Use theme service
            // Light theme definition (original)
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
            // Dark theme definition
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primaryColor: AppConstants.darkPrimaryColor,
              scaffoldBackgroundColor: AppConstants.darkBackgroundColor,
              cardColor: AppConstants.darkSurfaceColor,
              colorScheme: ColorScheme.dark(
                primary: AppConstants.darkPrimaryColor,
                secondary: AppConstants.darkSecondaryColor,
                surface: AppConstants.darkSurfaceColor,
                background: AppConstants.darkBackgroundColor,
                onBackground: AppConstants.darkTextColor,
                onSurface: AppConstants.darkTextColor,
              ),
              appBarTheme: AppBarTheme(
                color: AppConstants.darkBackgroundColor,
                elevation: 0,
                iconTheme: IconThemeData(color: AppConstants.darkTextColor),
                titleTextStyle: TextStyle(color: AppConstants.darkTextColor, fontWeight: FontWeight.bold, fontSize: 20),
              ),
              textTheme: Typography.whiteMountainView.apply(bodyColor: AppConstants.darkTextColor),
              dividerColor: Colors.grey[800],
              inputDecorationTheme: InputDecorationTheme(
                fillColor: AppConstants.darkGreyColor,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              chipTheme: ChipThemeData(
                backgroundColor: AppConstants.darkGreyColor,
                disabledColor: Colors.grey,
                selectedColor: AppConstants.darkPrimaryColor,
                secondarySelectedColor: AppConstants.darkSecondaryColor,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                labelStyle: TextStyle(color: AppConstants.darkTextColor),
                secondaryLabelStyle: TextStyle(color: AppConstants.darkTextColor),
                brightness: Brightness.dark,
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
              '/change_email': (context) => const ChangeEmailScreen(),
              '/change_password': (context) => const ChangePasswordScreen(),
              '/change_phone': (context) => const ChangePhoneScreen(),
              '/settings': (context) => const SettingsScreen(),
              '/account_information': (context) => const AccountInformationScreen(),
              '/notification_settings': (context) => const NotificationSettingsScreen(),
              '/appearance_settings': (context) => const AppearanceSettingsScreen(),
              '/privacy_settings': (context) => const PrivacySettingsScreen(),
              '/account_actions': (context) => const AccountActionsScreen(),
              '/change_home_city': (context) => const ChangeHomeCityScreen(),
            },
          );
        },
      ),
    );
  }
}
