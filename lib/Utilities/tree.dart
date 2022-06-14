// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:story_creator/Utilities/Character.dart';

class Branch {
  late Map<String,String> story;
  late Image background;
  late List<Character> characters;
  List<Branch> storyPath = [];
}