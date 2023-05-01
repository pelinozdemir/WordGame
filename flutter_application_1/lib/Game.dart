import 'dart:async';
import 'dart:convert';

import 'dart:io';
import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_application_1/GameScoreTable.dart';
import 'package:flutter_application_1/iceclass.dart';
import 'package:flutter_application_1/models/providers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/GameGrid.dart';
import 'package:flutter_application_1/GameLists.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'buttonColor.dart';
import 'models/providersDrop.dart';
import 'models/providersPoint.dart';

class GameUI extends StatefulWidget {
  @override
  State<GameUI> createState() => _GameUIState();
}

String str = "";
late AnimationController _controller;

class _GameUIState extends State<GameUI> with SingleTickerProviderStateMixin {
  Timer? timer;
  Timer? timerpunis;
  Timer? timer2;

  //bu fonksiyon satir satir inecek olan indexlerin kontrolunu yapiyor
  bool checkStart() {
    if (controllerforgrid.isNotEmpty) {
      int last = visiblecont.last;
      controllerforgrid.sort();
      if (controllerforgrid.last == last) {
        if (this.mounted) {
          setState(() {
            for (var i = 0; i < visiblecont.length; i++) {
              if (!gamevisible.contains(visiblecont[i])) {
                gamevisible.add(visiblecont[i]);
              }
            }

            controllerforgrid.remove(last);
          });
        }

        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  //bu fonksiyon her satir indiginde visiblecontun indexlerini baslangic degerine aliyor(satirlar artmaya devam etmesin diye)
  void resetalllist() {
    if (this.mounted) {
      setState(() {
        //inmesi gereken 3 satir kontrolu
        if (controllerforgrid.isNotEmpty) {
          if (visiblecont.length > 0) {
            for (var i = 0; i < visiblecont.length; i++) {
              visiblecont[i] = lineList[0][i];
            }
            //her satir inisinde o satirin harf dizimini belirliyor
            while (true) {
              var val = rng.nextInt(49690);

              for (var z = 0; z < 8; z++) {
                while (true) {
                  var rndmval = rng.nextInt(wordpool[val].trim().length);
                  var colorval = rng.nextInt(buttoncolorlist.length);
                  if (z < wordpool[val].trim().length - 1) {
                    if (!randomletter.contains(rndmval)) {
                      lineLetter[z] = wordpool[val]
                          .trim()
                          .characters
                          .elementAt(rndmval)
                          .toString();
                      lineColor[z] = colorval;
                      randomletter.add(rndmval);
                      z++;
                      if (z == 8) {
                        randomletter.clear();

                        break;
                      }
                    } else {
                      if (randomletter.length == wordpool[val].trim().length) {
                        randomletter.clear();
                        break;
                      }
                    }
                  } else {
                    val = rng.nextInt(49690);
                  }
                }
              }
              break;
            }
          }
        } else {
          // tum satirlar indiyse visiblecontu gozukmemesi icin indexlerine 80 degerini veriyoruyz
          for (var i = 0; i < visiblecont.length; i++) {
            visiblecont[i] = 80;
          }
        }
      });
    }
  }

  @override
  void initState() {
    if (this.mounted) {
      setState(() {
        refreshAllList();
        controllerforgrid.add(79);
        controllerforgrid.add(71);
        controllerforgrid.add(63);
        _controller = AnimationController(
          duration: const Duration(milliseconds: 1000),
          vsync: this,
        );
      });
    }

    super.initState();
  }

  //kelimeleri yukleme fonksiyonu
  Future<List<String>> loadAsset() async {
    if (wordpool.length > 49690) {
      return wordpool;
    } else {
      String loadedString = await rootBundle.loadString('assets/words.txt');
      loadedString.split('\n').forEach((element) {
        if (element.trim().length <= 2 ||
            element.trim().split(' ').length > 1) {
        } else {
          wordpool.add(element.trim());
        }
      });

      return wordpool;
    }
  }

  //her satir inisinde satir harflerini mape yukluyoruz arayuzde kullanabilmek icin
  void setLetter() async {
    if (this.mounted) {
      setState(() {
        if (controllerforgrid.length == 3) {
          for (var i = 0; i < 10; i++) {
            for (var z = 0; z < 8; z++) {
              rows.addAll({lineList[i][z]: lineLetter[z]});
              rowsColor.addAll({lineList[i][z]: buttoncolorlist[lineColor[z]]});
            }
          }
        } else if (controllerforgrid.length == 2 ||
            controllerforgrid.length == 1) {
          for (var i = 0; i < 7 + controllerforgrid.length; i++) {
            for (var z = 0; z < 8; z++) {
              rows.addAll({lineList[i][z]: lineLetter[z]});
              rowsColor.addAll({lineList[i][z]: buttoncolorlist[lineColor[z]]});
            }
          }
        }
      });
    }
  }

  void startGame() {
    resetalllist();
    setLetter();

    const duration = const Duration(milliseconds: 40);

    timer = Timer.periodic(duration, (Timer t) {
      if (checkStart()) {
        startGame();
        t.cancel();
      } else {
        if (controllerforgrid.isNotEmpty) {
          movedown();
        } else {
          t.cancel();
        }
      }
    });
    if (controllerforgrid.isEmpty && !(gamefinish)) {
      createDropBox();
    }
  }

  void movedown() {
    if (this.mounted) {
      setState(() {
        for (var i = 0; i < lineList[0].length; i++) {
          visiblecont[i] += 8;
        }
      });
    }
  }

  void setdropLetter() {
    if (this.mounted) {
      setState(() {
        randomletter.clear();

        var val = rng.nextInt(49690);

        str = wordpool[val].trim();
        var rndmval = rng.nextInt(wordpool[val].trim().length);
        dropletterVal =
            wordpool[val].trim().characters.elementAt(rndmval).toString();
        color = rng.nextInt(buttoncolorlist.length);
        randomletter.add(rndmval);
      });
    }
  }

  void createDropBox() {
    Provider.of<IndexProvider>(context, listen: false).setInt(80);

    if (point < 100) {
      const duration = const Duration(seconds: 5);
      level = 0;
      timer2 = Timer.periodic(duration, (Timer tim) {
        if (gamefinish) {
          _controller.reset();
          timer!.cancel();
          tim.cancel();
          timer2!.cancel();

          Provider.of<PointProvider>(context, listen: false).setInt(point);
          Provider.of<WordProvider>(context, listen: false).setString("");
          Provider.of<IndexProvider>(context, listen: false).setInt(80);

          Navigator.pop(context);
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new GameScore()));
        } else if (point >= 100) {
          // ice = rng.nextInt(3) + 5;
          createDropBox();
          tim.cancel();
        } else {
          const duration = const Duration(milliseconds: 45);

          // createDropBox(5000);
          /* if (ice == icecount) {
            print(ice);
            print("looo");
            var val = rng.nextInt(8);
            Provider.of<IndexProvider>(context, listen: false)
                .setInt(columnList[val][0]);
            setdropLetter();
            rows[Provider.of<IndexProvider>(context, listen: false)
                .indexCheck] = dropletterVal;
            rowsColor[Provider.of<IndexProvider>(context, listen: false)
                .indexCheck] = icecolor;
            Timer.periodic(duration, (Timer tim2) {
              if (!(Provider.of<IndexProvider>(context, listen: false)
                      .indexCheck >
                  columnList[val][9])) {
                dropLetter();
              } else {
                tim2.cancel();
              }
            });
          } else { */
          var val = rng.nextInt(8);
          Provider.of<IndexProvider>(context, listen: false)
              .setInt(columnList[val][0]);
          setdropLetter();
          rows[Provider.of<IndexProvider>(context, listen: false).indexCheck] =
              dropletterVal;
          rowsColor[Provider.of<IndexProvider>(context, listen: false)
              .indexCheck] = buttoncolorlist[color];
          Timer.periodic(duration, (Timer tim2) {
            if (!(Provider.of<IndexProvider>(context, listen: false)
                    .indexCheck >
                columnList[val][9])) {
              dropLetter();
            } else {
              tim2.cancel();
            }
          });
          // }
        }
      });
    } else if (200 > point && point >= 100) {
      const duration = const Duration(seconds: 4);
      level = 1;

      timer2 = Timer.periodic(duration, (Timer tim) {
        if (gamefinish) {
          _controller.reset();
          timer!.cancel();
          timerpunis!.cancel();
          tim.cancel();
          timer2!.cancel();
          timerpunis!.cancel();
          Provider.of<PointProvider>(context, listen: false).setInt(point);
          Provider.of<WordProvider>(context, listen: false).setString("");
          Provider.of<IndexProvider>(context, listen: false).setInt(80);

          Navigator.pop(context);
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new GameScore()));
        } else if (point >= 200) {
          //ice = rng.nextInt(2) + 5;
          createDropBox();
          tim.cancel();
        } else {
          var val = rng.nextInt(8);
          Provider.of<IndexProvider>(context, listen: false)
              .setInt(columnList[val][0]);
          setdropLetter();
          rows[Provider.of<IndexProvider>(context, listen: false).indexCheck] =
              dropletterVal;
          rowsColor[Provider.of<IndexProvider>(context, listen: false)
              .indexCheck] = buttoncolorlist[color];
          const duration = const Duration(milliseconds: 45);
          Timer.periodic(duration, (Timer tim2) {
            if (!(Provider.of<IndexProvider>(context, listen: false)
                    .indexCheck >
                columnList[val][9])) {
              dropLetter();
            } else {
              tim2.cancel();
            }
          });
        }
      });
    } else if (300 > point && point >= 200) {
      const duration = const Duration(seconds: 3);
      level = 2;
      timer2 = Timer.periodic(duration, (Timer tim) {
        if (gamefinish) {
          _controller.reset();
          timer!.cancel();
          tim.cancel();
          timer2!.cancel();

          Provider.of<PointProvider>(context, listen: false).setInt(point);
          Provider.of<WordProvider>(context, listen: false).setString("");
          Provider.of<IndexProvider>(context, listen: false).setInt(80);

          Navigator.pop(context);
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new GameScore()));
        } else if (point >= 300) {
          //  ice = rng.nextInt(2) + 4;
          createDropBox();
          tim.cancel();
        } else {
          var val = rng.nextInt(8);
          Provider.of<IndexProvider>(context, listen: false)
              .setInt(columnList[val][0]);
          setdropLetter();
          rows[Provider.of<IndexProvider>(context, listen: false).indexCheck] =
              dropletterVal;
          rowsColor[Provider.of<IndexProvider>(context, listen: false)
              .indexCheck] = buttoncolorlist[color];
          const duration = const Duration(milliseconds: 45);
          Timer.periodic(duration, (Timer tim2) {
            if (!(Provider.of<IndexProvider>(context, listen: false)
                    .indexCheck >
                columnList[val][9])) {
              dropLetter();
            } else {
              tim2.cancel();
            }
          });
        }
      });
    } else if (400 > point && point >= 300) {
      const duration = const Duration(seconds: 2);
      level = 3;
      timer2 = Timer.periodic(duration, (Timer tim) {
        if (gamefinish) {
          _controller.reset();
          timer!.cancel();
          tim.cancel();
          timer2!.cancel();

          Provider.of<PointProvider>(context, listen: false).setInt(point);
          Provider.of<WordProvider>(context, listen: false).setString("");
          Provider.of<IndexProvider>(context, listen: false).setInt(80);

          Navigator.pop(context);
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new GameScore()));
        } else if (point >= 400) {
          //  ice = rng.nextInt(3) + 3;
          createDropBox();
          tim.cancel();
        } else {
          var val = rng.nextInt(8);
          Provider.of<IndexProvider>(context, listen: false)
              .setInt(columnList[val][0]);
          setdropLetter();
          rows[Provider.of<IndexProvider>(context, listen: false).indexCheck] =
              dropletterVal;
          rowsColor[Provider.of<IndexProvider>(context, listen: false)
              .indexCheck] = buttoncolorlist[color];
          const duration = const Duration(milliseconds: 45);
          Timer.periodic(duration, (Timer tim2) {
            if (!(Provider.of<IndexProvider>(context, listen: false)
                    .indexCheck >
                columnList[val][9])) {
              dropLetter();
            } else {
              tim2.cancel();
            }
          });
        }
      });
    } else if (point >= 400) {
      level = 4;
      const duration = const Duration(seconds: 1);
      ice = 4;

      timer2 = Timer.periodic(duration, (Timer tim) {
        if (gamefinish) {
          _controller.reset();
          timer!.cancel();
          tim.cancel();
          timer2!.cancel();

          Provider.of<PointProvider>(context, listen: false).setInt(point);
          Provider.of<WordProvider>(context, listen: false).setString("");
          Provider.of<IndexProvider>(context, listen: false).setInt(80);

          Navigator.pop(context);
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new GameScore()));
        } else {
          var val = rng.nextInt(8);
          Provider.of<IndexProvider>(context, listen: false)
              .setInt(columnList[val][0]);
          setdropLetter();
          rows[Provider.of<IndexProvider>(context, listen: false).indexCheck] =
              dropletterVal;
          rowsColor[Provider.of<IndexProvider>(context, listen: false)
              .indexCheck] = buttoncolorlist[color];
          const duration = const Duration(milliseconds: 45);
          Timer.periodic(duration, (Timer tim2) {
            if (!(Provider.of<IndexProvider>(context, listen: false)
                    .indexCheck >=
                columnList[val][9])) {
              dropLetter();
            } else {
              tim2.cancel();
            }
          });
        }
      });
    }
  }

  void dropLetter() {
    if (this.mounted) {
      setState(() {
        /*  if (ice == icecount) {
          print(ice);
          Provider.of<IndexProvider>(context, listen: false).setInt(
              Provider.of<IndexProvider>(context, listen: false).indexCheck +
                  8);

          if (!gamevisible.contains(
              Provider.of<IndexProvider>(context, listen: false).indexCheck)) {
            for (var i = 0; i < 8; i++) {
              if (columnList[i].last ==
                  Provider.of<IndexProvider>(context, listen: false)
                      .indexCheck) {
                rows[Provider.of<IndexProvider>(context, listen: false)
                    .indexCheck] = dropletterVal;
                rowsColor[Provider.of<IndexProvider>(context, listen: false)
                    .indexCheck] = icecolor;
                if (!gamevisible.contains(
                    Provider.of<IndexProvider>(context, listen: false)
                        .indexCheck)) {
                  gamevisible.add(
                      Provider.of<IndexProvider>(context, listen: false)
                          .indexCheck);
                }

                Provider.of<IndexProvider>(context, listen: false).setInt(80);
              }
            }

            rows[Provider.of<IndexProvider>(context, listen: false)
                .indexCheck] = dropletterVal;
            rowsColor[Provider.of<IndexProvider>(context, listen: false)
                .indexCheck] = icecolor;
          } else {
            rows[Provider.of<IndexProvider>(context, listen: false).indexCheck -
                8] = dropletterVal;
            rowsColor[
                Provider.of<IndexProvider>(context, listen: false).indexCheck -
                    8] = icecolor;
            if (!gamevisible.contains(
                Provider.of<IndexProvider>(context, listen: false).indexCheck -
                    8)) {
              gamevisible.add(Provider.of<IndexProvider>(context, listen: false)
                      .indexCheck -
                  8);
            }

            iceboxsindex.add(
                Provider.of<IndexProvider>(context, listen: false).indexCheck -
                    8);
            IceClass().addIceBox(
                Provider.of<IndexProvider>(context, listen: false).indexCheck -
                    8);
            icecount = 0;

            for (var i = 0; i < 8; i++) {
              if (columnList[i].first ==
                  Provider.of<IndexProvider>(context, listen: false)
                          .indexCheck -
                      8) {
                _controller.reset();
                timer!.cancel();

                timer2!.cancel();
                Provider.of<PointProvider>(context, listen: false)
                    .setInt(point);
                Provider.of<WordProvider>(context, listen: false).setString("");
                Provider.of<IndexProvider>(context, listen: false).setInt(80);

                Navigator.pop(context);
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new GameScore()));

                print("createdrop");

                break;
              }
            }
            Provider.of<IndexProvider>(context, listen: false).setInt(80);
          }
        } else if (icecount < ice) { */
        Provider.of<IndexProvider>(context, listen: false).setInt(
            Provider.of<IndexProvider>(context, listen: false).indexCheck + 8);

        if (!gamevisible.contains(
            Provider.of<IndexProvider>(context, listen: false).indexCheck)) {
          for (var i = 0; i < 8; i++) {
            if (columnList[i].last ==
                Provider.of<IndexProvider>(context, listen: false).indexCheck) {
              rows[Provider.of<IndexProvider>(context, listen: false)
                  .indexCheck] = dropletterVal;
              rowsColor[Provider.of<IndexProvider>(context, listen: false)
                  .indexCheck] = buttoncolorlist[color];
              if (!gamevisible.contains(
                  Provider.of<IndexProvider>(context, listen: false)
                      .indexCheck)) {
                gamevisible.add(
                    Provider.of<IndexProvider>(context, listen: false)
                        .indexCheck);
              }

              Provider.of<IndexProvider>(context, listen: false).setInt(80);
            }
          }

          rows[Provider.of<IndexProvider>(context, listen: false).indexCheck] =
              dropletterVal;
          rowsColor[Provider.of<IndexProvider>(context, listen: false)
              .indexCheck] = buttoncolorlist[color];
        } else {
          rows[Provider.of<IndexProvider>(context, listen: false).indexCheck -
              8] = dropletterVal;
          rowsColor[
              Provider.of<IndexProvider>(context, listen: false).indexCheck -
                  8] = buttoncolorlist[color];
          if (!gamevisible.contains(
              Provider.of<IndexProvider>(context, listen: false).indexCheck -
                  8)) {
            gamevisible.add(
                Provider.of<IndexProvider>(context, listen: false).indexCheck -
                    8);
          }

          //icecount++;

          for (var i = 0; i < 8; i++) {
            if (columnList[i].first ==
                Provider.of<IndexProvider>(context, listen: false).indexCheck -
                    8) {
              gamefinish = true;
              _controller.reset();

              timer!.cancel();

              timer2!.cancel();
              Provider.of<PointProvider>(context, listen: false).setInt(point);
              Provider.of<WordProvider>(context, listen: false).setString("");
              Provider.of<IndexProvider>(context, listen: false).setInt(80);

              Navigator.pop(context);
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new GameScore()));

              break;
            }
          }
          Provider.of<IndexProvider>(context, listen: false).setInt(80);
        }
        // }
      });
    }
  }

  void deleteAllText() {
    if (this.mounted) {
      setState(() {
        Provider.of<WordProvider>(context, listen: false).deleteString();
        checkword = "";
        selectedLetter.clear();
      });
    }
  }

  void deleteLetter() {
    bool control = true;
    bool check = true;
    String temp = "";
    Color tempcolor = Colors.transparent;
    Color tempcolor2 = Colors.transparent;
    String temp2 = "";
    int dropice = 90;
    for (var i = 0; i < columnList.length; i++) {
      selectedLetter.sort();
      selectedLetter.forEach((element) {
        check = true;
        if (columnList[i].contains(element)) {
          for (var z = 0; z < columnList[i].indexOf(element); z++) {
            if (columnList[i].contains(columnList[i][z] + 8)) {
              if (gamevisible.contains(columnList[i][z])) {
                if (check) {
                  gamevisible[gamevisible.indexOf(columnList[i][z])] += 8;
                  temp = rows[columnList[i][z + 1]]!;
                  tempcolor = rowsColor[columnList[i][z + 1]]!;
                  /* if (icecolor == rowsColor[columnList[i][z]]!) {
                    iceboxsindex[iceboxsindex.indexOf(columnList[i][z])] += 8;
                  }*/
                  rows[columnList[i][z + 1]] = rows[columnList[i][z]]!;
                  rowsColor[columnList[i][z + 1]] =
                      rowsColor[columnList[i][z]]!;
                  check = false;
                } else {
                  temp2 = rows[columnList[i][z + 1]]!;
                  tempcolor2 = rowsColor[columnList[i][z + 1]]!;

                  gamevisible[gamevisible.indexOf(columnList[i][z])] += 8;
                  rows[columnList[i][z + 1]] = temp;
                  /*  if (tempcolor == icecolor) {
                    iceboxsindex[iceboxsindex.indexOf(columnList[i][z + 1])] +=
                        8;
                  }*/
                  rowsColor[columnList[i][z + 1]] = tempcolor;
                  temp = temp2;
                  tempcolor = tempcolor2;
                }
              } else {
                gamevisible.remove(element);
              }
            } else {
              control = false;
            }
          }
          if (!control) {
            gamevisible.remove(element);
          }
        }
      });
    }

    deleteAllText();
    // IceClass().refreshicebox();
  }

  void resetpunishment() {
    //inmesi gereken 3 satir kontrolu

    if (visiblecont.length > 0) {
      for (var i = 0; i < visiblecont.length; i++) {
        visiblecont[i] = 80;
        punishmentlecont[i] = 80;
      }
      //her satir inisinde o satirin harf dizimini belirliyor
    }
  }

  void resetpunishmentcount() {
    if (this.mounted) {
      setState(() {
        for (var t = 0; t < 8; t++) {
          if (rng.nextInt(2) == 0) {
            lineLetter[t] = vowel.elementAt(rng.nextInt(8));
            punishmentlecont[t] = lineList[0][t];

            visiblecont[t] = lineList[0][t];
            lineColor[t] = rng.nextInt(buttoncolorlist.length);
          } else {
            lineLetter[t] = consanant.elementAt(rng.nextInt(21));
            punishmentlecont[t] = lineList[0][t];

            visiblecont[t] = lineList[0][t];
            lineColor[t] = rng.nextInt(buttoncolorlist.length);
          }
        }
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void startPunishment() {
    // resetpunishment();
    resetpunishmentcount();
    const duration = const Duration(milliseconds: 65);

    timerpunis = Timer.periodic(duration, (Timer t) {
      if (gamefinish) {
        t.cancel();
        timerpunis!.cancel();
      } else {
        movedownPunishment();
      }
    });
  }

  void movedownPunishment() {
    if (this.mounted) {
      setState(() {
        for (var i = 0; i < lineList[0].length; i++) {
          punishmentlecont[i] += 8;

          if (!gamevisible.contains(punishmentlecont[i]) &&
              punishmentlecont[i] < 80) {
            visiblecont[i] = punishmentlecont[i];
            rows.addAll({visiblecont[i]: lineLetter[i]});
            rowsColor.addAll({visiblecont[i]: buttoncolorlist[lineColor[i]]});
            for (var i = 0; i < columnList.length; i++) {
              if (columnList[i].last == punishmentlecont[i]) {
                if (!gamevisible.contains(visiblecont[i])) {
                  gamevisible.add(visiblecont[i]);
                }
                break;
              }
            }
          } else {
            if (!gamevisible.contains(visiblecont[i])) {
              gamevisible.add(visiblecont[i]);
            }

            for (var n = 0; n < 8; n++) {
              if (columnList[n].first == visiblecont[n]) {
                wrong = 0;
                timer!.cancel();
                gamefinish = true;
                endgame_in_punishment = true;

                break;
              }
            }
          }
        }
      });
    }
  }

  void checkTextforPoint() {
    if (this.mounted) {
      setState(() {
        if (wordpool.contains(Provider.of<WordProvider>(context, listen: false)
            .wordCheck
            .trim())) {
          Characters wordcharacters = checkword.trim().characters;
          wordcharacters.forEach((element) {
            point += letterPoint[element]!;
          });

          deleteLetter();
        } else {
          wrong++;

          if (wrong == 3 && !gamefinish) {
            startPunishment();
            _controller.forward();
            Timer.periodic(Duration(seconds: 2), (timer) {
              wrong = 0;
              resetpunishment();
              timer.cancel();
              _controller.reset();
              //createDropBox();
            });
          }
        }
      });
    }
  }

  Timer? timersplash;
  Widget? splashScreen() {
    timersplash = Timer(Duration(seconds: 3), () {
      if (timersplash!.tick == 3) {
        timersplash!.cancel();
      }
    });
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<WordProvider>(context).loadThemeFromSharedPref();

    return Scaffold(
      body: Container(
        color: Colors.grey.shade800,
        child: FutureBuilder(
            future: loadAsset(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.13,
                              margin: EdgeInsets.only(
                                left: 25,
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(8),
                                    elevation: 7,
                                    shape: ContinuousRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(25),
                                            bottomRight: Radius.circular(25)),
                                        side: BorderSide.none),
                                    side: BorderSide(
                                      style: BorderStyle.none,
                                    ),
                                    backgroundColor: Colors.grey.shade600),
                                onPressed: () {
                                  if (this.mounted) {
                                    setState(() {
                                      if (start) {
                                        startGame();
                                        start = false;
                                      }
                                    });
                                  }
                                },
                                child: start
                                    ? Container(
                                        child: Icon(
                                          Icons.play_arrow,
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.08,
                                        ),
                                      )
                                    : Icon(
                                        Icons.pause,
                                        size:
                                            MediaQuery.of(context).size.width *
                                                0.08,
                                      ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.close,
                                    size: MediaQuery.of(context).size.width *
                                        0.15,
                                    color: wrong >= 1
                                        ? Colors.red
                                        : Colors.grey.shade800.darken(0.4),
                                  ),
                                  CircleAvatar(
                                    radius: MediaQuery.of(context).size.width *
                                        0.16,
                                    backgroundColor: wrong >= 3
                                        ? Colors.red
                                        : Colors.transparent,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey.shade900,
                                      radius:
                                          MediaQuery.of(context).size.width *
                                              0.14,
                                      child: wrong >= 3
                                          ? RotationTransition(
                                              turns: Tween(begin: 0.0, end: 1.0)
                                                  .animate(_controller),
                                              child: Icon(
                                                PhosphorIcons.fill.skull,
                                                size: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2,
                                              ),
                                            )
                                          : Text(
                                              '${point}',
                                              style: GoogleFonts.glory(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.09),
                                            ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.close,
                                    size: MediaQuery.of(context).size.width *
                                        0.15,
                                    color: wrong >= 2
                                        ? Colors.red
                                        : Colors.grey.shade800.darken(0.4),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(flex: 14, child: GameGrid()),
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: Stack(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                      bottom: 15,
                                    ),
                                    color: Colors.grey.shade800.darken(0.3),
                                    width: MediaQuery.of(context).size.width,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Text(
                                            Provider.of<WordProvider>(context)
                                                .wordCheck,
                                            style: GoogleFonts.glory(
                                              color: Colors.white60,
                                              letterSpacing: 10,
                                              fontSize: 30,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (this.mounted) {
                                          setState(() {
                                            deleteAllText();
                                          });
                                        }
                                      },
                                      child: Icon(
                                        Icons.close,
                                        size:
                                            MediaQuery.of(context).size.width *
                                                0.12,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        elevation: 7,
                                        backgroundColor: Colors.red.shade400,
                                        padding: EdgeInsets.all(10),
                                        shape: ContinuousRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(20),
                                                topRight: Radius.circular(20))),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          if (this.mounted) {
                                            setState(() {
                                              checkTextforPoint();
                                            });
                                          }
                                        },
                                        child: Icon(
                                          Icons.done,
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.12,
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          elevation: 7,
                                          backgroundColor: Colors.teal.shade400,
                                          padding: EdgeInsets.all(10),
                                          shape: ContinuousRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(20),
                                                  topLeft:
                                                      Radius.circular(20))),
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 2,
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: DotsIndicator(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    mainAxisSize: MainAxisSize.max,
                                    dotsCount: 5,
                                    position: level.toDouble(),
                                    decorator: DotsDecorator(
                                        size: Size.square(20),
                                        activeSize: const Size(30.0, 25.0),
                                        color: Colors.white12,
                                        activeColor: Colors.amberAccent,
                                        shape: StarBorder(),
                                        activeShape: StarBorder(

                                            // borderRadius: BorderRadius.circular(5.0)),
                                            )),
                                  ),
                                ),
                              ))
                        ],
                      ),
                    )
                  ],
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: new BoxDecoration(
                    color: Colors.grey.shade900,
                  ),
                  child: new Center(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                height: 400,
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.95,
                                        height: 100,
                                        decoration: BoxDecoration(
                                            // color: Colors.white38,
                                            //borderRadius: BorderRadius.all(Radius.circular(40))
                                            ),
                                        child: Center(
                                          child: Text(
                                            "WORD GAME",
                                            style: GoogleFonts.glory(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 30,
                                                letterSpacing: 12,
                                                height: 0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: LoadingIndicator(
                                        // backgroundColor: Colors.white,

                                        indicatorType: Indicator.ballPulse,
                                        colors: [
                                          Colors.greenAccent.shade700
                                              .brighten(0.1),
                                          Colors.pinkAccent.shade700
                                              .brighten(0.3),
                                          Colors.orange.shade800.brighten(0.2)
                                        ],

                                        strokeWidth: 1.0,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                  //<- place where the image appears
                );
              }
              return Container();
            }),
      ),
    );
  }
}
