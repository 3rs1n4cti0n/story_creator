// ignore_for_file: file_names

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:story_creator/FileFolder/directory_getter.dart';

import 'Inspector/inspector.dart';
import 'StoryLineTabs/story_line.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // used to create Pop up menu items
  final List<String> filesNavigation = [
    "New Project",
    "Open Project",
    "Save Project",
    "Export Project"
  ];

  final List<String> edit = [
    "Undo",
    "Redo",
    "Cut",
    "Copy",
    "Paste",
  ];

  // windows apps close, expand, minimize button colors
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[600],
      appBar: AppBar(
          leadingWidth: 150,
          backgroundColor: Colors.blueGrey[900],
          toolbarHeight: 30,
          elevation: 0,
          title: WindowTitleBarBox(child: MoveWindow()),
          actions: windowFrameButtons,
          leading: functionalityMenu(context)),
      body: Row(
        children: [
          FilesAndDirectories(),
          Flexible(child: StoryLineTabs()),
          Inspector(),
        ],
      ),
    );
  }

  // utility function for expanding or restoring window size
  void maximizeOrRestore() {
    setState(() {
      appWindow.maximizeOrRestore();
    });
  }

  // windows close, expanded minimize buttons
  List<Widget> get windowFrameButtons {
    return [
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
        ];
  }

  // window Frame buttons
  Row functionalityMenu(BuildContext context) {
    return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Image.asset("Assets/app_icon.png",width: 20,height: 20,)),
            Theme(
              data: Theme.of(context).copyWith(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
              ),
              child: PopupMenuButton(
                  // TODO: add Files popup menu functionality
                  onSelected: ((value) {}),
                  iconSize: 20,
                  tooltip: "Files",
                  color: Colors.blueGrey[900],
                  position: PopupMenuPosition.under,
                  icon: const Icon(
                    Icons.folder,
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context) {
                    return [
                      for (int i = 0; i < filesNavigation.length; i++)
                        PopupMenuItem(
                            value: filesNavigation[i],
                            child: Text(
                              filesNavigation[i],
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
                  // TODO: add Edit popup menu functionality
                  onSelected: ((value) {}),
                  iconSize: 20,
                  tooltip: "Edit",
                  color: Colors.blueGrey[900],
                  position: PopupMenuPosition.under,
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context) {
                    return [
                      for (int i = 0; i < edit.length; i++)
                        PopupMenuItem(
                            value: edit[i],
                            child: Text(
                              edit[i],
                              style: const TextStyle(color: Colors.white),
                            ))
                    ];
                  }),
            ),
            // TODO: add functionality for running the engine in testing
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
        );
  }
}
