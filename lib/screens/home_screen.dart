import 'package:flutter/material.dart';
import '../models/task.dart';
import '../models/schedule.dart';
import '../models/note.dart';
import '../theme/app_theme.dart';
import 'tasks_screen.dart';
import 'schedule_screen.dart';
import 'notes_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _fabAnimationController;
  
  List<Task> tasks = [
    Task(
      id: '1',
      title: 'Complete Project Report',
      description: 'Finish and submit the semester project report',
      dueDate: DateTime.now().add(const Duration(days: 2)),
      isCompleted: false,
    ),
    Task(
      id: '2',
      title: 'Study for Midterms',
      description: 'Review chapters 1-5 for mathematics',
      dueDate: DateTime.now().add(const Duration(days: 5)),
      isCompleted: false,
    ),
  ];

  List<Schedule> schedules = [
    Schedule(
      id: '1',
      subjectName: 'Mathematics',
      time: '09:00 AM - 10:30 AM',
      room: 'Room 101',
      instructor: 'Dr. Smith',
    ),
    Schedule(
      id: '2',
      subjectName: 'Physics',
      time: '11:00 AM - 12:30 PM',
      room: 'Lab 205',
      instructor: 'Prof. Johnson',
    ),
    Schedule(
      id: '3',
      subjectName: 'English',
      time: '02:00 PM - 03:30 PM',
      room: 'Room 302',
      instructor: 'Ms. Williams',
    ),
  ];

  List<Note> notes = [
    Note(
      id: '1',
      title: 'Important Concepts',
      content: 'Remember to focus on differential equations and integration techniques',
      createdAt: DateTime.now(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _addTask(Task task) {
    setState(() {
      tasks.add(task);
    });
  }

  void _toggleTask(Task task) {
    setState(() {
      final index = tasks.indexWhere((t) => t.id == task.id);
      if (index >= 0) {
        tasks[index] = task.copyWith(isCompleted: !task.isCompleted);
      }
    });
  }

  void _deleteTask(String taskId) {
    setState(() {
      tasks.removeWhere((t) => t.id == taskId);
    });
  }

  void _addSchedule(Schedule schedule) {
    setState(() {
      schedules.add(schedule);
    });
  }

  void _addNote(Note note) {
    setState(() {
      notes.add(note);
    });
  }

  void _deleteNote(String noteId) {
    setState(() {
      notes.removeWhere((n) => n.id == noteId);
    });
  }

  Widget _buildDashboard() {
    final completedTasks = tasks.where((t) => t.isCompleted).length;
    final pendingTasks = tasks.where((t) => !t.isCompleted).length;
    final completionPercentage = tasks.isEmpty ? 0 : (completedTasks / tasks.length * 100).toInt();

    return SingleChildScrollView(
      child: Column(
        children: [
          // Header Section
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryColor,
                  AppTheme.primaryColor.withOpacity(0.7),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome Back!',
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Keep your academics on track',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Stats Section
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Progress Card
                Card(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.successColor.withOpacity(0.1),
                          AppTheme.successColor.withOpacity(0.05),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tasks Progress',
                                  style: Theme.of(context).textTheme.headlineSmall,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '$completedTasks of ${tasks.length} completed',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.successColor.withOpacity(0.2),
                              ),
                              child: Center(
                                child: Text(
                                  '$completionPercentage%',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.successColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: tasks.isEmpty ? 0 : completedTasks / tasks.length,
                            minHeight: 8,
                            backgroundColor: Colors.grey[200],
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppTheme.successColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Stats Grid
                GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildStatCard(
                      title: 'Tasks',
                      value: tasks.length.toString(),
                      icon: Icons.assignment,
                      color: Colors.blue,
                    ),
                    _buildStatCard(
                      title: 'Pending',
                      value: pendingTasks.toString(),
                      icon: Icons.pending_actions,
                      color: AppTheme.warningColor,
                    ),
                    _buildStatCard(
                      title: 'Classes',
                      value: schedules.length.toString(),
                      icon: Icons.calendar_today,
                      color: Colors.purple,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Today's Schedule
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today\'s Schedule',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 2;
                    });
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: schedules.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 48,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No classes today',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: schedules.take(2).length,
                    itemBuilder: (context, index) {
                      final schedule = schedules[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Card(
                          child: ListTile(
                            leading: Container(
                              width: 50,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.school,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            title: Text(
                              schedule.subjectName,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(schedule.time),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.secondaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                schedule.room,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.secondaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 24),

          // Recent Notes
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Notes',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 3;
                    });
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: notes.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.note_outlined,
                          size: 48,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No notes yet',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: notes.take(2).length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Card(
                          child: ListTile(
                            leading: Container(
                              width: 50,
                              decoration: BoxDecoration(
                                color: AppTheme.accentColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.note,
                                color: AppTheme.accentColor,
                              ),
                            ),
                            title: Text(
                              note.title,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              note.content,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.15),
              color.withOpacity(0.05),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Academic Manager'),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildDashboard(),
          TasksScreen(
            tasks: tasks,
            onTaskAdded: _addTask,
            onTaskToggled: _toggleTask,
            onTaskDeleted: _deleteTask,
          ),
          ScheduleScreen(
            schedules: schedules,
            onScheduleAdded: _addSchedule,
          ),
          NotesScreen(
            notes: notes,
            onNoteAdded: _addNote,
            onNoteDeleted: _deleteNote,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_rounded),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_rounded),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note_rounded),
            label: 'Notes',
          ),
        ],
      ),
    );
  }
}
