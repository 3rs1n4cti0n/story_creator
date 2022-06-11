// ignore_for_file: non_constant_identifier_names

import 'package:bitsdojo_window/bitsdojo_window.dart';
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

  final buttonColors = WindowButtonColors(
      iconNormal: Colors.white,
      mouseOver: Colors.blueGrey[700],
      mouseDown: Colors.blueGrey[800],
      iconMouseOver: Colors.white,
      iconMouseDown: Colors.white);

  final closeButtonColors = WindowButtonColors(
      mouseOver: const Color(0xFFD32F2F),
      mouseDown: const Color(0xFFB71C1C),
      iconNormal: Colors.white,
      iconMouseOver: Colors.white);

  void maximizeOrRestore() {
    setState(() {
      appWindow.maximizeOrRestore();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[600],
      appBar: AppBar(
          leadingWidth: 120,
          backgroundColor: Colors.blueGrey[900],
          toolbarHeight: 30,
          elevation: 0,
          title: WindowTitleBarBox(child: MoveWindow()),
          actions: [
            MinimizeWindowButton(colors: buttonColors),
            appWindow.isMaximized
                ? RestoreWindowButton(
                    colors: buttonColors,
                    onPressed: maximizeOrRestore,
                  )
                : MaximizeWindowButton(
                    colors: buttonColors,
                    onPressed: maximizeOrRestore,
                  ),
            CloseWindowButton(colors: closeButtonColors),
          ],
          leading: Row(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Theme(
                  data: Theme.of(context).copyWith(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                  ),
                  child: PopupMenuButton(
                      // TODO: add functionality to the buttons
                      onSelected: ((value) {}),
                      iconSize: 20,
                      tooltip: "Files",
                      color: Colors.blueGrey[900],
                      position: PopupMenuPosition.under,
                      icon: const Icon(Icons.insert_drive_file_sharp,color: Colors.white,),
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
                ),
                Theme(
                  data: Theme.of(context).copyWith(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                  ),
                  child: PopupMenuButton(
                      // TODO: add functionality to the buttons
                      onSelected: ((value) {}),
                      iconSize: 20,
                      tooltip: "Edit",
                      color: Colors.blueGrey[900],
                      position: PopupMenuPosition.under,
                      icon: const Icon(Icons.edit,color: Colors.white,),
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
                ),
                // TODO: add functionality to the button
                Theme(
                  data: Theme.of(context).copyWith(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                  ),
                  child: IconButton(
                      tooltip: "Run",
                      padding: EdgeInsets.zero,
                      alignment: Alignment.center,
                      onPressed: () {},
                      icon: const Icon(
                        Icons.play_arrow_rounded,
                        size: 28,
                        color: Colors.white,
                      )),
                )
              ],
            ),
          ])),
      body: FileSystem(),
    );
  }
}
