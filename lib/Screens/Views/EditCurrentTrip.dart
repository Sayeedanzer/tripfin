import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tripfin/Screens/Components/CutomAppBar.dart';

import '../../utils/Color_Constants.dart';

class EditCurrentTrip extends StatefulWidget {
  const EditCurrentTrip({super.key});

  @override
  State<EditCurrentTrip> createState() => _EditCurrentTripState();
}

class _EditCurrentTripState extends State<EditCurrentTrip> {
  TextEditingController dateController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController budgetController = TextEditingController();
  File? _selectedImage;
  String? destinationError;
  String? dateError;
  String? budgetError;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    } else {}
  }

  bool _validateInputs() {
    bool isValid = true;
    setState(() {
      // Destination validation
      if (destinationController.text.trim().isEmpty) {
        destinationError = "Destination is required";
        isValid = false;
      } else if (destinationController.text.trim().length < 2) {
        destinationError = "Destination must be at least 2 characters";
        isValid = false;
      } else {
        destinationError = null;
      }

      // Date validation
      if (dateController.text.trim().isEmpty) {
        dateError = "Date is required";
        isValid = false;
      } else {
        dateError = null;
      }

      // Budget validation
      if (budgetController.text.trim().isEmpty) {
        budgetError = "Budget is required";
        isValid = false;
      } else {
        final budget = double.tryParse(budgetController.text.trim());
        if (budget == null || budget <= 0) {
          budgetError = "Enter a valid positive amount";
          isValid = false;
        } else {
          budgetError = null;
        }
      }
    });
    return isValid;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      dateController.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Scaffold(

      appBar: CustomAppBar(title: "Edit Current Trip ", actions: []),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: BoxDecoration(),

        child: Column(

          children: [
            _buildTextField(
              controller: destinationController,
              hint: 'Where you travel',
              errorText: destinationError,
            ),
            SizedBox(height: height * 0.015),
            _buildTextField(
              controller: dateController,
              hint: 'Select date',
              icon: Icons.calendar_today,
              readOnly: true,
              onTap: () => _selectDate(context),
              errorText: dateError,
            ),
            SizedBox(height: height * 0.015),
            _buildTextField(
              controller: budgetController,
              hint: 'Enter spend amount',
              errorText: budgetError,
            ),
            SizedBox(height: height * 0.015),
            _selectedImage == null
                ? InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      backgroundColor: primary,
                      context: context,
                      builder: (BuildContext context) {
                        return SafeArea(
                          child: Wrap(
                            children: <Widget>[
                              ListTile(
                                leading: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                                title: Text(
                                  'Upload File',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Mullish',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                  ),
                                ),
                                onTap: () {
                                  _pickImage(ImageSource.camera);
                                  context.pop();
                                },
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.photo_library,
                                  color: Colors.white,
                                ),
                                title: Text(
                                  'Choose from gallery',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Mullish',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                  ),
                                ),
                                onTap: () {
                                  _pickImage(ImageSource.gallery);
                                  context.pop();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    width: width,
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade600,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'Upload File',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Mullish',
                      ),
                    ),
                  ),
                )
                : Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        _selectedImage!,
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedImage = null;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    bool readOnly = false,
    VoidCallback? onTap,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          style: TextStyle(color: Colors.white, fontFamily: 'Mulish'),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white70),
            suffixIcon: icon != null ? Icon(icon, color: Colors.white70) : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.grey.shade600),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.grey.shade600),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(top: 4.0, left: 12.0),
            child: Text(
              errorText,
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 12.0,
                fontFamily: 'Mulish',
              ),
            ),
          ),
      ],
    );
  }
}
