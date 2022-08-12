// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class MybottonWidget extends StatelessWidget {
  MybottonWidget({
    required this.title,
    required this.onTap,
    Key? key,
  }) : super(key: key);
  String title;
  VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Center(
          child: Container(
            alignment: Alignment.center,
            height: 70,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.teal,
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
