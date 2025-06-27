import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tripfin/utils/Color_Constants.dart';
import '../Components/CustomAppButton.dart';

class Outofbudgetscreen extends StatelessWidget {
  final String message;
  const Outofbudgetscreen({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              'Hey Budget Boss',
              style: TextStyle(
                fontFamily: 'Mullish',
                color: Color(0xFFffffff),
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.all(1.0),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Your are  ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Mullish',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: 'out of budget',
                      style: TextStyle(
                        color: Color(0xffFF3B3B),
                        fontSize: 18,
                        fontFamily: 'Mullish',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(child: Image.asset('assets/screen2backImage.png')),
            SizedBox(height: 10),
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
