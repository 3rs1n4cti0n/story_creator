import 'package:flutter/material.dart';

class Character {
  late Map<String,String> characterReactions;
  Image? currentReaction;
  String characterName = "Default";
  late Map<String, int> characterAttributes;
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

  // increment attribute by x amount
  void incrementAttribute(String attributeName, int amount) {
    if (characterAttributes.containsKey(attributeName)) {
      characterAttributes.update(attributeName, (value) => value += amount);
    } else {
      addAttribute(attributeName, 0);
    }
  }
}
