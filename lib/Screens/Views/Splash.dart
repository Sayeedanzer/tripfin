import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../Block/Logic/Internet/internet_status_bloc.dart';
import '../../Block/Logic/Internet/internet_status_state.dart';
import '../../Services/AuthService.dart';
import '../../utils/Preferances.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;
  bool _showSecondImage = false;
  bool _showFinalImage = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 2), // Start from bottom
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.6, 0.8, curve: Curves.easeInOut),
    ));

    // Preload images
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _precacheImages();
    });

    // Start the animation
    _controller.forward();

    // After animation ends, show second and third elements, then navigate
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            _showSecondImage = true;
          });

          Future.delayed(const Duration(milliseconds: 500), () {
            setState(() {
              _showFinalImage = true;
            });

            Future.delayed(const Duration(milliseconds: 1000), () {
              _navigateAfterAnimation();
            });
          });
        });
      }
    });
  }

  void _navigateAfterAnimation() async {
    final onboarding = await PreferenceService().getString('on_boarding');
    final token = await AuthService.getAccessToken();

    if (!mounted) return;

    if (onboarding == null || onboarding.isEmpty) {
      context.go('/on_board');
    } else if (token == null || token.isEmpty) {
      context.go('/login_mobile');
    } else {
      context.go('/home'); // Or your default route
    }
  }

  void _precacheImages() {
    precacheImage(const AssetImage('assets/MapPin.png'), context);
    precacheImage(const AssetImage('assets/MapPinWithCircle.png'), context);
    precacheImage(const AssetImage('assets/TripFin_Text.png'), context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<InternetStatusBloc, InternetStatusState>(
      listener: (context, state) {
        if (state is InternetStatusLostState) {
          context.push('/no_internet');
        }else {
          context.pop();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xff1C3132),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SlideTransition(
                position: _offsetAnimation,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: _showSecondImage
                      ? Image.asset('assets/MapPinWithCircle.png',
                      key: const ValueKey('MapPinWithCircle'), height: 100)
                      : Image.asset('assets/MapPin.png',
                      key: const ValueKey('MapPin'), height: 100),
                ),
              ),
              const SizedBox(height: 20),
              AnimatedOpacity(
                opacity: _showFinalImage ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Image.asset('assets/TripFin_Text.png', height: 60),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
