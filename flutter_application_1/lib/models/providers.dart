import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WordProvider extends ChangeNotifier {
  String data = "";
  static SharedPreferences? _sharedPref;

  void setString(String word) {
    data = word;
    saveThemeToSharedPref();
    notifyListeners();
  }

  void deleteString() {
    data = "";
    saveThemeToSharedPref();
    notifyListeners();
  }

  /// Shared Preferences Methods
  Future<void> createPrefObject() async {
    SharedPreferences.setMockInitialValues({});
    _sharedPref = await SharedPreferences.getInstance();
  }

  void saveThemeToSharedPref() {
    _sharedPref!.setString('wordPrdovider', data);
  }

  void loadThemeFromSharedPref() {
    print('loadTheme.. fonksiyonu çalıştı');
    if (_sharedPref!.getString('wordPrdovider') != null) {
      data = _sharedPref!.getString('wordPrdovider')!;
    } else {
      data = '';
    }
  }

  String get wordCheck => data;
}
