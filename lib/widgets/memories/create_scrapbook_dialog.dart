import 'package:flutter/material.dart';

class CreateScrapbookDialog extends StatelessWidget {
  final int year;
  final Function(String, String, int) onScrapbookCreated;

  const CreateScrapbookDialog({
    super.key,
    required this.year,
    required this.onScrapbookCreated,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController dateController = TextEditingController();

    return AlertDialog(
      title: const Text('Create New Scrapbook'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Concert Title',
              hintText: 'Enter concert name',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: dateController,
            decoration: const InputDecoration(
              labelText: 'Date',
              hintText: 'MM/DD/YYYY',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () {
            if (titleController.text.isNotEmpty && dateController.text.isNotEmpty) {
              onScrapbookCreated(
                titleController.text,
                dateController.text,
                year,
              );
            }
            Navigator.pop(context);
          },
          child: const Text('CREATE'),
        ),
      ],
    );
  }
}
