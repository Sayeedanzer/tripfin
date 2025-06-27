import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../Block/Logic/ForgotPassword/ForgotPassWordCubit.dart';
import '../../Block/Logic/ForgotPassword/ForgotPasswordState.dart';
import '../../utils/Color_Constants.dart';
import '../Components/CustomAppButton.dart';
import '../Components/CutomAppBar.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isCodeSent = false;
  bool _isCodeVerified = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      appBar: CustomAppBar(title: 'Forgot Password', actions: const []),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              if (!_isCodeSent) ...[
                _buildTextField(
                  hint: 'Enter Your Email',
                  controller: _emailController,
                  inputType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
                  listener: (context, state) {
                    if (state is ForgotPasswordSuccess) {
                      setState(() {
                        _isCodeSent = true;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Reset code sent successfully'),
                        ),
                      );
                    } else if (state is ForgotPasswordError) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.message)));
                    }
                  },
                  builder: (context, state) {
                    return CustomAppButton1(
                      text: 'Send Reset Code',
                      isLoading: state is ForgotPasswordLoading,
                      onPlusTap: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<ForgotPasswordCubit>().Forgotpassword({
                            'email': _emailController.text,
                          });
                        }
                      },
                    );
                  },
                ),
              ]
              // Code Verification Field
              else if (!_isCodeVerified) ...[
                _buildTextField(
                  hint: 'Enter Verification Code',
                  controller: _codeController,
                  inputType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the verification code';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
                  listener: (context, state) {
                    if (state is ForgotPasswordSuccess) {
                      setState(() {
                        _isCodeVerified = true;
                      });
                    } else if (state is ForgotPasswordError) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.message)));
                    }
                  },
                  builder: (context, state) {
                    return CustomAppButton1(
                      text: 'Verify Code',
                      isLoading: state is ForgotPasswordLoading,
                      onPlusTap: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<ForgotPasswordCubit>().verifyOtp({
                            'email': _emailController.text,
                            'otp': _codeController.text,
                          });
                        }
                      },
                    );
                  },
                ),
              ] else ...[
                _buildTextField(
                  hint: 'New Password',
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your new password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    color: const Color(0xffffffff),
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                _buildTextField(
                  hint: 'Confirm Password',
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    color: const Color(0xffffffff),
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20.0),
                BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
                  listener: (context, state) {
                    if (state is ForgotPasswordSuccess) {
                      context.go('/login_mobile');
                    } else if (state is ForgotPasswordError) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.message)));
                    }
                  },
                  builder: (context, state) {
                    return CustomAppButton1(
                      text: 'Reset Password',
                      isLoading: state is ForgotPasswordLoading,
                      onPlusTap: () {
                        if (_formKey.currentState!.validate()) {
                          final Map<String, dynamic> data = {
                            'email': _emailController.text,
                            'new_password': _passwordController.text,
                            'confirm_password': _confirmPasswordController.text,
                          };
                          print("data:$data");
                          context.read<ForgotPasswordCubit>().confirmPassword(
                            data,
                          );
                        }
                      },
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required TextEditingController controller,
    TextInputType inputType = TextInputType.text,
    bool obscureText = false,
    String? Function(String?)? validator,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      obscureText: obscureText,
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
        suffixIcon: suffixIcon,
      ),
    );
  }
}
