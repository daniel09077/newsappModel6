import 'package:flutter/material.dart';
import 'package:news_app/models/news_item.dart'; // Import the NewsItem model

class NewsDetailPage extends StatelessWidget {
  final NewsItem newsItem; // The news item to display

  const NewsDetailPage({super.key, required this.newsItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Details', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop(); // Go back to the previous screen
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              newsItem.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(
                    newsItem.category,
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  backgroundColor: Colors.blue[700],
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
                Text(
                  '${newsItem.date.day}/${newsItem.date.month}/${newsItem.date.year}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              newsItem.content,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            // You can add more details here, like images, author, etc.
          ],
        ),
      ),
    );
  }
}
