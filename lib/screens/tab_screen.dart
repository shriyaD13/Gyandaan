import 'package:flutter/material.dart';
import 'package:gyandaan2/providers/user.dart';
import 'package:gyandaan2/screens/calendar.dart';
import 'package:gyandaan2/screens/dashboard.dart';
import 'package:gyandaan2/screens/learn/find_mentor.dart';
import 'package:gyandaan2/screens/profile_screen.dart';
import 'package:gyandaan2/screens/teach/schedule_class.dart';
import 'package:gyandaan2/widgets/learn/mentor_list.dart';
import 'package:gyandaan2/screens/teach/requests_screen.dart';
import 'package:provider/provider.dart';

class TabScreen extends StatefulWidget {
  int _selectedPageIndex = 0;
  static const routeName = '/tab-screen';

  TabScreen([this._selectedPageIndex = 0]);

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  List<Map<String, Object>> _pages = [];

  void _selectPage(int index) {
    setState(() {
      widget._selectedPageIndex = index;
    });
  }

  @override
  void initState() {
    _pages = [
      {
        'page': Dashboard(),
      },
      {
        'page': Dashboard(),
      },
      {
        'page': Calendar(),
      },
      {
        'page': ProfileScreen(),
      },
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

  final userRef = Provider.of<User>(context);
  final secondLabel = userRef.type == 'Learn' ? 'Mentors' : 'Requests';
  _pages[1]['page'] = userRef.type == 'Learn' ? MentorList(userRef.mentors) : RequestsScreen(userRef.students);

    return Scaffold(
      body: _pages[widget._selectedPageIndex]['page'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Theme.of(context).accentColor,
        currentIndex: widget._selectedPageIndex,
        onTap: _selectPage,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_rounded),
            label: secondLabel,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_rounded),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.face),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
