import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:tripfin/Block/Logic/ExpenseDetails/ExpenseDetailsCubit.dart';
import 'package:tripfin/Block/Logic/PostTrip/postTrip_cubit.dart';
import 'package:tripfin/Block/Logic/PostTrip/potTrip_state.dart';
import 'package:tripfin/Block/Logic/TripFinish/TripFinishCubit.dart';
import 'package:tripfin/Block/Logic/TripFinish/TripFinishState.dart';
import 'package:tripfin/Screens/Components/CustomSnackBar.dart';
import '../../Block/Logic/Home/HomeCubit.dart';
import '../../Block/Logic/Internet/internet_status_bloc.dart';
import '../../Block/Logic/Internet/internet_status_state.dart';
import '../../Block/Logic/PiechartdataScreen/PiechartCubit.dart';
import '../../Block/Logic/PiechartdataScreen/PiechartState.dart';
import '../../utils/Color_Constants.dart';
import '../Components/CutomAppBar.dart';
import '../Components/FilteringDate.dart';

class VacationHistory extends StatefulWidget {
  final String tripId;
  final String budget;
  final String tripDate;

  const VacationHistory({
    super.key,
    required this.tripId,
    required this.budget,
    required this.tripDate,
  });

  @override
  State<VacationHistory> createState() => _VacationHistoryState();
}

class _VacationHistoryState extends State<VacationHistory> {
  @override
  void initState() {
    super.initState();
    context.read<PiechartCubit>().fetchPieChartData(widget.tripId);
  }

  String? tripId;
  String? finishTripText;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    return Theme(
      data: ThemeData(
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontFamily: 'Mullish',
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          titleLarge: TextStyle(
            fontFamily: 'Mullish',
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          titleMedium: TextStyle(
            fontFamily: 'Mullish',
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Mullish',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          bodySmall: TextStyle(
            fontFamily: 'Mullish',
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          labelLarge: TextStyle(
            fontFamily: 'Mullish',
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'Mullish',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        snackBarTheme: const SnackBarThemeData(
          contentTextStyle: TextStyle(
            fontFamily: 'Mullish',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      child: BlocListener<InternetStatusBloc, InternetStatusState>(
        listener: (context, state) {
          if (state is InternetStatusLostState) {
            context.push('/no_internet');
          } else {
            context.pop();
          }
        },
        child: BlocBuilder<PiechartCubit, PiechartState>(
          builder: (context, state) {
            if (state is PiechartLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PiechartSuccess) {
              tripId = state.response.data?.tripId ?? '';
              finishTripText = state.message ?? "";
              final expenses = state.response.data?.expenseData ?? [];
              final totalExpense =
                  state.response.data?.totalExpense?.toDouble() ?? 0.0;
              final categoryTotals = <String, double>{};
              final categoryColorMap = <String, Color>{};
              final categoryGradientMap = <String, List<Color>>{};

              // Aggregate expenses by category and map colors from colorCode
              for (var expense in expenses) {
                final category = expense.categoryName ?? 'Miscellaneous';
                categoryTotals[category] =
                    (categoryTotals[category] ?? 0.0) +
                    (expense.totalExpense?.toDouble() ?? 0.0);

                // Parse colorCode (assuming it's a hex string like '#FF0000' or 'FF0000')
                try {
                  if (expense.colorCode != null &&
                      expense.colorCode!.isNotEmpty) {
                    final hexColor = expense.colorCode!.replaceAll('#', '');
                    final color = Color(int.parse('FF$hexColor', radix: 16));
                    categoryColorMap[category] = color;
                    categoryGradientMap[category] = [
                      color,
                      color.withOpacity(0.7),
                    ];
                  } else {
                    categoryColorMap[category] = Colors.grey;
                    categoryGradientMap[category] = [
                      Colors.grey,
                      Colors.grey.withOpacity(0.7),
                    ];
                  }
                } catch (e) {
                  categoryColorMap[category] = Colors.grey;
                  categoryGradientMap[category] = [
                    Colors.grey,
                    Colors.grey.withOpacity(0.7),
                  ];
                }
              }
              return Scaffold(
                backgroundColor: const Color(0xFF1C3132),
                appBar: CustomAppBar(
                  title:
                      "${capitalize(state.response.data?.destination ?? "")} Trip",
                  actions:
                      widget.tripId.isNotEmpty
                          ? []
                          : [
                            BlocListener<TripFinishCubit, TripFinishState>(
                              listener: (context, state) {
                                if (state is FinishTripSuccessState) {
                                  context.read<HomeCubit>().fetchHomeData();
                                  final budgetStr =
                                      state.finishTripModel.data?.budget;
                                  final totalExpenseStr =
                                      state.finishTripModel.data?.totalExpense;
                                  if (budgetStr != null &&
                                      totalExpenseStr != null) {
                                    final budget = double.tryParse(budgetStr);
                                    final totalExpense = double.tryParse(
                                      totalExpenseStr,
                                    );

                                    if (budget != null &&
                                        totalExpense != null) {
                                      if (budget == totalExpense) {
                                        context.pushReplacement(
                                          "/perfect_budget?message=${state.finishTripModel.settings?.message ?? ''}",
                                        );
                                      } else if (budget < totalExpense) {
                                        context.pushReplacement(
                                          "/out_of_theBudget?message=${state.finishTripModel.settings?.message ?? ''}",
                                        );
                                      } else if (budget > totalExpense) {
                                        context.pushReplacement(
                                          "/below_of_theBudget?message=${state.finishTripModel.settings?.message ?? ''}",
                                        );
                                      }
                                    }
                                  }
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: OutlinedButton(
                                  style: ButtonStyle(
                                    padding: WidgetStateProperty.all(
                                      EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                    ),
                                    visualDensity: VisualDensity.compact,
                                    shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          32,
                                        ), // Optional
                                      ),
                                    ),
                                    side: WidgetStateProperty.all(
                                      BorderSide(
                                        color: Color(
                                          0xFFFFA726,
                                        ), // Border color
                                        width: 1, // Border width (optional)
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder:
                                          (context) => AlertDialog(
                                            title: Text("Finish Trip"),
                                            content: const Text(
                                              "Are you sure you want to end this trip?",
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  context.pop();
                                                },
                                                child: const Text("Cancel"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  final Map<String, dynamic>
                                                  data = {
                                                    "is_completed": "true",
                                                  };
                                                  context
                                                      .read<TripFinishCubit>()
                                                      .finishTrip(data);
                                                },
                                                child: const Text(
                                                  "Confirm",
                                                  style: TextStyle(
                                                    color: Colors.redAccent,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                    );
                                  },
                                  child: Text(
                                    "Finish Trip",
                                    style: TextStyle(
                                      color: Color(0xFFDDA25F),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Lexend',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                ),
                body: ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFF304546),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Travel Plan",
                                style: TextStyle(
                                  color: Color(0xffFBFBFB),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Mullish',
                                ),
                              ),
                              Spacer(),
                              if (widget.tripId.isEmpty) ...[
                                IconButton(
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () {
                                    context.push(
                                      '/UpdateCurrentTrip?tripId=${state.response.data?.tripId ?? ""}',
                                    );
                                  },
                                  icon: Icon(Icons.edit, color: Colors.white70),
                                ),
                                SizedBox(width: 8),
                                BlocListener<postTripCubit, postTripState>(
                                  listener: (context, state) {
                                    if (state is PostTripSuccessState) {
                                      context.read<HomeCubit>().fetchHomeData();
                                      context.go('/home');
                                    }
                                  },
                                  child: IconButton(
                                    visualDensity: VisualDensity.compact,
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder:
                                            (context) => AlertDialog(
                                              title: const Text("Delete Trip"),
                                              content: const Text(
                                                "Are you sure you want to delete this trip?",
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    context.pop();
                                                  },
                                                  child: const Text("Cancel"),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    context
                                                        .read<postTripCubit>()
                                                        .deleteTrip(
                                                          state
                                                                  .response
                                                                  .data
                                                                  ?.tripId ??
                                                              "",
                                                        );
                                                  },
                                                  child: const Text(
                                                    "Confirm",
                                                    style: TextStyle(
                                                      color: Colors.redAccent,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                      );
                                    },
                                    icon: Icon(Icons.delete, color: Colors.red),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.white70,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                "Place : ",
                                style: TextStyle(
                                  color: Color(0xffDADADA),
                                  fontFamily: 'Mullish',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                capitalize(
                                  state.response.data?.destination ?? "",
                                ),
                                style: TextStyle(
                                  color: Color(0xffDADADA),
                                  fontFamily: 'Mullish',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.currency_rupee,
                                color: Colors.white70,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                "Budget : ",
                                style: TextStyle(
                                  color: Color(0xffDADADA),
                                  fontFamily: 'Mullish',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                widget.budget,
                                style: const TextStyle(
                                  color: Color(0xff55EE4A),
                                  fontFamily: 'Mullish',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: PieChart(
                        dataMap:
                            categoryTotals.isNotEmpty
                                ? categoryTotals
                                : {'No Expenses': 1.0},
                        colorList:
                            categoryTotals.isNotEmpty
                                ? categoryTotals.keys
                                    .map(
                                      (key) =>
                                          categoryColorMap[key] ?? Colors.grey,
                                    )
                                    .toList()
                                : [Colors.grey],
                        gradientList:
                            categoryTotals.isNotEmpty
                                ? categoryTotals.keys
                                    .map(
                                      (key) =>
                                          categoryGradientMap[key] ??
                                          [Colors.grey, Colors.grey],
                                    )
                                    .toList()
                                : [
                                  [Colors.grey, Colors.grey],
                                ],
                        animationDuration: Duration(milliseconds: 1200),
                        chartLegendSpacing: 28,
                        chartRadius: MediaQuery.of(context).size.width / 1.8,
                        initialAngleInDegree: 270,
                        chartType: ChartType.ring,
                        ringStrokeWidth: 20,
                        centerWidget: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Expenses",
                              style: TextStyle(
                                color: Color(0xffFFFFFF),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Mullish',
                              ),
                            ),
                            SizedBox(
                              width: width * 0.45,
                              child: Text(
                                textAlign: TextAlign.center,
                                "₹" + totalExpense.toStringAsFixed(0),
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: Colors.white,
                                  fontSize: 36,
                                ),
                              ),
                            ),
                          ],
                        ),
                        legendOptions: const LegendOptions(showLegends: false),
                        chartValuesOptions: const ChartValuesOptions(
                          showChartValues: false,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Travel Expenses",
                          style: TextStyle(
                            color: Color(0xffFBFBFB),
                            fontSize: 20,
                            fontFamily: 'Mullish',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (widget.tripId.isEmpty) ...[
                          FilledButton(
                            style: ButtonStyle(
                              visualDensity: VisualDensity.compact,
                              backgroundColor: MaterialStateProperty.all(
                                buttonBgColor,
                              ),
                            ),
                            onPressed: () {
                              context.pushReplacement(
                                '/update_expensive?id=${state.response.data?.tripId ?? ''}&budget=${widget.budget}&place=${state.response.data?.destination ?? ""}&date=${widget.tripDate??""}',
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                 Text(
                                  'Add',
                                  style: TextStyle(
                                    color: Color(0xff1C3132),
                                    fontSize: 14,
                                    fontFamily: 'Lexend',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Icon(
                                  Icons.add,
                                  color: const Color(0xff1C3132),
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    ..._buildExpenseList(expenses),
                  ],
                ),
              );
            } else if (state is PiechartError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.redAccent,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message ?? 'An error occurred while loading data',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFA726),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        context.read<PiechartCubit>().fetchPieChartData(
                          widget.tripId,
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            return const Center(
              child: Text(
                "No Data Available",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildExpenseList(List<dynamic> expenses) {
    final List<Widget> expenseWidgets = [];
    final dateFormat = DateFormat('dd.MM.yyyy');

    Color hexToColor(String hexColor) {
      try {
        hexColor = hexColor.replaceAll('#', '');
        if (hexColor.length == 6) {
          hexColor = 'FF$hexColor';
        }
        return Color(int.parse(hexColor, radix: 16));
      } catch (e) {
        return const Color(0xFF1C3132); // Fallback color
      }
    }

    final Map<String, List<dynamic>> groupedExpenses = {};
    for (var expense in expenses) {
      print('Expense object: $expense'); // Debug print
      final date =
          expense.date != null
              ? dateFormat.format(DateTime.parse(expense.date))
              : dateFormat.format(DateTime.now());
      if (!groupedExpenses.containsKey(date)) {
        groupedExpenses[date] = [];
      }
      groupedExpenses[date]!.add(expense);
    }
    final sortedDates =
        groupedExpenses.keys.toList()..sort((a, b) => b.compareTo(a));

    for (var date in sortedDates) {
      expenseWidgets.add(
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.only(bottom: 15),
              width: 120,
              height: 65,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/date patch.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Center(
                child: Transform.rotate(
                  angle: -0.1208, // 6.92 degrees in radians
                  child: Text(
                    date,
                    style: TextStyle(
                      color: Color(0xff1C3132),
                      fontSize: 14,
                      fontFamily: 'Comic',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
      final dateExpenses = groupedExpenses[date]!;
      for (var expense in dateExpenses) {
        final w = MediaQuery.of(context).size.width;
        final category = expense.categoryName ?? 'Miscellaneous';
        final colorCode = expense.colorCode ?? '';
        final expenseId = expense.expenseId ?? '';
        final amount = expense.totalExpense?.toDouble() ?? 0.0;
        final remarks = expense.remarks;
        final paymentMode = expense.paymentMode ?? "";
        print('Remarks for $category: $remarks'); // Debug print
        expenseWidgets.add(
          widget.tripId.isNotEmpty
              ? Container(
                margin: const EdgeInsets.only(bottom: 4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Color(0xff304546),
                  border: Border(
                    left: BorderSide(
                      color:
                          colorCode.isNotEmpty
                              ? hexToColor(colorCode)
                              : Color(0xFF1C3132),
                      width: 12,
                    ),
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: w * 0.65,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Mullish',
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            remarks != null &&
                                    remarks.isNotEmpty &&
                                    remarks != 'ntg'
                                ? remarks
                                : 'No description',
                            style: const TextStyle(
                              color: Color(0xffDBDBDB),
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Mullish',
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "- ₹ ${amount.toStringAsFixed(0)}",
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
              )
              : Dismissible(
                key: ValueKey(
                  expenseId.isNotEmpty ? expenseId : 'fallback_${UniqueKey()}',
                ),
                background: Container(
                  color: Colors.blue,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20),
                  child: const Row(
                    children: [
                      Icon(Icons.edit, color: Colors.white, size: 30),
                      SizedBox(width: 10),
                      Text(
                        'Edit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                secondaryBackground: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Delete',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.delete, color: Colors.white, size: 30),
                    ],
                  ),
                ),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    HapticFeedback.mediumImpact();
                    return await showDialog<bool>(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: const Text(
                              'Are you sure you want to delete this expense?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => context.pop(false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  try {
                                    await context
                                        .read<GetExpenseDetailCubit>()
                                        .deleteExpenseDetails(expenseId);
                                    CustomSnackBar.show(
                                      context,
                                      'Expense deleted successfully',
                                    );
                                    context
                                        .read<PiechartCubit>()
                                        .fetchPieChartData(widget.tripId);
                                    context.pop();
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Failed to delete expense: $e',
                                        ),
                                        backgroundColor: Colors.red,
                                        duration: const Duration(seconds: 3),
                                      ),
                                    );
                                    context.pop(false);
                                  }
                                },
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                    );
                  } else if (direction == DismissDirection.startToEnd) {
                    HapticFeedback.lightImpact();
                    context.push(
                      '/update_expensive?id=${tripId}&expenseId=$expenseId&date=${widget.tripDate??""}',
                    );
                    return false;
                  }
                  return false;
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xff304546),
                    border: Border(
                      left: BorderSide(
                        color:
                            colorCode.isNotEmpty
                                ? hexToColor(colorCode)
                                : const Color(0xFF1C3132),
                        width: 12,
                      ),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: w * 0.65,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Mullish',
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              remarks != null &&
                                      remarks.isNotEmpty &&
                                      remarks != 'ntg'
                                  ? remarks
                                  : 'No description',
                              style: const TextStyle(
                                color: Color(0xffDBDBDB),
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                fontFamily: 'Mullish',
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                          ],
                        ),
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          Text(
                            "-${amount.toStringAsFixed(0)}",
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(textAlign: TextAlign.end,
                            "${paymentMode}",
                            style:  TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
        );
      }
    }
    return expenseWidgets;
  }

  Color hexToColor(String hexColor) {
    try {
      hexColor = hexColor.replaceAll('#', '');
      if (hexColor.length == 6) {
        hexColor = 'FF$hexColor';
      }
      return Color(int.parse(hexColor, radix: 16));
    } catch (e) {
      return const Color(0xFF1C3132); // Fallback color
    }
  }
}
