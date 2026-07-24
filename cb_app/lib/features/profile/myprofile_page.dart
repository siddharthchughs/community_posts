import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth/presentation/blocs/authentication/authentication_bloc.dart';

class MyProfilePage extends StatelessWidget {
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) => const MyProfilePageView();
}

class MyProfilePageView extends StatelessWidget {
  const MyProfilePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthenticationBloc>().add(
                AuthenticationLogoutRequested(),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(child: Text('MyProfile Page View')),
    );
  }
}
