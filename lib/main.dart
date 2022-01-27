import 'package:flutter/material.dart';
import 'package:gyandaan2/providers/courses.dart';
import 'package:gyandaan2/providers/user.dart';
import 'package:gyandaan2/screens/dashboard.dart';
import 'package:gyandaan2/screens/learn/find_mentor.dart';
import 'package:gyandaan2/screens/learn/mentor_info.dart';
import 'package:gyandaan2/screens/profile_screen.dart';
import 'package:gyandaan2/screens/spalshScreen.dart';
import 'package:gyandaan2/screens/tab_screen.dart';
import 'package:gyandaan2/screens/teach/schedule_class.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../screens/auth_screen.dart';
import '../screens/login.dart';
import '../screens/sign_up.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, User>(
            create: (ctx) => User('', '', '', '', [], [], [], '', '', []),
            update: (ctx, auth, prevUser) => User(
              auth.uid,
              prevUser!.username,
              prevUser.type,
              prevUser.email,
              prevUser.mentors,
              prevUser.students,
              prevUser.upcommingClasses,
              prevUser.course,
              prevUser.timing,
              prevUser.days,
            ),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Courses(),
          )
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'Gyandaan',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              accentColor: Colors.blueAccent,
            ),
            home: auth.isAuth
                ? TabScreen()
                : FutureBuilder(
                    builder: (ctx, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                    future: auth.tryAutoLogin(),
                  ),
            routes: {
              LoginScreen.routeName: (ctx) => LoginScreen(),
              SignUpScreen.routeName: (ctx) => SignUpScreen(),
              AuthScreen.routeName: (ctx) => AuthScreen(),
              Dashboard.routeName: (ctx) => Dashboard(),
              FindMentor.routeName: (ctx) => FindMentor(),
              ScheduleClass.routeName: (ctx) => ScheduleClass(),
              ProfileScreen.routeName: (ctx) => ProfileScreen(),
              TabScreen.routeName: (ctx) => TabScreen(),
              MentorInfo.routeName: (ctx) => MentorInfo(),
            },
          ),
        ));
  }
}
