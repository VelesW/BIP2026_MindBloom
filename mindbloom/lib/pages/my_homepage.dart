import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home/wellness_home_bloc.dart';

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
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<WellnessHomeBloc, WellnessHomeState>(
        builder: (context, state) {
          if (state is WellnessHomeLoaded) {
            return _buildContent(context, state, isDarkMode);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, WellnessHomeLoaded state, bool isDarkMode) {
    return Stack(
      children: [
        // Background Image with Dark Overlay
        Positioned.fill(
          child: Image.asset(
            state.imageAssetPath,
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(isDarkMode ? 0.6 : 0.3),
            colorBlendMode: BlendMode.darken,
          ),
        ),
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  state.greeting,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      _buildTile(0, 'Journal', 'Write down your thoughts', Icons.book, Colors.purple.shade200),
                      _buildTile(1, 'Breath Exercises', 'Calm your mind', Icons.air, Colors.blue.shade200),
                      _buildTile(2, 'Daily mood', 'How are you feeling?', Icons.face, Colors.orange.shade200),
                      _buildTile(3, 'Stats', 'Track your progress', Icons.analytics, Colors.green.shade200),
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
      opacity: _controller.drive(CurveTween(curve: Interval(0.2 + (index * 0.1), 1.0))),
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: iconBg.withOpacity(0.3), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: iconBg),
          ),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(sub),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {},
        ),
      ),
    );
  }
}
