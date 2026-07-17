import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../src/di/di.dart';
import '../blocs/login/login_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocProvider(create: (context) => getIt<LoginBloc>(), child: LoginView());
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text('Login')],
      ),
    );
  }
}
