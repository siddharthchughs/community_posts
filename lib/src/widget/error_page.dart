import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/blocs/authentication/authentication_bloc.dart';
import '../blocs/login/login_bloc.dart';
import '../config/router/router_constants.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key, required this.error});
  final Exception? error;

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<AuthenticationBloc>().state.user != null;
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 18, 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'The page you were looking is not available any more.',
              ),
              const SizedBox(height: 20.0),
              MaterialButton(
                onPressed: () {
                  final path = isLoggedIn
                      ? RouteLocation.post
                      : RouteLocation.login;
                  context.go(path);
                },
                child: Text(isLoggedIn ? 'Go to home' : 'Go to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ErrorPageView extends StatelessWidget {
  const ErrorPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Error Page View')));
  }
}
