import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/custom_theme.dart';
import '../models/notifiers/theme_notifier.dart';

class ThemeSelectionScreen extends StatefulWidget {
  const ThemeSelectionScreen({super.key});

  @override
  State<ThemeSelectionScreen> createState() => _ThemeSelectionScreenState();
}

class _ThemeSelectionScreenState extends State<ThemeSelectionScreen> {
  String selectedThemeId = 'default_theme';


  Color primaryColor = Colors.blue;
  Color accentColor = Colors.blueAccent;
  Color backgroundColor = Colors.white;
  Color textColor = Colors.black;
  Color playerActionColor = Colors.black;
  Color playerBackgroundColor = Colors.white;
  String customThemeName = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ThemeNotifier>(context, listen: false).loadThemeFromPrefs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    selectedThemeId = themeNotifier.currentThemeId;

    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Select Theme', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(child: _buildThemeGrid(themeNotifier)),
            const SizedBox(height: 16),
            _buildCreateCustomThemeSection(themeNotifier),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeGrid(ThemeNotifier themeNotifier) {
    final presetThemes = [
      _ThemeGridItem(
        title: 'Default',
        themeId: 'default_theme',
        textColor: Colors.white,
        backgroundColor: Colors.black,
        accentColor: Colors.red,
        playerActionColor: Colors.red,
        playerBackgroundColor: Colors.grey.shade900,
      ),
    ];

    final customThemeItems =
        themeNotifier.customThemes.values.map((customTheme) {
      return _ThemeGridItem(
        title: customTheme.name,
        themeId: customTheme.id,
        textColor: customTheme.textColorObj,
        backgroundColor: customTheme.backgroundColorObj,
        accentColor: customTheme.accentColorObj,
        playerActionColor: customTheme.playerActionColorObj,
        playerBackgroundColor: customTheme.playerBackgroundColorObj,
        isCustom: true,
      );
    }).toList();

    final allThemes = [...presetThemes, ...customThemeItems];

    return GridView.builder(
      itemCount: allThemes.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
        childAspectRatio: 1,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final themeItem = allThemes[index];
        return GestureDetector(
          onTap: () => _applyTheme(themeNotifier, themeItem),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: selectedThemeId == themeItem.themeId
                    ? Colors.blue
                    : Colors.grey,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
              color: themeItem.backgroundColor,
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        themeItem.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: themeItem.textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _colorCircle(themeItem.accentColor),
                          const SizedBox(width: 8),
                          _colorCircle(themeItem.playerActionColor),
                        ],
                      ),
                    ],
                  ),
                ),
                if (themeItem.isCustom)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () =>
                          _deleteCustomTheme(themeNotifier, themeItem.themeId),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _colorCircle(Color color) {
    return CircleAvatar(
      backgroundColor: color,
      radius: 16,
    );
  }

  void _applyTheme(ThemeNotifier themeNotifier, _ThemeGridItem themeItem) {
    if (themeItem.isCustom) {
      final customTheme = themeNotifier.customThemes[themeItem.themeId]!;
      themeNotifier.setTheme(customTheme);
    } else {
      final presetCustomTheme = CustomTheme(
        id: themeItem.themeId,
        name: themeItem.title,
        textColor: themeItem.textColor.value,
        backgroundColor: themeItem.backgroundColor.value,
        accentColor: themeItem.accentColor.value,
        playerActionColor: themeItem.playerActionColor.value,
        playerBackgroundColor: themeItem.playerBackgroundColor.value,
      );
      themeNotifier.setTheme(presetCustomTheme);
    }
    setState(() {
      selectedThemeId = themeItem.themeId;
    });
  }

  void _deleteCustomTheme(ThemeNotifier themeNotifier, String themeId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Theme'),
          content: const Text('Are you sure you want to delete this theme?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              )),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                themeNotifier.deleteCustomTheme(themeId);
                if (selectedThemeId == themeId) {
                  final defaultTheme =
                      themeNotifier.currentThemeId == 'default_theme'
                          ? themeNotifier.currentTheme
                          : CustomTheme(
                              id: 'default_theme',
                              name: 'Default',
                              textColor: Colors.white.value,
                              backgroundColor: Colors.black.value,
                              accentColor: Colors.red.value,
                              playerActionColor: Colors.red.value,
                              playerBackgroundColor: Colors.grey.shade900.value,
                            );
                  themeNotifier.setTheme(defaultTheme);
                }
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildCreateCustomThemeSection(ThemeNotifier themeNotifier) {
    return ExpansionTile(
      title: const Center(
        child: Text(
          'Create New Theme',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      initiallyExpanded: true,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            onChanged: (value) => customThemeName = value,
            decoration: const InputDecoration(
              labelText: 'Enter custom theme name',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: [
            _buildColorPickerButton('Text Color', textColor, (color) {
              setState(() => textColor = color);
            }),
            _buildColorPickerButton('Background Color', backgroundColor,
                (color) {
              setState(() => backgroundColor = color);
            }),
            _buildColorPickerButton('Accent Color', accentColor, (color) {
              setState(() => accentColor = color);
            }),
            _buildColorPickerButton('Player Action Color', playerActionColor,
                (color) {
              setState(() => playerActionColor = color);
            }),
            _buildColorPickerButton(
                'Player Background Color', playerBackgroundColor, (color) {
              setState(() => playerBackgroundColor = color);
            }),
          ],
        ),
        const SizedBox(height: 16),
        const SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          child: const Text('Save Theme'),
          onPressed: () => _saveCustomTheme(themeNotifier),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildColorPickerButton(
    String title,
    Color currentColor,
    ValueChanged<Color> onColorChanged,
  ) {
    return Column(
      children: [
        Text(title),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () =>
              _showColorPickerDialog(title, currentColor, onColorChanged),
          child: CircleAvatar(
            backgroundColor: currentColor,
            radius: 24,
            child: const Icon(Icons.color_lens, color: Colors.white),
          ),
        ),
      ],
    );
  }

  void _showColorPickerDialog(
    String title,
    Color currentColor,
    ValueChanged<Color> onColorChanged,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        Color tempColor = currentColor;
        return AlertDialog(
          title: Text('Select $title'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return ColorPicker(
                pickerColor: tempColor,
                onColorChanged: (color) {
                  setState(() {
                    tempColor = color;
                  });
                  onColorChanged(color);
                },
                pickerAreaHeightPercent: 0.8,
              );
            },
          ),
          actions: [
            ElevatedButton(
              child: const Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _saveCustomTheme(ThemeNotifier themeNotifier) {
    if (customThemeName.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a theme name.')),
      );
      return;
    }

    final customTheme = CustomTheme(
      id: const Uuid().v4(),
      name: customThemeName,
      textColor: textColor.value,
      backgroundColor: backgroundColor.value,
      accentColor: accentColor.value,
      playerActionColor: playerActionColor.value,
      playerBackgroundColor: playerBackgroundColor.value,
    );

    themeNotifier.addCustomTheme(customTheme);
    themeNotifier.setTheme(customTheme);
    setState(() {
      selectedThemeId = customTheme.id;
      customThemeName = '';
      primaryColor = Colors.blue;
      accentColor = Colors.blueAccent;
      backgroundColor = Colors.white;
      textColor = Colors.black;
      playerActionColor = Colors.black;
      playerBackgroundColor = Colors.white;
    });
  }
}

class _ThemeGridItem {
  final String title;
  final String themeId;
  final Color textColor;
  final Color backgroundColor;
  final Color accentColor;
  final Color playerActionColor;
  final Color playerBackgroundColor;
  final bool isCustom;

  _ThemeGridItem({
    required this.title,
    required this.themeId,
    required this.textColor,
    required this.backgroundColor,
    required this.accentColor,
    required this.playerActionColor,
    required this.playerBackgroundColor,
    this.isCustom = false,
  });
}
