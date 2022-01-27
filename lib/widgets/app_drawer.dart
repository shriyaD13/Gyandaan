import 'package:flutter/material.dart';
import 'package:gyandaan2/providers/auth.dart';
import 'package:gyandaan2/providers/user.dart';
import 'package:gyandaan2/screens/learn/mentor_screen.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    bool isStudent() {
      return user.type == 'Learn';
    }

    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Welcome!'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.class__outlined),
            title: Text('Classes'),
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),
          ),
          Divider(),
          // ListTile(
          //   leading: Icon(Icons.people_outline),
          //   title: isStudent() ? Text('Mentors') : Text('Students'),
          //   onTap: () => isStudent()
          //       ? Navigator.of(context)
          //           .pushReplacementNamed(MentorsScreen.routeName)
          //       : Navigator.of(context)
          //           .pushReplacementNamed(Students_list.routeName),
          // ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout_rounded),
            title: Text('Log out'),
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil('/', ModalRoute.withName('/'));
              Provider.of<Auth>(context, listen: false).logOut();
            },
          ),
        ],
      ),
    );
  }
}
