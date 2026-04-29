import 'package:flutter/material.dart';
import '../models/note.dart';
import '../theme/app_theme.dart';

class NotesScreen extends StatefulWidget {
  final List<Note> notes;
  final Function(Note) onNoteAdded;
  final Function(String) onNoteDeleted;

  const NotesScreen({
    super.key,
    required this.notes,
    required this.onNoteAdded,
    required this.onNoteDeleted,
  });

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  void _showAddNoteDialog() {
    _titleController.clear();
    _contentController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Note'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Note Title',
                  hintText: 'Enter title',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Note Content',
                  hintText: 'Enter your note',
                ),
                maxLines: 5,
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
                  _contentController.text.isNotEmpty) {
                final newNote = Note(
                  id: DateTime.now().toString(),
                  title: _titleController.text,
                  content: _contentController.text,
                  createdAt: DateTime.now(),
                );
                widget.onNoteAdded(newNote);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('✓ Note added successfully!')),
                );
              }
            },
            child: const Text('Add Note'),
          ),
        ],
      ),
    );
  }

  void _showNoteDetails(Note note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(note.title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  note.content,
                  style: const TextStyle(fontSize: 16, height: 1.6),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 14),
                  const SizedBox(width: 8),
                  Text(
                    note.createdAt.toLocal().toString().split('.')[0],
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ],
          ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
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
                  '${widget.notes.length} Notes',
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
      body: widget.notes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.note_outlined,
                    size: 64,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No notes yet',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start taking notes to stay organized',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: widget.notes.length,
              itemBuilder: (context, index) {
                final note = widget.notes[index];
                final colors = [
                  const Color(0xFFFEF3C7),
                  const Color(0xFFDBEAFE),
                  const Color(0xFFFECDD3),
                  const Color(0xFFD1FAE5),
                ];
                final textColors = [
                  const Color(0xFF92400E),
                  const Color(0xFF1E40AF),
                  const Color(0xFF7C2D12),
                  const Color(0xFF065F46),
                ];
                final color = colors[index % colors.length];
                final textColor = textColors[index % textColors.length];

                return GestureDetector(
                  onTap: () => _showNoteDetails(note),
                  child: Dismissible(
                    key: Key(note.id),
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
                      widget.onNoteDeleted(note.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Note deleted')),
                      );
                    },
                    child: Card(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: color,
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.note,
                              color: textColor.withOpacity(0.6),
                              size: 24,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              note.title,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: textColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: Text(
                                note.content,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: textColor.withOpacity(0.7),
                                  height: 1.4,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              note.createdAt.toLocal().toString().split('.')[0],
                              style: TextStyle(
                                fontSize: 10,
                                color: textColor.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNoteDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
