// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:story_creator/Utilities/Character.dart';

class Branch {
  late List<String> story;
  late Image backgroundImage;
  late List<Character> characters;
  List<Branch> storyPath = [];

  void deleteStoryPath(int index)
  {
    storyPath.removeAt(index);
  }
  void deleteCharacter(int index)
  {
    characters.removeAt(index);
  }
  void deleteStory(int index)
  {
    story.removeAt(index);
  }
  
  void changeBackground(String path)
  {
    backgroundImage = Image.asset(path);
  }

  void addStoryPath(Branch newPath)
  {
    storyPath.add(newPath);
  }
  void addCharacter(Character newCharacter)
  {
    characters.add(newCharacter);
  }
  void addStory(String storyPiece){
    story.add(storyPiece);
  }
}