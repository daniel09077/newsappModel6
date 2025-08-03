import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:news_app/firebase_options.dart';
import 'package:news_app/screens/login_page.dart';
import 'package:news_app/screens/news_home_page.dart';
import 'package:news_app/models/user_profile.dart';
import 'package:news_app/screens/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:news_app/services/auth_service.dart';
import 'package:news_app/services/auth_service_base.dart'; // Needed for Provider
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    Provider<AuthServiceBase>(
      create: (_) => AuthService(),
      child: const NewsApp(),
    ),
  );
}

class NewsApp extends StatefulWidget {
  const NewsApp({super.key});

  @override
  State<NewsApp> createState() => _NewsAppState();
}

class _NewsAppState extends State<NewsApp> {
  bool _isLoggedIn = false;
  UserProfile? _loggedInUserProfile;
  bool _isLoading = true;
  bool _hasSeenOnboarding = false;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  void _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeen = prefs.getBool(onboardingSeenKey) ?? false;
    setState(() {
      _hasSeenOnboarding = hasSeen;
      _isLoading = false;
    });
  }

  void _handleOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(onboardingSeenKey, true);
    setState(() {
      _hasSeenOnboarding = true;
    });
  }

  void _handleLoginSuccess(UserProfile userProfile) {
    setState(() {
      _isLoggedIn = true;
      _loggedInUserProfile = userProfile;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthServiceBase>(context, listen: false);

    if (_isLoading) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MaterialApp(
      title: 'University News App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
        ),
        fontFamily: 'Roboto Serif',
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 57.0),
          displayMedium: TextStyle(fontSize: 45.0),
          displaySmall: TextStyle(fontSize: 36.0),
          headlineLarge: TextStyle(fontSize: 32.0),
          headlineMedium: TextStyle(fontSize: 28.0),
          headlineSmall: TextStyle(fontSize: 24.0),
          titleLarge: TextStyle(fontSize: 20.0),
          titleMedium: TextStyle(fontSize: 16.0),
          titleSmall: TextStyle(fontSize: 14.0),
          bodyLarge: TextStyle(fontSize: 16.0),
          bodyMedium: TextStyle(fontSize: 14.0),
          bodySmall: TextStyle(fontSize: 12.0),
          labelLarge: TextStyle(fontSize: 14.0),
          labelMedium: TextStyle(fontSize: 12.0),
          labelSmall: TextStyle(fontSize: 11.0),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: !_hasSeenOnboarding
          ? OnboardingScreen(onComplete: _handleOnboardingComplete)
          : _isLoggedIn && _loggedInUserProfile != null
              ? NewsHomePage(userProfile: _loggedInUserProfile!)
              : LoginPage(
                  onLoginSuccess: _handleLoginSuccess,
                  authService: authService,
                ),
    );
  }
}
