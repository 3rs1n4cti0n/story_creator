import 'package:flutter/material.dart';

class StoryLineTabs extends StatefulWidget {
  const StoryLineTabs({Key? key}) : super(key: key);

  @override
  State<StoryLineTabs> createState() => _StoryLineTabsState();
}

class _StoryLineTabsState extends State<StoryLineTabs> {
  bool isBranches = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.blueGrey[800],
          height: 30,
          width: double.infinity,
          child: Row(children: [
            Flexible(
              child: Container(
                height: 30,
                width: 80,
                color: isBranches ? Colors.blueGrey[600] : Colors.blueGrey[800],
                child: InkWell(
                  onTap: () {
                    isBranches = true;
                    setState(() {});
                  },
                  child: const Text(
                    "Branches",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Flexible(
              child: Container(
                height: 30,
                width: 80,
                color:
                    !isBranches ? Colors.blueGrey[600] : Colors.blueGrey[800],
                child: InkWell(
                  onTap: () {
                    isBranches = false;
                    setState(() {});
                  },
                  child: const Text(
                    "Story",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ]),
        ),
        Expanded(
          child: Container(
            color: Colors.transparent,
          ),
        ),
      ],
    );
  }
}
