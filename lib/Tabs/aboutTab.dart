import 'package:flutter/material.dart';
import 'package:sherophopia/Tabs/contactTab.dart';

class AboutUsPage extends StatelessWidget {
  static String routeName = "About";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('About Us'),
            Spacer(),
            Image(image: AssetImage('assets/images/psychology.png'),height: 40,width: 40,)
          ],
        ),
        backgroundColor: Color.fromRGBO(72, 132, 151, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAnimatedHeader(),
              SizedBox(height: 20),
              _buildSection(
                title: 'Welcome Home!',
                content: 'Who we are? We are an organization that seeks to help provide awareness about mental health disorders, treatment, and help to easily connect patients with the nearest and most suitable psychologists.',
                icon: Icons.star,
                backgroundColor: Colors.lightBlue[50],
                textColor: Colors.black,
              ),
              _buildSection(
                title: 'Our Mission',
                content: 'We are dedicated to fostering a space where mental well-being thrives. By providing innovative tools and resources, we empower you to cultivate resilience, navigate challenges, and blossom into your strongest self. We believe in continuous growth and are committed to continuously refining the app to unlock your full mental potential.',
                icon: Icons.flag,
                backgroundColor: Colors.lightBlue[50],
                textColor: Colors.black,
              ),
              _buildSection(
                title: 'Meet Our Passionate Team',
                content: 'Our app is powered by a diverse team of passionate professionals. Each member is an expert in their field, working tirelessly to bring you the best features and ensure the app runs smoothly. We are all committed to your mental health journey.',
                icon: Icons.group,
                backgroundColor: Colors.lightBlue[50],
                textColor: Colors.black,
              ),
              _buildSection(
                title: 'Our Social Media',
                content: ' instagram:https://www.instagram.com/sherophobiaa?igsh=NTE1aWg5bGVwOWZy or facebook : follow us we waiting for you .',
                icon: Icons.perm_media_rounded,
                backgroundColor: Colors.lightBlue[50],
                textColor: Colors.black,
              ),
              _buildSection(
                title: 'Contact Us',
                content: 'If you have any questions or feedback, feel free to contact us. We are always here to help you.',
                icon: Icons.contact_mail,
                backgroundColor: Colors.lightBlue[50],
                textColor: Colors.black,
              ),
              SizedBox(height: 20),
              _buildContactButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedHeader() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(seconds: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About Us',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(72, 132, 151, 1),
                ),
              ),
              SizedBox(height: 10),
              Divider(color: Color.fromRGBO(72, 132, 151, 1)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required IconData icon,
    required Color? backgroundColor,
    required Color textColor,
  }) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Card(
              color: backgroundColor,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(icon, color: Color.fromRGBO(72, 132, 151, 1)),
                        SizedBox(width: 10),
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      content,
                      style: TextStyle(fontSize: 16, color: textColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContactButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(
            Color.fromRGBO(72, 132, 151, 1),
          ),
          padding: MaterialStatePropertyAll(
            EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          ),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          elevation: MaterialStatePropertyAll(4),
        ),
        onPressed: () {
          Navigator.pushNamed(context, ContactUsPage.routeName);
        },
        child: Text(
          'Contact Us',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
