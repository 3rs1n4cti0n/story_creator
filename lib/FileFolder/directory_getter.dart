// ignore_for_file: prefer_const_constructors_in_immutables
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';

class FilesAndDirectories extends StatefulWidget {
  FilesAndDirectories({Key? key}) : super(key: key);

  @override
  State<FilesAndDirectories> createState() => _FileSystemState();
}

class _FileSystemState extends State<FilesAndDirectories> {
  // for getting files and directories
  List<FileSystemEntity> itemsInDir = [];

  // to add color change on hover
  List<bool> hovering = [];
  Color? hoverColor = Colors.blueGrey;
  Color? color = Colors.transparent;

  // caching project path due to file picker changing working directory
  final Directory projectPath = Directory(Directory.current.path);
  late Directory currentPath;
  late Directory parentPath;

  @override
  void initState() {
    getItems(projectPath.absolute);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Build function for Directory Path Navigator Menu
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[800],
      width: 250,
      height: double.infinity,
      child: Column(
        children: [
          if (MediaQuery.of(context).size.height > 55) directoryButtons(),
          dragableDirectories(),
        ],
      ),
    );
  }

  // gets a list of all files and directories in given path as FileSystemEntity
  Future<List<FileSystemEntity>> dirContents(Directory dir) {
    var files = <FileSystemEntity>[];
    var completer = Completer<List<FileSystemEntity>>();
    var lister = dir.list(recursive: false);
    lister.listen((file) => files.add(file),
        onDone: () => completer.complete(files));
    return completer.future;
  }

  // initializes hover for each item, waits for directory contents and sets current path and parent path
  void getItems(Directory path) async {
    itemsInDir = await dirContents(path);
    for (var i = 0; i < itemsInDir.length; i++) {
      hovering.add(false);
    }
    currentPath = path;
    parentPath = path.parent;
    setState(() {});
  }

  // Shows a dialog for creating folders
  Future<void> folderCreateDialog() async {
    String folderName = "";
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
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

  // shows deleting a file dialog
  Future<void> deleteDialog(FileSystemEntity toBeDeletedFile) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.blueGrey[800],
            title: const Text(
              "Are you Sure you want to delete file named:",
              style: TextStyle(color: Colors.white),
            ),
            content: const SingleChildScrollView(),
            actions: [
              TextButton(
                  onPressed: () {
                    deleteFile(toBeDeletedFile);
                    getItems(toBeDeletedFile.parent);
                    Navigator.of(context).pop();
                  },
                  child: const Text("Approve",
                      style: TextStyle(color: Colors.white))),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          );
        });
  }

  // Buttons for navigating directories, creating folders and importing images
  Widget directoryButtons() {
    return Row(
      children: [
        Flexible(
          child: Container(
            color: color,
            margin: const EdgeInsets.fromLTRB(0, 1, 0, 0),
            padding: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 5),
            width: 125,
            child: InkWell(
              child: const Icon(
                Icons.home_outlined,
                color: Colors.white,
              ),
              onTap: () => {getItems(projectPath.absolute)},
            ),
          ),
        ),
        Flexible(
          child: DragTarget<FileSystemEntity>(onAccept: (data) {
            movefile(data, currentPath.parent.path);
            getItems(currentPath);
          }, builder: (context, candidateData, rejectedData) {
            return Container(
              margin: const EdgeInsets.fromLTRB(0, 1, 0, 0),
              color: color,
              padding: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 5),
              width: 125,
              child: InkWell(
                child: const Icon(
                  Icons.keyboard_backspace_outlined,
                  color: Colors.white,
                ),
                onTap: () => {
                  if (currentPath.path != projectPath.path) getItems(parentPath)
                },
              ),
            );
          }),
        ),
        Flexible(
            child: Container(
          margin: const EdgeInsets.fromLTRB(0, 1, 0, 0),
          color: color,
          padding: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 5),
          width: 125,
          child: InkWell(
            child: const Icon(
              Icons.create_new_folder_outlined,
              color: Colors.white,
            ),
            onTap: () => {folderCreateDialog()},
          ),
        )),
        Flexible(
            child: Container(
          margin: const EdgeInsets.fromLTRB(0, 1, 0, 0),
          color: color,
          padding: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 5),
          width: 125,
          child: InkWell(
            child: const Icon(
              Icons.file_open_outlined,
              color: Colors.white,
            ),
            onTap: () => {getFiles()},
          ),
        )),
      ],
    );
  }

  // Uses directory and files to create draggable and clickable directories,
  // If a folder is clicked changes current directory to the click targets' directory
  // if a file is clicked nothing happens
  // if file doesn't exist, returns to main project path
  Expanded dragableDirectories() {
    return Expanded(
      child: ListView.builder(
          itemCount: itemsInDir.length,
          itemBuilder: (BuildContext context, int index) {
            final item = itemsInDir[index];
            var pos = item.path.lastIndexOf("/");
            if (pos == -1) {
              pos = item.path.lastIndexOf("\\");
            }
            String itemPathName = (pos != -1)
                ? item.path.substring(pos + 1, item.path.length)
                : item.path;
            return InkWell(
              onTap: () => {
                // removes cuntionality for files
                if (item.existsSync() && item is! File)
                  getItems(Directory(item.path))
                else if (item is File)
                  {}
                else
                  getItems(projectPath)
              },
              onHover: (ishover) {
                if (ishover == true) {
                  hovering[index] = true;
                } else {
                  hovering[index] = false;
                }
                setState(() {});
              },
              child: DragTarget<FileSystemEntity>(
                onAccept: (data) {
                  // can't drop items to themselves
                  if (data.path != item.path) {
                    movefile(data, item.path);
                    getItems(item.parent);
                  }
                },
                builder: (context, candidateData, rejectedData) {
                  return Draggable(
                    data: item,
                    feedback: Container(
                        margin: const EdgeInsets.fromLTRB(0, 1, 0, 0),
                        color: color,
                        padding: const EdgeInsets.symmetric(
                            vertical: 1, horizontal: 5),
                        child: (item is! File)
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
                            if (item is File)
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
                            Expanded(
                              child: Text(
                                itemPathName,
                                style: const TextStyle(
                                    color: Colors.white,
                                    overflow: TextOverflow.fade),
                              ),
                            ),
                            InkWell(
                              child: const Icon(
                                Icons.delete_forever_outlined,
                                size: 24,
                                color: Colors.white,
                              ),
                              onTap: () {
                                deleteDialog(item);
                                getItems(item.parent);
                              },
                            )
                          ],
                        )),
                  );
                },
              ),
            );
          }),
    );
  }

  // waits for the file to be moved into specified folder path
  void movefile(FileSystemEntity sourceFile, String newPath) async {
    await moveFile(sourceFile, newPath);
  }

  // async function to move files into specified path
  Future<void> moveFile(FileSystemEntity sourceFile, String newPath) async {
    if (Directory(newPath).existsSync()) {
      String fileName = path.basename(sourceFile.path);
      String destination = "$newPath\\$fileName";
      sourceFile.rename(destination);
    }
  }

  // file picker to get images
  getFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg']);

    if (result != null) {
      List<File> files =
          result.paths.map((fromPath) => File(fromPath!)).toList();
      for (var image in files) {
        movefile(image, "${projectPath.path}\\Assets");
      }
    } else {
      // didn't pick File
    }
    currentPath = projectPath.absolute;
    getItems(currentPath);
  }
  
  //************** DANGEROUS **************//
  // deletes files and folders recursively
  void deleteFile(FileSystemEntity sourceFile) {
    if (sourceFile.existsSync()) {
      sourceFile.deleteSync(recursive: true);
    }
  }
}
