import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:sherophopia/Tabs/searchTab.dart';

class MySlider extends StatelessWidget {
  GlobalKey<SliderDrawerState> _key = GlobalKey<SliderDrawerState>();

  @override
  Widget build(BuildContext context) {
    var _selectedIndex=0;
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color:Color.fromRGBO(72, 132, 151, 200) ,
            ),
            child: Text('Sherophopia'),
          ),
          ListTile(
            title: const Text('Search'),
            selected: _selectedIndex == 0,
            onTap: () {
              Navigator.pushReplacementNamed(context, SearchTab.routeName);

            },
          ),
          ListTile(
            title: const Text('About us'),
            selected: _selectedIndex == 1,
            onTap: () {

            },
          ),
          ListTile(
            title: const Text('Contact us'),
            selected: _selectedIndex == 2,
            onTap: () {

            },
          ),
        ],
      ),

    ) ;
  }
}
