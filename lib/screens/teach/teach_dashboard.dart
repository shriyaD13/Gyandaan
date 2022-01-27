import 'package:flutter/material.dart';
import 'package:gyandaan2/screens/profile_screen.dart';
import 'package:gyandaan2/screens/tab_screen.dart';
import 'package:gyandaan2/widgets/teach/extra_info.dart';
import 'package:gyandaan2/screens/teach/requests_screen.dart';
import 'package:gyandaan2/widgets/upcomingClasses.dart';

class TeachDashboard extends StatelessWidget {
  final String? username;
  final String? email;
  final List<dynamic> students;
  final List<dynamic> upcommingClasses;
  final String? course;
  final String? timing;

  TeachDashboard(
    this.username,
    this.email,
    this.students,
    this.upcommingClasses,
    this.course,
    this.timing,
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
            if (course!.isEmpty || timing!.isEmpty)
              ExtraInfo()
            else
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
                          'Classes taken',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            if (!upcommingClasses.isEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  SizedBox(height: 20),
                  UpcomingClasses(upcommingClasses, true),
                ],
              )
            else
              Container(
                height: 200,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('No classes yet! '),
                  ),
                ),
              )
            
          ],
        ),
      ),
    );
  }
}
