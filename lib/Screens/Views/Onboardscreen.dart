import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tripfin/Screens/Components/CustomAppButton.dart';
import 'package:tripfin/utils/Color_Constants.dart';

import '../../utils/Preferances.dart';
import '../Authentication/Login_Screen.dart';

class Onboardscreen extends StatefulWidget {
  @override
  State<Onboardscreen> createState() => _OnboardscreenState();
}

class _OnboardscreenState extends State<Onboardscreen> {
  @override
  void initState() {
    super.initState();
    PreferenceService().saveString('on_boarding', '1');
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,

        children: [

          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/on_boarding_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(),
                  Text(
                    'Hey Budget Boss!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      fontFamily: 'Mullish',
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Ready to plan your trip like a pro? Let’s make every penny count.',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Mullish',
                    ),
                  ),
                  Spacer(),
                  CustomAppButton1(height: 56,text: 'Get Started', onPlusTap: (){
                    context.pushReplacement('/login_mobile');
                  }),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],

      ),
    );
  }
}
