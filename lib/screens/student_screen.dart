import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../database/database_helper.dart';
import '../models/student.dart';
import 'login_screen.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  final _dbHelper = DatabaseHelper();
  List<Student> _students = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  
  Student? _editingStudent;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    final students = await _dbHelper.getStudents();
    setState(() {
      _students = students;
    });
  }

  Future<void> _saveStudent() async {
    final name = _nameController.text.trim();
    final ageText = _ageController.text.trim();

    if (name.isEmpty || ageText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter Name and Age')),
      );
      return;
    }

    final age = int.tryParse(ageText);
    if (age == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid number for Age')),
      );
      return;
    }

    final messenger = ScaffoldMessenger.of(context);

    if (_editingStudent == null) {
      // Create new student
      final newStudent = Student(name: name, age: age);
      await _dbHelper.insertStudent(newStudent);
      messenger.showSnackBar(
        const SnackBar(content: Text('Student added successfully!')),
      );
    } else {
      // Update existing student
      final updatedStudent = Student(
        id: _editingStudent!.id,
        name: name,
        age: age,
      );
      await _dbHelper.updateStudent(updatedStudent);
      setState(() {
        _editingStudent = null;
      });
      messenger.showSnackBar(
        const SnackBar(content: Text('Student updated successfully!')),
      );
    }

    _nameController.clear();
    _ageController.clear();
    _loadStudents();
  }

  Future<void> _deleteStudent(int id) async {
    await _dbHelper.deleteStudent(id);
    _loadStudents();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Student deleted!')),
    );
  }

  void _editStudent(Student student) {
    setState(() {
      _editingStudent = student;
      _nameController.text = student.name;
      _ageController.text = student.age.toString();
    });
  }

  void _cancelEdit() {
    setState(() {
      _editingStudent = null;
      _nameController.clear();
      _ageController.clear();
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.transparent, // Let gradient show through scaffold borders if any
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1E1E1E), // Soft white/grey base
              Colors.black,      // Deep black blend
              Colors.black,
            ],
            stops: [0.0, 0.4, 1.0],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600), // Responsive constraint
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  floating: true,
                  pinned: true,
                  backgroundColor: Colors.transparent, // Ensures gradient flows through
                  title: const Text('Student Records'),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.logout_rounded),
                      onPressed: _logout,
                      tooltip: 'Logout',
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
          SliverToBoxAdapter(
            child: Card(
              margin: const EdgeInsets.all(16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      _editingStudent == null ? 'Add New Student' : 'Edit Student',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        prefixIcon: Icon(Icons.person_outline, size: 20),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Age',
                        prefixIcon: Icon(Icons.cake_outlined, size: 20),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (_editingStudent != null)
                          TextButton(
                            onPressed: _cancelEdit,
                            child: const Text('Cancel'),
                          ),
                        if (_editingStudent != null) const SizedBox(width: 8),
                        ElevatedButton.icon(
                          icon: Icon(_editingStudent == null ? Icons.add_rounded : Icons.update_rounded),
                          label: Text(
                            _editingStudent == null ? 'Add Student' : 'Update',
                          ),
                          onPressed: _saveStudent,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),
          ),
          const SliverToBoxAdapter(child: Divider()),
          if (_students.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Text(
                  'No students recorded yet.',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ).animate().fadeIn(),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final student = _students[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white12, width: 1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person_outline, color: Colors.white, size: 24),
                      ),
                      title: Text(
                        student.name,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold, // Heavier weight to match reference
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        'Age: ${student.age}',
                        style: textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF888888), // Subtle descriptive text
                          height: 1.5,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white12, width: 1),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 18),
                              onPressed: () => _editStudent(student),
                              tooltip: 'Edit',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white12, width: 1),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.white, size: 18),
                              onPressed: () => _deleteStudent(student.id!),
                              tooltip: 'Delete',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: 0.1, curve: Curves.easeOut);
                },
                childCount: _students.length,
              ),
            ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}
