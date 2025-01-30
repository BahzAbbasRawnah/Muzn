import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:muzn/app/theme/dark_theme.dart';
import 'package:muzn/app/theme/light_theme.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/bloc/CircleBloc/circle_bloc.dart';
import 'package:muzn/bloc/CircleBloc/circle_repository.dart';
import 'package:muzn/bloc/LocaleBloc/locale_bloc.dart';
import 'package:muzn/bloc/SchoolBloc/school_repository.dart';
import 'package:muzn/bloc/SchoolBloc/schools_bloc.dart';
import 'package:muzn/bloc/StudentBloc/student_bloc.dart';
import 'package:muzn/bloc/StudentBloc/student_bloc_provider.dart';
import 'package:muzn/bloc/ThemeBloc/theme_bloc.dart';
import 'package:muzn/bloc/ThemeBloc/theme_event.dart';
import 'package:muzn/bloc/ThemeBloc/theme_state.dart';
import 'package:muzn/controllers/student_controller.dart';
import 'package:muzn/services/database_service.dart';
import 'package:muzn/views/screens/login_screen.dart';
import 'package:muzn/views/screens/onBoarding_screen.dart'; // Ensure this import is correct

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dbHelper = DatabaseManager(); // Ensure this class name matches the import
  await dbHelper.database;

  runApp(Muzn());
}

class Muzn extends StatelessWidget {
  Muzn({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocaleBloc>(
          create: (context) => LocaleBloc()..add(LoadLocaleEvent()),
        ),
        BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc()..add(LoadThemeEvent()),
        ),
        BlocProvider<SchoolBloc>(
  create: (context) => SchoolBloc(SchoolRepository()),
),
     BlocProvider<CircleBloc>(
  create: (context) => CircleBloc(CircleRepository()),
),
BlocProvider<StudentBloc>(
      create: (_) => StudentBloc(StudentController()),
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
                home: LoginScreen(),
              );
            },
          );
        },
      ),
    );
  }
}
