class AppSettings {
  final int totalGroups;
  final bool darkMode;
  final String language; // 'ar' for Arabic
  final bool enableBackup;
  final String backupPath;
  final int databaseVersion;

  AppSettings({
    this.totalGroups = 15,
    this.darkMode = false,
    this.language = 'ar',
    this.enableBackup = false,
    this.backupPath = '',
    this.databaseVersion = 3,
  });

  Map<String, dynamic> toJson() {
    return {
      'totalGroups': totalGroups,
      'darkMode': darkMode,
      'language': language,
      'enableBackup': enableBackup,
      'backupPath': backupPath,
      'databaseVersion': databaseVersion,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      totalGroups: json['totalGroups'] as int? ?? 15,
      darkMode: json['darkMode'] as bool? ?? false,
      language: json['language'] as String? ?? 'ar',
      enableBackup: json['enableBackup'] as bool? ?? false,
      backupPath: json['backupPath'] as String? ?? '',
      databaseVersion: json['databaseVersion'] as int? ?? 3,
    );
  }

  AppSettings copyWith({
    int? totalGroups,
    bool? darkMode,
    String? language,
    bool? enableBackup,
    String? backupPath,
    int? databaseVersion,
  }) {
    return AppSettings(
      totalGroups: totalGroups ?? this.totalGroups,
      darkMode: darkMode ?? this.darkMode,
      language: language ?? this.language,
      enableBackup: enableBackup ?? this.enableBackup,
      backupPath: backupPath ?? this.backupPath,
      databaseVersion: databaseVersion ?? this.databaseVersion,
    );
  }
}
