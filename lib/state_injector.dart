import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripfin/Block/Logic/CategoryList/CategoryCubit.dart';
import 'package:tripfin/Block/Logic/CategoryList/CategoryRepository.dart';
import 'package:tripfin/Block/Logic/CombinedProfile/CombinedProfileCubit.dart';
import 'package:tripfin/Block/Logic/ForgotPassword/ForgotPassWordCubit.dart';
import 'package:tripfin/Block/Logic/ForgotPassword/ForgotPassWordRepository.dart';
import 'package:tripfin/Block/Logic/GetCurrency/GetCurrencyCubit.dart';
import 'package:tripfin/Block/Logic/GetCurrency/GetCurrencyRepository.dart';
import 'package:tripfin/Block/Logic/GetPreviousTripHistory/GetPreviousTripHistoryCubit.dart';
import 'package:tripfin/Block/Logic/GetPreviousTripHistory/GetPreviousTripHistoryRepository.dart';
import 'package:tripfin/Block/Logic/GetTrip/GetTripCubit.dart';
import 'package:tripfin/Block/Logic/GetTrip/GetTripRepository.dart';
import 'package:tripfin/Block/Logic/LogInBloc/login_cubit.dart';
import 'package:tripfin/Block/Logic/LogInBloc/login_repository.dart';
import 'package:tripfin/Block/Logic/PiechartdataScreen/PiechartRepository.dart';
import 'package:tripfin/Block/Logic/PostTrip/postTrip_cubit.dart';
import 'package:tripfin/Block/Logic/Profiledetails/Profile_repository.dart';
import 'package:tripfin/Block/Logic/TripFinish/TripFinishCubit.dart';
import 'package:tripfin/Block/Logic/TripFinish/TripFinishRepository.dart';
import 'package:tripfin/Block/Logic/UpdateProfile/UpdateProfileCubit.dart';
import 'package:tripfin/Block/Logic/UpdateProfile/UpdateProfileRepository.dart';
import 'package:tripfin/Block/Logic/delete_account/DeleteAccountRepository.dart';
import 'package:tripfin/Services/remote_data_source.dart';
import 'Block/Logic/ExpenseDetails/ExpenseDetailsCubit.dart';
import 'Block/Logic/ExpenseDetails/ExpenseDetailsRepository.dart';
import 'Block/Logic/Home/HomeCubit.dart';
import 'Block/Logic/Internet/internet_status_bloc.dart';
import 'Block/Logic/PiechartdataScreen/PiechartCubit.dart';
import 'Block/Logic/PostTrip/postTrip_repository.dart';
import 'Block/Logic/Profiledetails/Profile_cubit.dart';
import 'Block/Logic/RegisterBloc/Register_cubit.dart';
import 'Block/Logic/RegisterBloc/Register_repository.dart';
import 'Block/Logic/TripCount/TripcountCubit.dart';
import 'Block/Logic/TripCount/TripcountRepository.dart';
import 'Block/Logic/delete_account/DeleteAccountCubit.dart';

class StateInjector {
  static final repositoryProviders = <RepositoryProvider>[
    RepositoryProvider<RemoteDataSource>(
      create: (context) => RemoteDataSourceImpl(),
    ),
    RepositoryProvider<RegisterRepository>(
      create:
          (context) =>
              RegisterImpl(remoteDataSource: context.read<RemoteDataSource>()),
    ),

    RepositoryProvider<LoginRepository>(
      create:
          (context) =>
              LoginImpl(remoteDataSource: context.read<RemoteDataSource>()),
    ),
    RepositoryProvider<Piechartrepository>(
      create:
          (context) =>
              PiedataImpl(remoteDataSource: context.read<RemoteDataSource>()),
    ),
    RepositoryProvider<GetTripRep>(
      create:
          (context) =>
              GetTripImpl(remoteDataSource: context.read<RemoteDataSource>()),
    ),
    RepositoryProvider<CurrencyRepo>(
      create: (context) => CurrencyImpl(context.read<RemoteDataSource>()),
    ),
    RepositoryProvider<GetProfileRepo>(
      create:
          (context) => GetProfileImpl(
            remoteDataSource: context.read<RemoteDataSource>(),
          ),
    ),
    RepositoryProvider<PostTripRepository>(
      create:
          (context) =>
              PostTripImpl(remoteDataSource: context.read<RemoteDataSource>()),
    ),
    RepositoryProvider<Tripcountrepository>(
      create:
          (context) => GetTripcountImpl(
            remoteDataSource: context.read<RemoteDataSource>(),
          ),
    ),
    RepositoryProvider<GetPreviousTripRepo>(
      create:
          (context) => GetPreviousTripImpl(
            remoteDataSource: context.read<RemoteDataSource>(),
          ),
    ),
    RepositoryProvider<GetPreviousTripRepo>(
      create:
          (context) => GetPreviousTripImpl(
            remoteDataSource: context.read<RemoteDataSource>(),
          ),
    ),

    RepositoryProvider<Categoryrepository>(
      create:
          (context) => GetcategoryImpl(
            remoteDataSource: context.read<RemoteDataSource>(),
          ),
    ),

    RepositoryProvider<GetExpenseDetailRepo>(
      create:
          (context) => GetExpenseDetailImpl(
            remoteDataSource: context.read<RemoteDataSource>(),
          ),
    ),
    RepositoryProvider<UpdateProfileRepository>(
      create:
          (context) => UpdateProfileImpl(
            remoteDataSource: context.read<RemoteDataSource>(),
          ),
    ),

    RepositoryProvider<TripFinishRepository>(
      create:
          (context) => FinishTripImpl(
            remoteDataSource: context.read<RemoteDataSource>(),
          ),
    ),
    RepositoryProvider<ForgotPasswordRepository>(
      create:
          (context) => ForgotPasswordImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
    RepositoryProvider<Deleteaccountrepository>(
      create:
          (context) => DeleteaccountrepositoryImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
  ];

  static final blocProviders = <BlocProvider>[
    BlocProvider<InternetStatusBloc>(create: (context) => InternetStatusBloc()),
    BlocProvider<RegisterCubit>(
      create: (context) => RegisterCubit(context.read<RegisterRepository>()),
    ),
    BlocProvider<LoginCubit>(
      create: (context) => LoginCubit(context.read<LoginRepository>()),
    ),
    BlocProvider<GetTripCubit>(
      create: (context) => GetTripCubit(context.read<GetTripRep>()),
    ),
    BlocProvider<GetPreviousTripHistoryCubit>(
      create:
          (context) =>
              GetPreviousTripHistoryCubit(context.read<GetPreviousTripRepo>()),
    ),
    BlocProvider<GetCurrencyCubit>(
      create: (context) => GetCurrencyCubit(context.read<CurrencyRepo>()),
    ),
    BlocProvider<HomeCubit>(
      create:
          (context) => HomeCubit(
            context.read<GetTripRep>(),
            context.read<GetPreviousTripRepo>(),
            context.read<GetProfileRepo>(),
          ),
    ),
    BlocProvider<ProfileCubit>(
      create: (context) => ProfileCubit(context.read<GetProfileRepo>()),
    ),
    BlocProvider<Tripcountcubit>(
      create: (context) => Tripcountcubit(context.read<Tripcountrepository>()),
    ),

    BlocProvider<Categorycubit>(
      create: (context) => Categorycubit(context.read<Categoryrepository>()),
    ),
    BlocProvider<Tripcountcubit>(
      create: (context) => Tripcountcubit(context.read<Tripcountrepository>()),
    ),
    BlocProvider<CombinedProfileCubit>(
      create:
          (context) => CombinedProfileCubit(
            getProfileRepo: context.read<GetProfileRepo>(),
            tripcountrepository: context.read<Tripcountrepository>(),
          ),
    ),

    BlocProvider<PiechartCubit>(
      create: (context) => PiechartCubit(context.read<Piechartrepository>()),
    ),
    BlocProvider<GetExpenseDetailCubit>(
      create:
          (context) =>
              GetExpenseDetailCubit(context.read<GetExpenseDetailRepo>()),
    ),
    BlocProvider<postTripCubit>(
      create: (context) => postTripCubit(context.read<PostTripRepository>()),
    ),
    BlocProvider<UpdateProfileCubit>(
      create:
          (context) =>
              UpdateProfileCubit(context.read<UpdateProfileRepository>()),
    ),
    BlocProvider<TripFinishCubit>(
      create:
          (context) => TripFinishCubit(context.read<TripFinishRepository>()),
    ),
    BlocProvider<ForgotPasswordCubit>(
      create:
          (context) => ForgotPasswordCubit(context.read<ForgotPasswordRepository>()),
    ),
    BlocProvider<DeleteAccountCubit>(
      create:
          (context) => DeleteAccountCubit(context.read<Deleteaccountrepository>()),
    ),
  ];
}
