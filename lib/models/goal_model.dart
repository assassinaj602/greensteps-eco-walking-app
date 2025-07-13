// Daily eco goal model
class EcoGoal {
  final String id;
  final String title;
  final String description;
  final int targetValue;
  final String unit;
  final int points;
  final DateTime date;
  final bool isCompleted;

  EcoGoal({
    required this.id,
    required this.title,
    required this.description,
    required this.targetValue,
    required this.unit,
    required this.points,
    required this.date,
    this.isCompleted = false,
  });

  factory EcoGoal.fromMap(Map<String, dynamic> map) {
    return EcoGoal(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      targetValue: map['targetValue'] ?? 0,
      unit: map['unit'] ?? '',
      points: map['points'] ?? 0,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] ?? 0),
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'targetValue': targetValue,
      'unit': unit,
      'points': points,
      'date': date.millisecondsSinceEpoch,
      'isCompleted': isCompleted,
    };
  }

  EcoGoal copyWith({
    String? id,
    String? title,
    String? description,
    int? targetValue,
    String? unit,
    int? points,
    DateTime? date,
    bool? isCompleted,
  }) {
    return EcoGoal(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      targetValue: targetValue ?? this.targetValue,
      unit: unit ?? this.unit,
      points: points ?? this.points,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
