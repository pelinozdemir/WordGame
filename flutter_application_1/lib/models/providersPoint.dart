import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PointProvider extends ChangeNotifier {
  List<String> data = [];
  static SharedPreferences? _sharedPref;
  List<int> tempdata = [];
  void setInt(int point) {
    data.add(point.toString());
    data.sort(
      (b, a) => int.parse(a).compareTo(int.parse(b)),
    );

    saveThemeToSharedPref();
    notifyListeners();
  }

  /// Shared Preferences Methods
  Future<void> createPrefObject() async {
    SharedPreferences.setMockInitialValues({});
    _sharedPref = await SharedPreferences.getInstance();
  }

  void saveThemeToSharedPref() {
    _sharedPref?.setStringList("pointProvider", data);
  }

  void loadThemeFromSharedPref() {
    print('loadTheme.. fonksiyonu çalıştı');
    if (_sharedPref!.getStringList('pointProvider') != null) {
      data = _sharedPref!.getStringList('pointProvider')!;
    } else {
      // data = 80;
    }
  }

  List<String> get pointCheck => data;
}
