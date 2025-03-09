import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:muzn/app/core/check_if_login.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/blocs/auth/auth_bloc.dart';
import 'package:muzn/blocs/LocaleBloc/locale_bloc.dart';
import 'package:muzn/blocs/ThemeBloc/theme_bloc.dart';
import 'package:muzn/views/screens/about_screen.dart';
import 'package:muzn/views/screens/contact_screen.dart';
import 'package:muzn/views/screens/home_screen.dart';
import 'package:muzn/views/screens/quran_pdf_screen.dart';
import 'package:muzn/views/screens/users/login_screen.dart';
import 'package:muzn/views/screens/quran_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          return ListView(
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
                       CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Theme.of(context).iconTheme.color,
                          ),
                      ),
                      const SizedBox(height: 5),
                      if (authState is AuthAuthenticated) ...[
                        Text(
                          authState.user.fullName,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          authState.user.email,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                      if(BlocProvider.of<AuthBloc>(context).userModel!=null)
                        Text(
                          BlocProvider.of<AuthBloc>(context).userModel?.fullName??"",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      Text(
                        BlocProvider.of<AuthBloc>(context).userModel?.email??"",
                        style: Theme.of(context).textTheme.bodyLarge,
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
                title: Text('quran'.trans(context)),
                onTap: () {
                  Get.to(()=>QuranScreen());
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => QuranPdfScreen()
                  //         // QuranScreen(),
                  //   ),
                  // );
                },
              ),

              // Main Screen
              ListTile(
                leading: const Icon(Icons.home),
                title: Text('home'.trans(context)),
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
                          ? 'dark_mode'.trans(context)
                          : 'light_mode'.trans(context),
                    ),
                  );
                },
              ),

              // Language Switcher
              BlocBuilder<LocaleBloc, LocaleState>(
                builder: (context, localeState) {
                  if (localeState is LocaleLoading) {
                    return const ListTile(
                      leading: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      title: Text('...'),
                    );
                  }

                  if (localeState is LocaleError) {
                    return ListTile(
                      leading: const Icon(Icons.error_outline, color: Colors.red),
                      title: Text(localeState.message),
                    );
                  }

                  final currentLocale = localeState is LocaleLoadedState
                      ? localeState.locale.languageCode
                      : 'ar';
                  
                  final isEnglish = currentLocale == 'en';
                  
                  return ListTile(
                    leading: isEnglish
                        ? Image.asset('assets/flags/us_flag.png', width: 20)
                        : Image.asset('assets/flags/ar_flag.png', width: 20),
                    title: Text('language'.trans(context)),
                    subtitle: Text(
                      isEnglish ? 'English' : 'العربية',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    trailing: Switch(
                      value: isEnglish,
                      onChanged: (value) {
                        context.read<LocaleBloc>().add(
                          ChangeLocaleEvent(value ? 'en' : 'ar'),
                        );
                      },
                      activeColor: const Color(0xffda9f35),
                    ),
                  );
                },
              ),

              // Contact Screen
              ListTile(
                leading: const Icon(Icons.contact_mail),
                title: Text('contact'.trans(context)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContactScreen(),
                    ),
                  );
                },
              ),
                    ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text('about'.trans(context)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AboutScreen(),
                    ),
                  );
                },
              ),

              // Logout
              // if (authState is AuthAuthenticated)
              if (BlocProvider.of<AuthBloc>(context).isLogin)
                ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: Text('logout'.trans(context)),
                  onTap: () {
                    context.read<AuthBloc>().add(LogoutEvent());
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}