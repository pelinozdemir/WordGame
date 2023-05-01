import 'dart:math';
import 'dart:ui';

import 'package:flutter_application_1/Game.dart';

void refreshAllList() {
  selectedLetter.clear();
  iceboxs.clear();
  dropice.clear();
  iceboxsindex.clear();
  endgame_in_punishment = false;
  wrong = 0;
  gamevisible.clear();
  randomletter.clear();
  punishmentLetter.clear();
  rows.clear();
  rowsColor.clear();
  visiblecont = [80, 80, 80, 80, 80, 80, 80, 80];
  punishmentlecont = [0, 1, 2, 3, 4, 5, 6, 7];
  lineLetter = ["", "", "", "", "", "", "", ""];
  lineColor = [7, 7, 7, 7, 7, 7, 7, 7];
  punishmentLetter = ["", "", "", "", "", "", "", ""];
  gamefinish = false;
  start = true;
  point = 0;
  dropletterVal = "";
  checkword = "";
  icecount = 0;
  ice = 12;
  color = 80;
  selected = false;
  selectedindex = 80;
  scoreindex = 0;
  level = 0;
  activepos = 0;
}

int activepos = 0;
int level = 0;
int point = 0;
Map<int, int> deleteice = {};
int scoreindex = 0;
bool gamefinish = false;
bool start = true;
List<int> controllerforgrid = [];
List<int> selectedLetter = [];
List<int> visiblecont = [80, 80, 80, 80, 80, 80, 80, 80];
List<int> punishmentlecont = [0, 1, 2, 3, 4, 5, 6, 7];
int color = 80;
int ice = 8;
int icecount = 0;
List<int> iceboxsindex = [];
List<int> dropice = [];
List<int> iceboxs = [];
//bool gamefinish = false;
bool endgame_in_punishment = false;

//oyunda gozukecek olan indexlerin listesi
int wrong = 0;
List<int> gamevisible = [];
List<int> randomletter = [];
List<int> punishmentrandomletter = [];
Map<int, String> rows = {};
List<String> lineLetter = ["", "", "", "", "", "", "", ""];
Map<int, Color> rowsColor = {};
List<int> lineColor = [7, 7, 7, 7, 7, 7, 7, 7];

String dropletterVal = "";
Map<String, int> letterPoint = {
  "A": 1,
  "B": 3,
  "C": 4,
  "Ç": 4,
  "D": 3,
  "E": 1,
  "F": 7,
  "G": 5,
  "Ğ": 8,
  "H": 5,
  "I": 2,
  "İ": 1,
  "J": 10,
  "K": 1,
  "L": 1,
  "M": 2,
  "N": 1,
  "O": 2,
  "Ö": 7,
  "P": 5,
  "R": 1,
  "S": 2,
  "Ş": 4,
  "T": 1,
  "U": 2,
  "Ü": 3,
  "V": 7,
  "Y": 3,
  "Z": 4,
};

//gridviewin index dizimine gore ayarlanmis satir ve sutunlar
List<List<int>> lineList = [
  [0, 1, 2, 3, 4, 5, 6, 7],
  [8, 9, 10, 11, 12, 13, 14, 15],
  [16, 17, 18, 19, 20, 21, 22, 23],
  [24, 25, 26, 27, 28, 29, 30, 31],
  [32, 33, 34, 35, 36, 37, 38, 39],
  [40, 41, 42, 43, 44, 45, 46, 47],
  [48, 49, 50, 51, 52, 53, 54, 55],
  [56, 57, 58, 59, 60, 61, 62, 63],
  [64, 65, 66, 67, 68, 69, 70, 71],
  [72, 73, 74, 75, 76, 77, 78, 79]
];
List<List<int>> columnList = [
  [0, 8, 16, 24, 32, 40, 48, 56, 64, 72],
  [1, 9, 17, 25, 33, 41, 49, 57, 65, 73],
  [2, 10, 18, 26, 34, 42, 50, 58, 66, 74],
  [3, 11, 19, 27, 35, 43, 51, 59, 67, 75],
  [4, 12, 20, 28, 36, 44, 52, 60, 68, 76],
  [5, 13, 21, 29, 37, 45, 53, 61, 69, 77],
  [6, 14, 22, 30, 38, 46, 54, 62, 70, 78],
  [7, 15, 23, 31, 39, 47, 55, 63, 71, 79],
];
bool selected = false;
int selectedindex = 80;
List<String> wordpool = [];
List<List<String>> letters = [
  ["A", "E", "I", "İ", " O", "Ö", "U", "Ü"],
  [
    "B",
    "C",
    "Ç",
    "D",
    "F",
    "G",
    "Ğ",
    "H",
    "J",
    "K",
    "L",
    "M",
    "N",
    "P",
    "R",
    "S",
    "Ş",
    "T",
    "V",
    "Y",
    "Z"
  ]
];

var rng = Random();

List<String> punishmentLetter = ["", "", "", "", "", "", "", ""];
List<String> vowel = ["A", "E", "I", "İ", " O", "Ö", "U", "Ü"];
List<String> consanant = [
  "B",
  "C",
  "Ç",
  "D",
  "F",
  "G",
  "Ğ",
  "H",
  "J",
  "K",
  "L",
  "M",
  "N",
  "P",
  "R",
  "S",
  "Ş",
  "T",
  "V",
  "Y",
  "Z"
];
String checkword = "";
