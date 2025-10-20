# Copilot Instructions for Student Attendance System

## 🎯 Project Overview
This is a **Flutter desktop application** for managing student attendance across 3 high school grades (الصف الاول/الثاني/الثالث الثانوي). Each grade has 5 predefined groups with "sat & tue" schedules. The app uses Arabic RTL interface with bilingual content.

## 🏗️ Architecture Patterns

### Database Architecture (SQLite + Unified Schema)
- **Core Entity Relationship**: `groups` (1) → `students` (many) with CASCADE DELETE
- **Migration Strategy**: Database version 3 with `_onUpgrade()` handling migrations from legacy schema
- **Access Pattern**: Use `UnifiedSqlDb` singleton - never instantiate multiple database connections
- **Default Data**: 15 predefined groups (5 per grade) auto-inserted on database creation

### State Management & Navigation
- **Tab-based Navigation**: Each grade uses `TabController` with registration tab + group data tabs
- **State Persistence**: `AutomaticKeepAliveClientMixin` maintains tab state across navigation
- **Theme Management**: `ThemeProvider` + `ChangeNotifier` with Hive persistence for dark/light/system modes
- **Form Controllers**: Global controllers in `constants.dart` shared across components

### Responsive Design System
- **Breakpoints**: Desktop (>992px), Tablet (>576px), Mobile (<576px) 
- **RTL Support**: Wrap screens in `Directionality(textDirection: TextDirection.rtl)`
- **Theme Colors**: Use `kPrimaryColor` (hex: 1B3C53), `kPrimarybackgroundColor` (hex: 234C6A) from constants

## 🔧 Development Workflows

### Database Operations
```dart
// Always use UnifiedSqlDb for all database operations
final db = UnifiedSqlDb();
await db.getGroupsByGrade(gradeNumber);  // Grade-specific queries
await db.getStudentsByGroup(groupId);    // Group-specific student data
```

### Adding New Features
1. **Models**: Create in `lib/models/` with `toMap()`, `fromMap()`, and `copyWith()` methods
2. **Database Methods**: Add CRUD operations to `UnifiedSqlDb` following existing patterns
3. **UI Components**: Use `CustomTextField` from `inputFields.dart` for form inputs
4. **Validation**: Regex patterns in `constants.dart` (nameRegex, phoneRegex)

### Testing & Debugging
- **Hot Reload**: Compatible - use `flutter run` for development
- **Database Reset**: Delete database file or increment `_currentVersion` in `UnifiedSqlDb`
- **Theme Testing**: Toggle via FloatingActionButton on each page

## 📁 Key File Responsibilities

### Core Services
- `lib/services/unified_sql_db.dart` - All database operations, migration logic
- `lib/theme/theme_provider.dart` - Theme state management with Hive persistence

### Models & Data
- `lib/models/group_model.dart` - Group entity (id, name, grade, schedule, isActive)
- `lib/models/student_model.dart` - Student entity with foreign key to group

### UI Architecture
- `lib/screens/navbar.dart` - Main navigation with PageView for 3 grades
- `lib/screens/unified_section_page.dart` - Grade-specific page with dynamic tabs
- `lib/screens/unified_data_table.dart` - Student data display with CRUD operations

### Configuration
- `lib/constants.dart` - Colors, regex patterns, global controllers, static group lists
- `lib/main.dart` - App initialization with Hive setup and theme configuration

## 🚨 Critical Conventions

### Arabic Text Handling
- **Always** wrap Arabic content in `Directionality(textDirection: TextDirection.rtl)`
- Use Arabic text for user-facing labels: 'الرجاء ادخال...' for validation messages
- Grade titles: 'الصف الاول الثانوي', 'الصف الثاني الثانوي', 'الصف الثالث الثانوي'

### Database Integrity
- **Never** modify group structure without updating default group creation in `_insertDefaultGroups()`
- **Always** use transactions for multi-table operations
- **Remember** foreign key constraints - deleting groups cascades to students

### Form Validation
- **Name Validation**: Must match `nameRegex` (3+ Arabic words)
- **Phone Validation**: Must match `phoneRegex` (Egyptian mobile format: 01[0125]XXXXXXXX)
- **Group Selection**: Validate selected group exists before student insertion

### Performance Considerations
- **Tab State**: Use `AutomaticKeepAliveClientMixin` for data-heavy tabs
- **Database Queries**: Prefer grade-specific queries over full table scans
- **Theme Transitions**: 300ms duration with `Curves.easeInOut` for smooth UX

## 🔄 Common Modification Patterns

When adding new student fields, update:
1. `StudentModel` - add property + toMap/fromMap/copyWith
2. `UnifiedSqlDb._onCreate()` - add column to CREATE TABLE
3. `inputFields.dart` - add CustomTextField with appropriate validation
4. `unified_section_page.dart` - add field to registration form
5. `unified_data_table.dart` - add column to display table