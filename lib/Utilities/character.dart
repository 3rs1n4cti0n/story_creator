// ignore_for_file: file_names

import 'package:flutter/material.dart';

class Character {
  late Map<String,String> characterReactions;
  Image? currentReaction;
  String characterName;
  late Map<String, int> characterAttributes;
  double x = 0,y = 0;
  int maxHearts;
  int minHearts;
  int hearts = 0;

  Character({
    this.characterName = "Default",
    this.maxHearts = 10,
    this.minHearts = -10,
  }) {
    addAttribute("ValueName", 0);
  }

  // changes reaction from datapath
  void changeReaction(String reactionType) {
    currentReaction = Image.asset(characterReactions.containsKey(reactionType) ? characterReactions[reactionType] as String : characterAttributes.entries.first.value as String);
  }

  void deleteReactions(String reactionType){
    characterReactions.remove(reactionType);
  }

  // increments affection with main character
  void incrementHeart(int amount) {
    hearts += amount;
    if (hearts > maxHearts) {
      hearts = maxHearts;
    } else if (hearts < minHearts) {
      hearts = minHearts;
    }
  }

  // adds a new attribute
  void addAttribute(String attributeName, int value) {
    characterAttributes.putIfAbsent(attributeName, () => value);
  }

  void deleteAttribute(String attributeName){
    characterAttributes.remove(attributeName);
  }

  // increment or decrement attribute by x amount
  void changeAttribute(String attributeName, int amount) {
    if (characterAttributes.containsKey(attributeName)) {
      characterAttributes.update(attributeName, (value) => value += amount);
    } else {
      addAttribute(attributeName, 0);
    }
  }
}
