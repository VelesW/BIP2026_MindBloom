import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home/wellness_home_bloc.dart';
import '../bloc/theme/theme_bloc.dart';
import '../bloc/theme/theme_event.dart';
import '../bloc/theme/theme_state.dart';
import '../bloc/stats/stats_event.dart';
import '../bloc/stats/stats_state.dart';
import '../bloc/stats/stats_bloc.dart';
import '../bloc/journal/journal_state.dart';
import '../bloc/journal/journal_event.dart';
import '../bloc/journal/journal_bloc.dart';
import '../data/repositories/stats_repository.dart';
import '../data/repositories/journal_repository.dart';
import 'breathing_page.dart';
import 'profile/profile_page.dart';
import 'journal/journal_page.dart';
import 'mood/mood_tracker_page.dart';
import 'stats/stats_page.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WellnessHomeBloc()..add(LoadHomeData()),
      child: _MyHomePageView(title: title),
    );
  }
}

class _MyHomePageView extends StatefulWidget {
  final String title;
  const _MyHomePageView({required this.title});

  @override
  State<_MyHomePageView> createState() => _MyHomePageViewState();
}

class _MyHomePageViewState extends State<_MyHomePageView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          // Theme Toggle Icon (Sun/Moon)
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return IconButton(
                icon: Icon(
                  state.isDarkMode ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                  color: Colors.white,
                ),
                onPressed: () {
                  context.read<ThemeBloc>().add(ToggleTheme(!state.isDarkMode));
                },
              );
            },
          ),

          // Settings Dropdown
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'profile') {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person_outline, size: 20),
                    SizedBox(width: 8),
                    Text('My Profile'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<WellnessHomeBloc, WellnessHomeState>(
        builder: (context, wellnessState) {
          if (wellnessState is WellnessHomeLoaded) {
            return BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, themeState) {
                return _buildContent(context, wellnessState, themeState.isDarkMode);
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, WellnessHomeLoaded state, bool isDarkMode) {
    final theme = Theme.of(context);

    return Stack(
      children: [
    // Background Image
    Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Image.asset(
        state.imageAssetPath,
        fit: BoxFit.fitWidth, 
        alignment: Alignment.topCenter,
        color: const Color.fromARGB(255, 130, 21, 134).withOpacity(isDarkMode ? 0.55 : 0.3),
        colorBlendMode: BlendMode.darken,
      ),
    ),
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting Section
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
                child: FadeTransition(
                  opacity: _controller.drive(CurveTween(curve: const Interval(0.0, 0.6))),
                  child: Text(
                    state.greeting,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                ),
              ),

              // Bottom Content Container
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      )
                    ],
                  ),
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      _buildTile(0, 'Journal', 'Write down your thoughts', Icons.book_rounded, Colors.purple.shade200),
                      _buildTile(1, 'Breathing Exercise', 'Find your inner calm', Icons.air_rounded, Colors.blue.shade200),
                      _buildTile(2, 'Daily Mood', 'Check in with yourself', Icons.face_retouching_natural, Colors.orange.shade200),
                      _buildTile(3, 'Stats', 'Monitor your wellness journey', Icons.analytics_rounded, Colors.green.shade200),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTile(int index, String title, String sub, IconData icon, Color iconBg) {
    return FadeTransition(
      opacity: _controller.drive(
        CurveTween(curve: Interval(0.3 + (index * 0.1), 1.0, curve: Curves.easeOut)),
      ),
      child: SlideTransition(
        position: _controller.drive(
          Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
              .chain(CurveTween(curve: Interval(0.3 + (index * 0.1), 1.0, curve: Curves.easeOut))),
        ),
        child: Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBg.withOpacity(0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconBg, size: 28),
            ),
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            subtitle: Text(sub, style: const TextStyle(fontSize: 13)),
            trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey.shade400),
            onTap: () {
              switch (index) {
                case 0:
                  Navigator.push(context, MaterialPageRoute(builder: (_) => BlocProvider(
                    create: (context) => JournalBloc(JournalRepository()),
                    child: JournalPage()
                  )));
                  break;
                case 1:
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const BreathExercisePage()));
                  break;
                case 2:
                  Navigator.push(context, MaterialPageRoute(builder: (_) =>  MoodTrackerPage()));
                  break;
                case 3:
                  Navigator.push(context, MaterialPageRoute(builder: (_) =>  BlocProvider(
                    create: (context) => StatsBloc(
                      repository: StatsRepository()
                    )..add(LoadStats()),
                    child: const StatsPage(),
                  )));
                  break;
              }
            },
          ),
        ),
      ),
    );
  }
}
