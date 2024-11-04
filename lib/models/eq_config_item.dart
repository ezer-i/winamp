class EQConfigItem {
  double centerFrequency;
  double gain;
  double width;
  String widthType;

  EQConfigItem({
    this.centerFrequency = 0,
    this.gain = 0,
    this.width = 200,
    this.widthType = "h",
  });
}
