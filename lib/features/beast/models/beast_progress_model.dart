class BeastProgressModel {
  const BeastProgressModel({
    required this.skillsProgress,
    required this.talentsProgress,
    required this.skinsProgress,
  });

  final double skillsProgress;
  final double talentsProgress;
  final double skinsProgress;

  double get overallProgress {
    return (skillsProgress + talentsProgress + skinsProgress) / 3;
  }
}