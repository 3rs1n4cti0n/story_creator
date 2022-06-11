import 'package:flutter/material.dart';
import 'package:story_creator/FileFolder/directory_getter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[600],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        toolbarHeight: 30,
        elevation: 0,
      ),
      body: FileSystem(),
    );
  }
}