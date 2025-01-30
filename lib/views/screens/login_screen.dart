import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/models/user_model.dart';
import 'package:muzn/utils/request_status.dart';
import 'package:muzn/views/screens/home_screen.dart';
import 'package:muzn/views/screens/quraan_screen.dart';
import 'package:muzn/views/screens/registration_screen.dart';
import 'package:muzn/views/widgets/custom_button.dart';
import 'package:muzn/views/widgets/custom_text_button.dart';
import 'package:muzn/views/widgets/custom_text_field.dart';
import 'package:muzn/bloc/LocaleBloc/locale_bloc.dart';
import 'package:muzn/controllers/auth_controller.dart';
import 'package:muzn/views/widgets/message.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  final AuthController _authController = AuthController();

Future<void> _login() async {
  if (_formKey.currentState!.validate()) {
    RequestStatus result = await _authController.loginUser(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    if (result.status && result.data != null) {
      // Extract user data from the API response
      final userData = result.data;

      // Create a User object
      final user = User(
        id: userData['id'] ?? 0,
        email: userData['email'] ?? '',
        password: passwordController.text.trim(), // Storing password is optional
        fullName: userData['full_name'] ?? '',
        phone: userData['phone'] ?? '',
        role: userData['role'] ?? '',
        status: userData['status'] ?? '',
        country: userData['country'] ?? '',
        gender: userData['gender'] ?? '',
      );

      // Store user in SharedPreferences
      await _authController.saveToSharedPreferences(user);

      // Navigate to the home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      ErrorSnackbar.show(context: context, errorText: result.message);
    }
  }
}


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
                CustomButton(
                  text: 'login_button'.tr(context),
                  onPressed: _login,
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
