import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class CreateScrapbookDialog extends StatefulWidget {
  final int year;
  final Function(String, String, int, Map<String, dynamic>) onScrapbookCreated;

  const CreateScrapbookDialog({
    super.key,
    required this.year,
    required this.onScrapbookCreated,
  });

  @override
  State<CreateScrapbookDialog> createState() => _CreateScrapbookDialogState();
}

class _CreateScrapbookDialogState extends State<CreateScrapbookDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _venueController = TextEditingController();
  final TextEditingController _artistsController = TextEditingController();
  
  final List<String> _selectedGenres = [];
  bool _isCollaborative = false;
  DateTime? _selectedDate;
  
  final List<String> _availableGenres = [
    'Rock', 'Pop', 'Hip Hop', 'R&B', 'EDM', 'Country', 'Jazz', 'Classical',
    'Metal', 'Folk', 'Indie', 'Alternative', 'K-Pop', 'Latin',
  ];

  @override
  void initState() {
    super.initState();
    // Set date to current year
    _selectedDate = DateTime(widget.year, DateTime.now().month, DateTime.now().day);
    _dateController.text = _formatDate(_selectedDate!);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _venueController.dispose();
    _artistsController.dispose();
    super.dispose();
  }
  
  // Show date picker
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(widget.year - 5),
      lastDate: DateTime(widget.year + 1),
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _formatDate(picked);
      });
    }
  }
  
  // Format date to MM/dd/yyyy
  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$month/$day/${date.year}';
  }
  
  // Toggle genre selection
  void _toggleGenre(String genre) {
    setState(() {
      if (_selectedGenres.contains(genre)) {
        _selectedGenres.remove(genre);
      } else {
        _selectedGenres.add(genre);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Text(
                  'Create New Scrapbook',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 24),
              
              // Title field
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Concert Title*',
                  hintText: 'Enter concert name',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              
              // Date field with picker
              GestureDetector(
                onTap: () => _pickDate(context),
                child: AbsorbPointer(
                  child: TextField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: 'Date*',
                      hintText: 'MM/DD/YYYY',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _pickDate(context),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Venue field
              TextField(
                controller: _venueController,
                decoration: const InputDecoration(
                  labelText: 'Venue',
                  hintText: 'Where was the concert?',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              
              // Artists field
              TextField(
                controller: _artistsController,
                decoration: const InputDecoration(
                  labelText: 'Artists',
                  hintText: 'Separate multiple artists with commas',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              
              // Genres
              const Text(
                'Genres',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableGenres.map((genre) {
                  final isSelected = _selectedGenres.contains(genre);
                  return FilterChip(
                    label: Text(genre),
                    selected: isSelected,
                    onSelected: (_) => _toggleGenre(genre),
                    backgroundColor: Colors.grey[200],
                    selectedColor: AppConstants.primaryColor.withOpacity(0.2),
                    checkmarkColor: AppConstants.primaryColor,
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              
              // Collaborative toggle
              SwitchListTile(
                title: const Text('Collaborative Scrapbook'),
                subtitle: const Text('Let friends add their memories'),
                value: _isCollaborative,
                onChanged: (value) {
                  setState(() {
                    _isCollaborative = value;
                  });
                },
                activeColor: AppConstants.primaryColor,
              ),
              const SizedBox(height: 24),
              
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('CANCEL'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      if (_titleController.text.isNotEmpty && _dateController.text.isNotEmpty) {
                        // Gather additional data
                        final Map<String, dynamic> additionalData = {
                          'venue': _venueController.text.isNotEmpty ? _venueController.text : null,
                          'artists': _artistsController.text.isNotEmpty 
                              ? _artistsController.text.split(',').map((e) => e.trim()).toList() 
                              : null,
                          'genres': _selectedGenres.isNotEmpty ? _selectedGenres : null,
                          'isCollaborative': _isCollaborative,
                          'createdAt': DateTime.now(),
                          'updatedAt': DateTime.now(),
                        };
                        
                        widget.onScrapbookCreated(
                          _titleController.text,
                          _dateController.text,
                          widget.year,
                          additionalData,
                        );
                      }
                      Navigator.pop(context);
                    },
                    child: const Text('CREATE'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
