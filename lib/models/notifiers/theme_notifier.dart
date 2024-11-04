import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:winamp/models/custom_theme.dart';

class ThemeNotifier extends ChangeNotifier {
  CustomTheme _currentTheme;
  String _currentThemeId;

  CustomTheme get currentTheme => _currentTheme;
  String get currentThemeId => _currentThemeId;

  Map<String, CustomTheme> _customThemes = {};

  Map<String, CustomTheme> get customThemes => _customThemes;

  ThemeNotifier(this._currentTheme, this._currentThemeId);

  Future<void> setTheme(CustomTheme theme) async {
    _currentTheme = theme;
    _currentThemeId = theme.id;
    notifyListeners();
    await _saveCurrentThemeIdToPrefs(theme.id);
  }

  Future<void> loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final themeId = prefs.getString('currentThemeId') ?? 'default_theme';
    _currentThemeId = themeId;
    await _loadCustomThemesFromPrefs();
    if (_customThemes.containsKey(themeId)) {
      _currentTheme = _customThemes[themeId]!;
    } else {
      _currentTheme = _getDefaultThemeById(themeId);
    }
    notifyListeners();
  }

  Future<void> _saveCurrentThemeIdToPrefs(String themeId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('currentThemeId', themeId);
  }

  Future<void> _saveCustomThemesToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final customThemesJson = jsonEncode(
      _customThemes.map((key, value) => MapEntry(key, value.toJson())),
    );
    prefs.setString('customThemes', customThemesJson);
  }

  Future<void> _loadCustomThemesFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final customThemesString = prefs.getString('customThemes');
    if (customThemesString != null) {
      final Map<String, dynamic> decoded = jsonDecode(customThemesString);
      _customThemes = decoded.map(
        (key, value) => MapEntry(key, CustomTheme.fromJson(value)),
      );
    }
  }

  Future<void> addCustomTheme(CustomTheme customTheme) async {
    _customThemes[customTheme.id] = customTheme;
    await _saveCustomThemesToPrefs();
    notifyListeners();
  }

  Future<void> deleteCustomTheme(String themeId) async {
    _customThemes.remove(themeId);
    await _saveCustomThemesToPrefs();
    notifyListeners();
  }

  CustomTheme _getDefaultThemeById(String themeId) {
    switch (themeId) {
      case 'default_theme':
        return CustomTheme(
          id: 'default_theme',
          name: 'Default',
          textColor: Colors.white.value,
          backgroundColor: Colors.black.value,
          accentColor: Colors.red.value,
          playerActionColor: Colors.red.value,
          playerBackgroundColor: Colors.grey.shade900.value,
        );
      default:
        return CustomTheme(
          id: 'default_theme',
          name: 'Default',
          textColor: Colors.white.value,
          backgroundColor: Colors.black.value,
          accentColor: Colors.red.value,
          playerActionColor: Colors.red.value,
          playerBackgroundColor: Colors.grey.shade900.value,
        );
    }
  }
}
