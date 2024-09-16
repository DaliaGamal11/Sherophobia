import 'package:flutter/material.dart';
import 'package:sherophopia/Tabs/aboutTab.dart';
import 'package:sherophopia/Tabs/contactTab.dart';
import 'package:sherophopia/PatientTabs/PatientHomeTab.dart';
import 'package:sherophopia/PatientTabs/payment.dart';
import 'package:sherophopia/Tabs/searchTab.dart';
import 'package:sherophopia/Tabs/communityTab.dart';
import 'package:sherophopia/Tabs/chatbotTab.dart';
import 'package:sherophopia/Tabs/profileTab.dart';
import 'package:sherophopia/introductionScreen.dart';

class PatientHome extends StatefulWidget {
  static const String routeName="HomeScreen";

  PatientHome({super.key});

  @override
  State<PatientHome> createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  int index=0;
  List<Widget>Tabs=[
    PatientHomeTab(),
    CommunityTab(),
    ProfileTab(),
    PaymentTab(),
  ];

  var _selectedIndex=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: true,
      appBar: AppBar(
          backgroundColor:Color.fromRGBO(72, 132, 151, 1),
          title: Row(
            children: [
              Text("Sherophopia",
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w700,color:Colors.white)),
              SizedBox(width: 140,),
              Image(image: AssetImage('assets/images/psychology.png'),height: 40,width: 40,)
            ],
          )),
      body:Tabs[index],
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
              selectedColor: Colors.black,
              selected: _selectedIndex == 2,
              onTap: () {
                Navigator.pushNamed(context, ContactUsPage.routeName);
              },
            ),
            ListTile(
              leading: Icon(Icons.search, color: Colors.black),
              title: Text('Search', style: TextStyle(fontSize: 18)),
              selectedColor: Colors.black,
              selected: _selectedIndex == 3,
              onTap: () {
                Navigator.pushNamed(context, SearchTab.routeName);
              },
            ),
          ],
        ),
      ),


      bottomNavigationBar: BottomAppBar(
        color: Color.fromRGBO(72, 132, 151, 1),
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        child: BottomNavigationBar(
          type:BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          onTap: (value) {
            index = value;
            setState(() {});
          },
          currentIndex: index,



          items:  [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded,size: 40,color:Colors.white),label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.groups_rounded,size: 40,color:Colors.white),label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.person,size: 40,color:Colors.white),label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.payment,size: 40,color:Colors.white),label:"")
          ],
        ),
      ),
      floatingActionButton: Visibility(
        visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
        child: FloatingActionButton(
           isExtended: false,
          child: Icon(Icons.chat,color: Colors.white,size: 40,),
          backgroundColor:Color.fromRGBO(72, 132, 151, 1),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatBotTab()),
            );          setState(() {
            });
          },),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,


    );
  }


}

