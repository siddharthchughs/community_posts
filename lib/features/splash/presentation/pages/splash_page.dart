import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    print('Splash Screen');
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
