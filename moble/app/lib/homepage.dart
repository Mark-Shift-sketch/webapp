import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final Map user;
  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          "Welcome ${user['email']}\n"
          "Department: ${user['dept']}\n"
          "Role: ${user['role']}\n"
          "Position: ${user['position']}",
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}