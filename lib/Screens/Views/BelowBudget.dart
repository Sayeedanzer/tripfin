import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tripfin/Screens/Components/CustomAppButton.dart';
import 'package:tripfin/utils/Color_Constants.dart';

class BudgetBossScreen extends StatelessWidget {
  final String  message;

  const BudgetBossScreen({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:primary,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16,vertical: 50),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Wow!',
                  style: TextStyle(
                    fontFamily: 'Mullish',
                    color: Color(0xFFDDA25F),
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),

                const Text(
                  'You are with in the budget boss.',
                  style: TextStyle(
                    fontFamily: 'Mullish',
                    color: Color(0xffFBFBFB),
                    fontSize: 18,
                    fontWeight: FontWeight.w400
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: Image.asset(
                'assets/screen1backimage.png',
                height: 300,
              ),
            ),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                children: [

                  TextSpan(
                    text: message,
                    style: TextStyle(
                      color: Color(0xff55EE4A), // Light green for "48,000"
                      fontSize: 24,
                      fontFamily: 'Mullish',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
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
