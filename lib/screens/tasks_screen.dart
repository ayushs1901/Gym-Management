import 'package:flutter/material.dart';
import '../models/task.dart';
import '../theme/app_theme.dart';

class TasksScreen extends StatefulWidget {
  final List<Task> tasks;
  final Function(Task) onTaskAdded;
  final Function(Task) onTaskToggled;
  final Function(String) onTaskDeleted;

  const TasksScreen({
    super.key,
    required this.tasks,
    required this.onTaskAdded,
    required this.onTaskToggled,
    required this.onTaskDeleted,
  });

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  String _filterStatus = 'All';

  void _showAddTaskDialog() {
    _titleController.clear();
    _descriptionController.clear();
    _selectedDate = null;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add New Task'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Task Title',
                    hintText: 'Enter task title',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter task description',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate != null
                            ? 'Due: ${_selectedDate!.toLocal().toString().split(' ')[0]}'
                            : 'No date selected',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null) {
                          setDialogState(() {
                            _selectedDate = date;
                          });
                        }
                      },
                      icon: const Icon(Icons.calendar_today, size: 18),
                      label: const Text('Date'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_titleController.text.isNotEmpty &&
                    _descriptionController.text.isNotEmpty &&
                    _selectedDate != null) {
                  final newTask = Task(
                    id: DateTime.now().toString(),
                    title: _titleController.text,
                    description: _descriptionController.text,
                    dueDate: _selectedDate!,
                  );
                  widget.onTaskAdded(newTask);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('✓ Task added successfully!')),
                  );
                }
              },
              child: const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }

  List<Task> _getFilteredTasks() {
    if (_filterStatus == 'Completed') {
      return widget.tasks.where((t) => t.isCompleted).toList();
    } else if (_filterStatus == 'Pending') {
      return widget.tasks.where((t) => !t.isCompleted).toList();
    }
    return widget.tasks;
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _getFilteredTasks();
    final pendingCount = widget.tasks.where((t) => !t.isCompleted).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        elevation: 0,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$pendingCount Pending',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Pending', 'Completed'].map((status) {
                  final isSelected = _filterStatus == status;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(status),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _filterStatus = selected ? status : 'All';
                        });
                      },
                      backgroundColor: Colors.grey[100],
                      selectedColor: AppTheme.primaryColor,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: filteredTasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assignment_outlined,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No $_filterStatus tasks',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.grey[400],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create your first task to get started',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      final daysUntilDue = task.dueDate.difference(DateTime.now()).inDays;
                      final isOverdue = daysUntilDue < 0 && !task.isCompleted;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Card(
                          child: Dismissible(
                            key: Key(task.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (_) {
                              widget.onTaskDeleted(task.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Task deleted')),
                              );
                            },
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              leading: Transform.scale(
                                scale: 1.3,
                                child: Checkbox(
                                  value: task.isCompleted,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  onChanged: (value) {
                                    widget.onTaskToggled(task);
                                  },
                                ),
                              ),
                              title: Text(
                                task.title,
                                style: TextStyle(
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 6),
                                  Text(
                                    task.description,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        size: 14,
                                        color: isOverdue ? Colors.red : Colors.grey[600],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        task.dueDate.toLocal().toString().split(' ')[0],
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isOverdue ? Colors.red : Colors.grey[600],
                                          fontWeight: isOverdue ? FontWeight.w600 : FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      if (daysUntilDue >= 0 && !task.isCompleted)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: daysUntilDue == 0
                                                ? AppTheme.errorColor.withOpacity(0.2)
                                                : AppTheme.warningColor.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            daysUntilDue == 0 ? 'Today' : 'In $daysUntilDue days',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: daysUntilDue == 0
                                                  ? AppTheme.errorColor
                                                  : AppTheme.warningColor,
                                            ),
                                          ),
                                        ),
                                      if (task.isCompleted)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppTheme.successColor.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: const Text(
                                            'Completed',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: AppTheme.successColor,
                                            ),
                                          ),
                                        ),
                                      if (isOverdue)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppTheme.errorColor.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: const Text(
                                            'Overdue',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: AppTheme.errorColor,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
