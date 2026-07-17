import 'package:flutter/material.dart';

class MyProfilePage extends StatelessWidget {
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) => const MyProfilePageView();
}

class MyProfilePageView extends StatelessWidget {
  const MyProfilePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('MyProfile Page View')));
  }
}
