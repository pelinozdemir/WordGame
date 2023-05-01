import 'dart:io';
import 'dart:math';
import 'package:flame/extensions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/GameLists.dart';

import 'package:flutter_application_1/buttonColor.dart';
import 'package:flutter_application_1/models/providers.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'models/providersDrop.dart';

class GameGrid extends StatefulWidget {
  // List<int> visibleindexs;
  // GameGrid({required this.visibleindexs});
  @override
  State<GameGrid> createState() => _GameGridState();
}

class _GameGridState extends State<GameGrid> {
  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey.shade900,
        margin: EdgeInsets.only(bottom: 0, top: 10),
        child: GridView.builder(
          padding: EdgeInsets.only(left: 5, right: 5, bottom: 1),
          itemCount: 80,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8, mainAxisSpacing: 1, crossAxisSpacing: 2),
          itemBuilder: (context, index) {
            return Visibility(
              visible: visiblecont.contains(index) ||
                      gamevisible.contains(index) ||
                      Provider.of<IndexProvider>(context, listen: false)
                              .indexCheck ==
                          index
                  ? true
                  : false,
              child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (!selectedLetter.contains(index)) {
                        selectedindex = index;
                        selectedLetter.add(index);

                        checkword =
                            checkword.trim() + rows[index].toString().trim();
                        Provider.of<WordProvider>(context, listen: false)
                            .setString(checkword);

                        selected = true;
                      } else {
                        if (selectedLetter.contains(index)) {
                          selectedindex = 80;

                          if (selectedLetter.indexOf(index) !=
                              selectedLetter.length - 1) {
                            checkword = checkword.substring(
                                    0, selectedLetter.indexOf(index)) +
                                checkword.substring(
                                  selectedLetter.indexOf(index) + 1,
                                );
                            Provider.of<WordProvider>(context, listen: false)
                                .setString(checkword);
                          } else {
                            checkword = checkword.substring(
                                0, selectedLetter.indexOf(index));
                            Provider.of<WordProvider>(context, listen: false)
                                .setString(checkword);
                          }
                          selectedLetter.remove(index);
                          selected = false;
                        } else {
                          selectedLetter.add(index);
                        }
                      }
                    });
                  },
                  child: AnimatedContainer(
                      margin: EdgeInsets.only(bottom: 2, left: 0.5, right: 0.5),
                      //padding: EdgeInsets.only(bottom: 2, left: 1, right: 1),
                      decoration: BoxDecoration(
                        color: selectedLetter.contains(index)
                            ? Colors.grey.shade900
                            : rowsColor[index]?.brighten(0.5),
                        borderRadius: selectedLetter.contains(index) ||
                                vowel.contains(rows[index])
                            ? BorderRadius.circular(25)
                            : BorderRadius.circular(12),
                        border: selectedLetter.contains(index)
                            ? Border.all(
                                color: rowsColor[index]!,
                                width: 1.8,
                              )
                            : Border.all(color: Colors.transparent, width: 0),
                      ),
                      child: Center(
                          child: Text(
                        "${rows[index]}",
                        style: GoogleFonts.glory(
                            fontSize:
                                MediaQuery.of(context).size.height * 0.025,
                            fontWeight: FontWeight.w600,
                            color: rowsColor[index]?.brighten(0.3).darken(0.3)),
                      )),
                      duration: Duration(milliseconds: 3))),
            );
          },
        ));
  }
}
