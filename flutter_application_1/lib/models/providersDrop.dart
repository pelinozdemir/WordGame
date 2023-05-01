import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IndexProvider extends ChangeNotifier {
  int data = 80;
  static SharedPreferences? _sharedPref;

  void setInt(int index) {
    data = index;
    saveThemeToSharedPref();
    notifyListeners();
  }

  void deleteIndex() {
    data = 80;
    saveThemeToSharedPref();
    notifyListeners();
  }

  /// Shared Preferences Methods
  Future<void> createPrefObject() async {
    SharedPreferences.setMockInitialValues({});
    _sharedPref = await SharedPreferences.getInstance();
  }

  void saveThemeToSharedPref() {
    _sharedPref?.setInt("indexProvider", data);
  }

  void loadThemeFromSharedPref() {
    print('loadTheme.. fonksiyonu çalıştı');
    if (_sharedPref!.getString('indexProvider') != null) {
      data = _sharedPref!.getInt('indexProvider')!;
    } else {
      data = 80;
    }
  }

  int get indexCheck => data;
}
