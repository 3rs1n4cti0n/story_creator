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
  late Directory parentPath;
  Color? hoverColor = Colors.blue[200];
  Color color = Colors.blue;
  bool isHovering = false;

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
    parentPath = path.parent;
    setState(() {});
  }

  @override
  void initState() {
    getItems(Directory(".\\"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[800],
      width: 250,
      height: double.infinity,
      child: Column(
        children: [
          if(MediaQuery.of(context).size.height>55)
          Row(
            children: [
              Flexible(
                child: Container(
                  color: Colors.blueGrey[100],
                  margin: const EdgeInsets.fromLTRB(0, 1, 0, 0),
                  padding:
                      const EdgeInsets.symmetric(vertical: 2.5, horizontal: 5),
                  width: 125,
                  child: InkWell(
                    child: const Text("home"),
                    onTap: () => {getItems(Directory(".\\"))},
                  ),
                ),
              ),
              const SizedBox(width: 1,),
              Flexible(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 1, 0, 0),
                  color: Colors.blueGrey[100],
                  padding:
                      const EdgeInsets.symmetric(vertical: 2.5, horizontal: 5),
                  width: 125,
                  child: InkWell(
                    child: const Text("\\"),
                    onTap: () => {getItems(parentPath)},
                  ),
                ),
              ),
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
                    child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 1, 0, 0),
                        color: Colors.blueGrey[100],
                        padding: const EdgeInsets.symmetric(
                            vertical: 2.5, horizontal: 5),
                        child: Text(itemsInDir[index].path)),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
