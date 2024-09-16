import 'package:flutter/material.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({Key? key}) : super(key: key);

  @override
  _SettingsTabState createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  bool _notificationsEnabled = true;
  bool _isDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Background color
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text('Settings',style: TextStyle(fontSize: 30,fontWeight: FontWeight.w700),),
          SwitchListTile(
            title: Text('Enable Notifications', style: TextStyle(fontSize: 18)),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
            secondary: Icon(Icons.notifications),
          ),
          SwitchListTile(
            title: Text('Dark Theme', style: TextStyle(fontSize: 18)),
            value: _isDarkTheme,
            onChanged: (bool value) {
              setState(() {
                _isDarkTheme = value;
                if (value) {
                  // Code to switch to dark theme
                } else {
                  // Code to switch to light theme
                }
              });
            },
            secondary: Icon(Icons.brightness_6),
          ),
          Divider(),
          ListTile(
            title: Text("Account Settings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Change Password', style: TextStyle(fontSize: 16)),
            onTap: () {
              // Navigate to change password screen
            },
          ),
          Divider(),
          ListTile(
            title: Text("App Information", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About', style: TextStyle(fontSize: 16)),
            onTap: () {
              // Show app information
            },
          ),
          ListTile(
            leading: Icon(Icons.phone_android),
            title: Text('App Version 1.0.0', style: TextStyle(fontSize: 16)),
            onTap: () {
              // Show app version information
            },
          ),
        ],
      ),
    );
  }
}
