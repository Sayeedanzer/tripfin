import 'dart:io';
import 'package:flutter_touch_ripple/flutter_touch_ripple.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tripfin/Block/Logic/GetTrip/GetTripCubit.dart';
import 'package:tripfin/Block/Logic/GetTrip/GetTripState.dart';
import 'package:tripfin/Block/Logic/Home/HomeState.dart';
import 'package:tripfin/Block/Logic/PostTrip/potTrip_state.dart';
import 'package:tripfin/Screens/Components/CustomSnackBar.dart';
import 'package:tripfin/Screens/Components/FilteringDate.dart';
import 'package:tripfin/Services/AuthService.dart';

import '../../Block/Logic/Home/HomeCubit.dart';
import '../../Block/Logic/Internet/internet_status_bloc.dart';
import '../../Block/Logic/Internet/internet_status_state.dart';
import '../../Block/Logic/PostTrip/postTrip_cubit.dart';
import '../../utils/Color_Constants.dart';
import '../../utils/spinkittsLoader.dart';
import '../Components/CustomAppButton.dart';
import '../Components/ShakeWidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool? isGuestUser;
  @override
  void initState() {
    super.initState();
    _checkGuestStatus();
    context.read<HomeCubit>().fetchHomeData();
  }

  Future<void> _checkGuestStatus() async {
    final isGuest = await AuthService.isGuest;
    if (mounted) {
      setState(() {
        isGuestUser = isGuest;
      });
    }
  }

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
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      dateController.text = formattedDate;
    }
  }

  Future<void> _onRefresh() async {
    await context.read<HomeCubit>().fetchHomeData();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    if (isGuestUser == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return BlocListener<InternetStatusBloc, InternetStatusState>(
          listener: (context, state) {
            if (state is InternetStatusLostState) {
              context.push('/no_internet');
            } else {
              context.pop();
            }
          },
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is HomeLoaded) {
                return Scaffold(
                  backgroundColor: const Color(0xFF0F292F),
                  appBar: AppBar(
                    backgroundColor: const Color(0xFF0F292F),
                    automaticallyImplyLeading: false,
                    title: Row(
                      children: [
                        InkWell(
                          onTap:
                              isGuestUser??false
                                  ? () {
                                    // Redirect to login for guest users
                                    context.push('/login_mobile');
                                  }
                                  : () {
                                    context.push('/profile_screen');
                                  },
                          borderRadius: BorderRadius.circular(width * 0.05),
                          child: ClipOval(
                            child:
                            isGuestUser??false
                                    ? CircleAvatar(
                                      radius: width * 0.05,
                                      backgroundImage: const AssetImage(
                                        'assets/profile.png',
                                      ),
                                    )
                                    : CachedNetworkImage(
                                      imageUrl:
                                          state.profileModel?.data?.image ?? '',
                                      width: width * 0.1,
                                      height: width * 0.1,
                                      fit: BoxFit.cover,
                                      imageBuilder:
                                          (context, imageProvider) =>
                                              CircleAvatar(
                                                radius: width * 0.05,
                                                backgroundImage: imageProvider,
                                              ),
                                      placeholder:
                                          (context, url) => CircleAvatar(
                                            radius: width * 0.05,
                                            child: Center(
                                              child:
                                                  spinkits
                                                      .getSpinningLinespinkit(),
                                            ),
                                          ),
                                      errorWidget:
                                          (context, url, error) => CircleAvatar(
                                            radius: width * 0.05,
                                            backgroundImage: const AssetImage(
                                              'assets/placeholder.png',
                                            ),
                                          ),
                                    ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            isGuestUser??false
                                ? "Hey Guest"
                                : "Hey ${state.profileModel?.data?.fullName ?? 'Unknown'}",
                            style: const TextStyle(
                              color: Color(0xFFFEFEFE),
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Mullish',
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  body: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.05,
                      vertical: height * 0.02,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            "assets/figmaimages.png",
                            width: double.infinity,
                            height: height * 0.25,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: height * 0.03),
                        if (!(isGuestUser??false)&&
                            (state.getTripModel?.data == null ||
                                state.getTripModel?.settings?.message ==
                                    "No active and ongoing trips found.")) ...[
                          Text(
                            "Travel Details",
                            style: const TextStyle(
                              color: Color(0xffFFFFFF),
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Mullish',
                            ),
                          ),
                          SizedBox(height: height * 0.02),
                          _buildTextField(
                            image: 'assets/NavigationArrow.png',
                            controller: destinationController,
                            hint: 'Enter destination',
                            errorText: destinationError,
                          ),
                          SizedBox(height: height * 0.015),
                          _buildTextField(
                            controller: dateController,
                            hint: 'Start date',
                            image: 'assets/CalendarDots.png',
                            readOnly: true,
                            onTap: () => _selectDate(context),
                            errorText: dateError,
                          ),
                          SizedBox(height: height * 0.015),
                          _buildTextField(
                            image: 'assets/CurrencyInr.png',
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: false,
                              signed: false,
                            ),
                            controller: budgetController,
                            hint: 'Enter spend amount',
                            errorText: budgetError,
                          ),
                          SizedBox(height: height * 0.025),
                          BlocConsumer<postTripCubit, postTripState>(
                            listener: (context, state) {
                              if (state is PostTripSuccessState) {
                                destinationController.clear();
                                dateController.clear();
                                budgetController.clear();
                                context.read<HomeCubit>().fetchHomeData();
                              }
                            },
                            builder: (context, state) {
                              return CustomAppButton1(
                                isLoading: state is PostTripLoading,
                                text: "Start Your Trip",
                                onPlusTap: () {
                                  if (_validateInputs()) {
                                    final Map<String, dynamic> data = {
                                      'destination': destinationController.text,
                                      'start_date': dateController.text,
                                      'budget': budgetController.text,
                                    };
                                    if (_selectedImage != null) {
                                      data['image'] = _selectedImage;
                                    }
                                    context.read<postTripCubit>().postTrip(
                                      data,
                                    );
                                  } else {
                                    CustomSnackBar.show(
                                      context,
                                      'Please fix the errors in the form',
                                    );
                                  }
                                },
                              );
                            },
                          ),
                          SizedBox(height: height * 0.035),
                        ] else if (isGuestUser??false) ...[
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(width * 0.04),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2C4748),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  "Please log in to create a trip",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Mullish',
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    context.push('/login_mobile');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFDDA25F),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    "Log In",
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontFamily: 'Mullish',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: height * 0.035),
                        ],
                        Text(
                          "Current Tour",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Mullish',
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        if (state.getTripModel?.data == null ||
                            state.getTripModel?.settings?.message ==
                                "No active and ongoing trips found.")
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(width * 0.04),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2C4748),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Text(
                              "No current tour found",
                              style: TextStyle(
                                fontFamily: 'Mullish',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          )
                        else
                          Dismissible(
                            key: Key(state.getTripModel?.data?.id ?? ''),
                            background: Container(
                              color: Colors.blue,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 20),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            secondaryBackground: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            confirmDismiss: (direction) async {
                              if ( isGuestUser??false) {
                                CustomSnackBar.show(
                                  context,
                                  'Please log in to edit or delete trips',
                                );
                                return false;
                              }
                              final tripId = state.getTripModel?.data?.id ?? '';
                              if (direction == DismissDirection.startToEnd) {
                                context.push(
                                  '/UpdateCurrentTrip?tripId=$tripId',
                                );
                                return false;
                              } else if (direction ==
                                  DismissDirection.endToStart) {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        title: const Text('Delete Trip'),
                                        content: const Text(
                                          'Are you sure you want to delete this trip?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => context.pop(false),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () => context.pop(true),
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      ),
                                );

                                if (confirm == true) {
                                  try {
                                    await context
                                        .read<postTripCubit>()
                                        .deleteTrip(tripId);
                                    await context
                                        .read<HomeCubit>()
                                        .fetchHomeData();
                                    return true;
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Failed to delete trip: $e',
                                        ),
                                      ),
                                    );
                                    return false;
                                  }
                                }
                                return false;
                              }
                              return false;
                            },
                            child: TouchRipple(
                              onTap: () {
                                final trip = state.getTripModel?.data;
                                final budget =
                                    trip?.budget?.toString() ?? "0.00";
                                if (state.getTripModel?.totalExpense > 0) {
                                  context.push('/vacation?budget=$budget');
                                } else {
                                  context.push(
                                    '/update_expensive?id=${trip?.id ?? ''}&place=${trip?.destination ?? ''}&budget=$budget&date=${trip?.startDate ?? ""}',
                                  );
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF304546),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: Image.asset(
                                        "assets/figmaimages.png",
                                        width: width * 0.18,
                                        height: width * 0.18,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(width: width * 0.035),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            capitalize(
                                              state
                                                      .getTripModel
                                                      ?.data
                                                      ?.destination ??
                                                  "Unknown",
                                            ),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Mullish',
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            state
                                                    .getTripModel
                                                    ?.data
                                                    ?.startDate ??
                                                "N/A",
                                            style: const TextStyle(
                                              color: Color(0xffDADADA),
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Mullish',
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 6),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                const TextSpan(
                                                  text: "Budget: ",
                                                  style: TextStyle(
                                                    color: Color(0xffB8B8B8),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'Mullish',
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      '₹ ${state.getTripModel?.data?.budget?.toString() ?? "0.00"}',
                                                  style: const TextStyle(
                                                    color: Color(0xff00AB03),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'Mullish',
                                                  ),
                                                ),
                                              ],
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed:
                                      isGuestUser??false
                                              ? () {
                                                CustomSnackBar.show(
                                                  context,
                                                  'Please log in to add expenses',
                                                );
                                              }
                                              : () {
                                                final trip =
                                                    state.getTripModel?.data;
                                                context.push(
                                                  '/update_expensive?id=${trip?.id ?? ''}&place=${trip?.destination ?? ''}&budget=${trip?.budget ?? ''}&date=${trip?.startDate ?? ""}',
                                                );
                                              },
                                      icon: const Icon(
                                        Icons.add,
                                        color: Colors.black87,
                                        size: 16,
                                      ),
                                      label: Text(
                                        "Spend",
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: width * 0.04,
                                          fontFamily: 'Mullish',
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        visualDensity: VisualDensity.compact,
                                        backgroundColor: const Color(
                                          0xFFDDA25F,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        SizedBox(height: height * 0.03),
                        const Text(
                          "Previous Tours",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Mullish',
                          ),
                        ),
                        SizedBox(height: 12),
                        Column(
                          children: [
                            if (state
                                    .getPrevousTripModel
                                    ?.previousTrips
                                    ?.isEmpty ??
                                true)
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(width * 0.04),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2C4748),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Text(
                                  "No Previous tour found.",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                    fontFamily: 'Mullish',
                                  ),
                                ),
                              )
                            else
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  itemCount:
                                      state
                                          .getPrevousTripModel
                                          ?.previousTrips
                                          ?.length ??
                                      0,
                                  itemBuilder: (context, index) {
                                    final trip =
                                        state
                                            .getPrevousTripModel
                                            ?.previousTrips![index];
                                    return TouchRipple(
                                      onTap: () {
                                        if (trip != null) {
                                          context.push(
                                            '/vacation?budget=${trip.budget.toString() ?? "0.00"}&tripId=${trip.tripId ?? ""}',
                                          );
                                        }
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 16,
                                        ),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF304546),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              child: Image.asset(
                                                "assets/figmaimages.png",
                                                width: width * 0.18,
                                                height: width * 0.18,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            SizedBox(width: width * 0.035),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    capitalize(
                                                      trip?.destination ?? "",
                                                    ),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: 'Mullish',
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Text(
                                                    trip?.startDate ?? "",
                                                    style: const TextStyle(
                                                      color: Color(
                                                        0xffDADADA,
                                                      ),
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: 'Mullish',
                                                    ),
                                                  ),
                                                  const SizedBox(height: 6),
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        const TextSpan(
                                                          text: "Budget: ",
                                                          style: TextStyle(
                                                            color: Color(
                                                              0xffB8B8B8,
                                                            ),
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600,
                                                            fontFamily:
                                                                'Mullish',
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text:
                                                              '₹ ${trip?.budget.toString() ?? ""}',
                                                          style:
                                                              const TextStyle(
                                                                color: Color(
                                                                  0xff00AB03,
                                                                ),
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontFamily:
                                                                    'Mullish',
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: width * 0.02),
                                            SizedBox(
                                              width: width * 0.25,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    textAlign:
                                                        TextAlign.center,
                                                    '₹ ${trip?.totalExpense.toString() ?? ""}',
                                                    style: const TextStyle(
                                                      color: Color(
                                                        0xffb0b0b0,
                                                      ),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: 'Mullish',
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                  const Text(
                                                    "Spends",
                                                    style: TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: 14,
                                                      fontFamily: 'Mullish',
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state is HomeError) {
                return Center(
                  child: Text(
                    state.message,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: width * 0.05,
                      fontFamily: 'Mullish',
                    ),
                  ),
                );
              }
              return Center(
                child: Text(
                  "No Data",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: width * 0.05,
                    fontFamily: 'Mullish',
                  ),
                ),
              );
            },
          ),
        );

  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    String? image,
    bool readOnly = false,
    VoidCallback? onTap,
    String? errorText,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: const TextStyle(color: Colors.white, fontFamily: 'Mullish'),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 20,
            ),
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF676767)),
            // Only one of suffixIcon or icon should be used
            suffixIcon:
                image != null
                    ? Padding(
                      padding: const EdgeInsets.all(
                        12.0,
                      ), // Add padding for better appearance
                      child: Image.asset(
                        image,
                        color: Color(0xFFD6D6D6),
                        height: 24,
                        width: 24,
                        fit: BoxFit.cover,
                      ),
                    )
                    : (icon != null ? Icon(icon, color: Colors.white70) : null),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
              borderSide: const BorderSide(
                color: Color(0xFF575757),
                width: 0.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
              borderSide: const BorderSide(
                color: Color(0xFF575757),
                width: 0.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
              borderSide: const BorderSide(color: Colors.white, width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
              borderSide: const BorderSide(color: Colors.redAccent, width: 0.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 12.0),
            child: Text(
              errorText,
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 12.0,
                fontFamily: 'Mullish', // Fixed typo in fontFamily
              ),
            ),
          ),
      ],
    );
  }
}
