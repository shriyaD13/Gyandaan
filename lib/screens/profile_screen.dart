import 'package:flutter/material.dart';
import 'package:gyandaan2/providers/auth.dart';
import 'package:gyandaan2/providers/user.dart';
import 'package:gyandaan2/widgets/edit_info.dart';
import 'package:provider/provider.dart';

import 'auth_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static const routeName = '/profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  
  void _showEditWindow(String fieldChanged, dynamic oldValue, BuildContext ctx) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: ctx,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: EditInfo(fieldChanged,oldValue),
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final userRef = Provider.of<User>(context);
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 30),
                alignment: Alignment.centerRight,
                child: CircleAvatar(
                  backgroundColor: Colors.blue.shade50,
                  radius: 25,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          AuthScreen.routeName, ModalRoute.withName('/'));
                      Provider.of<Auth>(context, listen: false).logOut();
                    },
                    icon: Icon(Icons.exit_to_app_rounded),
                  ),
                ),
              ),
              Container(
                width: deviceSize.width,
                margin: EdgeInsets.only(top: 40),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 5,
                        color: Colors.blueGrey.shade100,
                        spreadRadius: 5,
                      )
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 70,
                    child: Icon(
                      Icons.tag_faces_outlined,
                      size: 70,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                '${userRef.username}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                  letterSpacing: 7,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '${userRef.email}',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(
                height: 40,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 2,
                                      color: Colors.blueGrey.shade100,
                                      spreadRadius: 2,
                                    ),
                                  ]),
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 25,
                                child: Icon(Icons.person),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Username',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Text(
                                      '${userRef.username}',
                                      style: TextStyle(color: Colors.grey),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => _showEditWindow(
                                    'username', userRef.username, context))
                          ],
                        ),
                      ),
                      Divider(),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 2,
                                      color: Colors.blueGrey.shade100,
                                      spreadRadius: 2,
                                    ),
                                  ]),
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 25,
                                child: Icon(Icons.mail_outline),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Email',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Text(
                                      '${userRef.email}',
                                      style: TextStyle(color: Colors.grey),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            IconButton(icon: Icon(Icons.edit), onPressed: () => _showEditWindow('email', userRef.email, context))
                          ],
                        ),
                      ),
                      Divider(),
                      if (userRef.course!.isNotEmpty)
                        Container(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 2,
                                        color: Colors.blueGrey.shade100,
                                        spreadRadius: 2,
                                      ),
                                    ]),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 25,
                                  child: Icon(Icons.book_outlined),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Course',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        '${userRef.course}',
                                        style: TextStyle(color: Colors.grey),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(
                                  icon: Icon(Icons.edit), onPressed: () => _showEditWindow('course', userRef.course, context))
                            ],
                          ),
                        ),
                      if (userRef.course!.isNotEmpty) Divider(),
                      if (userRef.timing!.isNotEmpty)
                        Container(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 2,
                                        color: Colors.blueGrey.shade100,
                                        spreadRadius: 2,
                                      ),
                                    ]),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 25,
                                  child: Icon(Icons.watch_later_outlined),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Timing',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        '${userRef.timing}',
                                        style: TextStyle(color: Colors.grey),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(
                                  icon: Icon(Icons.edit), onPressed: () => _showEditWindow('timing', userRef.timing, context))
                            ],
                          ),
                        ),
                      if (userRef.timing!.isNotEmpty) Divider(),
                      if (userRef.days.isNotEmpty)
                        Container(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 2,
                                        color: Colors.blueGrey.shade100,
                                        spreadRadius: 2,
                                      ),
                                    ]),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 25,
                                  child: Icon(Icons.calendar_view_day),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Preferred Days',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        '${userRef.days.join(", ")}',
                                        style: TextStyle(color: Colors.grey),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(
                                  icon: Icon(Icons.edit), onPressed: ()=> _showEditWindow('days', userRef.days, context))
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
