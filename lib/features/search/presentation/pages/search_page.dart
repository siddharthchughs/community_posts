import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) => const SearchPageView();
}

class SearchPageView extends StatelessWidget {
  const SearchPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Search Profile Page View')),
    );
  }
}
