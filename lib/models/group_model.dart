class GroupModel {
  final int id;
  final String name;
  final int grade; // 1, 2, or 3 for الصف الاول/الثاني/الثالث
  final String schedule; // e.g., "sat & tue"
  final bool isActive;

  GroupModel({
    required this.id,
    required this.name,
    required this.grade,
    required this.schedule,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'grade': grade,
      'schedule': schedule,
      'isActive': isActive ? 1 : 0,
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      id: map['id'] as int,
      name: map['name'] as String,
      grade: map['grade'] as int,
      schedule: map['schedule'] as String,
      isActive: (map['isActive'] as int) == 1,
    );
  }

  GroupModel copyWith({
    int? id,
    String? name,
    int? grade,
    String? schedule,
    bool? isActive,
  }) {
    return GroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      grade: grade ?? this.grade,
      schedule: schedule ?? this.schedule,
      isActive: isActive ?? this.isActive,
    );
  }
}
