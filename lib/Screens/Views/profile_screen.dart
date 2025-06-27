import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_touch_ripple/flutter_touch_ripple.dart';
import 'package:go_router/go_router.dart';
import 'package:tripfin/Block/Logic/CombinedProfile/CombinedProfileCubit.dart';
import 'package:tripfin/Block/Logic/CombinedProfile/CombinedProfileState.dart';
import 'package:tripfin/Screens/Components/CustomAppButton.dart';
import 'package:tripfin/Screens/Components/CutomAppBar.dart';
import 'package:tripfin/utils/Color_Constants.dart';

import '../../Block/Logic/delete_account/DeleteAccountCubit.dart';
import '../../Block/Logic/delete_account/DeleteAccountStates.dart';
import '../../utils/Preferances.dart';
import '../../utils/spinkittsLoader.dart';
import '../Components/CustomSnackBar.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CombinedProfileCubit>().fetchCombinedProfile();
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Scaffold(
      backgroundColor: primary,
      appBar: CustomAppBar(title: 'Profile', actions: []),
      body: BlocBuilder<CombinedProfileCubit, CombinedProfileState>(
        builder: (context, state) {
          {
            if (state is CombinedProfileLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is CombinedProfileLoaded) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: state.profileModel.data?.image ?? '',
                            width: width * 0.15,
                            height: width * 0.15,
                            fit: BoxFit.cover,
                            imageBuilder:
                                (context, imageProvider) => CircleAvatar(
                                  radius: width * 0.05,
                                  backgroundImage: imageProvider,
                                ),
                            placeholder:
                                (context, url) => CircleAvatar(
                                  radius: width * 0.05,
                                  child: Center(
                                    child:
                                        spinkits
                                            .getSpinningLinespinkit(), // Ensure spinner fits
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
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 4),
                                        Text(
                                          state.profileModel.data?.fullName ??
                                              "",
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontFamily: "Mullish",
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 6),
                                        Text(
                                          state.profileModel.data?.mobile ?? "",
                                          style: TextStyle(
                                            color: Color(0xffFEFEFE),
                                            fontFamily: "Mullish",
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    visualDensity: VisualDensity.compact,
                                    onPressed: () {
                                      context.push('/edit_profile_screen');
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  TouchRipple(
                                    onTap: () {
                                      context.push('/edit_profile_screen');
                                    },
                                    child: Text(
                                      'Edit',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Mullish",
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '',
                                    style: TextStyle(
                                      fontFamily: "Mullish",
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 40),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xff304546),
                        border: Border.all(color: Color(0xff898989), width: 1),
                      ),
                      child: Row(
                        children: [
                          Image.asset('assets/tripTree.png', scale: 3),
                          SizedBox(width: 10),
                          Text(
                            'Your Trips',
                            style: TextStyle(
                              color: Color(0xffB9B9B9),
                              fontFamily: 'Mullish',
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                          Spacer(),
                          Text(
                            state.tripSummaryModel.data.totalPreviousTrips
                                    .toString() ??
                                "",
                            style: TextStyle(
                              color: Color(0xffFEFEFE),
                              fontFamily: 'Mullish',
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xff304546),
                        border: Border.all(color: Color(0xff898989), width: 1),
                      ),
                      child: Row(
                        children: [
                          Image.asset('assets/Money.png', scale: 3),
                          SizedBox(width: 10),
                          Text(
                            'Total Spends',
                            style: TextStyle(
                              color: Color(0xffB9B9B9),
                              fontFamily: 'Mullish',
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                          Spacer(),
                          Text(
                            state.tripSummaryModel.data.totalExpenses
                                    .toString() ??
                                "",
                            style: TextStyle(
                              color: Color(0xffFEFEFE),
                              fontFamily: 'Mullish',
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is CombinedProfileError) {
              return Center(child: Text(state.message));
            }
            return Center(child: Text("No Data"));
          }
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomAppButton1(
                height: 50,
                text: 'Log Out',
                onPlusTap: () {
                  _showLogoutConfirmationDialog(context);
                },
              ),
              SizedBox(height: 15,),
              CustomAppButton1(
                height: 50,
                text: 'Delete Account',
                onPlusTap: () {
                  DeleteAccountConfirmation
                      .showDeleteConfirmationSheet(context);
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}

void _showLogoutConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        elevation: 4.0,
        insetPadding: EdgeInsets.symmetric(horizontal: 14.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: SizedBox(
          width: 300.0,
          height: 200.0,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: -35.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  width: 70.0,
                  height: 70.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(width: 6.0, color: Colors.white),
                    shape: BoxShape.circle,
                    color:  Color(0xff304546),
                  ),
                  child: Icon(
                    Icons.power_settings_new,
                    size: 40.0,
                    color: Colors.red,
                  ),
                ),
              ),
              Positioned.fill(
                top: 30.0,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 15.0),
                      Text(
                        "Logout",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFamily: 'Mullish',
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        "Are you sure you want to logout?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontFamily: 'Mullish',
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 100,
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: primary,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                              ),
                              child: Text(
                                "No",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontFamily: 'Mullish',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: OutlinedButton(
                              onPressed: () async {
                                await PreferenceService().remove(
                                  "access_token",
                                );
                                context.go("/login_mobile");
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: BorderSide(color:  Colors.white),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                              ),
                              child: Text(
                                "Yes",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontFamily: 'Mullish',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class DeleteAccountConfirmation {
  static void showDeleteConfirmationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      elevation: 8,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return BlocConsumer<DeleteAccountCubit, DeleteAccountState>(
                listener: (context, state) {
                  if (state is DeleteAccountSuccessState) {
                    PreferenceService().clearPreferences();
                    context.pushReplacement('/login_mobile');
                  } else if (state is DeleteAccountError) {
                    CustomSnackBar.show(context, state.message ?? '');
                  }
                }, builder: (context, state) {
              final bool isLoading = state is DeleteAccountLoading;
              return Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // Description
                    Text(
                      'Are you sure you want to delete your account?',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        fontFamily: 'Mullish',),
                      textAlign: TextAlign.center,
                    ),
                    // Description
                    Text(
                      'All your data, including Travel history and preferences, will be permanently removed.',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                        fontFamily: 'Mullish',),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: isLoading
                                ? null
                                : () {
                              context.pop();
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey[400]!),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Mullish',
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isLoading ? null : () async {
                              context.read<DeleteAccountCubit>().deleteAccount();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                              backgroundColor: primary,
                              foregroundColor: primary,
                            ),
                            child: isLoading
                                ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                                : const Text(
                              'Delete',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mullish',
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            });
          },
        );
      },
    );
  }
}
