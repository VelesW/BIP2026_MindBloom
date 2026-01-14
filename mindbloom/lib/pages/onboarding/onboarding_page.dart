import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/onboarding/onboarding_bloc.dart';
import '../../bloc/onboarding/onboarding_event.dart';
import '../../bloc/onboarding/onboarding_state.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();

    return Scaffold(
      body: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, state) {
          return Stack(
            children: [
              PageView(
                controller: controller,
                onPageChanged: (index) {
                  context.read<OnboardingBloc>().add(PageChanged(index));
                },
                children: [
                  _buildPage(
                    title: "Breath",
                    desc: "Find your inner peace with guided exercises.",
                    color: Colors.blue.shade50,
                    icon: Icons.air,
                  ),
                  _buildPage(
                    title: "Reflect",
                    desc: "Keep a daily journal of your thoughts.",
                    color: Colors.purple.shade50,
                    icon: Icons.edit_note,
                  ),
                  _buildPage(
                    title: "Bloom",
                    desc: "Track your mood and grow every day.",
                    color: Colors.green.shade50,
                    icon: Icons.local_florist,
                  ),
                ],
              ),
              Positioned(
                bottom: 50,
                left: 24,
                right: 24,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => context.read<OnboardingBloc>().add(OnboardingFinished()),
                      child: const Text("Skip"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (state.pageIndex < 2) {
                          controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                        } else {
                          context.read<OnboardingBloc>().add(OnboardingFinished());
                        }
                      },
                      child: Text(state.pageIndex == 2 ? "Get Started" : "Next"),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildPage({required String title, required String desc, required Color color, required IconData icon}) {
    return Container(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 100, color: Colors.black54),
          const SizedBox(height: 40),
          Text(title, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(desc, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
