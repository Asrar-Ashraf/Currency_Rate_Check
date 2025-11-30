import 'package:flutter/material.dart';

class Containerbox extends StatelessWidget {
  const Containerbox({super.key, required this.size, required this.text});
  final Size size;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height! * 0.08,
      width: size.width! * 0.7,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 218, 211, 211),
        border: Border.all(color: Colors.purple, width: 2),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
