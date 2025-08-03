import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:news_app/models/news_item.dart';
import 'package:news_app/widgets/filter_chip_widget.dart';
import 'package:news_app/screens/login_page.dart';
import 'package:news_app/models/user_role.dart';
import 'package:news_app/screens/add_news_page.dart';
import 'package:news_app/screens/news_detail_page.dart';
import 'package:news_app/utils/app_constants.dart';
import 'package:news_app/models/user_profile.dart';
import 'package:news_app/services/auth_service.dart'; // <-- Make sure this path matches your project

class NewsHomePage extends StatefulWidget {
  final UserProfile userProfile;

  const NewsHomePage({super.key, required this.userProfile});

  @override
  State<NewsHomePage> createState() => _NewsHomePageState();
}

class _NewsHomePageState extends State<NewsHomePage> {
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<NewsItem> _allNews = [
    NewsItem(
      title: 'Registration Deadline Extended',
      content: 'The registration deadline for all students has been extended to January 20th, 2025. Please ensure all outstanding fees are paid.',
      category: AppConstants.categoryAdministration,
      date: DateTime(2025, 1, 15),
    ),
    // ... (rest of your mock news items here)
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  void _addNewNewsItem(NewsItem newsItem) {
    setState(() {
      _allNews.insert(0, newsItem);
    });
  }

  List<NewsItem> get _filteredNews {
    List<NewsItem> departmentFilteredNews = _allNews.where((news) {
      return news.category == AppConstants.categoryAdministration ||
             news.category == AppConstants.categoryStudentBody ||
             news.category == widget.userProfile.department;
    }).toList();

    if (_selectedFilter == 'All') {
      if (_searchQuery.isEmpty) {
        return departmentFilteredNews;
      } else {
        final lowerCaseQuery = _searchQuery.toLowerCase();
        return departmentFilteredNews.where((news) {
          return news.title.toLowerCase().contains(lowerCaseQuery) ||
                 news.content.toLowerCase().contains(lowerCaseQuery);
        }).toList();
      }
    } else {
      final categoryFiltered = departmentFilteredNews.where((news) => news.category == _selectedFilter).toList();
      if (_searchQuery.isEmpty) {
        return categoryFiltered;
      } else {
        final lowerCaseQuery = _searchQuery.toLowerCase();
        return categoryFiltered.where((news) {
          return news.title.toLowerCase().contains(lowerCaseQuery) ||
                 news.content.toLowerCase().contains(lowerCaseQuery);
        }).toList();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kaduna Polytechnic',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              'Student News Hub (${widget.userProfile.department} - ${widget.userProfile.role == UserRole.admin ? "Admin" : "Student"})',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none, color: Colors.black),
              label: const Text('Notifications', style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[200],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
          if (widget.userProfile.role == UserRole.admin)
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddNewsPage(onAddNews: _addNewNewsItem),
                  ));
                },
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Add News', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => LoginPage(
                    authService: authService,
                    onLoginSuccess: (userProfile) {
                      // Optional: handle login success
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(10.0),
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
                              color: Colors.blue[700],
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

            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search news, announcements...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
              ),
            ),
            const SizedBox(height: 20),

            const Text('Filter by:', style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 10),

            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                FilterChipWidget(
                  label: 'All',
                  count: _filteredNews.length,
                  isSelected: _selectedFilter == 'All',
                  onSelected: (selected) {
                    setState(() {
                      _selectedFilter = selected ? 'All' : '';
                    });
                  },
                ),
                FilterChipWidget(
                  label: AppConstants.categoryAdministration,
                  count: _filteredNews.where((news) => news.category == AppConstants.categoryAdministration).length,
                  isSelected: _selectedFilter == AppConstants.categoryAdministration,
                  onSelected: (selected) {
                    setState(() {
                      _selectedFilter = selected ? AppConstants.categoryAdministration : '';
                    });
                  },
                  icon: Icons.business,
                ),
                FilterChipWidget(
                  label: AppConstants.categoryDepartment,
                  count: _filteredNews.where((news) => news.category == AppConstants.categoryDepartment).length,
                  isSelected: _selectedFilter == AppConstants.categoryDepartment,
                  onSelected: (selected) {
                    setState(() {
                      _selectedFilter = selected ? AppConstants.categoryDepartment : '';
                    });
                  },
                  icon: Icons.school,
                ),
                FilterChipWidget(
                  label: AppConstants.categoryStudentBody,
                  count: _filteredNews.where((news) => news.category == AppConstants.categoryStudentBody).length,
                  isSelected: _selectedFilter == AppConstants.categoryStudentBody,
                  onSelected: (selected) {
                    setState(() {
                      _selectedFilter = selected ? AppConstants.categoryStudentBody : '';
                    });
                  },
                  icon: Icons.people,
                ),
              ],
            ),
            const SizedBox(height: 20),

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
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total Announcements', style: TextStyle(fontSize: 16, color: Colors.grey)),
                      const SizedBox(height: 5),
                      Text('${_filteredNews.length}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Icon(Icons.description, size: 60, color: Colors.blue[100]),
                ],
              ),
            ),
            const SizedBox(height: 20),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredNews.length,
              itemBuilder: (context, index) {
                final news = _filteredNews[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 15.0),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NewsDetailPage(newsItem: news),
                      ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(news.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(
                            news.content,
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(news.category, style: TextStyle(fontSize: 12, color: Colors.blue[700], fontWeight: FontWeight.w600)),
                              Text('${news.date.day}/${news.date.month}/${news.date.year}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),
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
