import 'package:core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/router/router_constants.dart';
import '../auth/presentation/blocs/authentication/authentication_bloc.dart';

class MyProfilePage extends StatelessWidget {
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) => const MyProfilePageView();
}

class MyProfilePageView extends StatefulWidget {
  const MyProfilePageView({super.key});

  @override
  State<StatefulWidget> createState() => _MyProfilePageViewState();
}

class _MyProfilePageViewState extends State<MyProfilePageView> {
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              final role = state.user?.role.trim().toLowerCase();
              if (role == Role.admin) {
                return FloatingActionButton(
                  heroTag: 'create_post',
                  onPressed: () {
                    context.push(RouteLocation.postCreate);
                  },
                  child: const Icon(Icons.add, color: Colors.blueAccent),
                );
              }
              return const SizedBox.shrink();
            },
          ),
    );
  }
}
