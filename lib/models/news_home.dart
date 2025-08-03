import 'package:flutter/material.dart';
import 'package:news_app/models/news_item.dart'; // Import NewsItem model
import 'package:news_app/widgets/filter_chip_widget.dart'; // Import FilterChipWidget

class NewsHomePage extends StatefulWidget {
  const NewsHomePage({super.key});

  @override
  State<NewsHomePage> createState() => _NewsHomePageState();
}

class _NewsHomePageState extends State<NewsHomePage> {
  // State for selected filter
  String _selectedFilter = 'Administration';

  // Mock News Data (replace with actual data fetching later)
  final List<NewsItem> _allNews = [
    NewsItem(
      title: 'Registration Deadline Extended',
      content: 'The registration deadline for all students has been extended to January 20th, 2025. Please ensure all outstanding fees are paid.',
      category: 'Administration',
      date: DateTime(2025, 1, 15),
    ),
    NewsItem(
      title: 'New Library Hours',
      content: 'Starting next week, the main library will operate from 8 AM to 8 PM on weekdays.',
      category: 'Administration',
      date: DateTime(2025, 1, 10),
    ),
    NewsItem(
      title: 'Faculty of Engineering Workshop',
      content: 'A workshop on advanced CAD software will be held on February 5th in the Engineering complex.',
      category: 'Faculty',
      date: DateTime(2025, 1, 20),
    ),
    NewsItem(
      title: 'Student Union Elections',
      content: 'Nominations for the upcoming Student Union elections are now open. Forms can be collected from the Dean of Students office.',
      category: 'Student Body',
      date: DateTime(2025, 1, 18),
    ),
    NewsItem(
      title: 'Inter-Departmental Sports Festival',
      content: 'The annual inter-departmental sports festival will commence on March 1st. Register your teams now!',
      category: 'Student Body',
      date: DateTime(2025, 1, 12),
    ),
    NewsItem(
      title: 'Academic Calendar Update',
      content: 'The updated academic calendar for the new session is now available on the university portal.',
      category: 'Administration',
      date: DateTime(2025, 1, 7),
    ),
  ];

  // Filtered news list based on selected category
  List<NewsItem> get _filteredNews {
    if (_selectedFilter == 'All') {
      return _allNews;
    } else {
      return _allNews.where((news) => news.category == _selectedFilter).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. AppBar
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80, // Adjust height for better spacing
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kaduna Polytechnic',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              'Student News Hub',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          // Notifications button
          Container(
            margin: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                // Handle notifications tap
              },
              icon: const Icon(Icons.notifications_none, color: Colors.black),
              label: const Text('Notifications', style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[200], // Light grey background
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners
                ),
                elevation: 0, // No shadow
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
          // Add News button
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                // Handle add news tap
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Add News', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Blue background
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners
                ),
                elevation: 0, // No shadow
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 2. Urgent Announcements Banner
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.red[50], // Light red background
                borderRadius: BorderRadius.circular(10.0), // Rounded corners
              ),
              child: Row(
                children: [
                  const Icon(Icons.notifications_active, color: Colors.red),
                  const SizedBox(width: 10),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black, fontSize: 14),
                        children: [
                          const TextSpan(
                            text: 'Urgent Announcements: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: 'Registration Deadline Extended to January 20th',
                            style: TextStyle(
                              color: Colors.blue[700], // Blue for the link
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search news, announcements...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners
                  borderSide: BorderSide.none, // No border line
                ),
                filled: true,
                fillColor: Colors.grey[200], // Light grey background
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
              ),
            ),
            const SizedBox(height: 20),

            // 4. Filter by Text
            const Text(
              'Filter by:',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),

            // 5. Filter Buttons (Chips)
            Wrap(
              spacing: 8.0, // Space between chips
              runSpacing: 8.0, // Space between rows of chips
              children: [
                FilterChipWidget(
                  label: 'All',
                  count: _allNews.length,
                  isSelected: _selectedFilter == 'All',
                  onSelected: (selected) {
                    setState(() {
                      _selectedFilter = selected ? 'All' : '';
                    });
                  },
                ),
                FilterChipWidget(
                  label: 'Administration',
                  count: _allNews.where((news) => news.category == 'Administration').length,
                  isSelected: _selectedFilter == 'Administration',
                  onSelected: (selected) {
                    setState(() {
                      _selectedFilter = selected ? 'Administration' : '';
                    });
                  },
                  icon: Icons.business,
                ),
                FilterChipWidget(
                  label: 'Faculty',
                  count: _allNews.where((news) => news.category == 'Faculty').length,
                  isSelected: _selectedFilter == 'Faculty',
                  onSelected: (selected) {
                    setState(() {
                      _selectedFilter = selected ? 'Faculty' : '';
                    });
                  },
                  icon: Icons.school,
                ),
                FilterChipWidget(
                  label: 'Student Body',
                  count: _allNews.where((news) => news.category == 'Student Body').length,
                  isSelected: _selectedFilter == 'Student Body',
                  onSelected: (selected) {
                    setState(() {
                      _selectedFilter = selected ? 'Student Body' : '';
                    });
                  },
                  icon: Icons.people,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 6. Total Announcements Section
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Announcements',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${_filteredNews.length}', // Display count of filtered news
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.description, // Or a custom icon for announcements
                    size: 60,
                    color: Colors.blue[100], // Light blue icon
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 7. News List
            ListView.builder(
              shrinkWrap: true, // Important to make ListView work inside SingleChildScrollView
              physics: const NeverScrollableScrollPhysics(), // Disable ListView's own scrolling
              itemCount: _filteredNews.length,
              itemBuilder: (context, index) {
                final news = _filteredNews[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 15.0),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          news.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          news.content,
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                          maxLines: 3, // Show a few lines of content
                          overflow: TextOverflow.ellipsis, // Add ellipsis if content overflows
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              news.category,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${news.date.day}/${news.date.month}/${news.date.year}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
