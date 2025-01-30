import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/bloc/LocaleBloc/locale_bloc.dart';
import 'package:muzn/bloc/ThemeBloc/theme_bloc.dart';
import 'package:muzn/bloc/ThemeBloc/theme_event.dart';
import 'package:muzn/controllers/auth_controller.dart';
import 'package:muzn/models/user_model.dart';
import 'package:muzn/utils/shared_preferences.dart';
import 'package:muzn/views/screens/contact_screen.dart';
import 'package:muzn/views/screens/login_screen.dart';
import 'package:muzn/views/screens/main_screen.dart';
import 'package:muzn/views/screens/quraan_screen.dart';

import '../../bloc/ThemeBloc/theme_state.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({Key? key}) : super(key: key);
  final _sharedPrefs = SharedPrefsHelper();

  @override
  Widget build(BuildContext context) {
    AuthController _authController = AuthController();

    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xffda9f35),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      AssetImage('assets/images/avatar_placeholder.png'),
                ),
                const SizedBox(height: 5),

             FutureBuilder<User?>(
  future: AuthController.getCurrentUser(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator(); // Show loading indicator
    }
    if (snapshot.hasError || !snapshot.hasData) {
      return Text(
        "Guest",
        style: Theme.of(context).textTheme.bodyLarge,
      );
    }

    final String userName = snapshot.data?.fullName?.trim().isNotEmpty == true
        ? snapshot.data!.fullName
        : "Guest";

    return Text(
      userName,
      style: Theme.of(context).textTheme.bodyLarge,
    );
  },
),

              ],
            ),
          ),

          // Quran Screen
          ListTile(
            leading: Image.asset(
              'assets/images/quran.png',
              fit: BoxFit.contain,
              width: 30,
              height: 30,
            ),
            title: Text('quran'.tr(context)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuranScreen(),
                ),
              );
            },
          ),

          // Main Screen
          ListTile(
            leading: const Icon(Icons.home),
            title: Text('home'.tr(context)),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainScreen(),
                ),
              );
            },
          ),

          // Theme Switcher
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              return ListTile(
                leading: Icon(
                  themeState is ThemeDark ? Icons.dark_mode : Icons.light_mode,
                  color: themeState is ThemeDark ? Colors.black : Colors.amber,
                ),
                trailing: Switch(
                  value: themeState is ThemeDark,
                  onChanged: (_) {
                    context.read<ThemeBloc>().add(ToggleThemeEvent());
                  },
                  activeColor: const Color(0xffda9f35),
                ),
                title: Text(
                  themeState is ThemeDark
                      ? 'dark_mode'.tr(context)
                      : 'light_mode'.tr(context),
                ),
              );
            },
          ),

          // Language Switcher
          BlocBuilder<LocaleBloc, LocaleState>(
            builder: (context, localeState) {
              final isEnglish = localeState.locale.languageCode == 'en';
              return ListTile(
                leading: isEnglish
                    ? Image.asset('assets/flags/us_flag.png', width: 20)
                    : Image.asset('assets/flags/ar_flag.png', width: 20),
                trailing: Switch(
                  value: isEnglish,
                  onChanged: (value) {
                    final newLocale = isEnglish ? 'ar' : 'en';
                    context
                        .read<LocaleBloc>()
                        .add(ChangeLocaleEvent(newLocale));
                  },
                  activeColor: const Color(0xffda9f35),
                ),
                title: Text('language'.tr(context)),
              );
            },
          ),

          // Contact Screen
          ListTile(
            leading: const Icon(Icons.contact_mail),
            title: Text('contact'.tr(context)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContactScreen(),
                ),
              );
            },
          ),

          // Logout
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: Text('logout'.tr(context)),
            onTap: () async {
              String result = await _authController.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
