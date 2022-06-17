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
    dirContents(projectPath.absolute).then((value) => null);
    super.initState();
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

  // Utility function to help build dialogs
  Future<void> dialogDisplayer(
      Widget child, Widget title, List<Widget> actions) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title,
          backgroundColor: Colors.blueGrey[800],
          content: child,
          actions: actions,
        );
      },
    );
  }

  // gets a list of all files and directories in given path as FileSystemEntity
  Future<void> dirContents(Directory dir) async {
    var files = <FileSystemEntity>[];
    var completer = Completer<List<FileSystemEntity>>();
    var lister = dir.list(recursive: false);
    lister.listen((file) => files.add(file),
        onDone: () => completer.complete(files));

    itemsInDir = await completer.future;
    for (var i = 0; i < itemsInDir.length; i++) {
      hovering.add(false);
    }
    currentPath = dir;
    parentPath = dir.parent;

    setState(() {
      itemsInDir;
    });
  }

  // Shows a dialog for creating folders
  Future<void> folderCreateDialog() async {
    String folderName = "";
    return dialogDisplayer(
        SingleChildScrollView(
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
        const Text(
          "Create Folder",
          style: TextStyle(color: Colors.white),
        ),
        <Widget>[
          TextButton(
            child: const Text(
              'Approve',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Directory("${currentPath.path}\\$folderName").createSync();
              dirContents(currentPath).then((value) => null);
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
        ]);
  }

  // shows deleting a file dialog
  Future<void> deleteDialog(FileSystemEntity toBeDeletedFile) async {
    return dialogDisplayer(
        SingleChildScrollView(
          child: Text(path.basename(toBeDeletedFile.path),
              style: const TextStyle(color: Colors.white)),
        ),
        const Text(
          "Are you Sure you want to delete",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        <Widget>[
          TextButton(
              onPressed: () {
                deleteFile(toBeDeletedFile);
                dirContents(toBeDeletedFile.parent).then((value) => null);
                Navigator.of(context).pop();
              },
              child:
                  const Text("Approve", style: TextStyle(color: Colors.white))),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.white),
              ))
        ]);
  }

  // shows dialog for renaming file
  Future<void> renameDialog(FileSystemEntity sourceFile) async {
    String newName = "";
    return dialogDisplayer(
        SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              TextField(
                onChanged: (name) {
                  newName = name;
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
                    hintText: "New Name",
                    hintStyle: TextStyle(color: Colors.blueGrey[300])),
              )
            ],
          ),
        ),
        const Text(
          "Rename File",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        <Widget>[
          TextButton(
              onPressed: () {
                renameFile(sourceFile, newName);
                dirContents(sourceFile.parent).then((value) => null);
                Navigator.of(context).pop();
              },
              child:
                  const Text("Approve", style: TextStyle(color: Colors.white))),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.white),
              ))
        ]);
  }

  // Buttons for navigating directories, creating folders and importing images
  Widget directoryButtons() {
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              child: Container(
                color: color,
                margin: const EdgeInsets.fromLTRB(0, 1, 0, 0),
                padding:
                    const EdgeInsets.symmetric(vertical: 2.5, horizontal: 5),
                width: 125,
                child: InkWell(
                  child: const Icon(
                    Icons.home_outlined,
                    color: Colors.white,
                  ),
                  onTap: () async => {await dirContents(projectPath.absolute)},
                ),
              ),
            ),
            Flexible(
              child: DragTarget<FileSystemEntity>(onAccept: (data) async {
                await moveFile(data, currentPath.parent.path);
                await dirContents(currentPath);
              }, builder: (context, candidateData, rejectedData) {
                return Container(
                  margin: const EdgeInsets.fromLTRB(0, 1, 0, 0),
                  color: color,
                  padding:
                      const EdgeInsets.symmetric(vertical: 2.5, horizontal: 5),
                  width: 125,
                  child: InkWell(
                    child: const Icon(
                      Icons.keyboard_backspace_outlined,
                      color: Colors.white,
                    ),
                    onTap: () async => {
                      if (currentPath.path != projectPath.path)
                        await dirContents(parentPath),
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
                onTap: () => {pickImages()},
              ),
            )),
          ],
        ),
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
            return InkWell(
              onTap: () async => {
                // removes funtionality for files
                if (await item.exists() && item is! File)
                  await dirContents(Directory(item.path))
                else if (item is File)
                  {}
                else
                  await dirContents(projectPath),
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
                onAccept: (data) async {
                  // can't drop items to themselves or if its a file
                  if (data.path != item.path && item is! File) {
                    await moveFile(data, item.path);
                    await dirContents(item.parent);
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
                                path.basename(item.path),
                                style: const TextStyle(
                                    color: Colors.white,
                                    overflow: TextOverflow.fade),
                              ),
                            ),
                            InkWell(
                              child: const Icon(
                                Icons.edit,
                                size: 24,
                                color: Colors.white,
                              ),
                              onTap: () async {
                                renameDialog(item);
                                await dirContents(item.parent);
                              },
                            ),
                            InkWell(
                              child: const Icon(
                                Icons.delete_forever_outlined,
                                size: 24,
                                color: Colors.white,
                              ),
                              onTap: () async {
                                deleteDialog(item);
                                await dirContents(item.parent);
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

  // moves the file to given path
  Future<void> moveFile(FileSystemEntity sourceFile, String newPath) async {
    if(!await Directory(newPath).exists()) return;

    String fileName = path.basename(sourceFile.path);
    String destination = "$newPath\\$fileName";
    sourceFile.rename(destination);
    await dirContents(sourceFile.parent);
  }

  // file picker to get images
  void pickImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg']);

    if (result != null) {
      List<File> files =
          result.paths.map((fromPath) => File(fromPath!)).toList();
      for (var image in files) {
        moveFile(image, "${projectPath.path}\\Assets");
      }
    } else {
      // didn't pick File
    }
    currentPath = projectPath.absolute;
    await dirContents(currentPath);
  }

  //************** DANGEROUS **************//
  //*deletes files and folders recursively*//
  void deleteFile(FileSystemEntity sourceFile) {
    if (sourceFile.existsSync()) {
      sourceFile.deleteSync(recursive: true);
    }
  }

  //************** DANGEROUS **************//
  //*     renames files and folders       *//
  void renameFile(FileSystemEntity sourceFile, String newName) {
    String sourcePath = sourceFile.path;
    int lastSeparator = sourcePath.lastIndexOf(Platform.pathSeparator);
    if (sourceFile is! File) {
      // calculates new path without extension for folders
      var newPath = sourcePath.substring(0, lastSeparator + 1) + newName;
      sourceFile.rename(newPath);
    } else {
      // gets extension of file such as .png or .jpeg
      String extentionName = path.basename(sourceFile.path);
      var pos = extentionName.lastIndexOf(".");
      extentionName = extentionName.substring(pos, extentionName.length);

      // calculates new path with extention
      String newPath =
          sourcePath.substring(0, lastSeparator + 1) + newName + extentionName;

      // checks if file already exists or not
      if (!File(newPath).existsSync()) {
        sourceFile.rename(newPath);
      }
    }
  }
}
