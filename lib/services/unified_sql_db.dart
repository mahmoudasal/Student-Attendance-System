import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../models/student_model.dart';
import '../models/group_model.dart';

class UnifiedSqlDb {
  static Database? _db;
  static const int _currentVersion = 3;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await intialDb();
      return _db;
    } else {
      return _db;
    }
  }

  intialDb() async {
    databaseFactory = databaseFactoryFfi;

    String dataBasePath = await getDatabasesPath();
    String path = join(dataBasePath, 'student_unified.db');
    Database mydb = await openDatabase(
      path,
      onCreate: _onCreate,
      version: _currentVersion,
      onUpgrade: _onUpgrade,
    );
    return mydb;
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print("Upgrading database from version $oldVersion to $newVersion");
    
    if (oldVersion < 3) {
      // Migration logic would go here
      print("Performing migration to unified schema...");
    }
  }

  _onCreate(Database db, int version) async {
    // Create groups table
    await db.execute('''
      CREATE TABLE groups (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        grade INTEGER NOT NULL,
        schedule TEXT NOT NULL,
        isActive INTEGER NOT NULL DEFAULT 1
      )
    ''');

    // Create students table with foreign key to groups
    await db.execute('''
      CREATE TABLE students (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        group_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        sPhone TEXT NOT NULL,
        gPhone TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (group_id) REFERENCES groups(id) ON DELETE CASCADE
      )
    ''');

    // Create index for better query performance
    await db.execute('''
      CREATE INDEX idx_students_group_id ON students(group_id)
    ''');

    // Insert default 15 groups (migrating from old structure)
    await _insertDefaultGroups(db);

    print("Created unified database schema with groups and students tables");
  }

  Future<void> _insertDefaultGroups(Database db) async {
    final defaultGroups = [
      // Grade 1 (الصف الاول الثانوي)
      {'name': 'sat & tue1', 'grade': 1, 'schedule': 'السبت والثلاثاء'},
      {'name': 'sat & tue2', 'grade': 1, 'schedule': 'السبت والثلاثاء'},
      {'name': 'sat & tue3', 'grade': 1, 'schedule': 'السبت والثلاثاء'},
      {'name': 'sat & tue4', 'grade': 1, 'schedule': 'السبت والثلاثاء'},
      {'name': 'sat & tue5', 'grade': 1, 'schedule': 'السبت والثلاثاء'},
      
      // Grade 2 (الصف الثاني الثانوي)
      {'name': 'sat & tue6', 'grade': 2, 'schedule': 'السبت والثلاثاء'},
      {'name': 'sat & tue7', 'grade': 2, 'schedule': 'السبت والثلاثاء'},
      {'name': 'sat & tue8', 'grade': 2, 'schedule': 'السبت والثلاثاء'},
      {'name': 'sat & tue9', 'grade': 2, 'schedule': 'السبت والثلاثاء'},
      {'name': 'sat & tue10', 'grade': 2, 'schedule': 'السبت والثلاثاء'},
      
      // Grade 3 (الصف الثالث الثانوي)
      {'name': 'sat & tue11', 'grade': 3, 'schedule': 'السبت والثلاثاء'},
      {'name': 'sat & tue12', 'grade': 3, 'schedule': 'السبت والثلاثاء'},
      {'name': 'sat & tue13', 'grade': 3, 'schedule': 'السبت والثلاثاء'},
      {'name': 'sat & tue14', 'grade': 3, 'schedule': 'السبت والثلاثاء'},
      {'name': 'sat & tue15', 'grade': 3, 'schedule': 'السبت والثلاثاء'},
    ];

    for (var group in defaultGroups) {
      await db.insert('groups', {
        ...group,
        'isActive': 1,
      });
    }
  }

  // ============== GROUP OPERATIONS ==============
  
  Future<List<GroupModel>> getAllGroups() async {
    Database? mydb = await db;
    List<Map<String, dynamic>> response = await mydb!.query('groups', orderBy: 'id ASC');
    return response.map((map) => GroupModel.fromMap(map)).toList();
  }

  Future<List<GroupModel>> getGroupsByGrade(int grade) async {
    Database? mydb = await db;
    List<Map<String, dynamic>> response = await mydb!.query(
      'groups',
      where: 'grade = ? AND isActive = 1',
      whereArgs: [grade],
      orderBy: 'id ASC',
    );
    return response.map((map) => GroupModel.fromMap(map)).toList();
  }

  Future<GroupModel?> getGroupById(int id) async {
    Database? mydb = await db;
    List<Map<String, dynamic>> response = await mydb!.query(
      'groups',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (response.isEmpty) return null;
    return GroupModel.fromMap(response.first);
  }

  Future<int> insertGroup(GroupModel group) async {
    Database? mydb = await db;
    // Remove id from map to let SQLite auto-increment
    final Map<String, dynamic> groupMap = group.toMap();
    groupMap.remove('id'); // Don't insert id, let it auto-increment
    return await mydb!.insert('groups', groupMap);
  }

  Future<int> updateGroup(GroupModel group) async {
    Database? mydb = await db;
    return await mydb!.update(
      'groups',
      group.toMap(),
      where: 'id = ?',
      whereArgs: [group.id],
    );
  }

  Future<int> deleteGroup(int id) async {
    Database? mydb = await db;
    // This will cascade delete all students in this group
    return await mydb!.delete('groups', where: 'id = ?', whereArgs: [id]);
  }

  // ============== STUDENT OPERATIONS ==============

  Future<List<StudentModel>> getStudentsByGroup(int groupId) async {
    Database? mydb = await db;
    List<Map<String, dynamic>> response = await mydb!.query(
      'students',
      where: 'group_id = ?',
      whereArgs: [groupId],
      orderBy: 'name ASC',
    );
    return response.map((map) => StudentModel.fromMap(map)).toList();
  }

  Future<int> insertStudent(StudentModel student) async {
    Database? mydb = await db;
    // Remove id from map to let SQLite auto-increment
    final Map<String, dynamic> studentMap = student.toMap();
    studentMap.remove('id'); // Don't insert id if null, let it auto-increment
    return await mydb!.insert('students', studentMap);
  }

  Future<int> updateStudent(StudentModel student) async {
    Database? mydb = await db;
    return await mydb!.update(
      'students',
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  Future<int> deleteStudent(int id) async {
    Database? mydb = await db;
    return await mydb!.delete('students', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<StudentModel>> getAllStudents() async {
    Database? mydb = await db;
    List<Map<String, dynamic>> response = await mydb!.query('students', orderBy: 'name ASC');
    return response.map((map) => StudentModel.fromMap(map)).toList();
  }

  Future<int> getStudentCountByGroup(int groupId) async {
    Database? mydb = await db;
    var result = await mydb!.rawQuery(
      'SELECT COUNT(*) as count FROM students WHERE group_id = ?',
      [groupId],
    );
    return result.isNotEmpty ? (result.first['count'] as int?) ?? 0 : 0;
  }

  // ============== UTILITY OPERATIONS ==============

  Future<Map<String, dynamic>> getDatabaseStats() async {
    Database? mydb = await db;
    
    var totalGroups = await mydb!.rawQuery('SELECT COUNT(*) as count FROM groups');
    var totalStudents = await mydb.rawQuery('SELECT COUNT(*) as count FROM students');
    var activeGroups = await mydb.rawQuery('SELECT COUNT(*) as count FROM groups WHERE isActive = 1');
    
    return {
      'totalGroups': totalGroups.isNotEmpty ? (totalGroups.first['count'] as int?) ?? 0 : 0,
      'totalStudents': totalStudents.isNotEmpty ? (totalStudents.first['count'] as int?) ?? 0 : 0,
      'activeGroups': activeGroups.isNotEmpty ? (activeGroups.first['count'] as int?) ?? 0 : 0,
    };
  }

  Future<void> closeDatabase() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
    }
  }
}
