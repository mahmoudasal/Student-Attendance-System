class StudentModel {
  final int? id;
  final int groupId;
  final String name;
  final String sPhone;
  final String gPhone;
  final DateTime createdAt;

  StudentModel({
    this.id,
    required this.groupId,
    required this.name,
    required this.sPhone,
    required this.gPhone,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'group_id': groupId,
      'name': name,
      'sPhone': sPhone,
      'gPhone': gPhone,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      id: map['id'] as int?,
      groupId: map['group_id'] as int,
      name: map['name'] as String,
      sPhone: map['sPhone'] as String,
      gPhone: map['gPhone'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  StudentModel copyWith({
    int? id,
    int? groupId,
    String? name,
    String? sPhone,
    String? gPhone,
    DateTime? createdAt,
  }) {
    return StudentModel(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      name: name ?? this.name,
      sPhone: sPhone ?? this.sPhone,
      gPhone: gPhone ?? this.gPhone,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
