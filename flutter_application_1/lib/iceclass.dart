import 'package:flutter/material.dart';
import 'package:flutter_application_1/buttonColor.dart';

import 'GameLists.dart';

class IceClass {
  bool checkIceBox(int index) {
    if (iceboxs.contains(index)) {
      return true;
    } else {
      return false;
    }
  }

  void refreshicebox() {
    bool checkice = false;

    iceboxs.removeRange(0, iceboxs.length);
    for (var i = 0; i < 10; i++) {
      for (var t = 0; t < iceboxsindex.length;) {
        if (lineList[i][0] == iceboxsindex[t] &&
            (lineList[i][7] != iceboxsindex[t])) {
          if (!iceboxs.contains(iceboxsindex[t] + 1) ||
              !iceboxsindex.contains(iceboxsindex[t] + 1)) {
            iceboxs.add(iceboxsindex[t] + 1);
            deleteice.addAll({iceboxsindex[t] + 1: 0});
            rowsColor[iceboxsindex[t] + 1] = iceboxcolor;
          }
          if (!iceboxs.contains(iceboxsindex[t] - 8) ||
              !iceboxsindex.contains(iceboxsindex[t] - 8)) {
            iceboxs.add(iceboxsindex[t] - 8);
            deleteice.addAll({iceboxsindex[t] - 8: 0});
            rowsColor[iceboxsindex[t] - 8] = iceboxcolor;
          }
          if (!iceboxs.contains(iceboxsindex[t] + 8) ||
              !iceboxsindex.contains(iceboxsindex[t] + 8)) {
            iceboxs.add(iceboxsindex[t] + 8);
            deleteice.addAll({iceboxsindex[t] + 8: 0});
            rowsColor[iceboxsindex[t] + 8] = iceboxcolor;
          }
          checkice = true;

          break;
        } else if (lineList[i][0] != iceboxsindex[t] &&
            lineList[i][7] == iceboxsindex[t]) {
          if (!iceboxs.contains(iceboxsindex[t] - 1) ||
              !iceboxsindex.contains(iceboxsindex[t] - 1)) {
            iceboxs.add(iceboxsindex[t] - 1);
            deleteice.addAll({iceboxsindex[t] - 1: 0});
            rowsColor[iceboxsindex[t] - 1] = iceboxcolor;
          }
          if (!iceboxs.contains(iceboxsindex[t] - 8) ||
              !iceboxsindex.contains(iceboxsindex[t] - 8)) {
            iceboxs.add(iceboxsindex[t] - 8);
            deleteice.addAll({iceboxsindex[t] - 8: 0});
            rowsColor[iceboxsindex[t] - 8] = iceboxcolor;
          }
          if (!iceboxs.contains(iceboxsindex[t] + 8) ||
              !iceboxsindex.contains(iceboxsindex[t] + 8)) {
            iceboxs.add(iceboxsindex[t] + 8);
            deleteice.addAll({iceboxsindex[t] + 8: 0});
            rowsColor[iceboxsindex[t] + 8] = iceboxcolor;
          }
          checkice = true;

          break;
        } else {
          if (!iceboxs.contains(iceboxsindex[t] + 1) ||
              !iceboxsindex.contains(iceboxsindex[t] + 1)) {
            iceboxs.add(iceboxsindex[t] + 1);
            deleteice.addAll({iceboxsindex[t] + 1: 0});
            rowsColor[iceboxsindex[t] + 1] = iceboxcolor;
          }
          if (!iceboxs.contains(iceboxsindex[t] - 1) ||
              !iceboxsindex.contains(iceboxsindex[t] - 1)) {
            iceboxs.add(iceboxsindex[t] - 1);
            deleteice.addAll({iceboxsindex[t] - 1: 0});
            rowsColor[iceboxsindex[t] - 1] = iceboxcolor;
          }
          if (!iceboxs.contains(iceboxsindex[t] - 8) ||
              !iceboxsindex.contains(iceboxsindex[t] - 8)) {
            iceboxs.add(iceboxsindex[t] - 8);
            deleteice.addAll({iceboxsindex[t] - 8: 0});
            rowsColor[iceboxsindex[t] - 8] = iceboxcolor;
          }
          if (!iceboxs.contains(iceboxsindex[t] + 8) ||
              !iceboxsindex.contains(iceboxsindex[t] + 8)) {
            iceboxs.add(iceboxsindex[t] + 8);
            deleteice.addAll({iceboxsindex[t] + 8: 0});
            rowsColor[iceboxsindex[t] + 8] = iceboxcolor;
          }

          break;
        }
      }
    }
  }

  void addIceBox(int index) {
    bool checkice = false;

    for (var i = 0; i < 10; i++) {
      if (lineList[i][0] == index && (lineList[i][7] != index)) {
        if (iceboxs.contains(index + 1) || iceboxsindex.contains(index + 1)) {
          checkice = true;

          break;
        } else {
          iceboxs.add(index + 1);
          deleteice.addAll({index + 1: 0});
          rowsColor[index + 1] = iceboxcolor;
          checkice = true;
          break;
        }
      } else if (lineList[i][0] != index && lineList[i][7] == index) {
        if (iceboxs.contains(index - 1) || iceboxsindex.contains(index - 1)) {
          checkice = true;

          break;
        } else {
          iceboxs.add(index - 1);
          deleteice.addAll({index - 1: 0});
          rowsColor[index - 1] = iceboxcolor;

          checkice = true;
          break;
        }
      }
      if (checkice) {
        if (iceboxsindex.contains(index + 8)) {
          iceboxs.add(index - 8);
          deleteice.addAll({index - 8: 0});
          rowsColor[index - 8] = iceboxcolor;
        } else if (iceboxsindex.contains(index - 8)) {
          iceboxs.add(index + 8);
          deleteice.addAll({index + 8: 0});
          rowsColor[index + 8] = iceboxcolor;
        } else {
          iceboxs.add(index + 8);
          deleteice.addAll({index + 8: 0});
          iceboxs.add(index - 8);
          deleteice.addAll({index - 8: 0});
          rowsColor[index + 8] = iceboxcolor;

          rowsColor[index - 8] = iceboxcolor;
        }
      } else {
        if (iceboxsindex.contains(index + 8)) {
          iceboxs.add(index - 8);
          deleteice.addAll({index - 8: 0});
          iceboxs.add(index + 1);
          deleteice.addAll({index + 1: 0});
          iceboxs.add(index - 1);
          deleteice.addAll({index - 1: 0});
          rowsColor[index - 1] = iceboxcolor;
          rowsColor[index + 1] = iceboxcolor;
          rowsColor[index - 8] = iceboxcolor;
        } else if (iceboxsindex.contains(index - 8)) {
          iceboxs.add(index + 8);
          deleteice.addAll({index + 8: 0});
          rowsColor[index + 8] = iceboxcolor;
          iceboxs.add(index + 1);
          deleteice.addAll({index + 1: 0});
          iceboxs.add(index - 1);
          deleteice.addAll({index - 1: 0});
          rowsColor[index - 1] = iceboxcolor;

          rowsColor[index + 1] = iceboxcolor;
        } else {
          iceboxs.add(index + 8);
          deleteice.addAll({index + 8: 0});
          iceboxs.add(index - 8);
          deleteice.addAll({index - 8: 0});
          iceboxs.add(index + 1);
          deleteice.addAll({index + 1: 0});
          iceboxs.add(index - 1);
          deleteice.addAll({index - 1: 0});
          rowsColor[index + 8] = iceboxcolor;

          rowsColor[index - 8] = iceboxcolor;
          rowsColor[index - 1] = iceboxcolor;

          rowsColor[index + 1] = iceboxcolor;
        }
      }
    }
  }
}
