import 'package:flutter/material.dart';
import 'Home.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

void main(List<String> args) {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/home': (context) => Home(),
      },
    )
  );
  doWhenWindowReady((){
    final win = appWindow;
    win.minSize = Size(600,480);
    win.alignment = Alignment.center;
    win.title = "RBT Visual Novel Maker";
  });
}