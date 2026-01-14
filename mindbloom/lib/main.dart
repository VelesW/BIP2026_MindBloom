import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Services
import 'package:mindbloom/data/services/local_storage_service.dart';
import 'package:mindbloom/data/services/secure_storage_service.dart';

// Pages
import 'package:mindbloom/pages/my_homepage.dart';
import 'package:mindbloom/pages/auth/login_page.dart';
import 'package:mindbloom/pages/onboarding/onboarding_page.dart';

// Repositories
import 'package:mindbloom/data/repositories/auth_repository.dart';

// BLoCs
import 'package:mindbloom/bloc/theme/theme_bloc.dart';
import 'package:mindbloom/bloc/theme/theme_state.dart';
import 'package:mindbloom/bloc/auth/auth_bloc.dart';
import 'package:mindbloom/bloc/auth/auth_event.dart';
import 'package:mindbloom/bloc/auth/auth_state.dart';
import 'package:mindbloom/bloc/onboarding/onboarding_bloc.dart';
import 'package:mindbloom/bloc/onboarding/onboarding_event.dart';
import 'package:mindbloom/bloc/onboarding/onboarding_state.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize SharedPreferences for synchronous theme loading
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  final localStorage = LocalStorageService(prefs);
  final secureStorage = SecureStorageService();
  final authRepository = AuthRepository();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeBloc(localStorage),
        ),
        BlocProvider(
          create: (context) => AuthBloc(authRepository: authRepository)..add(AuthCheckRequested()),
        ),
        BlocProvider(
          create: (context) => OnboardingBloc(secureStorage)..add(CheckOnboardingStatus()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const brandSeedColor = Colors.green;

    // Listen for Theme changes globally
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp(
          title: 'MindBloom',
          debugShowCheckedModeBanner: false,
          themeMode: themeState.isDarkMode ? ThemeMode.dark : ThemeMode.light,

          // Light Theme Setup
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: brandSeedColor,
              brightness: Brightness.light,
            ),
            cardTheme: CardThemeData(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),

          // Dark Theme Setup
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: brandSeedColor,
              brightness: Brightness.dark,
            ),
            cardTheme: CardThemeData(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),

          // The Navigation Gatekeeper
          home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              if (authState is Authenticated) {
                return const MyHomePage(title: 'MindBloom');
              }

              if (authState is AuthLoading) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              return BlocBuilder<OnboardingBloc, OnboardingState>(
                builder: (context, onboardingState) {
                  if (onboardingState.isCompleted) {
                    return const LoginPage();
                  }
                  return const OnboardingPage();
                },
              );
            },
          ),
        );
      },
    );
  }
}
