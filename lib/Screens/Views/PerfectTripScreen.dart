import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tripfin/utils/Color_Constants.dart';

import '../Components/CustomAppButton.dart';

class Perfecttripscreen extends StatelessWidget {
  final String message;
  const Perfecttripscreen({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              'Perfect Boss !',
              style: TextStyle(
                fontFamily: 'Mullish',
                color: Color(0xFFDDA25F),
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'You finished the tour with in the Budget.',
              style: TextStyle(
                fontFamily: 'Mullish',
                fontWeight: FontWeight.w400,
                color: Color(0xffFBFBFB),
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20), // Exact spacing as in the image

            Center(
              child: Image.asset(
                'assets/screen3backimage.png', // Your image asset
                height: 300, // Matches the size in the image
              ),
            ),
            const SizedBox(height: 10), // Exact spacing as in the image
            Text(
              message,
              style: TextStyle(
                color: Color(0xffDBDBDB),
                fontWeight: FontWeight.w500,
                fontSize: 20,
                fontFamily: 'Mullish',
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 80, horizontal: 16),
        child: CustomAppButton1(
          text: 'Done',
          onPlusTap: () {
            context.go("/home");
          },
        ),
      ),
    );
  }
}
