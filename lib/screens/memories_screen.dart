import 'package:flutter/material.dart';

class MemoriesScreen extends StatelessWidget {
  const MemoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memories'),
      ),
      body: const Center(
        child: Text('Memories Screen'),
      ),
    );
  }
}
