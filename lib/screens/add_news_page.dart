import 'package:flutter/material.dart';
import 'package:news_app/models/news_item.dart'; // Import NewsItem model

class AddNewsPage extends StatefulWidget {
  // Callback to add the new news item to the main list (for mock data)
  final Function(NewsItem) onAddNews;

  const AddNewsPage({super.key, required this.onAddNews});

  @override
  State<AddNewsPage> createState() => _AddNewsPageState();
}

class _AddNewsPageState extends State<AddNewsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String? _selectedCategory; // For the dropdown menu

  // List of categories for the dropdown
  final List<String> _categories = [
    'Administration',
    'College',
    'Student Body',
    // Add more categories if needed
  ];

  void _submitNews() {
    if (_formKey.currentState!.validate()) {
      final newNews = NewsItem(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        category: _selectedCategory!, // Guaranteed not null by validator
        date: DateTime.now(), // Set current date
      );

      widget.onAddNews(newNews); // Call the callback to add news
      Navigator.of(context).pop(); // Go back to the previous screen (NewsHomePage)
      _showMessageBox(context, 'Success', 'News item added successfully!');
    }
  }

  void _showMessageBox(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New News', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'News Title',
                  hintText: 'e.g., Important Exam Schedule Update',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a news title.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _contentController,
                maxLines: 8, // Allow multiple lines for content
                decoration: InputDecoration(
                  labelText: 'News Content',
                  hintText: 'Write the full news article here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  alignLabelWithHint: true, // Aligns label to top for multiline input
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter news content.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                hint: const Text('Select a category'),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submitNews,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Submit News',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
