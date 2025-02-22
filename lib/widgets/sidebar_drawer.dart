import 'package:flutter/material.dart';

class SidebarDrawer extends StatefulWidget {
  final String name;
  final String email;


  const SidebarDrawer({
    required this.name,
    required this.email,
    super.key,
  });

  @override
  SidebarDrawerState createState() => SidebarDrawerState();
}

class SidebarDrawerState extends State<SidebarDrawer> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    String name = widget.name;
    String email = widget.email;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.redAccent,
            ),
            accountName:
                Text(name.substring(0, 1).toUpperCase() + name.substring(1)),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                name.substring(0, 1).toUpperCase(),
                style: TextStyle(fontSize: 40.0),
              ),
            ),
            otherAccountsPictures: [
              IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          ListTile(
            title:
                Text('BROWSE', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),

            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushNamed(
                context,
                '/home',
                arguments: {'name': name, 'email': email},
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Favorites'),
            onTap: () {
              // Handle Favorites tap
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: Icon(Icons.feedback),
            title: Text('Feedback'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushNamed(
                context,
                '/feedback',
                arguments: {'name': name, 'email': email},
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Help'),
            onTap: () {
              // Handle Help tap
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            title:
                Text('HISTORY', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('History'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushNamed(
                context,
                '/history',
                arguments: {'name': name, 'email': email},
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notification'),
            onTap: () {
              // Handle Notification tap
              Navigator.pop(context); // Close the drawer
            },
          ),
          Divider(),
          // ListTile(
          //   leading: Icon(Icons.dark_mode),
          //   title: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text('Dark Mode'),
          //       Switch(
          //         value: isDarkMode,
          //         onChanged: (bool value) {
          //           setState(() {
          //             isDarkMode = value;
          //             // Handle the dark mode toggle here
          //           });
          //         },
          //       ),
          //     ],
          //   ),
          //   onTap: () {},
          // ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              bool? result = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Confirm Logout'),
                    content: Text('Are you sure you want to log out?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false); // Return false
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true); // Return true
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );

              if (result == true) {
                Navigator.pop(context); // Close the drawer
                Navigator.pushReplacementNamed(context, '/login'); // Navigate to /log
              }
            },
          ),
        ],
      ),
    );
  }
}