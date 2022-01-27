import 'package:flutter/material.dart';
import 'package:gyandaan2/screens/login.dart';
import 'package:gyandaan2/screens/sign_up.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';
  const AuthScreen({Key? key}) : super(key: key);

  void showLoginForm(BuildContext ctx) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: ctx,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: LoginScreen(),
        );
      },
    );
  }
  void showSignUpForm(BuildContext ctx) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: ctx,
      builder: (_) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: SignUpScreen(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    // final groupType = ModalRoute.of(context)!.settings.arguments as String;
    // print(args);


    
    return Scaffold(
        // appBar: AppBar(title: Text('Gyandaan'),),
        body: Stack(
      children: [
          Container(
          height: deviceSize.height,
          width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(
              'assets/images/welcome_image4.jpeg',
              fit: BoxFit.cover,
            ),
          ),
        Container(
          height: 130,
          margin: EdgeInsets.only(bottom: 20.0, top: 30),
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.cover,
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 30, top: 150),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'G Y A N D A A N',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'Voluntary contribution of knowledge',
                  style: TextStyle(
                    // color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(bottom: 60.0),
          height: deviceSize.height,
          width: deviceSize.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: deviceSize.width * (4 / 5),
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: ElevatedButton(
                      child: Text(
                        'Sign up',
                      ),
                      onPressed: () => showSignUpForm(context),
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                      )),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: deviceSize.width * (4 / 5),
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: ElevatedButton(
                    child: Text('Sign in'),
                    onPressed: () => showLoginForm(context),
                    style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}


// Container(
//           height: deviceSize.height,
//           width: deviceSize.width,
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   "Welcome!",
//                   style: TextStyle(fontWeight: FontWeight.w500, fontSize: 50),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 ElevatedButton(
//                     onPressed: () =>
//                         Navigator.of(context).popAndPushNamed(LoginScreen.routeName),
//                     child: Text('Login')),
//                 ElevatedButton(
//                     onPressed: () =>
//                         Navigator.of(context).popAndPushNamed(SignUpScreen.routeName),
//                     child: Text('Sign Up')),
//               ],
//             ),
//           ),
//         ),
