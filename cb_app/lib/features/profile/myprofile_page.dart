import 'package:core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/router/router_constants.dart';
import '../auth/presentation/blocs/authentication/authentication_bloc.dart';
import 'package:flutter/cupertino.dart';

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
        backgroundColor: Colors.amberAccent.shade200,
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
      body: const Center(child: Text('MyProfile Page View')),
      floatingActionButton:
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              print(state.user?.username);
              print(state.user?.role);
              if (state.user?.role == Role.admin) {
                return FloatingActionButton(
                  onPressed: () {
                    context.push(RouteLocation.postCreate);
                  },
                  child: const Icon(Icons.add),
                );
              }
              return const SizedBox.shrink();
            },
          ),
    );
  }
}
