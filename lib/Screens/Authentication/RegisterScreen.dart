import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tripfin/Block/Logic/GetCurrency/GetCurrencyCubit.dart';
import 'package:tripfin/Block/Logic/GetCurrency/GetCurrencyState.dart';
import 'package:tripfin/Block/Logic/RegisterBloc/Register_cubit.dart';
import 'package:tripfin/Block/Logic/RegisterBloc/Register_state.dart';
import 'package:tripfin/Model/GetCurrencyModel.dart';
import 'package:tripfin/Screens/Components/CustomAppButton.dart';
import 'package:tripfin/Screens/Components/CustomSnackBar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Form key and controllers
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _conformPasswordController = TextEditingController();
  final _emailController = TextEditingController();

  final TextEditingController _selectCurrency = TextEditingController();
  final FocusNode _currencyFocusNode = FocusNode();
  String? _selectedCurrency;

  bool _obscurePassword = true;

  @override
  void initState() {
    // context.read<GetCurrencyCubit>().GetCurrency();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _conformPasswordController.dispose();
    _emailController.dispose();
    _selectCurrency.dispose();
    _currencyFocusNode.dispose();
    super.dispose();
  }

  // Validation functions
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
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(
      r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{8,}$',
    ).hasMatch(value)) {
      return 'Password must contain letters and numbers';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? _validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your mobile number';
    }
    final mobileRegex = RegExp(r'^\+?[1-9]\d{9,14}$');
    if (!mobileRegex.hasMatch(value)) {
      return 'Please enter a valid mobile number';
    }
    return null;
  }

  void _handleRegistration(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // if (_selectedCurrency == null) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(
      //       content: Text('Please select a currency'),
      //       backgroundColor: Colors.red,
      //     ),
      //   );
      //   return;
      // }

      final registerData = {
        'full_name': _nameController.text.trim(),
        'mobile': _mobileController.text.trim(),
        'password': _passwordController.text,
        'confirm_password': _conformPasswordController.text,
        'email': _emailController.text.trim(),
        // 'currency': _selectCurrency.text,
      };
      context.read<RegisterCubit>().postRegister(registerData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C3132),
      body: SafeArea(
        child: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccessState) {
              CustomSnackBar.show(context, state.message);
              Future.delayed(const Duration(milliseconds: 500), () {
                context.pushReplacement('/login_mobile');
              });
            } else if (state is RegisterError) {
              CustomSnackBar.show(context, state.message);
            }
          },
          builder: (context, state) {
            final isLoading = state is RegisterLoading;
            return
              // BlocBuilder<GetCurrencyCubit, GetCurrenecyState>(
              //   builder: (context, state) {
              //     if (state is GetCurrencyLoading) {
              //       return Center(child: CircularProgressIndicator());
              //     } else if (state is GetCurrencyLoaded) {
              //       return
              Stack(
                children: [
                  Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 32,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              'Create Account',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontFamily: 'Mullish',
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Name Field
                          _buildLabel('Full Name'),
                          const SizedBox(height: 8),
                          _buildTextField(
                            hint: 'Enter your full name',
                            controller: _nameController,
                            validator: _validateName,
                            icon: Icons.person_outline,
                          ),

                          const SizedBox(height: 16),

                          // Mobile Field
                          _buildLabel('Mobile Number'),
                          const SizedBox(height: 8),
                          _buildTextField(
                            hint: 'Enter your mobile number',
                            controller: _mobileController,
                            inputType: TextInputType.phone,
                            validator: _validateMobile,
                            icon: Icons.phone_outlined,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Email Field
                          _buildLabel('Email Address'),
                          const SizedBox(height: 8),
                          _buildTextField(
                            hint: 'Enter your email',
                            controller: _emailController,
                            inputType: TextInputType.emailAddress,
                            validator: _validateEmail,
                            icon: Icons.email_outlined,
                          ),

                          const SizedBox(height: 16),

                          // Password Field
                          _buildLabel('Password'),
                          const SizedBox(height: 8),
                          _buildTextField(
                            hint: 'Enter your password',
                            controller: _passwordController,
                            validator: _validatePassword,
                            obscureText: _obscurePassword,
                            icon: Icons.lock_outline,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white70,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Confirm Password Field
                          _buildLabel('Confirm Password'),
                          const SizedBox(height: 8),
                          _buildTextField(
                            hint: 'Enter your confirm password',
                            controller: _conformPasswordController,
                            validator: _validateConfirmPassword,
                            obscureText: _obscurePassword,
                            icon: Icons.lock_outline,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white70,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),

                          const SizedBox(height: 32),

                          CustomAppButton1(
                            isLoading: isLoading,
                            text: 'Register',
                            onPlusTap: isLoading ? null : () {
                              _handleRegistration(context);
                            },
                          ),

                          const SizedBox(height: 24),

                          // Login Link
                          Center(
                            child: TextButton(
                              onPressed: () {
                                context.push('/login_mobile');
                              },
                              child: const Text(
                                'Already have an account? Login',
                                style: TextStyle(
                                  color: Color(0xFFF4A261),
                                  fontFamily: 'Mullish',
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                // )
                //   } else if (state is GetCurrencyError) {
                //     return Center(child: Text(state.message));
                //   }
                //   return Center(child: Text("No Data"));
                // },
              );
          },
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontFamily: 'Mullish',
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required TextEditingController controller,
    TextInputType inputType = TextInputType.text,
    String? Function(String?)? validator,
    bool obscureText = false,
    List<TextInputFormatter>? inputFormatters,
    IconData? icon,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      obscureText: obscureText,
      style: const TextStyle(
        color: Colors.white,
        fontFamily: 'Mullish',
        fontSize: 14,
      ),
      validator: validator,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFFB0B0B0),
          fontFamily: 'Mullish',
        ),
        prefixIcon:
        icon != null ? Icon(icon, color: Colors.white70, size: 20) : null,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0x1AFFFFFF),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Colors.white54, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Color(0xFFF4A261), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }
}