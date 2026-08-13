import 'package:flutter/material.dart';

class PostDetailPage extends StatelessWidget {
  const PostDetailPage({super.key, required this.postId});
  final String postId;

  @override
  Widget build(BuildContext context) => const PostDetailView();
}

class PostDetailView extends StatelessWidget {
  const PostDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Post Detail Page')),
      body: Center(child: Text('Post Detail Page View')),
    );
  }
}
