import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/bloc/User/user_bloc.dart';
import 'package:muzn/bloc/User/user_event.dart';
import 'package:muzn/bloc/User/user_state.dart';
import 'package:muzn/models/user_model.dart';
import 'package:muzn/views/screens/home_screen.dart';
import 'package:muzn/views/screens/quraan_screen.dart';
import 'package:muzn/views/screens/registration_screen.dart';
import 'package:muzn/views/widgets/custom_button.dart';
import 'package:muzn/views/widgets/custom_text_button.dart';
import 'package:muzn/views/widgets/custom_text_field.dart';
import 'package:muzn/bloc/LocaleBloc/locale_bloc.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: PopupMenuButton<String>(
          onSelected: (String value) {
            context.read<LocaleBloc>().add(ChangeLocaleEvent(value));
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem(value: 'en', child: Text('English')),
            const PopupMenuItem(value: 'ar', child: Text('العربية')),
          ],
          child: const Icon(Icons.language),
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
                MaterialPageRoute(builder: (context) => QuranScreen()),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
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
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'email_required'.tr(context);
                    }
                    if (!RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                        .hasMatch(value)) {
                      return 'email_invalid'.tr(context);
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
                  controller: passwordController,
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
                BlocConsumer<UserBloc, UserState>(
                  listener: (context, state) {
                    if (state is UserAuthenticated) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                      
                     
                    } else if (state is UserError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Center(child: Text('auth_error.register_failed'.tr(context))),backgroundColor: Colors.red,),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is UserLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return CustomButton(
                      text: 'login_button'.tr(context),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Dispatch the LoginEvent to the BLoC
                          context.read<UserBloc>().add(
                                LoginEvent(
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                ),
                              );
                        }
                      },
                    );
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
  }
}