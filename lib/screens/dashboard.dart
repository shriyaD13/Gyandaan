import 'package:flutter/material.dart';
import 'package:gyandaan2/providers/user.dart';
import 'package:gyandaan2/screens/learn/learn_dashboard.dart';
import 'package:gyandaan2/screens/teach/teach_dashboard.dart';
import 'package:gyandaan2/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);
  static const routeName = '/dashboard';

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var _isInit = true;
  var _isloading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isloading = true;
      });
      Provider.of<User>(context,listen: false)
          .fetchUserDetails()
          .then((value) => setState(() {
                _isloading = false;
              }));
      super.didChangeDependencies();
    }
    _isInit = false;
  }


  

  @override
  Widget build(BuildContext context) {
    final userRef = Provider.of<User>(context);
    // print(userRef.email);
    return Scaffold(
      body: _isloading
          ? Center(child: CircularProgressIndicator())
          : userRef.type == 'Learn'
              ? LearnDashboard(
                  userRef.username,
                  userRef.email,
                  userRef.mentors,
                  userRef.upcommingClasses,
                )
              : TeachDashboard(
                  userRef.username,
                  userRef.email,
                  userRef.students,
                  userRef.upcommingClasses,
                  userRef.course,
                  userRef.timing,
                ),
    );
  }
}
