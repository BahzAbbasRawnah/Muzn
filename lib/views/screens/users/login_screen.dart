import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/blocs/LocaleBloc/locale_bloc.dart';
import 'package:muzn/blocs/auth/auth_bloc.dart';
import 'package:muzn/views/screens/home_screen.dart';
import 'package:muzn/views/screens/quran_pdf_screen.dart';
import 'package:muzn/views/screens/quran_screen.dart';
import 'package:muzn/views/screens/users/registration_screen.dart';
import 'package:muzn/views/widgets/custom_button.dart';
import 'package:muzn/views/widgets/custom_text_button.dart';
import 'package:muzn/views/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: BlocBuilder<LocaleBloc, LocaleState>(
          builder: (context, state) {
            final currentLocale = state is LocaleLoadedState
                ? state.locale.languageCode
                : 'ar';

            return PopupMenuButton<String>(
              onSelected: (String value) {
                context.read<LocaleBloc>().add(ChangeLocaleEvent(value));
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  value: 'en',
                  child: Row(
                    children: [
                      Image.asset('assets/flags/us_flag.png', width: 24),
                      const SizedBox(width: 8),
                      const Text('English'),
                      if (currentLocale == 'en')
                        const Icon(Icons.check, color: Color(0xffda9f35)),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'ar',
                  child: Row(
                    children: [
                      Image.asset('assets/flags/ar_flag.png', width: 24),
                      const SizedBox(width: 8),
                      const Text('العربية'),
                      if (currentLocale == 'ar')
                        const Icon(Icons.check, color: Color(0xffda9f35)),
                    ],
                  ),
                ),
              ],
              icon: const Icon(Icons.language),
            );
          },
        ),
        title: Text('login_title'.tr(context)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: GestureDetector(
              child: Image.asset(
                'assets/images/quran.png',
                fit: BoxFit.contain,
                width: 40,
                height: 40,
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuranPdfScreen()),
              ),
            ),
          ),
        ],
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(padding: EdgeInsets.only(top: deviceHeight * 0.05)),
                      Center(
                        child: Image.asset(
                          'assets/images/app_logo.png',
                          height: deviceHeight * 0.30,
                          width: deviceWidth * 0.80,
                        ),
                      ),
                      SizedBox(height: deviceHeight * 0.05),
                      CustomTextField(
                        hintText: 'email_hint'.tr(context),
                        labelText: 'email_label'.tr(context),
                        prefixIcon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'email_required'.tr(context);
                          }
                        
                          return null;
                        },
                      ),
                      SizedBox(height: deviceHeight * 0.03),
                      CustomTextField(
                        hintText: 'password_hint'.tr(context),
                        labelText: 'password_label'.tr(context),
                        prefixIcon: Icons.lock,
                        suffixIcon: _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        obscureText: !_isPasswordVisible,
                        controller: _passwordController,
                        onSuffixTap: () {
                          setState(() => _isPasswordVisible = !_isPasswordVisible);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'password_required'.tr(context);
                          }
                          if (value.length < 6) {
                            return 'password_length'.tr(context);
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: deviceHeight * 0.03),
                      if (state is AuthLoading)
                        const CircularProgressIndicator()
                      else
                        CustomButton(
                          text: 'login_button'.tr(context),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                LoginEvent(
                                  emailOrPhone: _emailController.text,
                                  password: _passwordController.text,
                                ),
                              );
                            }
                          },
                        ),
                      const SizedBox(height: 16.0),
                      CustomTextButton(
                        text:
                            '${'have_not_account'.tr(context)} ${'register_button'.tr(context)}',
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}