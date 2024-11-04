import 'package:flutter/material.dart';

class CustomTheme {
  final String id;
  final String name;
  final int textColor;
  final int backgroundColor;
  final int accentColor;
  final int playerActionColor;
  final int playerBackgroundColor;

  CustomTheme({
    required this.id,
    required this.name,
    required this.textColor,
    required this.backgroundColor,
    required this.accentColor,
    required this.playerActionColor,
    required this.playerBackgroundColor,
  });


  Color get textColorObj => Color(textColor);
  Color get backgroundColorObj => Color(backgroundColor);
  Color get accentColorObj => Color(accentColor);
  Color get playerActionColorObj => Color(playerActionColor);
  Color get playerBackgroundColorObj => Color(playerBackgroundColor);


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'textColor': textColor,
      'backgroundColor': backgroundColor,
      'accentColor': accentColor,
      'playerActionColor': playerActionColor,
      'playerBackgroundColor': playerBackgroundColor,
    };
  }

  factory CustomTheme.fromJson(Map<String, dynamic> json) {
    return CustomTheme(
      id: json['id'],
      name: json['name'],
      textColor: json['textColor'],
      backgroundColor: json['backgroundColor'],
      accentColor: json['accentColor'],
      playerActionColor: json['playerActionColor'],
      playerBackgroundColor: json['playerBackgroundColor'],
    );
  }

  static CustomTheme getDefaultTheme() {
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
