import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Required for BlocProvider and BlocBuilder
import 'package:mindbloom/pages/my_homepage.dart';
import 'package:mindbloom/firebase_options.dart';

// Import your Theme BLoC files
import 'bloc/theme/theme_bloc.dart';
import 'bloc/theme/theme_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    // Providing ThemeBloc at the very top so the whole app can access it
    BlocProvider(
      create: (context) => ThemeBloc(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const brandSeedColor = Colors.green;

    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          title: 'MindBloom',
          debugShowCheckedModeBanner: false,

          // themeMode is now driven by the current state of your ThemeBloc
          themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,

          // Light Theme Configuration
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

          // Dark Theme Configuration
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

          home: const MyHomePage(title: 'MindBloom'),
        );
      },
    );
  }
}
