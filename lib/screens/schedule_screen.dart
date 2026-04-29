import 'package:flutter/material.dart';
import '../models/schedule.dart';
import '../theme/app_theme.dart';

class ScheduleScreen extends StatefulWidget {
  final List<Schedule> schedules;
  final Function(Schedule) onScheduleAdded;

  const ScheduleScreen({
    super.key,
    required this.schedules,
    required this.onScheduleAdded,
  });

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final _subjectController = TextEditingController();
  final _timeController = TextEditingController();
  final _roomController = TextEditingController();
  final _instructorController = TextEditingController();
  String _viewType = 'Grid';

  void _showAddScheduleDialog() {
    _subjectController.clear();
    _timeController.clear();
    _roomController.clear();
    _instructorController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Schedule'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _subjectController,
                decoration: const InputDecoration(labelText: 'Subject'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _timeController,
                decoration: const InputDecoration(labelText: 'Time (e.g., 09:00 AM)'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _roomController,
                decoration: const InputDecoration(labelText: 'Room'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _instructorController,
                decoration: const InputDecoration(labelText: 'Instructor'),
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
              if (_subjectController.text.isNotEmpty &&
                  _timeController.text.isNotEmpty) {
                final newSchedule = Schedule(
                  id: DateTime.now().toString(),
                  subjectName: _subjectController.text,
                  time: _timeController.text,
                  room: _roomController.text,
                  instructor: _instructorController.text,
                );
                widget.onScheduleAdded(newSchedule);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✓ Schedule added successfully!'),
                  ),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showScheduleDetails(Schedule schedule) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(schedule.subjectName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Time', schedule.time, Icons.access_time),
            const SizedBox(height: 16),
            _buildDetailRow('Room', schedule.room, Icons.meeting_room),
            const SizedBox(height: 16),
            _buildDetailRow('Instructor', schedule.instructor, Icons.person),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.primaryColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleCard(Schedule schedule) {
    final colors = [
      const [Color(0xFF7C3AED), Color(0xFF8B5CF6)],
      const [Color(0xFF06B6D4), Color(0xFF22D3EE)],
      const [Color(0xFFEC4899), Color(0xFFF472B6)],
      const [Color(0xFFF59E0B), Color(0xFFFBBF24)],
    ];
    final colorPair = colors[widget.schedules.indexOf(schedule) % colors.length];

    return GestureDetector(
      onTap: () => _showScheduleDetails(schedule),
      child: Card(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colorPair,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.class_,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      schedule.subjectName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            schedule.time,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.meeting_room,
                          size: 14,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          schedule.room,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
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
                  '${widget.schedules.length} Classes',
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
          // View Toggle
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: ['Grid', 'List'].map((view) {
                final isSelected = _viewType == view;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _viewType = view;
                      });
                    },
                    icon: Icon(view == 'Grid' ? Icons.grid_view : Icons.list),
                    label: Text(view),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected
                          ? AppTheme.primaryColor
                          : Colors.grey[200],
                      foregroundColor: isSelected ? Colors.white : AppTheme.textPrimary,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: widget.schedules.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No schedule yet',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.grey[400],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add your first class to get started',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  )
                : _viewType == 'Grid'
                    ? GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.95,
                        ),
                        itemCount: widget.schedules.length,
                        itemBuilder: (context, index) {
                          return _buildScheduleCard(widget.schedules[index]);
                        },
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: widget.schedules.length,
                        itemBuilder: (context, index) {
                          final schedule = widget.schedules[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Card(
                              child: ListTile(
                                onTap: () => _showScheduleDetails(schedule),
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddScheduleDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _timeController.dispose();
    _roomController.dispose();
    _instructorController.dispose();
    super.dispose();
  }
}
