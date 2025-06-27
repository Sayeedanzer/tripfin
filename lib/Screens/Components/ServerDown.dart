import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/Color_Constants.dart';
import 'CustomAppButton.dart';


class Serverdown extends StatelessWidget {
  const Serverdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "Whoops! ",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: primary,
                    fontFamily: "lexend",
                  ),
                  children: [
                    TextSpan(
                      text: "The server’s on a coffee break.",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color:Color(0xff9E9E9E),
                        fontFamily: "lexend",
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Image.asset("assets/images/server_error.png"),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomAppButton(text: "Try later", onPlusTap: (){

            }),
          ],
        ),
      ),
    );
  }
}
