import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  final String title;

  const TestPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const Center(
        child: Text("Здесь будет тест"),
      ),
    );
  }
}
