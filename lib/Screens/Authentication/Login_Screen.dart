import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tripfin/Screens/Components/CustomAppButton.dart';
import 'package:tripfin/Screens/Components/CustomSnackBar.dart';
import 'package:tripfin/utils/Color_Constants.dart';
import '../../Block/Logic/LogInBloc/login_cubit.dart';
import '../../Block/Logic/LogInBloc/login_state.dart';
import '../../Services/AuthService.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccessState &&
            state.loginModel.settings?.success == 1) {
          AuthService.saveTokens(
            state.loginModel.data?.access ?? '',
            state.loginModel.data?.refresh ?? "",
            state.loginModel.data?.expiryTime ?? 0,
          );
          context.pushReplacement('/home');
        } else if (state is LoginError) {
          CustomSnackBar.show(context, state.message ?? "");
        }
      },

      builder: (context, state) {
        final isLoading = state is LoginLoading;
        return Scaffold(
          backgroundColor: const Color(0xff1C3132),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Center(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: 90,
                        height: 30,
                        child: OutlinedButton(
                          onPressed: () {
                            context.pushReplacement("/home");
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Colors.white,
                            ), // White border
                            foregroundColor: Colors.white, // Text color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            backgroundColor:
                                Colors.transparent, // Transparent background
                          ),
                          child: const Text(
                            'Skip',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Mullish',
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Image.asset(
                      "assets/MapPinWithCircle.png",
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 10),
                    Image.asset(
                      "assets/TripFin_Text.png",
                      width: 150,
                      height: 50,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      constraints: const BoxConstraints(maxWidth: 400),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Sign in to continue',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white70,
                                fontFamily: 'Mullish',
                              ),
                            ),
                            const SizedBox(height: 32),
                            // Email Field
                            const Text(
                              'Email',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                                fontFamily: 'Mullish',
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildTextField(
                              hint: 'Enter Your Email',
                              controller: _emailController,
                              inputType: TextInputType.emailAddress,
                              validator: _validateEmail,
                            ),
                            const SizedBox(height: 16),
                            // Password Field
                            const Text(
                              'Password',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                                fontFamily: 'Mullish',
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Mullish',
                              ),
                              validator: _validatePassword,
                              decoration: InputDecoration(
                                hintText: 'Enter Your Password',
                                hintStyle: const TextStyle(
                                  color: Color(0xFFB0B0B0),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                filled: true,
                                fillColor: const Color(0x1AFFFFFF),
                                contentPadding: const EdgeInsets.all(16),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: const BorderSide(
                                    color: Colors.white54,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 1,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  context.push('/forgot-password');
                                },
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Mullish',
                                    color: Color(0xFFF4A261),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: CustomAppButton1(
                                text: 'Login',
                                isLoading: isLoading,
                                onPlusTap:
                                    isLoading
                                        ? null
                                        : () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            final Map<String, dynamic>
                                            loginData = {
                                              'email': _emailController.text,
                                              'password':
                                                  _passwordController.text,
                                            };
                                            context
                                                .read<LoginCubit>()
                                                .postLogIn(loginData);
                                          }
                                        },
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account? ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.7),
                                    fontFamily: 'Mullish',
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    context.push('/signup');
                                  },
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFF4A261),
                                      fontFamily: 'Mullish',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required String hint,
    required TextEditingController controller,
    TextInputType inputType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      style: const TextStyle(color: Colors.white, fontFamily: 'Mullish'),
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFB0B0B0)),
        filled: true,
        fillColor: const Color(0x1AFFFFFF),
        contentPadding: const EdgeInsets.all(16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: Colors.white54, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }
}
