import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:muzn/app/theme/dark_theme.dart';
import 'package:muzn/app/theme/light_theme.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/blocs/LocaleBloc/locale_bloc.dart';
import 'package:muzn/blocs/ThemeBloc/theme_bloc.dart';
import 'package:muzn/blocs/ThemeBloc/theme_state.dart';
import 'package:muzn/blocs/auth/auth_bloc.dart';
import 'package:muzn/blocs/circle/circle_bloc.dart';
import 'package:muzn/blocs/circle_category/circle_category_bloc.dart';
import 'package:muzn/blocs/circle_student/circle_student_bloc.dart';
import 'package:muzn/blocs/homework/homework_bloc.dart';
import 'package:muzn/blocs/school/school_bloc.dart';
import 'package:muzn/blocs/student/student_progress_bloc.dart';
import 'package:muzn/services/database_service.dart';
import 'package:muzn/views/screens/home_screen.dart';
import 'package:muzn/views/screens/users/login_screen.dart';
import 'package:muzn/views/screens/onBoarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the database
  final dbHelper = DatabaseManager();
  final database = await dbHelper.database;

  // Check if this is the first launch
  final prefs = await SharedPreferences.getInstance();
  final isFirstLaunch = prefs.getBool('is_first_launch') ?? true;

  // Check if user is authenticated
  final authToken = prefs.getString('auth_token');
  final isAuthenticated = authToken != null;

  runApp(Muzn(
    database: database,
    isFirstLaunch: isFirstLaunch,
    isAuthenticated: isAuthenticated,
  ));

  // Set first launch to false after app starts
  if (isFirstLaunch) {
    await prefs.setBool('is_first_launch', false);
  }
}

class Muzn extends StatelessWidget {
  final Database database;
  final bool isFirstLaunch;
  final bool isAuthenticated;

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
        // Locale BLoC for language management
        BlocProvider<LocaleBloc>(
          create: (_) => LocaleBloc(),
        ),

        // Theme BLoC for theme management
        BlocProvider<ThemeBloc>(
          create: (_) => ThemeBloc(),
        ),

        // Auth BLoC for authentication
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(),
        ),

        // School BLoC for school management
        BlocProvider<SchoolBloc>(
          create: (_) => SchoolBloc(),
        ),
        BlocProvider<CircleBloc>(
          create: (_) => CircleBloc(),
        ),
             BlocProvider<CircleStudentBloc>(
          create: (_) => CircleStudentBloc(),
        ),

                     BlocProvider<CircleCategoryBloc>(
          create: (_) => CircleCategoryBloc(),
        ),
                   BlocProvider<HomeworkBloc>(
          create: (_) => HomeworkBloc(),
                   ),
          BlocProvider<StudentProgressBloc>(
          create: (_) => StudentProgressBloc(),
        
        ),
      ],
      child: BlocBuilder<LocaleBloc, LocaleState>(
        builder: (context, localeState) {
          return BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              // Get the current locale from state
              final currentLocale = localeState is LocaleLoadedState
                  ? localeState.locale
                  : const Locale('ar'); // Default to Arabic

              return MaterialApp(
                locale: currentLocale,
                theme: themeState is ThemeLight ? lightTheme : darkTheme,
                debugShowCheckedModeBanner: false,
                title: 'Muzn Quran',
                supportedLocales: LocaleBloc.getSupportedLocales(),
                localizationsDelegates: const [
                  AppLocalization.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                localeListResolutionCallback: (deviceLocales, supportedLocales) {
                  // If we have a current locale state, use it
                  if (localeState is LocaleLoadedState) {
                    return localeState.locale;
                  }
                  
                  // Otherwise, try to match device locale
                  if (deviceLocales != null) {
                    for (var locale in deviceLocales) {
                      if (supportedLocales.contains(locale)) {
                        return locale;
                      }
                    }
                  }
                  
                  // Default to Arabic
                  return const Locale('ar');
                },
                home: _getInitialScreen(),
              );
            },
          );
        },
      ),
    );
  }

  Widget _getInitialScreen() {
    if (isFirstLaunch) {
      return OnboardingScreen();
    }

    if (isAuthenticated) {
      return const HomeScreen();
    }

    return const LoginScreen();
  }
}