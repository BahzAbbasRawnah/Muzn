import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:muzn/app/core/check_if_login.dart';
import 'package:muzn/app/theme/dark_theme.dart';
import 'package:muzn/app/theme/light_theme.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/blocs/LocaleBloc/locale_bloc.dart';
import 'package:muzn/blocs/ThemeBloc/theme_bloc.dart';
import 'package:muzn/blocs/auth/auth_bloc.dart';
import 'package:muzn/blocs/bloc_observer.dart';
import 'package:muzn/blocs/circle/circle_bloc.dart';
import 'package:muzn/blocs/circle_category/circle_category_bloc.dart';
import 'package:muzn/blocs/circle_student/add_student_cubit.dart';
import 'package:muzn/blocs/circle_student/circle_student_bloc.dart';
import 'package:muzn/blocs/circle_student/edit_student_cubit.dart';
import 'package:muzn/blocs/homework/homework_bloc.dart';
import 'package:muzn/blocs/school/school_bloc.dart';
import 'package:muzn/blocs/statistics/statistics_bloc.dart';
import 'package:muzn/blocs/student/student_progress_bloc.dart';
import 'package:muzn/services/database_service.dart';
import 'package:muzn/views/screens/home_screen.dart';
import 'package:muzn/views/screens/users/login_screen.dart';
import 'package:muzn/views/screens/onBoarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  Bloc.observer = MuznBlocObserver();

  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize database
    final dbHelper = DatabaseManager();
    final database = await dbHelper.database;
    if (database == null) {
      throw Exception("Database initialization failed");
    }

    // Get shared preferences
    final prefs = await SharedPreferences.getInstance();
    final isLogin = await checkIfLogin();
    print('is Login value ');
    print(isLogin);
    // Check first launch
    final isFirstLaunch = prefs.getBool('is_first_launch') ?? true;
    final isAuthenticated =
        prefs.getBool('authToken') ?? false; // Ensuring it's never null

    runApp(Muzn(
      database: database,
      isFirstLaunch: isFirstLaunch,
      isAuthenticated: isLogin,
      // isAuthenticated,
    ));

    // Set first launch to false
    if (isFirstLaunch) {
      await prefs.setBool('is_first_launch', false);
    }
  } catch (e) {
    debugPrint("Error initializing app: $e");
  }
}

class Muzn extends StatelessWidget {
  final Database database;
  final bool isFirstLaunch;
  final bool isAuthenticated;
  // final bool isAuthenticated;

  const Muzn({
    Key? key,
    required this.database,
    required this.isFirstLaunch,
    required this.isAuthenticated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocaleBloc>(create: (_) => LocaleBloc()),
        BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
        BlocProvider<SchoolBloc>(create: (_) => SchoolBloc()),
        BlocProvider<CircleBloc>(create: (_) => CircleBloc()),
        BlocProvider<CircleStudentBloc>(create: (_) => CircleStudentBloc()),
        BlocProvider<CircleCategoryBloc>(create: (_) => CircleCategoryBloc()),
        BlocProvider<HomeworkBloc>(create: (_) => HomeworkBloc()),
        BlocProvider<StudentProgressBloc>(create: (_) => StudentProgressBloc()),
        BlocProvider<ThemeBloc>(create: (_) => ThemeBloc()),
        BlocProvider<StatisticsBloc>(create: (_) => StatisticsBloc()),
        BlocProvider<AddStudentCubit>(create: (_) => AddStudentCubit()),
        BlocProvider<EditStudentCubit>(create: (_) => EditStudentCubit()),
      ],
      child: BlocBuilder<LocaleBloc, LocaleState>(
        builder: (context, localeState) {
          return BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              print('state is ');
              print(themeState.toString());
              return BlocBuilder<AuthBloc, AuthState>(
                builder: (context, authState) {
                  final currentLocale = localeState is LocaleLoadedState
                      ? localeState.locale
                      : const Locale('ar');

                  return GetMaterialApp(
                    locale: currentLocale,
                    theme: themeState is ThemeLight ? lightTheme : darkTheme,
                    debugShowCheckedModeBanner: false,
                    title: 'Muzn Quran',
                    // Static title for now
                    supportedLocales: LocaleBloc.getSupportedLocales(),
                    localizationsDelegates: const [
                      AppLocalization.delegate,
                      GlobalCupertinoLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                    ],
                    localeListResolutionCallback:
                        (deviceLocales, supportedLocales) {
                      if (localeState is LocaleLoadedState) {
                        return localeState.locale;
                      }
                      if (deviceLocales != null) {
                        for (var locale in deviceLocales) {
                          if (supportedLocales.contains(locale)) {
                            return locale;
                          }
                        }
                      }
                      return const Locale('ar'); // Default to Arabic
                    },
                    home:isAuthenticated?HomeScreen(): _getInitialScreen(authState),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _getInitialScreen(AuthState authState) {
    if (isFirstLaunch) {
      return OnboardingScreen();
    }
    // if (await checkIfLogin()) {
    //   print('to main');
    //   return HomeScreen();
    // }
    // if (isAuthenticated) {
    //   return const HomeScreen();
    // }
    return const LoginScreen();
  }
}
