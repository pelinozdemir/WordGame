import 'dart:math';

import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Game.dart';
import 'package:flutter_application_1/GameLists.dart';
import 'package:flutter_application_1/buttonColor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:gui_shape/gui_shape.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:provider/provider.dart';

import 'models/providersPoint.dart';

class GameScore extends StatefulWidget {
  @override
  State<GameScore> createState() => _GameScoreState();
}

class _GameScoreState extends State<GameScore>
    with SingleTickerProviderStateMixin {
  CarouselController _controller = CarouselController();
  int _index = 0;

  late AnimationController _controllers;

  @override
  void initState() {
    setState(() {
      _controllers = AnimationController(
        duration: const Duration(milliseconds: 5000),
        vsync: this,
      );
      _controllers.forward();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      SliverAppBar(
          elevation: 0,
          stretch: true,
          backgroundColor: Colors.grey.shade900,
          expandedHeight: MediaQuery.of(context).size.height,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
              expandedTitleScale: 1.5,
              centerTitle: true,
              collapseMode: CollapseMode.parallax,
              titlePadding: EdgeInsets.all(20),
              stretchModes: [
                StretchMode.blurBackground,
                StretchMode.zoomBackground
              ],
              background: Stack(
                children: [
                  Positioned(
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.only(bottom: 10),
                      color: Colors.grey.shade800,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RotationTransition(
                                turns: Tween(begin: 0.0, end: 1.0)
                                    .animate(_controllers),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.06,
                                  width:
                                      MediaQuery.of(context).size.width * 0.13,
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image:
                                              AssetImage('assets/bones.png'))),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.04,
                              ),
                              CircleAvatar(
                                radius:
                                    MediaQuery.of(context).size.width * 0.14,
                                backgroundColor: Colors.transparent,
                                child: CircleAvatar(
                                    backgroundColor: Colors.grey.shade900,
                                    radius: MediaQuery.of(context).size.width *
                                        0.14,
                                    child: Icon(PhosphorIcons.fill.skull,
                                        color: Colors.white,
                                        size:
                                            MediaQuery.of(context).size.width *
                                                0.2)),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.04,
                              ),
                              RotationTransition(
                                turns: Tween(begin: 0.0, end: 1.0)
                                    .animate(_controllers),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.06,
                                  width:
                                      MediaQuery.of(context).size.width * 0.13,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(80),
                                      color: Colors.transparent,
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image:
                                              AssetImage('assets/bones.png'))),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 25),
                            child: DefaultTextStyle(
                              style: GoogleFonts.glory(
                                  fontSize: 40, letterSpacing: 12),
                              child: AnimatedTextKit(
                                onTap: () {
                                  _controllers.forward();
                                },
                                animatedTexts: [
                                  TypewriterAnimatedText('GAME OVER'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.25,
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.25,
                    left: 0,
                    right: 0,
                    child: Container(
                      margin: EdgeInsets.only(left: 12, right: 12),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.55,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800.darken(0.3),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(40),
                            bottomRight: Radius.circular(40)),
                      ),
                      child: Stack(children: [
                        Positioned(
                            left: 0,
                            right: 0,
                            child: Column(
                              children: [
                                CarouselSlider(
                                    carouselController: _controller,
                                    options: CarouselOptions(
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          _index = index;
                                        });
                                      },
                                      scrollPhysics: BouncingScrollPhysics(
                                          decelerationRate:
                                              ScrollDecelerationRate.fast),
                                      animateToClosest: true,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.4,
                                      aspectRatio: 16 / 7,
                                      viewportFraction: 1,
                                      initialPage: 0,
                                      enableInfiniteScroll: true,
                                      reverse: false,
                                      autoPlay: false,
                                      autoPlayInterval: Duration(seconds: 3),
                                      autoPlayAnimationDuration:
                                          Duration(milliseconds: 800),
                                      autoPlayCurve: Curves.linear,
                                      enlargeCenterPage: true,
                                      enlargeFactor: 0.3,
                                      scrollDirection: Axis.horizontal,
                                    ),
                                    items: [
                                      Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.6,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.11,
                                              child: Center(
                                                  child: Text(
                                                "SCORE",
                                                style: GoogleFonts.glory(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.07,
                                                    letterSpacing: 6),
                                              )),
                                              decoration: BoxDecoration(
                                                  // color: Colors.red,
                                                  image: DecorationImage(
                                                      fit: BoxFit.fitWidth,
                                                      image: AssetImage(
                                                          'assets/ribbon.png'))),
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.06,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.17,
                                              child: Center(
                                                  child: Text(
                                                "${point}",
                                                style: GoogleFonts.glory(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 25,
                                                    letterSpacing: 6),
                                              )),
                                              decoration: BoxDecoration(
                                                  //color: Colors.red,
                                                  image: DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: AssetImage(
                                                          'assets/sheriff.png'))),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        //  color: Colors.amber,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6,
                                                child: Center(
                                                    child: Text(
                                                  "SCORE",
                                                  style: GoogleFonts.glory(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.07,
                                                      letterSpacing: 6),
                                                )),
                                                decoration: BoxDecoration(
                                                    // color: Colors.red,
                                                    image: DecorationImage(
                                                        fit: BoxFit.fitWidth,
                                                        image: AssetImage(
                                                            'assets/ribbon.png'))),
                                              ),
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.04,
                                            ),
                                            Expanded(
                                              flex: 6,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 0,
                                                  right: 0,
                                                ),
                                                child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,

                                                    //color: Colors.red,
                                                    child:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      child: DataTable(
                                                          headingRowHeight: 0,
                                                          columnSpacing: 0,
                                                          showBottomBorder:
                                                              true,
                                                          dividerThickness: 2,
                                                          horizontalMargin: 0,
                                                          border: TableBorder.all(
                                                              color: Colors
                                                                  .transparent),
                                                          showCheckboxColumn:
                                                              false,
                                                          columns: [
                                                            DataColumn(
                                                                label: Text('',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            0,
                                                                        fontWeight:
                                                                            FontWeight.bold))),
                                                            DataColumn(
                                                                label: Text('',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            0,
                                                                        fontWeight:
                                                                            FontWeight.bold))),
                                                          ],
                                                          rows: Provider.of<
                                                                      PointProvider>(
                                                                  context)
                                                              .pointCheck
                                                              .map((e) {
                                                            return DataRow(
                                                                color: MaterialStateProperty
                                                                    .resolveWith<
                                                                        Color?>((Set<
                                                                            MaterialState>
                                                                        states) {
                                                                  if (states.contains(
                                                                      MaterialState
                                                                          .selected)) {
                                                                    return buttoncolorlist[
                                                                        rng.nextInt(
                                                                            buttoncolorlist.length)];
                                                                  }
                                                                  return Colors
                                                                      .grey
                                                                      .shade700
                                                                      .withOpacity(
                                                                          0.3); // Use the default value.
                                                                }),
                                                                cells: [
                                                                  DataCell(
                                                                    Icon(
                                                                      Icons
                                                                          .arrow_right,
                                                                      size: 40,
                                                                      color: Colors
                                                                          .orangeAccent,
                                                                    ),
                                                                  ),
                                                                  DataCell(Text(
                                                                    "${e}",
                                                                    style: GoogleFonts.glory(
                                                                        color: Colors
                                                                            .grey
                                                                            .shade300,
                                                                        fontSize:
                                                                            25),
                                                                  ))
                                                                ]);
                                                          }).toList()

                                                          //if data is loaded then show table

                                                          ),
                                                    )),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ]),
                                new DotsIndicator(
                                  //  mainAxisSize: MainAxisSize.max,
                                  dotsCount: 2,
                                  position: _index.toDouble(),
                                  decorator: DotsDecorator(
                                      activeColor: Colors.amberAccent,
                                      size: Size.square(10),
                                      activeSize: const Size(18.0, 15.0),
                                      shape: const StarBorder(),
                                      activeShape: StarBorder(
                                        innerRadiusRatio: 0.5,
                                        points: 5,

                                        // borderRadius: BorderRadius.circular(5.0)),
                                      )),
                                ),
                              ],
                            )),
                        Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        padding: EdgeInsets.all(20),
                                        shape: ContinuousRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(40),
                                                topLeft: Radius.circular(0))),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _controller.stopAutoPlay();
                                          _controllers.reset();
                                          SystemNavigator.pop();
                                        });
                                      },
                                      child: Icon(
                                        Icons.close,
                                        size: 35,
                                      )),
                                ),
                                Expanded(
                                    flex: 4,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors
                                              .deepPurple.shade200
                                              .darken(0.4),
                                          padding: EdgeInsets.all(20),
                                          shape: ContinuousRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(40),
                                                  topRight:
                                                      Radius.circular(0))),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            // add your code here.

                                            _controller.stopAutoPlay();
                                            _controllers.reset();
                                            Navigator.pop(context);
                                            Navigator.push(
                                                context,
                                                new MaterialPageRoute(
                                                    builder: (context) =>
                                                        new GameUI()));

                                            // Navigator.pop(context);
                                          });
                                        },
                                        child: Icon(
                                          Icons.refresh_rounded,
                                          size: 35,
                                        )))
                              ],
                            )),
                      ]),
                    ),
                  ),
                ],
              )))
    ]);
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => new GameUI(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }
}
