import 'package:flutter/material.dart';

import '../blocs/login/login_bloc.dart';

class PostPage extends StatelessWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context) => const PostPageView();
}

class PostPageView extends StatelessWidget {
  const PostPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Post Page View')));
  }
}
