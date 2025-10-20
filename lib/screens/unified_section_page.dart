import 'package:flutter/material.dart';
import '../constants.dart';
import '../services/unified_sql_db.dart';
import '../models/group_model.dart';
import '../models/student_model.dart';
import 'inputFields.dart';
import 'unified_data_table.dart';
import 'settings_drawer.dart';

class UnifiedSectionPage extends StatefulWidget {
  final int grade; // 1, 2, or 3
  final String gradeTitle;

  const UnifiedSectionPage({
    Key? key,
    required this.grade,
    required this.gradeTitle,
  }) : super(key: key);

  @override
  _UnifiedSectionPageState createState() => _UnifiedSectionPageState();
}

class _UnifiedSectionPageState extends State<UnifiedSectionPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final UnifiedSqlDb _db = UnifiedSqlDb();
  late TabController tabController;
  List<GroupModel> groups = [];
  GroupModel? selectedGroup;
  bool isLoading = true;
  final _localFormKey = GlobalKey<FormState>(); // Local form key for this page

  @override
  bool get wantKeepAlive => true; // Keep state alive when switching pages

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Future<void> _loadGroups() async {
    setState(() => isLoading = true);
    
    try {
      final loadedGroups = await _db.getGroupsByGrade(widget.grade);
      
      setState(() {
        groups = loadedGroups;
        if (groups.isNotEmpty) {
          selectedGroup = groups.first;
        }
        isLoading = false;
      });

      // Initialize tab controller after groups are loaded
      tabController = TabController(
        length: groups.length + 1, // +1 for registration tab
        vsync: this,
      );
    } catch (e) {
      print('Error loading groups: $e');
      setState(() {
        isLoading = false;
        groups = [];
      });
      
      // Create a default tab controller even if loading fails
      tabController = TabController(length: 1, vsync: this);
    }
  }

  Future<void> _saveStudent() async {
    if (_localFormKey.currentState!.validate()) {
      if (selectedGroup == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('الرجاء اختيار مجموعة')),
        );
        return;
      }

      try {
        final student = StudentModel(
          groupId: selectedGroup!.id,
          name: nameController.text,
          sPhone: sphoneController.text,
          gPhone: gphoneController.text,
        );

        await _db.insertStudent(student);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تمت إضافة بيانات الطالب بنجاح!')),
        );

        // Clear controllers
        nameController.clear();
        sphoneController.clear();
        gphoneController.clear();

        // Auto-switch to the group's tab to show the added student
        final groupIndex = groups.indexWhere((g) => g.id == selectedGroup!.id);
        if (groupIndex != -1) {
          // +1 because registration tab is first
          tabController.animateTo(groupIndex + 1);
        }
      } catch (e) {
        print('Error saving student: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('حدث خطأ أثناء حفظ البيانات')),
        );
      }
    }
  }

  Widget _buildRegistrationTab() {
    return Form(
      key: _localFormKey, // Use local form key instead of global
      child: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                const SizedBox(height: 100),
                CustomTextField(
                  controller: nameController,
                  hintText: 'اسم الطالب',
                  emptyValueError: 'الرجاء ادخال اسم الطالب',
                  validationError: 'الرجاء ادخال اسم الطالب ثلاثي',
                  regex: nameRegex,
                ),
                const SizedBox(height: 25),
                CustomTextField(
                  controller: sphoneController,
                  hintText: 'رقم الطالب',
                  emptyValueError: 'الرجاء ادخال رقم الطالب',
                  validationError: 'الرجاء ادخال رقم صحيح',
                  regex: phoneRegex,
                ),
                const SizedBox(height: 25),
                CustomTextField(
                  controller: gphoneController,
                  hintText: 'رقم ولي الامر',
                  emptyValueError: 'الرجاء ادخال رقم ولي الامر',
                  validationError: 'الرجاء ادخال رقم صحيح',
                  regex: phoneRegex,
                ),
                const SizedBox(height: 25),
                _buildDynamicDropdown(),
                const SizedBox(height: 25),
                SizedBox(
                  width: MediaQuery.of(context).size.width > 992
                      ? 500
                      : MediaQuery.of(context).size.width > 576
                          ? MediaQuery.of(context).size.width * 0.6
                          : MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: _saveStudent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('اضافه'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicDropdown() {
    if (groups.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'لا توجد مجموعات. الرجاء إضافة مجموعات من قائمة الإعدادات.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.orange),
        ),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    double dropdownWidth;
    if (screenWidth > 992) {
      dropdownWidth = 550;
    } else if (screenWidth > 576) {
      dropdownWidth = screenWidth * 0.7;
    } else {
      dropdownWidth = screenWidth * 0.85;
    }

    return SizedBox(
      height: 70,
      width: dropdownWidth,
      child: InputDecorator(
        decoration: const InputDecoration(),
        child: DropdownButtonFormField<int>(
          value: selectedGroup?.id,
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
          onChanged: (int? newValue) {
            setState(() {
              selectedGroup = groups.firstWhere((g) => g.id == newValue);
            });
          },
          items: groups.map<DropdownMenuItem<int>>((GroupModel group) {
            return DropdownMenuItem<int>(
              value: group.id,
              child: Text(group.name),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimarybackgroundColor,
          centerTitle: true,
          title: Text(
            widget.gradeTitle,
            style: const TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                _loadGroups(); // Refresh groups
              },
              tooltip: 'تحديث المجموعات',
            ),
          ],
          bottom: TabBar(
            controller: tabController,
            isScrollable: groups.length > 5, // Make scrollable if many groups
            tabs: [
              const Tab(text: 'تسجيل طالب جديد'),
              ...groups.map((group) => Tab(text: group.name)).toList(),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: const Color.fromARGB(255, 165, 165, 165),
          ),
        ),
        drawer: SettingsDrawer(
          onGroupsChanged: () {
            _loadGroups(); // Refresh groups when settings change
          },
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            _buildRegistrationTab(),
            ...groups.map((group) => UnifiedDataTable(
                  groupId: group.id,
                  groupName: group.name,
                )).toList(),
          ],
        ),
      ),
    );
  }
}
