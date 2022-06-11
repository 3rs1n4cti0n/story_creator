// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:story_creator/FileFolder/directory_getter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> FilesNavigation = [
    "New Project",
    "Open Project",
    "Save Project",
    "Export Project"
  ];

  final List<String> Edit = [
    "Undo",
    "Redo",
    "Cut",
    "Copy",
    "Paste",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[600],
      appBar: AppBar(
          leadingWidth: 250,
          backgroundColor: Colors.blueGrey[900],
          toolbarHeight: 30,
          elevation: 0,
          title: const SizedBox(
            width: 0,
            height: 0,
          ),
          leading: Row(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PopupMenuButton(
                    // TODO: add functionality to the buttons
                    onSelected: ((value) {}),
                    iconSize: 20,
                    tooltip: "Files",
                    color: Colors.blueGrey[900],
                    position: PopupMenuPosition.under,
                    icon: const Icon(Icons.insert_drive_file_sharp),
                    padding: EdgeInsets.zero,
                    itemBuilder: (context) {
                      return [
                        for (int i = 0; i < FilesNavigation.length; i++)
                          PopupMenuItem(
                              value: FilesNavigation[i],
                              child: Text(
                                FilesNavigation[i],
                                style: const TextStyle(color: Colors.white),
                              ))
                      ];
                    }),
                PopupMenuButton(
                    // TODO: add functionality to the buttons
                    onSelected: ((value) {}),
                    iconSize: 20,
                    tooltip: "Edit",
                    color: Colors.blueGrey[900],
                    position: PopupMenuPosition.under,
                    icon: const Icon(Icons.edit),
                    padding: EdgeInsets.zero,
                    itemBuilder: (context) {
                      return [
                        for (int i = 0; i < Edit.length; i++)
                          PopupMenuItem(
                              value: Edit[i],
                              child: Text(
                                Edit[i],
                                style: const TextStyle(color: Colors.white),
                              ))
                      ];
                    }),
                    // TODO: add functionality to the button
                IconButton(
                    tooltip: "Run",
                    padding: EdgeInsets.zero,
                    alignment: Alignment.center,
                    onPressed: () {},
                    icon: const Icon(
                      Icons.play_arrow_rounded,
                      size: 28,
                    ))
              ],
            ),
          ])),
      body: FileSystem(),
    );
  }
}
