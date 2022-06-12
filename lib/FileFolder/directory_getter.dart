// ignore_for_file: prefer_const_constructors_in_immutables
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

class FileSystem extends StatefulWidget {
  FileSystem({Key? key}) : super(key: key);

  @override
  State<FileSystem> createState() => _FileSystemState();
}

class _FileSystemState extends State<FileSystem> {
  List<FileSystemEntity> itemsInDir = [];
  List<bool> hovering = [];
  late Directory currentPath;
  late Directory parentPath;
  Color? hoverColor = Colors.blueGrey;
  Color? color = Colors.transparent;

  Future<List<FileSystemEntity>> dirContents(Directory dir) {
    var files = <FileSystemEntity>[];
    var completer = Completer<List<FileSystemEntity>>();
    var lister = dir.list(recursive: false);
    lister.listen((file) => files.add(file),
        // should also register onError
        onDone: () => completer.complete(files));

    return completer.future;
  }

  void getItems(Directory path) async {
    itemsInDir = await dirContents(path);
    for (var i = 0; i < itemsInDir.length; i++) {
      hovering.add(false);
    }

    currentPath = path;
    parentPath = path.parent;
    setState(() {});
  }

  @override
  void initState() {
    getItems(Directory(".\\"));
    super.initState();
  }

  Future<void> _showMyDialog() async {
    String folderName = "";

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Create Folder',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blueGrey[800],
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  onChanged: (name) {
                    folderName = name;
                  },
                  cursorColor: Colors.orange,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueGrey),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                      border: const UnderlineInputBorder(),
                      hintText: "Folder Name",
                      hintStyle: TextStyle(color: Colors.blueGrey[300])),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Approve',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Directory("${currentPath.path}\\$folderName").createSync();
                getItems(currentPath);
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[800],
      width: 250,
      height: double.infinity,
      child: Column(
        children: [
          if (MediaQuery.of(context).size.height > 55)
            Row(
              children: [
                Flexible(
                  child: Container(
                    color: color,
                    margin: const EdgeInsets.fromLTRB(0, 1, 0, 0),
                    padding: const EdgeInsets.symmetric(
                        vertical: 2.5, horizontal: 5),
                    width: 125,
                    child: InkWell(
                      child: const Icon(
                        Icons.home_rounded,
                        color: Colors.white,
                      ),
                      onTap: () => {getItems(Directory(".\\"))},
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 1, 0, 0),
                    color: color,
                    padding: const EdgeInsets.symmetric(
                        vertical: 2.5, horizontal: 5),
                    width: 125,
                    child: InkWell(
                      child: const Icon(
                        Icons.keyboard_backspace_rounded,
                        color: Colors.white,
                      ),
                      onTap: () => {
                        getItems(parentPath),
                      },
                    ),
                  ),
                ),
                Flexible(
                    child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 1, 0, 0),
                  color: color,
                  padding:
                      const EdgeInsets.symmetric(vertical: 2.5, horizontal: 5),
                  width: 125,
                  child: InkWell(
                    child: const Icon(
                      Icons.create_new_folder_outlined,
                      color: Colors.white,
                    ),
                    onTap: () => {_showMyDialog()},
                  ),
                ))
              ],
            ),
          Expanded(
            child: ListView.builder(
                itemCount: itemsInDir.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () => {
                      getItems(Directory(itemsInDir[index].path)),
                    },
                    onHover: (ishover) {
                      if (ishover == true) {
                        hovering[index] = true;
                      } else {
                        hovering[index] = false;
                      }
                      setState(() {});
                    },
                    child: Draggable(
                      feedback: Container(
                          margin: const EdgeInsets.fromLTRB(0, 1, 0, 0),
                          color: color,
                          padding: const EdgeInsets.symmetric(
                              vertical: 1, horizontal: 5),
                          child: (itemsInDir[index] is! File)
                              ? Icon(
                                  Icons.folder,
                                  size: 28,
                                  color: Colors.orange[600],
                                )
                              : const Icon(
                                  Icons.insert_drive_file_rounded,
                                  size: 28,
                                  color: Colors.white,
                                )),
                      child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 1, 0, 0),
                          color: hovering[index] ? hoverColor : color,
                          padding: const EdgeInsets.symmetric(
                              vertical: 1, horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (itemsInDir[index] is File)
                                const Icon(
                                  Icons.insert_drive_file_rounded,
                                  size: 28,
                                  color: Colors.white,
                                )
                              else
                                Icon(
                                  Icons.folder,
                                  size: 28,
                                  color: Colors.orange[600],
                                ),
                              const SizedBox(
                                width: 5,
                              ),
                              Flexible(
                                child: Text(
                                  itemsInDir[index].path,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      overflow: TextOverflow.fade),
                                ),
                              ),
                            ],
                          )),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
