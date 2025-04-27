import 'dart:math';

class Detection {
  final double x1, y1, x2, y2;
  final double score;
  final int classId;

  Detection(this.x1, this.y1, this.x2, this.y2, this.score, this.classId);
}

List<Detection> nonMaxSuppression(
  List<List<List<double>>> output, {
  double objectThreshold = 0.4,
  double iouThreshold = 0.5,
}) {
  List<Detection> results = [];

  for (int i = 0; i < 8400; i++) {
    final List<double> prediction = List.generate(24, (j) => output[0][j][i]);
    final double x = prediction[0];
    final double y = prediction[1];
    final double w = prediction[2];
    final double h = prediction[3];
    final double objectness = prediction[4];

    if (objectness < objectThreshold) continue;

    // Find class with highest confidence
    final classScores = prediction.sublist(5);
    final maxClassScore = classScores.reduce(max);
    final classId = classScores.indexOf(maxClassScore);
    final finalScore = objectness * maxClassScore;

    // Convert to [x1, y1, x2, y2]
    final double x1 = x - w / 2;
    final double y1 = y - h / 2;
    final double x2 = x + w / 2;
    final double y2 = y + h / 2;

    results.add(Detection(x1, y1, x2, y2, finalScore, classId));
  }

  // Sort by score
  results.sort((a, b) => b.score.compareTo(a.score));

  // Apply NMS
  List<Detection> finalDetections = [];

  while (results.isNotEmpty) {
    final best = results.removeAt(0);
    finalDetections.add(best);

    results = results.where((det) => _iou(best, det) < iouThreshold).toList();
  }

  return finalDetections;
}

double _iou(Detection a, Detection b) {
  final double interX1 = max(a.x1, b.x1);
  final double interY1 = max(a.y1, b.y1);
  final double interX2 = min(a.x2, b.x2);
  final double interY2 = min(a.y2, b.y2);

  final double interArea = max(0, interX2 - interX1) * max(0, interY2 - interY1);
  final double areaA = (a.x2 - a.x1) * (a.y2 - a.y1);
  final double areaB = (b.x2 - b.x1) * (b.y2 - b.y1);

  return interArea / (areaA + areaB - interArea);
}
