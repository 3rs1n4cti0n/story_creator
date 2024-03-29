// ignore_for_file: prefer_const_constructors_in_immutables
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool isParentDirButtonHover = false;
  Color? hoverColor = Colors.blueGrey;
  Color? color = Colors.transparent;

  // caching project path due to file picker changing working directory
  final Directory projectPath = Directory(Directory.current.path);
  late Directory currentPath = Directory(Directory.current.path);
  late Directory parentPath;

  @override
  void initState() {
    getItems(projectPath.absolute);
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
          Padding(
            padding: const EdgeInsets.only(bottom: 3.0),
            child: Divider(
              height: 0,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          parentDirectory(),
          dragableDirectories(),
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(),
            child: Container(
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(color: Colors.grey[900], boxShadow: [
                BoxShadow(color: Colors.black, blurRadius: 3, spreadRadius: 1)
              ]),
              child: Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        "Path > ${currentPath.path}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 12,
                            decoration: TextDecoration.none,
                            color: Colors.white,
                            overflow: TextOverflow.fade),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget parentDirectory() {
    return Tooltip(
      decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.8),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      message: "Parent Directory",
      child: DragTarget<FileSystemEntity>(
        onAccept: (data) {
          moveFile(data, currentPath.parent.path);
          getItems(currentPath);
        },
        builder: (context, candidateData, rejectedData) {
          return InkWell(
              onHover: (value) {
                if (isParentDirButtonHover) {
                  isParentDirButtonHover = false;
                } else {
                  isParentDirButtonHover = true;
                }
                setState(() {});
              },
              onTap: () {
                if (currentPath.path != projectPath.path) {
                  getItems(parentPath);
                }
              },
              child: Container(
                color: isParentDirButtonHover ? hoverColor : color,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Icon(
                        Icons.folder,
                        size: 28,
                        color: Colors.orange[600],
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Expanded(
                      child: Text(
                        "..",
                        style: TextStyle(
                            color: Colors.white, overflow: TextOverflow.fade),
                      ),
                    ),
                  ],
                ),
              ));
        },
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
  Future<List<FileSystemEntity>> dirContents(Directory dir) async {
    var files = <FileSystemEntity>[];
    var completer = Completer<List<FileSystemEntity>>();
    var lister = dir.list(recursive: false);
    lister.listen((file) => files.add(file),
        onDone: () => completer.complete(files));
    return completer.future;
  }

  // initializes hover for each item, waits for directory contents and sets current path and parent path
  getItems(Directory path) async {
    await dirContents(path).then((value) {
      itemsInDir = value;
      // sort by name order
      itemsInDir.sort(
        (a, b) {
          return a.path
              .split('\\')
              .last
              .toLowerCase()
              .compareTo(b.path.split('\\').last.toLowerCase());
        },
      );
      // sort by file type
      itemsInDir.sort(((a, b) {
        if (a is File) {
          return 1;
        } else {
          return -1;
        }
      }));
      hovering.clear();
      for (var i = 0; i < itemsInDir.length; i++) {
        hovering.add(false);
      }
      currentPath = path;
      parentPath = path.parent;
    });

    setState(() {});
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
                onSubmitted: (value) {
                  Directory("${currentPath.path}\\$folderName").createSync();
                  getItems(currentPath);
                  Navigator.of(context).pop();
                },
                textInputAction: TextInputAction.done,
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
              getItems(currentPath);
              Navigator.of(context).pop();
            },
          ),
          RawKeyboardListener(
            focusNode: FocusNode(),
            autofocus: true,
            onKey: (v) {
              if (v.logicalKey == LogicalKeyboardKey.escape) {
                Navigator.of(context).pop();
              }
            },
            child: TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
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
          RawKeyboardListener(
            focusNode: FocusNode(),
            autofocus: true,
            onKey: (v) {
              if (v.logicalKey == LogicalKeyboardKey.enter) {
                deleteFile(toBeDeletedFile);
                getItems(toBeDeletedFile.parent);
                Navigator.of(context).pop();
              } else if (v.logicalKey == LogicalKeyboardKey.escape) {
                Navigator.of(context).pop();
              }
            },
            child: TextButton(
                onPressed: () {
                  deleteFile(toBeDeletedFile);
                  getItems(toBeDeletedFile.parent);
                  Navigator.of(context).pop();
                },
                child: const Text("Approve",
                    style: TextStyle(color: Colors.white))),
          ),
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
                onSubmitted: (value) {
                  renameFile(sourceFile, newName);
                  getItems(sourceFile.parent);
                  Navigator.of(context).pop();
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
                getItems(sourceFile.parent);
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
    return IntrinsicHeight(
      child: Row(
        children: [
          Flexible(
            child: Tooltip(
              decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.8),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              message: "Home Directory",
              child: Container(
                color: color,
                margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
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
          ),
          VerticalDivider(
            width: 0,
            color: Colors.white.withOpacity(0.3),
          ),
          /*Flexible(
            child: DragTarget<FileSystemEntity>(onAccept: (data) {
              moveFile(data, currentPath.parent.path);
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
                  onTap: () async => {
                    if (currentPath.path != projectPath.path)
                      getItems(parentPath),
                  },
                ),
              );
            }),
          ),*/
          Flexible(
              child: Tooltip(
            message: "Create New Folder",
            decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.8),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              color: color,
              width: 125,
              child: InkWell(
                child: const Icon(
                  Icons.create_new_folder_outlined,
                  color: Colors.white,
                ),
                onTap: () => {folderCreateDialog()},
              ),
            ),
          )),
          VerticalDivider(
            width: 0,
            color: Colors.white.withOpacity(0.3),
          ),
          Flexible(
              child: Tooltip(
            decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.8),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            message: "Pick Images",
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              color: color,
              width: 125,
              child: InkWell(
                child: const Icon(
                  Icons.file_open_outlined,
                  color: Colors.white,
                ),
                onTap: () => {getFiles()},
              ),
            ),
          )),
        ],
      ),
    );
  }

  // Uses directory and files to create draggable and clickable directories,
  // If a folder is clicked changes current directory to the click targets' directory
  // if a file is clicked nothing happens
  // if file doesn't exist, returns to main project path
  Expanded dragableDirectories() {
    return Expanded(
      flex: 6,
      child: ListView.builder(
          itemCount: itemsInDir.length,
          itemBuilder: (BuildContext context, int index) {
            final item = itemsInDir[index];
            return InkWell(
              onTap: () => {
                // removes cuntionality for files
                if (item.existsSync() && item is! File)
                  getItems(Directory(item.path))
                else if (item is File)
                  {}
                else
                  getItems(projectPath),
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
                    moveFile(data, item.path);
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
                            ? Container(
                                decoration: BoxDecoration(
                                    color:
                                        color?.withOpacity(0.0) ?? Colors.red,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.folder,
                                      size: 28,
                                      color: Colors.orange[600],
                                    ),
                                    Text(
                                      path.basename(item.path),
                                      style: const TextStyle(
                                          fontSize: 16,
                                          decoration: TextDecoration.none,
                                          color: Colors.white,
                                          overflow: TextOverflow.fade),
                                    )
                                  ],
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    color:
                                        color?.withOpacity(0.0) ?? Colors.red,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.insert_drive_file_rounded,
                                      size: 28,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      path.basename(item.path),
                                      style: const TextStyle(
                                          fontSize: 16,
                                          decoration: TextDecoration.none,
                                          color: Colors.white,
                                          overflow: TextOverflow.fade),
                                    )
                                  ],
                                ),
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
                              onTap: () {
                                renameDialog(item);
                                getItems(item.parent);
                              },
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
  void moveFile(FileSystemEntity sourceFile, String newPath) async {
    if (Directory(newPath).existsSync()) {
      String fileName = path.basename(sourceFile.path);
      String destination = "$newPath\\$fileName";
      await sourceFile.rename(destination);
    }
    getItems(currentPath);
  }

  // file picker to get images
  void getFiles() async {
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
    getItems(currentPath);
  }

  //************** DANGEROUS **************//
  //*deletes files and folders recursively*//
  void deleteFile(FileSystemEntity sourceFile) {
    if (sourceFile.existsSync()) {
      sourceFile.deleteSync(recursive: true);
    }
    getItems(currentPath);
  }

  //************** DANGEROUS **************//
  //*     renames files and folders       *//
  void renameFile(FileSystemEntity sourceFile, String newName) {
    if (sourceFile is! File) {
      var path = sourceFile.path;
      var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
      var newPath = path.substring(0, lastSeparator + 1) + newName;
      sourceFile.rename(newPath);
    } else {
      String extentionName = path.basename(sourceFile.path);
      var pos = extentionName.lastIndexOf(".");
      extentionName = extentionName.substring(pos, extentionName.length);

      String sourcePath = sourceFile.path;
      int lastSeparator = sourcePath.lastIndexOf(Platform.pathSeparator);
      String newPath =
          sourcePath.substring(0, lastSeparator + 1) + newName + extentionName;
      if (!File(newPath).existsSync()) {
        sourceFile.rename(newPath);
      } else {
        // show that file name already exists
      }
    }
    getItems(currentPath);
  }
}
