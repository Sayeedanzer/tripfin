import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tripfin/Block/Logic/CategoryList/CategoryState.dart';
import 'package:tripfin/Block/Logic/GetTrip/GetTripCubit.dart';
import 'package:tripfin/Block/Logic/Home/HomeCubit.dart';
import 'package:tripfin/Screens/Components/CustomSnackBar.dart';
import 'package:tripfin/Screens/Components/FilteringDate.dart';
import '../../Block/Logic/CategoryList/CategoryCubit.dart';
import '../../Block/Logic/ExpenseDetails/ExpenseDetailsCubit.dart';
import '../../Block/Logic/ExpenseDetails/ExpenseDetailsState.dart';
import '../../Block/Logic/Internet/internet_status_bloc.dart';
import '../../Block/Logic/Internet/internet_status_state.dart';
import '../../Block/Logic/PiechartdataScreen/PiechartCubit.dart';
import '../../utils/Color_Constants.dart';
import '../Components/CustomAppButton.dart';
import '../Components/CutomAppBar.dart';

class UpdateExpense extends StatefulWidget {
  final String id;
  final String place;
  final String budget;
  final String expenseId;
  final String date;

  const UpdateExpense({
    Key? key,
    required this.id,
    required this.place,
    required this.budget,
    required this.expenseId,
    required this.date,
  }) : super(key: key);

  @override
  State<UpdateExpense> createState() => _UpdateExpenseState();
}

class _UpdateExpenseState extends State<UpdateExpense> {
  String selectedCategory = "";
  String paymentMode = "Online";
  String? selectedCategoryId;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  late DateTime initStart;
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    } else {}
  }

  @override
  void initState() {
    super.initState();
    try {
      if (widget.date.isNotEmpty) {
        initStart = DateFormat('yyyy-MM-dd').parse(widget.date);
      } else {
        initStart = DateTime.now();
      }
    } catch (e) {
      initStart = DateTime.now();
    }
    context.read<Categorycubit>().GetCategory();

    // if (widget.date.isNotEmpty) {
    //   initStart = DateFormat('yyyy-MM-dd').parse(widget.date);
    // } else {
    //   initStart = DateTime.now();
    // }
    context.read<Categorycubit>().GetCategory();

    if (widget.expenseId.isNotEmpty) {
      context.read<GetExpenseDetailCubit>().GetExpenseDetails(widget.expenseId);
    }

    context.read<GetExpenseDetailCubit>().stream.listen((state) {
      if (state is GetExpenseDetailLoaded) {
        final expenseData = state.expenseDetailModel.data;
        setState(() {
          selectedCategoryId = expenseData?.category ?? "";
          selectedCategory = expenseData?.categoryName ?? "";
          paymentMode = expenseData?.paymentMode ?? "Online";
          amountController.text = expenseData?.expense.toString() ?? "";
          dateController.text = expenseData?.date ?? "";
          remarksController.text = expenseData?.remarks ?? "";
        });
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime today = DateTime.now();

    // Allow selection up to initStart if it's a future date
    final DateTime lastDate = initStart.isAfter(today) ? initStart : today;

    // Initial date should be within the range
    final DateTime initialDate = today.isAfter(lastDate) ? lastDate : today;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: lastDate,
    );

    if (picked != null) {
      dateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InternetStatusBloc, InternetStatusState>(
      listener: (context, state) {
        if (state is InternetStatusLostState) {
          context.push('/no_internet');
        } else {
          context.pop();
        }
      },
      child: BlocConsumer<GetExpenseDetailCubit, GetExpenseDetailsState>(
        listener: (context, state) {
          if (state is ExpenceDetailSuccess) {
            Future.microtask(() {
              context.pushReplacement(
                '/vacation?budget=${widget.budget}&place=${widget.place}',
              );
              context.read<PiechartCubit>().fetchPieChartData("");
              context.read<HomeCubit>().fetchHomeData();
            });
          } else if (state is GetExpenseDetailError) {
            CustomSnackBar.show(context, state.message);
          }
        },
        builder: (context, expenseState) {
          if (expenseState is GetExpenseDetailLoading ||
              expenseState is SaveExpenseDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (expenseState is GetExpenseDetailLoaded ||
              expenseState is ExpenceDetailSuccess ||
              widget.expenseId.isEmpty) {
            return Scaffold(
              backgroundColor: const Color(0xff102A2C),
              appBar: CustomAppBar(
                title: capitalize(widget.place),
                actions: const [],
              ),
              body: _buildForm(context),
            );
          } else if (expenseState is GetExpenseDetailError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    expenseState.message,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (widget.expenseId.isNotEmpty) {
                        context.read<GetExpenseDetailCubit>().GetExpenseDetails(
                          widget.expenseId,
                        );
                      }
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: Text(
              "Loading data...",
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.expenseId.isEmpty) ...[
            _buildSectionTitle('Travel Plan'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xff1D3A3C),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildInfoRow(
                    Icons.place,
                    'Place: ',
                    capitalize(widget.place),
                  ),
                  const Divider(color: Colors.grey, height: 24),
                  _buildInfoRow(
                    Icons.currency_rupee,
                    'Budget: ',
                    widget.budget,
                    textColor: Colors.greenAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          _buildSectionTitle('Travel Expenses'),
          const SizedBox(height: 12),
          _buildExpenseForm(),
          const SizedBox(height: 32),
          _buildSubmitButton(context),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    Color? textColor,
    FontWeight? fontWeight,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
        Text(
          value,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontFamily: "Mullish",
            fontSize: 16,
            fontWeight: fontWeight ?? FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildExpenseForm() {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff1D3A3C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildCategoryDropdown(),
          const SizedBox(height: 16),
          _buildTextField(
            controller: amountController,
            hint: 'Amount',
            icon: Icons.currency_rupee,
            inputType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: dateController,
            hint: 'When you Spent',
            icon: Icons.calendar_today,
            readOnly: true,
            onTap: () => _selectDate(context),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: remarksController,
            hint: 'Remarks',
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          _buildPaymentModeSelector(),
          const SizedBox(height: 16),
          // SizedBox(height: height * 0.015),
          // _selectedImage == null
          //     ? InkWell(
          //       onTap: () {
          //         showModalBottomSheet(
          //           backgroundColor: primary,
          //           context: context,
          //           builder: (BuildContext context) {
          //             return SafeArea(
          //               child: Wrap(
          //                 children: <Widget>[
          //                   ListTile(
          //                     leading: Icon(
          //                       Icons.camera_alt,
          //                       color: Colors.white,
          //                     ),
          //                     title: Text(
          //                       'Upload Image for Trip',
          //                       style: TextStyle(
          //                         color: Colors.white,
          //                         fontFamily: 'Mullish',
          //                         fontWeight: FontWeight.w400,
          //                         fontSize: 15,
          //                       ),
          //                     ),
          //                     onTap: () {
          //                       _pickImage(ImageSource.camera);
          //                       context.pop();
          //                     },
          //                   ),
          //                   ListTile(
          //                     leading: Icon(
          //                       Icons.photo_library,
          //                       color: Colors.white,
          //                     ),
          //                     title: Text(
          //                       'Choose from gallery',
          //                       style: TextStyle(
          //                         color: Colors.white,
          //                         fontFamily: 'Mullish',
          //                         fontWeight: FontWeight.w400,
          //                         fontSize: 15,
          //                       ),
          //                     ),
          //                     onTap: () {
          //                       _pickImage(ImageSource.gallery);
          //                       context.pop();
          //                     },
          //                   ),
          //                 ],
          //               ),
          //             );
          //           },
          //         );
          //       },
          //       child: Container(
          //         width: width,
          //         padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 14),
          //         decoration: BoxDecoration(
          //           border: Border.all(color: Colors.grey.shade600, width: 1.0),
          //           borderRadius: BorderRadius.circular(30),
          //         ),
          //         child: Text(
          //           'Upload File',
          //           style: TextStyle(
          //             color: Colors.white70,
          //             fontSize: 16.0,
          //             fontWeight: FontWeight.w500,
          //             fontFamily: 'Mullish',
          //           ),
          //         ),
          //       ),
          //     )
          //     : Stack(
          //       children: [
          //         ClipRRect(
          //           borderRadius: BorderRadius.circular(8),
          //           child: Image.file(
          //             _selectedImage!,
          //             height: 80,
          //             width: 80,
          //             fit: BoxFit.cover,
          //           ),
          //         ),
          //         Positioned(
          //           top: 0,
          //           right: 0,
          //           child: GestureDetector(
          //             onTap: () {
          //               setState(() {
          //                 _selectedImage = null;
          //               });
          //             },
          //             child: Container(
          //               decoration: BoxDecoration(
          //                 color: Colors.black.withOpacity(0.6),
          //                 shape: BoxShape.circle,
          //               ),
          //               child: Icon(Icons.close, color: Colors.white, size: 18),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
        ],
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return BlocBuilder<Categorycubit, Categorystate>(
      builder: (context, categoryState) {
        if (categoryState is CategoryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (categoryState is CategoryLoaded &&
            categoryState.categoryresponsemodel.data != null) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade600),
              borderRadius: BorderRadius.circular(30),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                dropdownColor: const Color(0xff1D3A3C),
                value: selectedCategoryId,
                isExpanded: true,
                hint: const Text(
                  'Select Category',
                  style: TextStyle(color: Colors.white70),
                ),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                items:
                    categoryState.categoryresponsemodel.data!.map((category) {
                      return DropdownMenuItem<String>(
                        value: category.id,
                        child: Text(
                          category.categoryName ?? "",
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      selectedCategoryId = val;
                      final catName = categoryState.categoryresponsemodel.data!
                          .firstWhere((element) => element.id == val);
                      selectedCategory = catName.categoryName ?? "";
                    });
                  }
                },
              ),
            ),
          );
        } else if (categoryState is CategoryError) {
          return Center(
            child: Text(
              categoryState.message,
              style: const TextStyle(color: Colors.white),
            ),
          );
        }
        return const Center(
          child: Text(
            "No Categories Available",
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _buildPaymentModeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Mode',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        Row(
          children: [
            Radio<String>(
              value: "Online",
              groupValue: paymentMode,
              activeColor: Colors.orangeAccent,
              onChanged: (val) {
                if (val != null) {
                  setState(() => paymentMode = val);
                }
              },
            ),
            const Text('Online', style: TextStyle(color: Colors.white)),
            Radio<String>(
              value: "Cash",
              groupValue: paymentMode,
              activeColor: Colors.orangeAccent,
              onChanged: (val) {
                if (val != null) {
                  setState(() => paymentMode = val);
                }
              },
            ),
            const Text('Cash', style: TextStyle(color: Colors.white)),
          ],
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return BlocBuilder<GetExpenseDetailCubit, GetExpenseDetailsState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: 50,
          child: CustomAppButton1(
            text: widget.expenseId.isEmpty ? 'Add Expense' : 'Update Expense',
            isLoading: state is SaveExpenseDetailLoading,
            onPlusTap: () {
              if (!_validateForm()) {
                CustomSnackBar.show(context, 'Please fill all required fields');
                return;
              }
              final Map<String, dynamic> data = {
                'expense': amountController.text,
                'category': selectedCategoryId,
                'date': dateController.text,
                'remarks': remarksController.text,
                'payment_mode': paymentMode,
                'trip': widget.id,
              };
              if (widget.expenseId.isNotEmpty) {
                context.read<GetExpenseDetailCubit>().updateExpenseDetails(
                  data,
                  widget.expenseId,
                );
              } else {
                context.read<GetExpenseDetailCubit>().addExpense(data);
              }
            },
          ),
        );
      },
    );
  }

  bool _validateForm() {
    return selectedCategoryId != null &&
        amountController.text.isNotEmpty &&
        dateController.text.isNotEmpty &&
        double.tryParse(amountController.text) != null;
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    TextInputType inputType = TextInputType.text,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70),
        prefixIcon: icon != null ? Icon(icon, color: Colors.white70) : null,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade600),
          borderRadius: BorderRadius.circular(30),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.orangeAccent),
          borderRadius: BorderRadius.circular(30),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    dateController.dispose();
    remarksController.dispose();
    super.dispose();
  }
}
