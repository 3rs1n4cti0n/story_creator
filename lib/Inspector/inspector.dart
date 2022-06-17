import 'package:flutter/material.dart';

class Inspector extends StatefulWidget {
  Inspector({Key? key}) : super(key: key);

  @override
  State<Inspector> createState() => _InspectorState();
}

class _InspectorState extends State<Inspector> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange,
      width: 250,
      height: double.infinity,
      child: Column(
        children: [
          
        ],
      ),
    );
  }
}