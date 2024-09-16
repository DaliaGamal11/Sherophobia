import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class content extends StatelessWidget {
  // URLs for each option
  final String inspiringStoriesUrl = 'https://boldjourney.com/?p=327347';
  final String recommendedBooksUrl = 'https://www.cosmopolitan.com/entertainment/books/g38018758/best-mental-health-books/';
  final String meditationVideosUrl = 'https://youtube.com/@greatmeditation?si=4Y8v9o6owA8t1nJ9';

  // Function to launch URL
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'What do you want to do today?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Card(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _buildListItem(
                title: 'Reading Inspiring Stories',
                imageUrl: 'assets/images/inspires.jpg',
                onTap: () => _launchURL(inspiringStoriesUrl),
              ),
              _buildListItem(
                title: 'Reading Recommended Books',
                imageUrl: 'assets/images/book2.jpg',
                onTap: () => _launchURL(recommendedBooksUrl),
              ),
              _buildListItem(
                title: 'Meditation and Podcast',
                imageUrl: 'assets/images/meditation.jpg',
                onTap: () => _launchURL(meditationVideosUrl),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListItem({
    required String title,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        backgroundImage: AssetImage(imageUrl),
        radius: 25,
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}