import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../src/di/di.dart';
import '../blocs/login/login_bloc.dart';

class PostFormPage extends StatelessWidget {
  const PostFormPage({super.key, required this.postId});
  final String postId;

  @override
  Widget build(BuildContext context) => const PostFormView();
}

class PostFormView extends StatelessWidget {
  const PostFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Post Form Page View')));
  }
}
