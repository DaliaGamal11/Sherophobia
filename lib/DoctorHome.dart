import 'package:flutter/material.dart';
import 'package:sherophopia/DoctorTabs/UploadResume.dart';
import 'package:sherophopia/DoctorTabs/UploadTab.dart';
import 'package:sherophopia/Tabs/aboutTab.dart';
import 'package:sherophopia/DoctorTabs/communityTabDoctor.dart';
import 'package:sherophopia/Tabs/contactTab.dart';
import 'package:sherophopia/Tabs/profileTab.dart';
import 'package:sherophopia/DoctorTabs/DoctorHomeTab.dart';
import 'package:sherophopia/Tabs/searchTab.dart';
import 'package:sherophopia/Tabs/chatbotTab.dart';
import 'package:sherophopia/introductionScreen.dart';

class DoctorHome extends StatefulWidget {
  static const String routeName = "DoctorHomeScreen";
  final String? userName;
  final String? bio;

  DoctorHome({Key? key, this.userName, this.bio}) : super(key: key);

  @override
  State<DoctorHome> createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  int _selectedIndex = 0;

  late List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = [
      DoctorHomeTab(),
      CommunityTabDoctor(),
      ProfileTab(),
      UploadResume()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(72, 132, 151, 1),
        title: Row(
          children: [
            Text(
              "Sherophopia",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
            ),
            Spacer(),
            Image(image: AssetImage('assets/images/psychology.png'),height: 40,width: 40,)          ],
        ),
      ),
      body: _tabs[_selectedIndex],
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromRGBO(72, 132, 151, 1),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Sherophopia',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.black),
              title: Text('Logout', style: TextStyle(fontSize: 18)),
              selectedColor: Colors.black,
              selected: _selectedIndex == 0,
              onTap: () {
                Navigator.pushReplacementNamed(context, IntroductionScreen.routeName);
              },
            ),
            ListTile(
              leading: Icon(Icons.info, color: Colors.black),
              title: Text('About us', style: TextStyle(fontSize: 18)),
              selectedColor: Colors.black,
              selected: _selectedIndex == 1,
              onTap: () {
                Navigator.pushNamed(context, AboutUsPage.routeName);
              },
            ),
            ListTile(
              leading: Icon(Icons.contact_mail, color: Colors.black),
              title: Text('Contact us', style: TextStyle(fontSize: 18)),
              selected: _selectedIndex == 2,
              onTap: () {
                Navigator.pushNamed(context, ContactUsPage.routeName);
              },
            ),
            ListTile(
              leading: Icon(Icons.search,color: Colors.black,),
              title: const Text('Search', style: TextStyle(fontSize: 18)),
              selected: _selectedIndex == 3,
              selectedColor: Colors.black,
              onTap: () {
                Navigator.pushNamed(context, SearchTab.routeName);
              },
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        color: Color.fromRGBO(72, 132, 151, 1),
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          onTap: (value) {
            setState(() {
              _selectedIndex = value;
            });
          },
          currentIndex: _selectedIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded, size: 40, color: Colors.white), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.groups_rounded, size: 40, color: Colors.white), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.person, size: 40, color: Colors.white), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.upload_file, size: 40, color: Colors.white), label: ""),
          ],
        ),
      ),
      floatingActionButton: Visibility(
        visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
        child: FloatingActionButton(
          child: const Icon(Icons.chat, color: Colors.white, size: 40),
          backgroundColor: Color.fromRGBO(72, 132, 151, 1),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatBotTab()),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
