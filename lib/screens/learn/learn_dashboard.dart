import 'package:flutter/material.dart';
import 'package:gyandaan2/providers/user.dart';
import 'package:gyandaan2/screens/learn/find_mentor.dart';
import 'package:gyandaan2/widgets/learn/mentor_list.dart';
import 'package:gyandaan2/widgets/upcomingClasses.dart';
import 'package:provider/provider.dart';

import '../tab_screen.dart';

class LearnDashboard extends StatelessWidget {
  final String? username;
  final String? email;
  final List<dynamic> mentors;
  final List<dynamic> upcomingClasses;

  LearnDashboard(
    this.username,
    this.email,
    this.mentors,
    this.upcomingClasses,
  );

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Welcome, $username ',
                          style: TextStyle(
                              fontSize: 15, color: Colors.grey.shade600),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Your Statistic',
                          style: TextStyle(
                              fontSize: 28, color: Colors.indigo.shade900),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => TabScreen(3))),
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.face),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Stack(
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                      // color: Colors.blueAccent,
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.withOpacity(0.5),
                          Colors.blue.withOpacity(0.8)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0, 1],
                      ),
                      borderRadius: BorderRadius.circular(20)),
                ),
                Container(
                  margin: EdgeInsets.only(top: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '100',
                        style: TextStyle(
                          color: Colors.indigo.shade900,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Hours of learning',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ],
                  ),
                )
              ],
            ),
            if (!upcomingClasses.isEmpty)
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 30),
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Upcoming Classes',
                            style: TextStyle(
                                fontSize: 20, color: Colors.indigo.shade900),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            shape: BoxShape.circle,
                          ),
                          margin: EdgeInsets.only(top: 30),
                          // padding: const EdgeInsets.all (4.0),
                          child: FloatingActionButton(
                            onPressed: () => Navigator.of(context)
                                .pushNamed(FindMentor.routeName),
                            child: Icon(Icons.person_add_alt_1_outlined),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    UpcomingClasses(upcomingClasses, false)
                  ],
                ),
              )
            else
              Column(
                children: [
                  Container(
                    height: 200,
                    child: Center(
                      child: Text(
                        'No classes yet ! \n Wait for your mentor to schedule a class',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      shape: BoxShape.circle,
                    ),
                    margin: EdgeInsets.only(top: 30),
                    // padding: const EdgeInsets.all (4.0),
                    child: FloatingActionButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed(FindMentor.routeName),
                      child: Icon(Icons.person_add_alt_1_outlined),
                    ),
                  ),
                ],
              ),

            // if (mentors.isNotEmpty)
            //   Container(
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           'Mentors',
            //           style: TextStyle(fontSize: 20),
            //         ),
            //         MentorList(mentors),
            //       ],
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}
