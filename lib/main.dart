import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:muzn/app/theme/dark_theme.dart';
import 'package:muzn/app/theme/light_theme.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/bloc/CircleBloc/circle_bloc.dart';
import 'package:muzn/bloc/LocaleBloc/locale_bloc.dart';
import 'package:muzn/bloc/SchoolBloc/schools_bloc.dart';
import 'package:muzn/bloc/ThemeBloc/theme_bloc.dart';
import 'package:muzn/bloc/ThemeBloc/theme_state.dart';
import 'package:muzn/bloc/User/user_bloc.dart';
import 'package:muzn/bloc/User/user_event.dart';
import 'package:muzn/controllers/circle_controller.dart';
import 'package:muzn/controllers/school_controller.dart';
import 'package:muzn/controllers/user_controller.dart';
import 'package:muzn/repository/circle_repository.dart';
import 'package:muzn/repository/user_repository.dart';
import 'package:muzn/services/database_service.dart';
import 'package:muzn/views/screens/onBoarding_screen.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the database
  final dbHelper = DatabaseManager();
  final database = await dbHelper.database;

  runApp(Muzn(database: database));
}

class Muzn extends StatelessWidget {
  final Database database;

  const Muzn({Key? key, required this.database}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize repositories

    final userController = UserController();

     SchoolController _schoolController = SchoolController();
     

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

        // User BLoC for authentication and user management
        BlocProvider<UserBloc>(
          create: (_) => UserBloc(
            userController: userController,
          )..add(GetUserProfileEvent()), // Fetch current user profile on app start
        ),
         BlocProvider<SchoolBloc>(
  create: (_) => SchoolBloc(schoolController: _schoolController),
),
BlocProvider<CircleBloc>(
  create: (_) => CircleBloc(),
),
      ],
      child: BlocBuilder<LocaleBloc, LocaleState>(
        builder: (context, localeState) {
          return BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              return MaterialApp(
                locale: localeState.locale,
                theme: themeState is ThemeLight ? lightTheme : darkTheme,
                debugShowCheckedModeBanner: false,
                title: 'Muzn Quran',
                supportedLocales: const [Locale('ar'), Locale('en')],
                localizationsDelegates: const [
                  AppLocalization.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                localeListResolutionCallback: (deviceLocales, supportedLocales) {
                  if (deviceLocales != null) {
                    for (var locale in deviceLocales) {
                      if (supportedLocales.contains(locale)) {
                        return locale;
                      }
                    }
                  }
                  return supportedLocales.first;
                },
                home: OnboardingScreen(),
              );
            },
          );
        },
      ),
    );
  }
}