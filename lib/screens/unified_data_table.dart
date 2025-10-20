import 'package:flutter/material.dart';
import '../constants.dart';
import '../services/unified_sql_db.dart';
import '../models/student_model.dart';

class UnifiedDataTable extends StatefulWidget {
  final int groupId;
  final String groupName;

  const UnifiedDataTable({
    Key? key,
    required this.groupId,
    required this.groupName,
  }) : super(key: key);

  @override
  _UnifiedDataTableState createState() => _UnifiedDataTableState();
}

class _UnifiedDataTableState extends State<UnifiedDataTable>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  final UnifiedSqlDb _db = UnifiedSqlDb();
  List<StudentModel> students = [];
  bool isLoading = false;
  bool hasLoadedOnce = false;

  @override
  bool get wantKeepAlive => true; // Keep state when switching tabs

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Auto-load students when tab is first viewed
    _loadStudents();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh data whenever dependencies change (e.g., when navigating back to this tab)
    if (hasLoadedOnce) {
      _loadStudents();
    }
  }

  Future<void> _loadStudents() async {
    setState(() => isLoading = true);
    try {
      final loadedStudents = await _db.getStudentsByGroup(widget.groupId);
      setState(() {
        students = loadedStudents;
        isLoading = false;
        hasLoadedOnce = true;
      });
    } catch (e) {
      print('Error loading students: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _editStudent(StudentModel student) async {
    final nameController = TextEditingController(text: student.name);
    final sphoneController = TextEditingController(text: student.sPhone);
    final gphoneController = TextEditingController(text: student.gPhone);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('تعديل بيانات الطالب'),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'الاسم'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال الاسم';
                        }
                        if (!nameRegex.hasMatch(value)) {
                          return 'الرجاء إدخال اسم ثلاثي';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: sphoneController,
                      decoration: const InputDecoration(labelText: 'رقم الطالب'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال رقم الطالب';
                        }
                        if (!phoneRegex.hasMatch(value)) {
                          return 'الرجاء إدخال رقم صحيح';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: gphoneController,
                      decoration: const InputDecoration(labelText: 'رقم ولي الأمر'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال رقم ولي الأمر';
                        }
                        if (!phoneRegex.hasMatch(value)) {
                          return 'الرجاء إدخال رقم صحيح';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    final updatedStudent = student.copyWith(
                      name: nameController.text,
                      sPhone: sphoneController.text,
                      gPhone: gphoneController.text,
                    );
                    
                    await _db.updateStudent(updatedStudent);
                    Navigator.pop(context);
                    _loadStudents();
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم تحديث البيانات بنجاح')),
                    );
                  }
                },
                child: const Text('حفظ'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _deleteStudent(int studentId, String studentName) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('تأكيد الحذف'),
            content: Text('هل أنت متأكد من حذف الطالب "$studentName"؟'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _db.deleteStudent(studentId);
                  Navigator.pop(context);
                  _loadStudents();
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم حذف الطالب بنجاح')),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('حذف'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
    return Column(
      children: [
        const SizedBox(height: 16),
        // Manual refresh button (optional - data auto-refreshes on navigation)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: _loadStudents,
                icon: const Icon(Icons.refresh),
                tooltip: 'تحديث البيانات',
                color: kPrimaryColor,
              ),
            ],
          ),
        ),
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else
          Expanded(
            child: SingleChildScrollView(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('الاسم')),
                    DataColumn(label: Text('رقم الطالب')),
                    DataColumn(label: Text('رقم ولي الأمر')),
                    DataColumn(label: Text('تعديل')),
                    DataColumn(label: Text('حذف')),
                  ],
                  rows: students.map((student) {
                    return DataRow(cells: [
                      DataCell(Text(student.name)),
                      DataCell(Text(student.sPhone)),
                      DataCell(Text(student.gPhone)),
                      DataCell(
                        IconButton(
                          onPressed: () => _editStudent(student),
                          icon: const Icon(Icons.edit, color: Colors.blue),
                        ),
                      ),
                      DataCell(
                        IconButton(
                          onPressed: () => _deleteStudent(student.id!, student.name),
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
