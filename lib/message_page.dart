import 'package:flutter/material.dart';

class MessagePage extends StatelessWidget {
  final Map? message;
  const MessagePage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(message.toString())],
        ),
      ),
    );
  }
}
