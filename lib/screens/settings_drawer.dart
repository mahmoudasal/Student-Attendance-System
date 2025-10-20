import 'package:flutter/material.dart';
import '../constants.dart';
import '../services/settings_service.dart';
import '../services/unified_sql_db.dart';
import '../models/app_settings.dart';
import '../models/group_model.dart';

class SettingsDrawer extends StatefulWidget {
  final VoidCallback? onGroupsChanged;
  
  const SettingsDrawer({Key? key, this.onGroupsChanged}) : super(key: key);

  @override
  _SettingsDrawerState createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {
  final UnifiedSqlDb _db = UnifiedSqlDb();
  late SettingsService _settingsService;
  AppSettings? _settings;
  Map<String, dynamic>? _dbStats;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    _settingsService = await SettingsService.getInstance();
    _settings = await _settingsService.loadSettings();
    _dbStats = await _db.getDatabaseStats();
    
    setState(() => _isLoading = false);
  }

  Future<void> _showGroupsManager() async {
    if (!mounted) return; // Check if widget is still mounted
    
    final groups = await _db.getAllGroups();
    
    if (!mounted) return; // Check again after async operation
    
    showDialog(
      context: context,
      builder: (dialogContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('إدارة المجموعات'),
          content: SizedBox(
            width: 400,
            height: 500,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                      final group = groups[index];
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text('${group.id}'),
                          ),
                          title: Text(group.name),
                          subtitle: Text('الصف ${_getGradeName(group.grade)}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _editGroup(group),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteGroup(group.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: _addNewGroup,
                  icon: const Icon(Icons.add),
                  label: const Text('إضافة مجموعة جديدة'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('إغلاق'),
            ),
          ],
        ),
      ),
    );
  }

  String _getGradeName(int grade) {
    switch (grade) {
      case 1:
        return 'الأول الثانوي';
      case 2:
        return 'الثاني الثانوي';
      case 3:
        return 'الثالث الثانوي';
      default:
        return 'غير محدد';
    }
  }

  Future<void> _addNewGroup() async {
    if (!mounted) return;
    
    final nameController = TextEditingController();
    int selectedGrade = 1;

    showDialog(
      context: context,
      builder: (dialogContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: StatefulBuilder(
          builder: (builderContext, setDialogState) => AlertDialog(
            title: const Text('إضافة مجموعة جديدة'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'اسم المجموعة',
                    hintText: 'مثال: sat & tue16',
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<int>(
                  value: selectedGrade,
                  decoration: const InputDecoration(
                    labelText: 'الصف الدراسي',
                  ),
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('الأول الثانوي')),
                    DropdownMenuItem(value: 2, child: Text('الثاني الثانوي')),
                    DropdownMenuItem(value: 3, child: Text('الثالث الثانوي')),
                  ],
                  onChanged: (value) {
                    setDialogState(() => selectedGrade = value!);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (nameController.text.isNotEmpty) {
                    final newGroup = GroupModel(
                      id: 0, // Will be auto-incremented
                      name: nameController.text,
                      grade: selectedGrade,
                      schedule: 'السبت والثلاثاء',
                    );
                    await _db.insertGroup(newGroup);
                    if (!mounted) return;
                    Navigator.pop(dialogContext); // Close add dialog
                    Navigator.pop(context); // Close groups manager
                    await _loadData();
                    widget.onGroupsChanged?.call(); // Notify parent
                    if (mounted) {
                      _showGroupsManager(); // Reopen groups manager
                    }
                  }
                },
                child: const Text('إضافة'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _editGroup(GroupModel group) async {
    if (!mounted) return;
    
    final nameController = TextEditingController(text: group.name);
    int selectedGrade = group.grade;

    showDialog(
      context: context,
      builder: (dialogContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: StatefulBuilder(
          builder: (builderContext, setDialogState) => AlertDialog(
            title: const Text('تعديل المجموعة'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'اسم المجموعة'),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<int>(
                  value: selectedGrade,
                  decoration: const InputDecoration(labelText: 'الصف الدراسي'),
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('الأول الثانوي')),
                    DropdownMenuItem(value: 2, child: Text('الثاني الثانوي')),
                    DropdownMenuItem(value: 3, child: Text('الثالث الثانوي')),
                  ],
                  onChanged: (value) {
                    setDialogState(() => selectedGrade = value!);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final updatedGroup = group.copyWith(
                    name: nameController.text,
                    grade: selectedGrade,
                  );
                  await _db.updateGroup(updatedGroup);
                  if (!mounted) return;
                  Navigator.pop(dialogContext); // Close edit dialog
                  Navigator.pop(context); // Close groups manager
                  await _loadData();
                  widget.onGroupsChanged?.call(); // Notify parent
                  if (mounted) {
                    _showGroupsManager(); // Reopen groups manager
                  }
                },
                child: const Text('حفظ'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteGroup(int groupId) async {
    if (!mounted) return; // Check if widget is still mounted
    
    final studentCount = await _db.getStudentCountByGroup(groupId);
    
    if (!mounted) return; // Check again after async operation
    
    showDialog(
      context: context,
      builder: (dialogContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('تأكيد الحذف'),
          content: Text(
            studentCount > 0
                ? 'هذه المجموعة تحتوي على $studentCount طالب. سيتم حذف جميع الطلاب. هل أنت متأكد؟'
                : 'هل أنت متأكد من حذف هذه المجموعة؟',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _db.deleteGroup(groupId);
                if (!mounted) return;
                Navigator.pop(dialogContext); // Close delete confirmation
                Navigator.pop(context); // Close groups manager
                await _loadData();
                widget.onGroupsChanged?.call(); // Notify parent
                if (mounted) {
                  _showGroupsManager(); // Reopen groups manager
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('حذف'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: const BoxDecoration(
                      color: kPrimaryColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.settings,
                          size: 48,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'إعدادات التطبيق',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'نسخة ${_settings?.databaseVersion ?? 3}.0',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Database Statistics
                  if (_dbStats != null) ...[
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'إحصائيات قاعدة البيانات',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _buildStatTile(
                      Icons.group,
                      'إجمالي المجموعات',
                      '${_dbStats!['totalGroups']}',
                    ),
                    _buildStatTile(
                      Icons.people,
                      'إجمالي الطلاب',
                      '${_dbStats!['totalStudents']}',
                    ),
                    _buildStatTile(
                      Icons.check_circle,
                      'المجموعات النشطة',
                      '${_dbStats!['activeGroups']}',
                    ),
                    const Divider(),
                  ],

                  // Group Management
                  ListTile(
                    leading: const Icon(Icons.group_add, color: kPrimaryColor),
                    title: const Text('إدارة المجموعات'),
                    subtitle: const Text('إضافة، تعديل أو حذف المجموعات'),
                    onTap: _showGroupsManager,
                  ),

                  // Backup Settings
                  ListTile(
                    leading: const Icon(Icons.backup, color: kPrimaryColor),
                    title: const Text('النسخ الاحتياطي'),
                    subtitle: const Text('حفظ واستعادة البيانات'),
                    trailing: Switch(
                      value: _settings?.enableBackup ?? false,
                      onChanged: (value) async {
                        await _settingsService.toggleBackup();
                        _loadData();
                      },
                    ),
                  ),

                  // Dark Mode
                  ListTile(
                    leading: const Icon(Icons.dark_mode, color: kPrimaryColor),
                    title: const Text('الوضع الليلي'),
                    subtitle: const Text('تفعيل الوضع الليلي'),
                    trailing: Switch(
                      value: _settings?.darkMode ?? false,
                      onChanged: (value) async {
                        await _settingsService.toggleDarkMode();
                        _loadData();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('سيتم تطبيق الوضع الليلي في الإصدار القادم'),
                          ),
                        );
                      },
                    ),
                  ),

                  const Divider(),

                  // About
                  ListTile(
                    leading: const Icon(Icons.info, color: kPrimaryColor),
                    title: const Text('حول التطبيق'),
                    subtitle: const Text('معلومات عن تطبيق الزريف للحضور'),
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'تطبيق الزريف للحضور',
                        applicationVersion: '3.0.0',
                        applicationLegalese: '© 2025  Islamic Education',
                        children: [
                          const Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text(
                              '\nتطبيق شامل لإدارة حضور الطلاب في التعليم الإسلامي.\n\n'
                              'يدعم التطبيق:\n'
                              '• إدارة مجموعات متعددة\n'
                              '• تتبع بيانات الطلاب\n'
                              '• تصميم متجاوب\n'
                              '• قاعدة بيانات موحدة\n',
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  // Help
                  ListTile(
                    leading: const Icon(Icons.help, color: kPrimaryColor),
                    title: const Text('المساعدة'),
                    subtitle: const Text('دليل استخدام التطبيق'),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => Directionality(
                          textDirection: TextDirection.rtl,
                          child: AlertDialog(
                            title: const Text('دليل الاستخدام'),
                            content: const SingleChildScrollView(
                              child: Text(
                                'كيفية استخدام التطبيق:\n\n'
                                '1. اختر الصف الدراسي من القائمة السفلية\n'
                                '2. اضغط على "تسجيل طالب جديد"\n'
                                '3. أدخل بيانات الطالب (الاسم، رقم الطالب، رقم ولي الأمر)\n'
                                '4. اختر المجموعة من القائمة المنسدلة\n'
                                '5. اضغط "إضافة" لحفظ البيانات\n\n'
                                'لعرض الطلاب:\n'
                                '• انتقل إلى تبويب المجموعة المطلوبة\n'
                                '• اضغط "عرض بيانات المجموعة"\n'
                                '• يمكنك التعديل أو الحذف من خلال الأزرار\n\n'
                                'إدارة المجموعات:\n'
                                '• افتح قائمة الإعدادات من الزاوية العلوية\n'
                                '• اختر "إدارة المجموعات"\n'
                                '• يمكنك إضافة، تعديل أو حذف مجموعات',
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('فهمت'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildStatTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: kPrimaryColor),
      title: Text(title),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: kPrimaryLightColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: kPrimaryColor,
          ),
        ),
      ),
    );
  }
}
