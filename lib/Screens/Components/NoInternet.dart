import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../utils/Color_Constants.dart';
import 'dart:io';
import 'CustomAppButton.dart';
import 'CustomSnackBar.dart';

class Nointernet extends StatelessWidget {
  const Nointernet({super.key});

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
                    color: primary, // Ensure `primary` is defined
                    fontFamily: "lexend",
                  ),
                  children: [
                    TextSpan(
                      text: "The internet took a break",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff9E9E9E),
                        fontFamily: "lexend",
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Image.asset("assets/no_internet.png"),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomAppButton(
                text: "Retry",
                  onPlusTap: () async {
                    final connectivityResult = await Connectivity().checkConnectivity();
                    if (connectivityResult != ConnectivityResult.none) {
                      try {
                        // Try to make an actual internet request
                        final result = await InternetAddress.lookup('google.com');
                        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                          // Internet is definitely available
                          context.pop();
                          return;
                        }
                      } catch (e) {
                        // Lookup failed — still no internet
                      }
                    }
                    // If we reach here, still no internet
                    CustomSnackBar.show(context, "Still no internet. Please try again.");
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
