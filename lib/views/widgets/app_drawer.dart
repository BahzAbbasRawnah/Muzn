import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/bloc/LocaleBloc/locale_bloc.dart';
import 'package:muzn/bloc/ThemeBloc/theme_bloc.dart';
import 'package:muzn/bloc/ThemeBloc/theme_event.dart';
import 'package:muzn/controllers/user_controller.dart';
import 'package:muzn/models/user_model.dart';
import 'package:muzn/views/screens/contact_screen.dart';
import 'package:muzn/views/screens/home_screen.dart';
import 'package:muzn/views/screens/login_screen.dart';
import 'package:muzn/views/screens/main_screen.dart';
import 'package:muzn/views/screens/quraan_screen.dart';
import 'package:provider/provider.dart';
import '../../bloc/ThemeBloc/theme_state.dart';

class AppDrawer extends StatelessWidget {
  final UserController _userController;

  // Inject UserController via constructor
  const AppDrawer({Key? key, required UserController userController})
      : _userController = userController,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Drawer Header
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xffda9f35),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/avatar_placeholder.png'),
                  ),
                  const SizedBox(height: 5),
                  FutureBuilder<User?>(
                    future: _userController.getCurrentUser(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(); // Show loading indicator
                      }
                      if (snapshot.hasData && snapshot.data?.fullName?.trim().isNotEmpty == true) {
                        return Text(
                          snapshot.data!.fullName!,
                          style: Theme.of(context).textTheme.displayLarge,
                        );
                      }
                      return Text(
                        "Guest",
                        style: Theme.of(context).textTheme.bodyLarge,
                      );
                    },
                  ),
                ],
              ),
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
                  builder: (context) =>  QuranScreen(),
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
                  builder: (context) => const HomeScreen(),
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
                    context.read<LocaleBloc>().add(ChangeLocaleEvent(newLocale));
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
                  builder: (context) =>  ContactScreen(),
                ),
              );
            },
          ),

          // Logout
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: Text('logout'.tr(context)),
            onTap: () async {
              await _userController.logout();
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