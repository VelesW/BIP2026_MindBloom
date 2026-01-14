import 'package:starseu/data/datasource/project_ads_remote_ds.dart';
import 'package:starseu/data/repositories/project_ads_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/create_ad_bloc.dart';

class CreateAdPage extends StatelessWidget {
  const CreateAdPage({super.key});

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;
    final repo = ProjectAdsRepository(ProjectAdsRemoteDataSource(firestore));

    return BlocProvider(
      create: (_) => CreateAdBloc(repo: repo),
      child: const _CreateAdView(),
    );
  }
}

class _CreateAdView extends StatelessWidget {
  const _CreateAdView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateAdBloc, CreateAdState>(
      listenWhen: (prev, curr) => prev.status != curr.status || prev.errorMessage != curr.errorMessage,
      listener: (context, state) {
        if (state.status == CreateAdStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You are Logged in')),
          );
          Navigator.of(context).pop();
        }
        if (state.status == CreateAdStatus.failure && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Name'),
                onChanged: (v) => context.read<CreateAdBloc>().add(TitleChanged(v)),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(labelText: 'Password'),
                minLines: 3,
                maxLines: 6,
                onChanged: (v) => context.read<CreateAdBloc>().add(DescriptionChanged(v)),
              ),
              const SizedBox(height: 16),
              BlocBuilder<CreateAdBloc, CreateAdState>(
                buildWhen: (p, c) => p.status != c.status,
                builder: (context, state) {
                  final isLoading = state.status == CreateAdStatus.loading;
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              // docelowo: FirebaseAuth.instance.currentUser!.uid
                              context.read<CreateAdBloc>().add(
                                    const SubmitPressed(authorId: 'user-data'),
                                  );
                            },
                      child: isLoading
                          ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Text('login'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
