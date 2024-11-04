import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winamp/models/eq_config_item.dart';
import 'package:winamp/models/notifiers/theme_notifier.dart';

class EqualizerModal extends StatefulWidget {
  final Function(List<EQConfigItem>, double) onEqualizerChanged;

  const EqualizerModal({super.key, required this.onEqualizerChanged});

  @override
  State<EqualizerModal> createState() => _EqualizerModalState();
}

class _EqualizerModalState extends State<EqualizerModal> {
  bool _isEnabled = true;
  String _selectedPreset = 'Reggae';
  double _preampValue = 0.0;

  List<EQConfigItem> eqConfigItems = [
    EQConfigItem(centerFrequency: 60),
    EQConfigItem(centerFrequency: 170),
    EQConfigItem(centerFrequency: 320),
    EQConfigItem(centerFrequency: 600),
    EQConfigItem(centerFrequency: 1000),
    EQConfigItem(centerFrequency: 3000),
    EQConfigItem(centerFrequency: 6000),
    EQConfigItem(centerFrequency: 12000),
    EQConfigItem(centerFrequency: 14000),
    EQConfigItem(centerFrequency: 16000),
  ];

  List<EQConfigItem> get _frequencies => eqConfigItems;

  final List<String> _presets = [
    'Rock',
    'Pop',
    'Jazz',
    'Classical',
    'Reggae',
    'Custom'
  ];

  final Map<String, List<double>> _presetFrequencies = {
    'Rock': [5.0, 3.0, -3.0, -4.0, -2.0, 3.0, 5.0, 6.0, 6.0, 6.0],
    'Pop': [4.0, 2.0, 0.0, -1.0, 0.0, 2.0, 3.0, 5.0, 5.0, 5.0],
    'Jazz': [3.0, 1.0, -2.0, -3.0, -1.0, 1.0, 2.0, 4.0, 4.0, 4.0],
    'Classical': [2.0, 0.0, -1.0, -2.0, 0.0, 1.0, 3.0, 3.0, 3.0, 3.0],
    'Reggae': [0.72, 0.72, 0.0, -3.41, 0.72, 4.31, 4.31, 0.72, 0.72, 0.72],
  };

  final List<String> _frequencyLabels = [
    '60',
    '170',
    '320',
    '600',
    '1.0 K',
    '3.0 K',
    '6.0 K',
    '12.0 K',
    '14.0 K',
    '16.0 K'
  ];

  void _updateFrequencies(String preset) {
    if (preset != 'Custom') {
      setState(() {
        List<double> presetValues = _presetFrequencies[preset]!;
        for (int i = 0; i < eqConfigItems.length; i++) {
          eqConfigItems[i].gain = presetValues[i];
        }
        _selectedPreset = preset;
        widget.onEqualizerChanged(_frequencies, _preampValue);
      });
    } else {
      _selectedPreset = 'Custom';
    }
  }

  void _resetEqualizer() {
    setState(() {
      for (var item in eqConfigItems) {
        item.gain = 0.0;
      }
      _preampValue = 0.0;
      _selectedPreset = 'Custom';
      widget.onEqualizerChanged(_frequencies, _preampValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    var customTheme = Provider.of<ThemeNotifier>(context).currentTheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Center(
                  child: Text('Equalizer',
                      style: TextStyle(
                          color: customTheme.textColorObj,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              if (Navigator.of(context).canPop())
                IconButton(
                  icon: Icon(CupertinoIcons.xmark,
                      color: customTheme.textColorObj),
                  onPressed: () => Navigator.of(context).pop(),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Enable equalizer',
                  style: TextStyle(color: customTheme.textColorObj)),
              Switch.adaptive(
                value: _isEnabled,
                onChanged: (value) {
                  setState(() {
                    _isEnabled = value;
                    widget.onEqualizerChanged(_frequencies, _preampValue);
                  });
                },
              ),
            ],
          ),
          if (_isEnabled) ...[
            const Divider(),
            Text('Presets', style: TextStyle(color: customTheme.textColorObj)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              alignment: Alignment.center,
              isExpanded: true,
              value: _selectedPreset,
              items: _presets.map((preset) {
                return DropdownMenuItem(
                  value: preset,
                  child: Text(preset,
                      style: TextStyle(color: customTheme.textColorObj)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _updateFrequencies(value);
                  });
                }
              },
              dropdownColor: Colors.grey[900],
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        Text('Preamp',
                            style: TextStyle(color: customTheme.textColorObj)),
                        const SizedBox(height: 18),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        children: [
                          Slider.adaptive(
                            value: _preampValue,
                            min: -10,
                            max: 10,
                            onChanged: (value) {
                              setState(() {
                                _preampValue = value;
                                _selectedPreset = 'Custom';
                                widget.onEqualizerChanged(
                                    _frequencies, _preampValue);
                              });
                            },
                            activeColor: Colors.blueAccent,
                            inactiveColor: Colors.white54,
                            label: '${_preampValue.toStringAsFixed(2)} dB',
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('-10db',
                                  style: TextStyle(
                                      color: Colors.white54, fontSize: 12)),
                              Spacer(),
                              Text('+10db',
                                  style: TextStyle(
                                      color: Colors.white54, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(_frequencies.length, (index) {
                return Expanded(
                  child: Column(
                    children: [
                      Text(
                        _frequencies[index].gain.toStringAsFixed(1),
                        style:
                            const TextStyle(fontSize: 10, color: Colors.white),
                      ),
                      RotatedBox(
                        quarterTurns: -1,
                        child: CupertinoSlider(
                          value: _frequencies[index].gain,
                          min: -12,
                          max: 12,
                          divisions: 24,
                          onChanged: (value) {
                            setState(() {
                              eqConfigItems[index].gain =
                                  value;
                              _selectedPreset = 'Custom';
                              widget.onEqualizerChanged(
                                  _frequencies, _preampValue);
                            });
                          },
                          activeColor: Colors.white,
                        ),
                      ),
                      Text(
                        _frequencyLabels[index],
                        style: const TextStyle(
                            fontSize: 10, color: Colors.white54),
                      ),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: _resetEqualizer,
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  backgroundColor: Colors.redAccent,
                ),
                child: Text('Reset Equalizer',
                    style: TextStyle(color: customTheme.textColorObj)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
